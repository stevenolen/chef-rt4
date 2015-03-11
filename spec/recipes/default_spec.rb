require 'spec_helper'

describe 'rt4::default' do
  context 'on Ubuntu 14.04' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
        .converge(described_recipe)
    end
    it 'installs rt4-fcgi' do
      stub_command('which nginx').and_return('/usr/bin/nginx')
      expect(chef_run).to install_package('rt4-fcgi')
    end
  end
end
