#!/bin/bash

exec sudo /usr/bin/chef-client --no-color -c /etc/chef/client.rb -z -r "webapp::default"
