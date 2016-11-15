# ovn northd
# == Class: ovn::northd
#
# Installs ovn package starts the ovn-northd service
#
# [*dbs_listen_ip*]
#   The IP-Address where OVN DBs should be listening
#   Defaults to '0.0.0.0'
#
class ovn::northd($dbs_listen_ip = "0.0.0.0") {
    include ::ovn::params

    file { '/etc/sysconfig/ovn-northd':
      ensure  => file,
      mode    => '0600',
      owner   => 'root',
      group   => 'root',
      content => "NORTHD_OPTS=--db-nb-addr=${dbs_listen_ip} --db-sb-addr=${dbs_listen_ip}",
      before  => Service['northd']
    }

    service { 'northd':
        ensure    => true,
        enable    => true,
        name      => $::ovn::params::ovn_northd_service_name,
        hasstatus => $::ovn::params::ovn_northd_service_status,
        pattern   => $::ovn::params::ovn_northd_service_pattern,
    }

    package { $::ovn::params::ovn_northd_package_name:
        ensure => present,
        name   => $::ovn::params::ovn_northd_package_name,
        before => Service['northd']
    }
}
