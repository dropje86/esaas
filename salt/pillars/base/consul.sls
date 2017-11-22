consul:
  cluster:
    name: default

  version: 0.9.2-ent1
  auto_bootstrap: false

  config:
    bind_addr: 0.0.0.0
    advertise_addr: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
    client_addr: 127.0.0.1
    datacenter: {{ salt['grains.get']('region') }}
    data_dir: /var/lib/consul
    disable_update_check: true
    enable_debug: false
    enable_syslog: true
    encrypt: iAk/RvQm4v3PERWRq2EXjA==
    log_level: info
    retry_interval: 3s
    retry_join: ["consul001"]
    retry_join_wan: []
    server: false
