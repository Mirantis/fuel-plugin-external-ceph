$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/radosgw-keystone.pp")


$region         = 'RegionOne'
$external_ceph  = hiera_hash('external-ceph', {})
$deploy_radosgw = pick($external_ceph['deploy_radosgw'], false)

if $deploy_radosgw {
  $public_ssl_hash     = hiera('public_ssl')
  $pub_protocol        = $public_ssl_hash['services'] ? {
    true    => 'https',
    default => 'http'
  }
  $public_ip           = hiera('public_vip')
  $int_ip              = hiera('management_vip')
  $adm_ip              = hiera('management_vip')
  $swift_endpoint_port = 8080

  $public_url          = "${pub_protocol}://${pub_ip}:${swift_endpoint_port}/swift/v1",
  $admin_url           = "http://${adm_ip}:${swift_endpoint_port}/swift/v1",
  $internal_url        = "http://${int_ip}:${swift_endpoint_port}/swift/v1",
} else {
  $public_url          = external_ceph['s3_endpoint']
  $internal_url        = external_ceph['s3_endpoint']
  $admin_url           = external_ceph['s3_endpoint']
}

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
