require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class Rt4Service < Chef::Provider::LWRPBase
      # Chef 11 LWRP DSL Methods
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      # Mix in helpers from libraries/helpers.rb
      include Rt4Cookbook::Helpers

      action :create do
        include_recipe 'build-essential'
        include_recipe 'perl'

        case new_resource.db_type
        when 'mysql'
          include_recipe 'mysql::client'
          mysql_service db_name_picker do
            server_root_password node['mysql']['server_root_password']
            action :create
            only_if { new_resource.db_host == 'localhost' }
          end
        when 'postgresql'
          include_recipe 'postgresql::client'
          include_recipe 'postgresql::server'
        end

        case new_resource.web_server
        when 'nginx'
          include_recipe 'nginx'

          template "#{node['nginx']['dir']}/sites-available/#{new_resource.name}" do
            source 'rt4_nginx.conf.erb'
            mode 0644
            cookbook 'rt4'
            variables(
              config: new_resource,
              web_path: web_path_picker
              )
          end

          nginx_site new_resource.name do
            action :enable
          end

          template "/etc/init.d/#{new_resource.name}-fcgi" do
            source "#{node['platform_family']}/rt4_fcgi_init.erb"
            user 'root'
            group 'root'
            mode '0755'
            cookbook 'rt4'
            variables(
              config: new_resource,
              rt4_user: rt4_user
              )
          end
        when 'apache'
          configure_epel if node['platform_family'] == 'rhel'
          httpd_config new_resource.name do
            instance new_resource.name
            source 'rt4_apache.conf.erb'
            cookbook 'rt4'
            variables(
              config: new_resource,
              web_path: web_path_picker
              )
            notifies :restart, "httpd_service[#{new_resource.name}]"
            action :create
          end
          httpd_service new_resource.name do
            action [:create, :start]
          end
          httpd_module 'fcgid' do
            instance new_resource.name
            package_name 'mod_fcgid' if node['platform_family'] == 'rhel'
          end
        end

        configure_package_deps.each do |pkg|
          package pkg
        end

        cpan_module 'Encode' do
          force true
          version '>= 2.64'
        end
        # gets dep list, splits each dep and installs required version if exists
        configure_cpan_deps.each do |item|
          arr_module = item.split(' ', 2)
          cpan_module arr_module[0] do
            version arr_module[1] if arr_module[1]
          end
        end

        directory "/usr/src/#{new_resource.name}"
        directory "/opt/#{new_resource.name}"

        remote_file "#{new_resource.name}: downloading rt4 source" do
          source 'https://download.bestpractical.com/pub/rt/release/rt-4.2.10.tar.gz'
          checksum '86258ac7771465be0beae1d8d14d05610c5a938cede418143b8fd7203ccd3eb6'
          path "/usr/src/#{new_resource.name}/rt-4.2.10.tar.gz"
        end

        execute "#{new_resource.name}: extracting rt4 source" do
          command 'tar -xzf rt-4.2.10.tar.gz'
          cwd "/usr/src/#{new_resource.name}/"
          action :nothing
          subscribes :run, "remote_file[#{new_resource.name}: downloading rt4 source]", :immediately
        end

        template "#{new_resource.name}: copying rt4 build file" do
          source 'rt4_build.erb'
          cookbook 'rt4'
          path "/usr/src/#{new_resource.name}/rt-4.2.10/build"
          mode '0755'
          variables(
            config: new_resource,
            rt4_user: rt4_user
            )
        end

        execute "#{new_resource.name}: build script" do
          command rt4_install_command
          cwd "/usr/src/#{new_resource.name}/rt-4.2.10/"
          action :nothing
          subscribes :run, "template[#{new_resource.name}: copying rt4 build file]", :immediately
        end

        group rt4_user do
          append true
          members 'postgres'
          action :modify
          only_if { new_resource.db_type == 'postgresql'}
        end

        template "/opt/#{new_resource.name}/etc/RT_SiteConfig.pm" do
          source 'RT_SiteConfig.pm.erb'
          mode 0666
          owner 'root'
          group 'root'
          cookbook 'rt4'
          variables(
            config: new_resource,
            db_name: db_name_picker,
            db_port: db_port_picker,
            web_path: web_path_picker
            )
          notifies :restart, "service[#{new_resource.name}-fcgi]", :delayed
        end

        execute "#{new_resource.name}: #{new_resource.db_type} db init" do
          command db_init_script
          user db_init_user
          not_if notif_db_init_script, user: db_init_user
        end

        service "#{new_resource.name}-fcgi" do
          supports start: true, restart: true, stop: true, status: true
          action [:enable, :start]
          only_if { new_resource.web_server == 'nginx' }
        end

      end
    end
  end
end
