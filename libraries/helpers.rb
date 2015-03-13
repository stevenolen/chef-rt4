module Rt4Cookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def configure_epel
      # we need to configure epel since the centos repos don't have mod_fcgid for apache.
      yum_repository 'epel' do
        mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
        description 'Extra Packages for Enterprise Linux 6 - $basearch'
        enabled true
        gpgcheck true
        gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
      end
    end

    def rt4_user
      case node['platform_family']
      when 'rhel'
        return 'nginx' if new_resource.web_server == 'nginx'
        return 'apache' if new_resource.web_server == 'apache'
      else
        'www-data'
      end
    end

    def db_init_user
      return 'root' if new_resource.db_type == 'mysql'
      return 'postgres' if new_resource.db_type == 'postgresql'
    end

    def db_init_script
      case new_resource.db_type
      when 'mysql'
        @db_init = ''
        @db_init = "/usr/bin/perl /opt/#{new_resource.name}/sbin/rt-setup-database "
        @db_init += '--action init '
        @db_init += '--dba root '
        @db_init += "--dba-password #{node['mysql']['server_root_password']}"
        @db_init
      when 'postgresql'
        @db_init = "/usr/bin/perl /opt/#{new_resource.name}/sbin/rt-setup-database "
        @db_init += '--action init '
        @db_init += '--dba postgres '
        @db_init += "--dba-password #{node['postgresql']['password']['postgres']}"
      end
    end

    # we need a script that, regardless of db_type, will cause the db_init not to be run twice.
    def notif_db_init_script
      @is_db_init = ''
      case new_resource.db_type
      when 'mysql'
        @is_db_init = '/usr/bin/mysqlshow '
        @is_db_init += "--host=#{new_resource.db_host} "
        @is_db_init += "--port=#{new_resource.db_port} "
        @is_db_init += '-u root '
        @is_db_init += "-p#{node['mysql']['server_root_password']} "
        @is_db_init += "| grep #{db_name_picker}"
        @is_db_init
      when 'postgresql'
        @is_db_init = "/usr/bin/psql -l | grep #{db_name_picker}"
        @is_db_init
      end
    end

    def db_name_picker
      case new_resource.db_type
      when 'mysql'
        return new_resource.db_name if new_resource.db_name
        new_resource.name
      when 'postgresql'
        return new_resource.db_name.sub(/-/, '') if new_resource.db_name
        new_resource.name.sub(/-/, '')
      end
    end

    def db_port_picker
      return new_resource.db_port if new_resource.db_port
      return '3306' if new_resource.db_type == 'mysql'
      return '5432' if new_resource.db_type == 'postgresql'
    end

    def web_path_picker
      return new_resource.web_path if new_resource.web_path
      "/#{new_resource.name}"
    end

    # Stuffing this in a helper because we may want to refactor out the use of the RT4 build script
    def rt4_install_command
      <<-EOF
      "./build"
      EOF
    end

    def configure_package_deps
      @pkg_deps = []
      @pkg_deps += %w(libgd-gd2-perl libgraphviz-dev graphviz libfcgi-perl procps spawn-fcgi libssl-dev) if node['platform_family'] == 'debian'
      @pkg_deps += %w(spawn-fcgi perl-GD graphviz-perl perl-XML-Parser) if node['platform_family'] == 'rhel'
      @pkg_deps
    end

    def configure_cpan_deps
      @cpan_deps = []
      @cpan_deps += default_rt4_cpan_deps
      @cpan_deps += fcgi_rt4_cpan_deps
      @cpan_deps += mysql_rt4_cpan_deps if new_resource.db_type == 'mysql'
      @cpan_deps += postgresql_rt4_cpan_deps if new_resource.db_type == 'postgresql'
      @cpan_deps
    end

    def mysql_rt4_cpan_deps
      ['DBD::mysql >= 2.1018']
    end

    def postgresql_rt4_cpan_deps
      ['DBD::Pg']
    end

    def fcgi_rt4_cpan_deps
      # these are fcgi reqs
      ['FCGI::ProcManager', 'FCGI >= 0.74']
    end

    def default_rt4_cpan_deps
      ['Term::ReadKey',
       'Getopt::Long >= 2.24',
       'HTTP::Request::Common',
       'Term::ReadLine',
       'Text::ParseWords',
       'LWP',
       'DateTime >= 0.44',
       'Class::ReturnValue >= 0.40',
       'Text::Quoted >= 2.02',
       'Regexp::IPv6',
       'HTML::TreeBuilder',
       'CSS::Squish >= 0.06',
       'DateTime::Locale >= 0.40',
       'Module::Versions::Report >= 1.05',
       'MIME::Entity >= 5.425',
       'Digest::SHA',
       'List::MoreUtils',
       'DBI >= 1.37',
       'Locale::Maketext::Lexicon >= 0.32',
       'Devel::StackTrace >= 1.19',
       'Digest::base',
       'HTML::FormatText',
       'Text::Password::Pronounceable',
       'Devel::GlobalDestruction',
       'Time::ParseDate',
       'File::Temp >= 0.19',
       'Locale::Maketext >= 1.06',
       'Tree::Simple >= 1.04',
       'Text::Template >= 1.44',
       'Scalar::Util',
       'HTML::Quoted',
       'HTML::Scrubber >= 0.08',
       'File::Spec >= 0.8',
       'DBIx::SearchBuilder >= 1.59',
       'Sys::Syslog >= 0.16',
       'Mail::Mailer >= 1.57',
       'File::ShareDir',
       'Regexp::Common',
       'Digest::MD5 >= 2.27',
       'Cache::Simple::TimedExpiry',
       'File::Glob',
       'Class::Accessor >= 0.34',
       'Locale::Maketext::Fuzzy',
       'Time::HiRes',
       'Text::Wrapper',
       'Regexp::Common::net::CIDR',
       'Net::CIDR',
       'Log::Dispatch >= 2.23',
       'UNIVERSAL::require',
       'Email::Address',
       'HTML::RewriteAttributes >= 0.05',
       'URI >= 1.59',
       'MIME::Types',
       'GD::Text',
       'GD',
       'GD::Graph',
       'PerlIO::eol',
       'GnuPG::Interface',
       'IPC::Run >= 0.90',
       'GraphViz',
       'Data::ICal',
       'Pod::Usage',
       'Getopt::Long',
       'LWP::UserAgent',
       'Storable >= 2.08',
       'CSS::Squish >= 0.06',
       'Apache::Session >= 1.53',
       'Errno',
       'Devel::StackTrace >= 1.19',
       'IPC::Run3',
       'CGI::Cookie >= 1.20',
       'Text::WikiFormat >= 0.76',
       'XML::RSS >= 1.05',
       'HTML::Mason >= 1.43',
       'Digest::MD5 >= 2.27',
       'JSON',
       'CGI::Emulate::PSGI',
       'CGI >= 3.38',
       'CGI::PSGI >= 0.12',
       'HTML::Mason::PSGIHandler >= 0.52',
       'Plack >= 0.9971',
       'Plack::Handler::Starlet',
       'Net::SMTP',
       'Convert::Color',
       # 'HTML::FormatText::WithLinks >= 0.14',
       'Crypt::Eksblowfish',
       'Module::Refresh >= 0.03',
       'DateTime::Format::Natural >= 0.67',
       'Email::Address::List >= 0.02',
       'Symbol::Global::Name >= 0.04',
       'HTML::FormatText::WithLinks::AndTables',
       'Role::Basic >= 0.12',
       # 'Encode >= 2.64',
       'Date::Manip',
       'Date::Extract >= 0.02',
       'Data::GUID',
       'Mozilla::CA',
       'Crypt::SSLeay',
       'Net::SSL',
       'Crypt::X509',
       'String::ShellQuote'
      ]
    end
  end
end
