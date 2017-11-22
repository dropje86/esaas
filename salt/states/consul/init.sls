{% from "consul/settings.sls" import consul with context %}

consul:
  group.present:
    - system: true
  user.present:
    - createhome: false
    - system: true
    - gid_from_name: true
  file.directory:
    - name: /etc/consul
  pkg.installed:
    - version: {{ consul.version }}
  service.running:
    - require:
      - file: /etc/consul/config.json

/etc/consul/config.json:
  file.serialize:
    - user: root
    - group: root
    - mode: '0644'
    - dataset: {{ consul.config }}
    - formatter: json
    - watch_in:
       - service: consul

{% if consul is defined and consul.services is defined %}
include:
  - .services
{% endif %}
