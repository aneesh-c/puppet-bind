define bind::zone_file (
  $package_name = $::bind::params::package_name,
  $template     = 'bind/zone_file.erb',
  $zonedir      = $::bind::params::zonedir,
  $zonegroup    = $::bind::params::zonegroup,
  $file_name    = undef,
  $nameserver   = undef,
  $admin        = undef,
  $ttl          = undef,
  $serial       = undef,
  $refresh      = undef,
  $retry        = undef,
  $expire       = undef,
  $minimum      = undef,
  $records      = [],
) {
  include bind::params
  if ! defined(File[$zonedir]) {
    file { $zonedir:
      ensure => directory,
    }
  }
  file { "${zonedir}${file_name}":
    require => Package[$package_name],
    content => template($template),
    group   => $zonegroup,
    mode    => '0640',
    notify  => Service["named"]
  }
}
