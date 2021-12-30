# == Class: bind
#
# === Examples
#
#  class { 'bind':
#    listen_on       => '{ 127.0.0.1; }',
#    zone            => {
#      'example.com' => [
#        'type master',
#        'file "/etc/bind/zones/example.com.db"',
#      ],
#    },
#  }
#
# === Authors
#
# Aneesh C <aneeshchandrasekharan@gmail.com>
#

class bind (
  $package_name           = $::bind::params::package_name,
  $service_name           = $::bind::params::service_name,
  $config_file            = $::bind::params::config_file,
  $template               = 'bind/configfile.erb',
  $acl                    = [],
  $listen_on              = undef,
  $listen_on_v6           = undef,
  $directory              = undef,
  $dump_file              = undef,
  $statistics_file        = undef,
  $memstatistics_file     = undef,
  $allow_query            = undef,
  $allow_update           = undef,
  $allow_transfer         = undef,
  $blackhole              = undef,
  $recursion              = undef,
  $allow_recursion        = undef,
  $dnssec_enable          = undef,
  $dnssec_validation      = undef,
  $bindkeys_file          = undef,
  $managed_keys_directory = undef,
  $pid_file               = undef,
  $session_keyfile        = undef,
  $auth_nxdomain          = undef,
  $version                = undef,
  $server_id              = undef,
  $cleaning_interval      = undef,
  $interface_interval     = undef,
  $max_ncache_ttl         = undef,
  $nnotify                = undef,
  $logging                = undef,
  $logging_config         = undef,
  $zone                   = [],
  $include                = [],
) inherits ::bind::params {
  package { $package_name:
    ensure => installed
  }
  file { $config_file:
    backup  => '.backup',
    content => template($template),
    require => Package[$package_name],
  }
  service { $service_name:
    enable  => true,
    require => [ Package[$package_name], File[$config_file] ],
  }
}
