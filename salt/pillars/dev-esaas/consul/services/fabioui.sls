consul:
  services:
    fabioui:
        service:
          id: fabioui-{{ grains['host'] }}
          name: fabioui
          port: 8080
          tags:
            - urlprefix-fabio.{{ salt['grains.get']('domain') }}/
          address: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
          checks:
            - id: fabioui
              tcp: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}:8080
              interval: 3s
              timeout: 1s
