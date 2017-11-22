{% set dnsmasq = salt['pillar.get']('dnsmasq', '{}') %}

dnsmasq-install:
  pkg.installed:
    - name: dnsmasq
    - require_in:
      - service: dnsmasq-service

dnsmasq-service:
  service.running:
    - name: dnsmasq

{% for key, value in dnsmasq.config.items() %}
/etc/dnsmasq.d/{{ key }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
       {{ value.contents|indent(7) }}
    - watch_in:
      - service: dnsmasq-service
{% endfor %}
