# set a few params *not* in the LWRP because we can't really control them in this cookbook.

rt4_service 'rt4-default' do
  db_type 'postgresql'
  web_server 'apache'
  correspond_address 'test2@example.com'
  comment_address 'test-comment@example.com'
  organization 'Test'
end
