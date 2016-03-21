$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin_name}/conf.pp")


$external_ceph = hiera_hash('external-ceph', {})

$mon_host_string = pick($external_ceph['ceph_mons'], "")
$fsid            = pick($external_ceph['ceph_fsid'], "")

$cinder_ceph     = pick($external_ceph['cinder_ceph'], false)
$cinder_key      = pick($external_ceph['cinder_key'], false)
$cinder_user     = pick($external_ceph['cinder_user'], false)

$glance_ceph     = pick($external_ceph['glance_ceph'], true)
$glance_user     = pick($external_ceph['glance_user'], false)
$glance_key      = pick($external_ceph['glance_key'], false)

$nova_ceph     = pick($external_ceph['nova_ceph'], true)
$nova_user     = pick($external_ceph['nova_user'], false)
$nova_key      = pick($external_ceph['nova_key'], false)

file { '/etc/ceph':
  ensure => directory,
}

file { 'ceph_conf':
  content => template('external_ceph/ceph.conf'),
  path    => '/etc/ceph/ceph.conf',
  ensure  => present,
  mode    => 0644,
}

file { 'keyring_bin':
 ensure => present,
 content => template('external_ceph/keyring.bin.erb'),
 path   => '/etc/ceph/keyring.bin',
 mode => '0664',
}

File['/etc/ceph'] -> File['ceph_conf'] -> File['keyring_bin']
