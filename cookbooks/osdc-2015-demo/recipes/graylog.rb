# Configures a Graylog setup including MongoDB and Elasticsearch

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'mongodb'
include_recipe 'graylog2::default'
include_recipe 'graylog2::server'
include_recipe 'graylog2::web'

service 'elasticsearch' do
  action :start
end

service 'graylog-server' do
  action :start
end

service 'graylog-web' do
  action :start
end

cookbook_file 'graylog-seed.rb' do
  path  '/usr/bin/graylog-seed'
  owner 'root'
  group 'root'
  mode  '0555'
end

file '/etc/graylog/seed.json' do
  owner 'root'
  group 'root'
  mode  '0444'
  content JSON.pretty_generate(node['graylog2']['seed'])
end

execute 'graylog-seed' do
  command '/usr/bin/graylog-seed'
end
