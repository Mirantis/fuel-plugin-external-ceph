$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/volumes-controller.pp")


$external_ceph = hiera_hash('external-ceph', {})

$cinder_ceph  = pick($external_ceph['cinder_ceph'], false)
$cinder_user  = pick($external_ceph['cinder_user'], false)
$cinder_key   = pick($external_ceph['cinder_key'], false)
$cinder_pool  = pick($external_ceph['cinder_pool'], false)


include cinder::params


if $cinder_ceph {

  package { 'cinder':
    ensure  => installed,
    name    => $::cinder::params::package_name,
  }

  service { "${cinder::params::api_service}":
    enable => true,
    ensure => running,
  }

  package { "$::cinder::params::tgt_package_name":
    ensure   => installed,
    name     => $::cinder::params::tgt_package_name,
    before   => Class['cinder::volume'],
  }

  package { 'ceph-client-package':
    ensure => installed,
    name   => 'ceph',
  }


  service { "$::cinder::params::tgt_service_name":
    enable   => false,
    ensure   => stopped,
  }

  class { 'cinder::volume':
    enabled => true,
  }

  class { 'cinder::volume::rbd':
    rbd_user            => $cinder_user,
    rbd_pool            => $cinder_pool,
    rbd_secret_uuid     => 'a5d0dd94-57c4-ae55-ffe0-7e3732a24455', # seems to be hardcoded in the library
  }

  class { 'cinder::backup':
    enabled => true,
  }

  class { 'cinder::backup::ceph':
    backup_ceph_user => $cinder_user,
    backup_ceph_pool => $cinder_pool,
  }


  Package['ceph-client-package'] -> Cinder_config<||>
  Cinder_config<||> ~> Service["${cinder::params::api_service}"]
  Cinder_config<||> ~> Service["${cinder::params::volume_service}"]

}

