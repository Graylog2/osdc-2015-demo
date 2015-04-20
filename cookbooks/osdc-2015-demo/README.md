# osdc-2015-demo-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['osdc-2015-demo']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### osdc-2015-demo::default

Include `osdc-2015-demo` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[osdc-2015-demo::default]"
  ]
}
```

## License and Authors

Author:: Graylog, Inc. (<bernd@graylog.com>)
