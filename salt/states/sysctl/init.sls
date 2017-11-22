{% for key, value in salt['pillar.get']('sysctl', {}).iteritems() %}
sysctl-{{ key }}:
  sysctl.present:
    - name: {{ key }}
    - value: {{ value }}
{% endfor %}
