require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class Rt4Service < Chef::Resource::LWRPBase
      self.resource_name = :rt4_service
      actions :create, :delete, :start, :stop, :restart, :reload
      default_action :create

      attribute :web_path, kind_of: String, default: nil
      attribute :web_server, kind_of: String, default: 'nginx'
      attribute :db_type, kind_of: String, default: 'mysql'
      attribute :organization, kind_of: String, default: nil, required: true
      attribute :correspond_address, kind_of: String, default: nil, required: true
      attribute :comment_address, kind_of: String, default: nil, required: true
      attribute :db_host, kind_of: String, default: 'localhost'
      attribute :db_port, kind_of: String, default: nil
      attribute :db_name, kind_of: String, default: nil
      attribute :db_user, kind_of: String, default: 'rt4user'
      attribute :db_pass, kind_of: String, default: 'rt4pass'
      attribute :instance, kind_of: String, name_attribute: true
      attribute :version, kind_of: String, default: nil
    end
  end
end
