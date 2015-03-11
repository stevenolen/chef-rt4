# rt4

A cookbook which provides an 'rt4' LWRP for configuring request-tracker4 via a wrapper cookbook.  Please note that (opinionated or not) there a number of steps required for a fully-functioning RT server that are competely left out of this cookbook. In particular, e-mail setup is left 
up to the wrapper cookbook. 

## Supported Platforms

Ubuntu, Debian, RedHat-based distros have been tested, but minimal extra configuration would be required to support most all Unix-based distros.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cens-dhcp']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cens-dhcp::default

Include `cens-dhcp` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cens-dhcp::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
