mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  bind_address '127.0.0.1'
  port '3306'
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

mysql_connection_info = {
  :host => node['icinga2']['ido']['db_host'],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['icinga2']['ido']['db_name'] do
  connection mysql_connection_info
  action :create
end

mysql_database node['icinga2']['web2']['db_name'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node['icinga2']['ido']['db_user'] do
  connection    mysql_connection_info
  host          node['icinga2']['ido']['db_host']
  password      node['icinga2']['ido']['db_password']
  database_name node['icinga2']['ido']['db_name']
  privileges    [:all]
  action        [:create, :grant]
end

mysql_database_user node['icinga2']['web2']['db_user'] do
  connection    mysql_connection_info
  host          node['icinga2']['web2']['db_host']
  password      node['icinga2']['web2']['db_password']
  database_name node['icinga2']['web2']['db_name']
  privileges    [:all]
  action        [:create, :grant]
end

icinga2_idomysqlconnection 'idomysqlconnection' do
  library   'db_ido_mysql'
  host      node['icinga2']['ido']['db_host']
  port      3306
  user      node['icinga2']['ido']['db_user']
  password  node['icinga2']['ido']['db_password']
  database  node['icinga2']['ido']['db_name']
end

include_recipe 'icinga2::server'
include_recipe 'icinga2::server_web2'

file '/etc/php5/apache2/conf.d/99-timezone.ini' do
  content "date.timezone = Europe/Berlin\n"
  owner 'root'
  group 'root'
  mode '0444'
end

web_app 'icingaweb2' do
  template 'icingaweb2.conf.erb'
  docroot '/usr/share/icingaweb2/public'
  server_name node['fqdn']
  enable true
end

icinga2_gelfwriter 'gelfwriter' do
  host '127.0.0.1'
  port 12201
  source 'icinga2'
end
