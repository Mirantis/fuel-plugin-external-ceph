$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin-name}/volumes.pp")

$cinder_ceph = hiera('cinder_ceph', False)
$cinder_user = hiera('cinder_user', False)
$cinder_key  = hiera('cinder_key', False)
$cinder_pool = hiera('cinder_pool', False)


include cinder::params


if $cinder_ceph {

  service { "${cinder::params::api_service}":
    enabled => true,
    ensure  => running,
  }

  service { "${cinder::params::volume_service}":
    enabled => true,
    ensure  => running,
  }

  class { 'cinder::volume::rbd':
    rbd_user => $cinder_user,
    rbd_pool => $cinder_pool,
  }

  Cinder_config<||> ~> Service["${cinder::params::api_service}"]
  Cinder_config<||> ~> Service["${cinder::params::volume_service}"]

}
