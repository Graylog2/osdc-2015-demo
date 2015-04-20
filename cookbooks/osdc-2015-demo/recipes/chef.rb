include_recipe 'chef-client::config'
include_recipe 'chef-client::service'

# Using a locally installed gem file until the gem is public!
gem_version = '0.4.0'
gem_path = "/tmp/chef-handler-graylog-#{gem_version}.gem"

cookbook_file gem_path do
  source File.basename(gem_path)
  owner 'root'
  group 'root'
  mode '644'
  action :nothing
end.run_action(:create)

chef_gem 'chef-handler-graylog' do
  source gem_path
  compile_time(false) if respond_to?(:compile_time)
  version gem_version
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
