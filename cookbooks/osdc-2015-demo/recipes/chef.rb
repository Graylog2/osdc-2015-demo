include_recipe 'chef-client::config'
include_recipe 'chef-client::service'

chef_gem 'chef-handler-graylog' do
  compile_time(false) if respond_to?(:compile_time)
  version node['chef_client']['gelf_handler_version']
  action :nothing
end.run_action(:install)

template '/etc/chef/client.d/graylog_handler.rb' do
  source    'graylog_handler.rb.erb'
  mode      '0444'
  owner     'root'
  group     'root'
  variables :server_url => node['chef_client']['gelf_http_url'], :timeout => 5
  notifies  :create, 'ruby_block[reload_client_config]'
end
