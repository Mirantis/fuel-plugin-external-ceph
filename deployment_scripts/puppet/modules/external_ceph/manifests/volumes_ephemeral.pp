class external_ceph::volumes_ephemeral {

  $plugin_name = 'external-ceph'

  notice("MODULAR: ${plugin_name}/volumes-and-ephemeral-compute.pp")


  $external_ceph = hiera_hash('external-ceph', {})

  $cinder_ceph  = pick($external_ceph['cinder_ceph'], false)
  $cinder_pool  = pick($external_ceph['cinder_pool'], false)
  $nova_ceph    = pick($external_ceph['nova_ceph'], false)
  $cinder_user    = pick($external_ceph['cinder_user'], false)
  $cinder_key     = pick($external_ceph['cinder_key'], false)
  $nova_pool    = pick($external_ceph['nova_pool'], false)


  include nova::params


  service { "$nova::params::compute_service_name":
    ensure => stopped,
  }


  service { "libvirt":
    name   => 'libvirtd',
    enable => true,
    ensure => running,
  }

  class { 'nova::compute::rbd':
    libvirt_rbd_user        => $cinder_user,
    libvirt_images_rbd_pool => $nova_pool,
    libvirt_rbd_secret_uuid => 'a5d0dd94-57c4-ae55-ffe0-7e3732a24455', # seems to be hardcoded in the library
    libvirt_rbd_secret_key  => $cinder_key,
    ephemeral_storage       => $nova_ceph,
  }

  File <| title == '/etc/nova/secret.xml' |> {
    require => [],
  }

  Package['ceph-client-package'] -> Nova_config<||> # ~> Service["${nova::params::compute_service_name}"]

}
