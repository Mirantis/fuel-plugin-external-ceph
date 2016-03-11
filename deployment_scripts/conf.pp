$plugin_name = 'external-ceph'

notice("MODULAR: ${plugin-name}/conf.pp")


$mon_host_string = hiera('ceph_mons', "")
$fsid            = hiera('ceph_fsid', "")

$cinder_ceph     = hiera('cinder_ceph', False)
$cinder_key      = hiera('cinder_key', False)


file { '/etc/ceph':
  ensure => directory,
}

file { 'ceph_conf':
  content => template('external_ceph/ceph.conf'),
  path    => '/etc/ceph/ceph.conf'
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
