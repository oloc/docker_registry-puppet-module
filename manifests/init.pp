# == Class: docker_registry
#
# this module installs a private docker registry server 
#
# === Examples
#
#  include docker_registry
#
# === Authors
#
# Mark Butcher:  mbutch3r at google mail 
#
# === Copyright
#
# Copyright 2014 Mark Butcher, unless otherwise noted.
#
class docker_registry {

  stage { 'pre':
    before => Stage['main'],
  }

  class { 'docker_registry::repos':
    stage => 'pre',
  }

  case $::osfamily {

    debian: {
      # install packages 
      #  note: python-pip and python-dev are also required, but they'll be installed by the python module
      $deb_packages = ['build-essential','libevent-dev','liblzma-dev','lxc-docker']
      package { $deb_packages:
        ensure => installed,
      }

      class { 'python':
        version    => 'system',
        pip        => true,
        dev        => true,
        virtualenv => true,
        gunicorn   => true,
      }

      python::pip { 'docker-registry':
        pkgname => 'docker-registry',
        before  => Service['docker_registry'],
      }

      # create config dir
      file { '/etc/docker_registry':
        ensure => directory,
      }

      # create config file
      file { '/etc/docker_registry/config.yml':
        ensure  => present,
        replace => 'no',
        content => template('docker_registry/docker_registry_config.erb'),
        mode    => '0644',
      }

      # create log dir
      file { '/var/log/docker_registry':
        ensure => directory,
      }

      # upstart conf
      file { '/etc/init/docker_registry.conf':
        ensure  => present,
        content => template('docker_registry/docker_registry_init.erb'),
        mode    => '0644',
      }

      # start the upstart service 
      service { 'docker_registry':
        ensure  => 'running',
        require => File['/etc/init/docker_registry.conf'],
      }

    }


    redhat: {

      # install packages
      $rel_packages = ['docker-io', 'docker-registry']
      package { $rel_packages:
        ensure => installed,
      }
      
      # start services
      service { 'docker':
        ensure => running,
      }
      service { 'docker-registry':
        ensure => running,
      }
    }

    default: {
      case $::operatingsystem {
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
