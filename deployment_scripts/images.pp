$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/images.pp")


$external_ceph = hiera_hash('external-ceph', {})

$glance_ceph  = pick($external_ceph['glance_ceph'], true)
$glance_user  = pick($external_ceph['glance_user'], false)
$glance_pool  = pick($external_ceph['glance_pool'], false)


include glance::params


service { "${glance::params::api_service_name}":
  enable => true,
  ensure => running,
}

class { 'glance::backend::rbd':
  rbd_store_user => $glance_user,
  rbd_store_pool => $glance_pool,
}

glance_api_config {
  'glance_store/stores': value => 'rbd';
}

Glance_api_config<||> ~> Service["${glance::params::api_service_name}"]
