nomad:
  version: 0.7.0-1

  config:
    advertise:
      http: {{ salt['grains.get']('ipv4')[0] }}:4646
    bind_addr: 0.0.0.0
    client:
      enabled: true
      network_speed: 1000
      options:
        docker.cleanup.image: false
      reserved:
        memory: 512
        disk: 2000
    datacenter: {{ salt['grains.get']('availability_zone') }}
    data_dir: /var/lib/nomad
    disable_update_check: true
    region: {{ salt['grains.get']('region') }}
