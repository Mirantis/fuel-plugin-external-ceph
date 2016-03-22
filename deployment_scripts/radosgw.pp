$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/radosgw.pp")


$external_ceph    = hiera_hash('external-ceph', {})
$keystone_hash    = hiera('keystone', {})
$service_endpoint = hiera('service_endpoint')


$radosgw_user  = pick($external_ceph['radosgw_user'], false)


ceph::radosgw { "${radosgw_user}":
  keyring_path => '/etc/ceph/keyring.bin'
}

ceph::radosgw::keystone { "${radosgw_user}":
  rgw_keystone_admin_token         => $keystone_hash['admin_token'],
  rgw_keystone_url                 => "${service_endpoint}:35357",
  rgw_keystone_accepted_roles      => '_member_, Member, admin, swiftoperator',
  rgw_keystone_token_cache_size    => '10',
  rgw_keystone_revocation_interval => '1000000',
  nss_db_path                      => '/etc/ceph/nss',
}
