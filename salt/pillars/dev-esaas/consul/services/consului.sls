consul:
  services:
    consului:
      service:
        id: consului-{{ grains['host'] }}
        name: consului
        port: 8080
        tags:
          - urlprefix-consul.{{ salt['grains.get']('domain') }}/
        address: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
        checks:
          - id: consului
            tcp: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}:8080
            interval: 3s
            timeout: 1s
