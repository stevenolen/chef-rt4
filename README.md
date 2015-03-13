# rt4

[![Build Status](https://ci.ohmage.org/buildStatus/icon?job=chef-rt4)](https://ci.ohmage.org/view/All/job/chef-rt4/)

A cookbook which provides an 'rt4' LWRP for configuring request-tracker4 via a wrapper cookbook.  Please note that (opinionated or not) there a number of steps required for a fully-functioning RT server that are competely left out of this cookbook. In particular, e-mail setup is left 
up to the wrapper cookbook. 

## Supported Platforms

Ubuntu, Debian, RedHat-based distros have been tested, but minimal extra configuration would be required to support most all Unix-based distros.

## Attributes

TODO

## Usage

### rt4_service

```
rt4_service 'rt4' do
  correspond_email 'test@example.com'
  comment_email 'test-comment@example.com'
  organization 'TestOrg'
  db_type 'postgresql'
end
```


## License and Authors

Author:: Steve Nolen (technolengy@gmail.com)
