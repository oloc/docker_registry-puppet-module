class docker_registry::repos {

  case $::osfamily {
    debian: {
      class { 'apt':
        always_apt_update    => true,
        apt_update_frequency => undef,
        disable_keys         => undef,
        proxy_host           => false,
        proxy_port           => false,
        purge_sources_list   => false,
        purge_sources_list_d => false,
        purge_preferences_d  => false,
        update_timeout       => undef,
        fancy_progress       => true
      }

      class { 'apt::release':
        release_id => '',
      }

      apt::source { 'docker':
        location    => 'https://get.docker.com/ubuntu',
        include_src => false,
        repos       => 'docker main',
        release     => '',
        key         => 'A88D21E9',
        key_server  => 'keyserver.ubuntu.com',
      }

      file { '/sbin/insserv':
        ensure => 'link',
        target => '/usr/lib/insserv/insserv',
      }

    }
    redhat: {
      include epel
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
