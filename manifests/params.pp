class bind::params {
  if $::osfamily == 'RedHat' {
    $package_name = [ 'bind', 'bind-chroot' ]
    $config_file  = '/etc/named.conf'
    $zonedir = '/var/named/'
    $zonegroup = 'named'
    $service_name = 'named'
  }
  elsif $::osfamily == 'Debian' {
    $package_name = [ 'bind9' ]
    $config_file = '/etc/bind/named.conf'
    $zonedir = '/etc/bind/zones/'
    $zonegroup = 'bind'
    $service_name = 'bind9'
  }
}
