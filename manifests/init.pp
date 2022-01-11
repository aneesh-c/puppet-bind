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
  $acl                    = [],
  $allow_query            = undef,
  $allow_recursion        = undef,
  $allow_update           = undef,
  $allow_transfer         = undef,
  $auth_nxdomain          = undef,
  $bindkeys_file          = undef,
  $blackhole              = undef,
  $cleaning_interval      = undef,
  $config_file            = $::bind::params::config_file,
  $directory              = undef,
  $dnssec_enable          = undef,
  $dnssec_validation      = undef,
  $dump_file              = undef,
  $enable                 = true,
  $ensure                 = 'running',
  $interface_interval     = undef,
  $template               = 'bind/configfile.erb',
  $listen_on              = undef,
  $listen_on_v6           = undef,
  $logging                = undef,
  $logging_config         = undef,
  $managed_keys_directory = undef,
  $max_ncache_ttl         = undef,
  $memstatistics_file     = undef,
  $nnotify                = undef,
  $package_name           = $::bind::params::package_name,
  $pid_file               = undef,
  $recursion              = undef,
  $session_keyfile        = undef,
  $server_id              = undef,
  $service_name           = $::bind::params::service_name,
  $statistics_file        = undef,
  $sysconfig_params       = ['OPTIONS="-4"'],
  $version                = undef,
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
    enable  => $enable,
    ensure  => $ensure,
    require => [ Package[$package_name], File[$config_file] ],
  }
  if $sysconfig_params {
    $params = join($sysconfig_params, "\n")
    file { '/etc/sysconfig/named':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      content => $params
    }
  }
}
