nomad:
  version: 0.7.0-1

  config:
    advertise:
      http: {{ salt['grains.get']('ipv4')[0] }}:4646
      rpc: {{ salt['grains.get']('ipv4')[0] }}:4647
      serf: {{ salt['grains.get']('ipv4')[0] }}:4648
    bind_addr: 0.0.0.0
    datacenter: {{ salt['grains.get']('availability_zone') }}
    data_dir: /var/lib/nomad
    disable_update_check: true
    region: {{ salt['grains.get']('region') }}
    server:
      enabled: true
      bootstrap_expect: 1
