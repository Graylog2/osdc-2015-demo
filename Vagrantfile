# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'box-cutter/ubuntu1404'
  config.vm.box_check_update = false

  config.cache.scope = :box
  config.cache.auto_detect = true

  config.omnibus.chef_version = '12.2.1'
  config.berkshelf.enabled = true

  config.vm.define 'monitor' do |machine|
    machine.vm.hostname = 'monitor'
    machine.vm.network 'private_network', ip: '10.0.0.10'
    machine.vm.network 'forwarded_port', guest: 80, host: 8080
    machine.vm.network 'forwarded_port', guest: 9000, host: 9000
    machine.vm.network 'forwarded_port', guest: 12900, host: 12900

    machine.vm.provider 'virtualbox' do |vb|
      vb.memory = '4096'
    end

    machine.vm.provision 'chef_zero' do |chef|
      # https://github.com/mitchellh/vagrant/issues/5199#issuecomment-87412634
      chef.provisioning_path = '/tmp/vagrant-chef-3'
      chef.json = JSON.parse(File.read('chef.json'))
      chef.add_recipe 'osdc-2015-demo::default'
      chef.add_recipe 'osdc-2015-demo::graylog'
      chef.add_recipe 'osdc-2015-demo::icinga2'
    end
  end

  config.vm.define 'webserver' do |machine|
    machine.vm.hostname = 'webserver'
    machine.vm.network 'private_network', ip: '10.0.0.11'
    machine.vm.network 'forwarded_port', guest: 80, host: 8081

    machine.vm.provider 'virtualbox' do |vb|
      vb.memory = '512'
    end

    machine.vm.provision 'chef_zero' do |chef|
      # https://github.com/mitchellh/vagrant/issues/5199#issuecomment-87412634
      chef.provisioning_path = '/tmp/vagrant-chef-3'
      chef.json = JSON.parse(File.read('chef.json'))
      chef.add_recipe 'osdc-2015-demo::default'
      chef.add_recipe 'osdc-2015-demo::chef'
      chef.add_recipe 'osdc-2015-demo::webserver'
    end
  end
end
