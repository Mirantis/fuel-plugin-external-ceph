$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/volumes-types.pp")


$access_admin    = hiera_hash('access_hash', {})
$public_vip      = hiera('public_vip')
$public_ssl_hash = hiera('public_ssl')
$ssl_hash        = hiera_hash('use_ssl', {})
$region          = hiera('region', 'RegionOne')

$public_protocol    = get_ssl_property($ssl_hash, $public_ssl_hash, 'keystone', 'public', 'protocol', 'http')
$public_address     = get_ssl_property($ssl_hash, $public_ssl_hash, 'keystone', 'public', 'hostname', [$public_vip])


include ::cinder::client


cinder::type { 'external-ceph':
  set_key              => 'volume_backend_name',
  set_value            => 'external-ceph',
  os_password          => $access_admin['password'],
  os_tenant_name       => $access_admin['tenant'],
  os_username          => $access_admin['user'],
  os_auth_url          => "${public_protocol}://${public_address}:5000/v2.0/",
  os_region_name       => $region,
}
