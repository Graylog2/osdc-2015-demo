OSDC 2015 Demo Setup
====================

This Vagrant setup can be used to test the Chef / Graylog / Icinga2 demo
that has been presented at the OSDC 2015 conference.

## Setup

You need to have [Vagrant](http://vagrantup.com/) installed.

```
$ vagrant plugin install vagrant-triggers
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
$ vagrant up monitor
$ vagrant up webserver
```

## Application URLs

| Service | URL                           | Username | Password | Notes                           |
|---------|-------------------------------|----------|----------|---------------------------------|
| Graylog | http://localhost:9000/        | admin    | admin    | -                               |
| Icinga2 | http://localhost:8080/icinga/ | admin    | admin    | Needs manual setup via browser! |
