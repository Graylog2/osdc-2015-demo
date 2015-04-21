package 'apache2' do
  action :install
end

directory '/var/www/webapp' do
  action :create
end

file '/var/www/webapp/index.html' do
  content '<html><head><title>Hello OSDC!</title></head><body>Hello OSDC 2015!</body></html>'
end

file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  notifies :restart, 'service[apache2]', :delayed
end

template '/etc/apache2/sites-enabled/webapp.conf' do
  source 'webapp.conf.erb'
  action :create
  notifies :restart, 'service[apache2]', :delayed
end

service 'apache2' do
  action [:enable, :start]
end
