$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/volumes-and-ephemeral-compute.pp")


$external_ceph = hiera_hash('external-ceph', {})

$cinder_ceph  = pick($external_ceph['cinder_ceph'], false)
$cinder_pool  = pick($external_ceph['cinder_pool'], false)
$nova_ceph    = pick($external_ceph['nova_ceph'], false)
$nova_user    = pick($external_ceph['nova_user'], false)
$nova_key     = pick($external_ceph['nova_key'], false)
$nova_pool    = pick($external_ceph['nova_pool'], false)


include cinder::params


if $cinder_ceph {

  service { "$nova::params::compute_service_name":
    enable   => true,
    ensure   => running,
  }

  class { 'nova::compute::rbd':
    libvirt_rbd_user        => $nova_user,
    libvirt_images_rbd_pool => $nova_pool, # actually, it's for volumes, option naming skills: openstack/10
    libvirt_rbd_secret_uuid => 'a5d0dd94-57c4-ae55-ffe0-7e3732a24455', # seems to be hardcoded in the library
    libvirt_rbd_secret_key  => $nova_key,
    ephemeral_storage       => $nova_ceph,
  }

  Nova_config<||> ~> Service["${nova::params::compute_service_name}"]
}

