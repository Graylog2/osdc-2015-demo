#!/bin/bash

exec sudo /usr/bin/chef-client -c /etc/chef/client.rb -z -r "webapp::default"
