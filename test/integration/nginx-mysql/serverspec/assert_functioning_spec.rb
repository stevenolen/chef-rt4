require 'serverspec'

set :backend, :exec

# NGINX
describe port(80) do
  it { should be_listening }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe service('rt4-default-fcgi') do
  it { should be_enabled }
  it { should be_running }
end

def mysql_service
  return 'mysqld' if os[:family] =~ /redhat/
  'mysql'
end

# MYSQL
describe port(3306) do
  it { should be_listening }
end

describe service(mysql_service) do
  it { should be_enabled }
  it { should be_running }
end

# RT is able to create tickets, eg. 'set up'
describe command('export RTSERVER=http://127.0.0.1/rt4-default && export RTPASSWD=password && /usr/bin/perl /opt/rt4-default/bin/rt create -t ticket set subject="test"') do
  its(:stdout) { should match(/Ticket \d+ created/) }
end
