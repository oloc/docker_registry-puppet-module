class docker_registry::repos {

  case $::osfamily {
    debian: {
      if !defined(Class['apt']) {
        class { 'apt': }
      }  

      apt::source { 'docker':
        location   => 'https://get.docker.com/ubuntu',
        include_src => false,
        repos      => 'docker main',
        release => '',
        key               => 'A88D21E9',
        key_server        => 'keyserver.ubuntu.com',
     }

     file { '/sbin/insserv' : 
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
