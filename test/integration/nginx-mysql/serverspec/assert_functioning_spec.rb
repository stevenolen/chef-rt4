require 'serverspec'

set :backend, :exec

# NGINX
describe port(80) do
  it { should be_listening }
end

describe port(3306) do
  it { should be_listening}
 end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe service('rt4-default-fcgi') do
  it { should be_enabled }
  it { should be_running }
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe command('export RTSERVER=http://127.0.0.1/rt4-default && export RTPASSWD=password && /usr/bin/perl /opt/rt4-default/bin/rt create -t ticket set subject="test"') do
  its(:stdout) { should match /Ticket \d+ created/ }
end
