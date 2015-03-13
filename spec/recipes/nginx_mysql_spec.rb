require 'spec_helper'

describe 'rt4_service_test::nginx_mysql' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: 'rt4_service')
      .converge(described_recipe)
  end

  context 'compiling the test recipe' do
    before do
      stub_command('which nginx').and_return(false)
    end
    before do
      stub_command('/usr/bin/mysqlshow --host=localhost --port= -u root -pfigureoutabetterway | grep rt4-default').and_return(false)
    end
    it 'creates rt4_service[rt4-default]' do
      expect(chef_run).to create_rt4_service('rt4-default')
    end
  end

  context 'stepping into rt4_service[rt4-default] resource' do
    before do
      stub_command('which nginx').and_return(false)
    end
    before do
      stub_command('/usr/bin/mysqlshow --host=localhost --port= -u root -pfigureoutabetterway | grep rt4-default').and_return(false)
    end

    %w(libgd-gd2-perl libgraphviz-dev graphviz libfcgi-perl procps spawn-fcgi libssl-dev).each do |pkg|
      it "installs #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end

    %w(FCGI::ProcManager FCGI Encode Term::ReadKey Getopt::Long HTTP::Request::Common Term::ReadLine Text::ParseWords
       LWP DateTime Class::ReturnValue Text::Quoted Regexp::IPv6 HTML::TreeBuilder CSS::Squish DateTime::Locale Module::Versions::Report
       MIME::Entity Digest::SHA List::MoreUtils DBI Locale::Maketext::Lexicon Devel::StackTrace Digest::base HTML::FormatText
       Text::Password::Pronounceable Devel::GlobalDestruction Time::ParseDate File::Temp Locale::Maketext Tree::Simple Text::Template
       Scalar::Util HTML::Quoted HTML::Scrubber File::Spec DBIx::SearchBuilder Sys::Syslog Mail::Mailer File::ShareDir Regexp::Common
       Digest::MD5 Cache::Simple::TimedExpiry File::Glob Class::Accessor Locale::Maketext::Fuzzy Time::HiRes Text::Wrapper
       Regexp::Common::net::CIDR Net::CIDR Log::Dispatch UNIVERSAL::require Email::Address HTML::RewriteAttributes URI MIME::Types
       GD::Text GD GD::Graph PerlIO::eol GnuPG::Interface IPC::Run GraphViz Data::ICal Pod::Usage Getopt::Long LWP::UserAgent Storable
       CSS::Squish Apache::Session Errno Devel::StackTrace IPC::Run3 CGI::Cookie Text::WikiFormat XML::RSS HTML::Mason Digest::MD5 JSON
       CGI::Emulate::PSGI CGI CGI::PSGI HTML::Mason::PSGIHandler Plack Plack::Handler::Starlet Net::SMTP Convert::Color Crypt::Eksblowfish
       Module::Refresh DateTime::Format::Natural Email::Address::List Symbol::Global::Name HTML::FormatText::WithLinks::AndTables Role::Basic
       Date::Manip Date::Extract Data::GUID Mozilla::CA Crypt::SSLeay Net::SSL Crypt::X509 String::ShellQuote Mail::Header). each do |cpan|
      it "installs #{cpan} from cpan" do
        expect(chef_run).to create_cpan_module(cpan)
      end
    end
    it 'creates download dir for rt4' do
      expect(chef_run).to create_directory('/usr/src/rt4-default')
    end
    it 'creates src deploy location for rt4' do
      expect(chef_run).to create_directory('/opt/rt4-default')
    end
    it 'downloads rt4 src file' do
      expect(chef_run).to create_remote_file('/usr/src/rt4-default/rt-4.2.10.tar.gz')
    end
    it 'extracts rt4 src file' do
      expect(chef_run).to_not run_execute('rt4-default: extracting rt4 source')
      extract_action = chef_run.execute('rt4-default: extracting rt4 source')
      expect(extract_action).to subscribe_to('remote_file[rt4-default: downloading rt4 source]').on(:run).immediately
    end
    it 'creates template for build file' do
      expect(chef_run).to create_template('/usr/src/rt4-default/rt-4.2.10/build')
    end
    it 'executes rt4 build process' do
      expect(chef_run).to_not run_execute('rt4-default: build script')
      build_action = chef_run.execute('rt4-default: build script')
      expect(build_action).to subscribe_to('template[rt4-default: copying rt4 build file]').on(:run).immediately
    end
    it 'creates template for RT4_SiteConfig.pm' do
      expect(chef_run).to create_template('/opt/rt4-default/etc/RT_SiteConfig.pm')
    end

    # NGINX
    it 'installs nginx' do
      stub_command('which nginx').and_return(false)
      expect(chef_run).to include_recipe('build-essential')
    end
    it 'creates nginx site template' do
      expect(chef_run).to create_template('/etc/nginx/sites-available/rt4-default')
    end
    it 'creates init service for fcgi' do
      expect(chef_run).to create_template('/etc/init.d/rt4-default-fcgi')
    end
    it 'starts/enables fcgi service' do
      expect(chef_run).to enable_service('rt4-default-fcgi')
      expect(chef_run).to start_service('rt4-default-fcgi')
    end

    # MYSQL
    it 'installs DBD::mysql from cpan' do
      expect(chef_run).to create_cpan_module('DBD::mysql')
    end
    it 'executes mysql_service resource' do
      expect(chef_run).to create_mysql_service('rt4-default')
    end
    it 'does not modify web group' do
      expect(chef_run).to_not modify_group('www-data')
    end
    it 'executes mysql db init' do
      expect(chef_run).to run_execute('rt4-default: mysql db init')
    end
  end
end
