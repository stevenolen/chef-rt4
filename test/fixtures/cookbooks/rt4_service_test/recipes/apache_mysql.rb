# set a few params *not* in the LWRP because we can't really control them in this cookbook.
node.set['mysql']['server_root_password'] = 'figureoutabetterway'

rt4_service 'rt4-default' do
  web_server 'apache'
  correspond_address 'test2@example.com'
  comment_address 'test-comment@example.com'
  organization 'Test'
end