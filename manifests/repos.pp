class docker_registry::repos {

  case $::osfamily {
    debian: {
      if !defined(Class['apt']) {
        class { 'apt': }
      }
      if !defined(Class['apt::update']) {
        class { 'apt::update':
          require => Class['apt'],
        }
      }

      apt::source { 'docker':
        location    => 'https://get.docker.io/ubuntu',
        release     => 'docker'
        repos       => 'main',
        key         => '36A1D7869245C8950F966E92D8576A8BA88D21E9',
        key_server  => 'keyserver.ubuntu.com',
        before      => Class['apt::update'],
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
