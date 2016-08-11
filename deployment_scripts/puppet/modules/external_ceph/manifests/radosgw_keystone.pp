class external_ceph::radosgw_keystone {

  $plugin_name = 'external-ceph'

  notice("MODULAR: ${plugin_name}/radosgw-keystone.pp")


  $region         = 'RegionOne'
  $external_ceph  = hiera_hash('external-ceph', {})

  $public_url     = $external_ceph['radosgw_endpoint_public']
  $internal_url   = $external_ceph['radosgw_endpoint_internal']
  $admin_url      = $external_ceph['radosgw_endpoint_admin']


  keystone_service {'swift':
    ensure      => present,
    type        => 'object-store',
    description => 'Openstack Object-Store Service',
  }

  keystone_endpoint {"${region}/swift":
    ensure       => present,
    public_url   => "${public_url}",
    admin_url    => "${admin_url}",
    internal_url => "${internal_url}",
  }

}
