#
#
# == Class: profiles::dns::bind
#
# installs and configures dns bind
#
# === Parameters:
#
# [*enabled*] - enables/disables the profile
#
# === Notes:
#
# Use bind_config hash in hiera to configure dns bind
#
# bind_config:
#   class_params:
#    directory: '/var/named'
#    dump_file: '/var/named/data/cache_dump.db'
#    statistics_file: '/var/named/data/named_stats.txt'
#    memstatistics_file: '/var/named/data/named_mem_stats.txt'
#    recursion: 'no'
#    dnssec_enable: 'yes'
#    dnssec_validation: 'yes'
#    bindkeys_file: '/etc/named.iscdlv.key'
#    managed_keys_directory: '/var/named/dynamic'
#    pid_file: '/run/named/named.pid'
#    session_keyfile: '/run/named/session.key'
#    nnotify: 'master-only'
#    request_ixfr: 'no'
#    logging: 'yes'
#    listen_on: 
#      - '%{::ipaddress}'
#    listen_on_v6:
#      - '::1'
#    allow_query:
#      - '10.0.0.0/8'
#    allow_update:
#      - 'key "mysecet"'
#    allow_transfer:
#      - 'none'
#    statistics_channels:
#      %{::ipaddress}:
#        - '10.0.0.0/8'
#    include: 
#      - '/etc/named.rfc1912.zones'
#      - '/etc/named.root.key'
#    key:
#      mysecret:
#        - 'algorithm hmac-md5'
#        - 'secret "<mysecretkey>"'
#    zone:
#      local.net:
#        - 'type master'
#        - 'file "local.net"'
#        - 'allow-transfer { none; }'
#        - 'allow-query { any; }'
#        - 'allow-update { none; }'
#  zone_files:
#    local.net:
#      file_name: 'local.net'
#      serial: '1'
#      records:
#        - '@            IN    NS      %{::fqdn}.'
#        - 'testsrv01    IN    A       10.0.0.2'
#
#
class profiles::dns::bind (
    $enabled = true,
) {
    #
    # Explicit resource tagging for restricted runs
    #
    tag regsubst($name, ':', '_', 'G')

    if (is_bool($enabled) and $enabled) or str2bool($enabled) {
        $config     = hiera_cross('bind_config', {})
        $empty_hash = {}
        $defaults = {}

        $class_params = has_key($config, 'class_params') ? {
            true    => $config['class_params'],
            default => $empty_hash
        }

        $zone_files = has_key($config, 'zone_files') ? {
            true    => $config['zone_files'],
            default => $empty_hash
        }

        # create the class
        create_resources('class', { bind => $class_params }, $defaults )
        create_resources('bind::zone_file', $zone_files)
    }
}
