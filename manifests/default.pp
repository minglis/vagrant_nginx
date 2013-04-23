class base_packages {
  package {
    [
      'curl'
    ]:
    ensure => installed
  }
}

class nginx {
 
  package { "nginx":
    ensure => present,
  }

  service { "nginx":
    ensure => running,
    require => Package["nginx"],
  }

  file { '/var/www':
    ensure => link,
    target => "/vagrant",
    notify => Service['nginx'],
    force  => true
  }

  file { '/etc/nginx/server.crt':
        ensure  => present,
        mode    => '0644',
        owner    => 'root',
        source  => '/etc/puppet/files/modules/nginx/conf/server.crt'
  }

  file { '/etc/nginx/server.key':
        ensure  => present,
        mode    => '0644',
        owner    => 'root',
        source  => '/etc/puppet/files/modules/nginx/conf/server.key'
  }

  file { '/etc/nginx/ca.crt':
        ensure   => present,
        mode    => '0644',
        owner    => 'root',
        source  => '/etc/puppet/files/modules/nginx/conf/ca.crt'
  }

  file { '/etc/nginx/sites-enabled/default':
        ensure  => present,
        mode    => '0644',
        owner    => 'root',        
        source  => '/etc/puppet/files/modules/nginx/etc/default'
  }

}

 file { '/var/www/index.html':
        ensure  => present,
        source  => '/etc/puppet/files/index.html'
  }

 exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

include base_packages
include nginx

