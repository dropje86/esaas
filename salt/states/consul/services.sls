{% from "consul/settings.sls" import consul with context %}

{% if consul is defined and consul.services is defined %}
{% for key, value in consul.services.items() %}
/etc/consul/{{ key ~ '.json' }}:
  file.serialize:
    - user: root
    - group: root
    - mode: '0644'
    - dataset: {{ value }}
    - formatter: json
    - watch_in:
      - service: consul
    - require:
      - pkg: consul
{% endfor %}
{% endif %}
