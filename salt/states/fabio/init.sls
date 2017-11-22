fabio:
  pkg.installed:
    - version: {{ salt['pillar.get']('fabio:version', 'latest') }}

  service.running:
    - enable: True
    - reload: True

fabio-property-dir:
  # need at least one dict key
  file.directory:
    - name: /etc/fabio
    - makedirs: True

{% for file, content in salt['pillar.get']('fabio:properties', {}).items() %}
fabio-property-file-{{ file }}:
  file.managed:
    - name: /etc/fabio/{{ file }}.properties
    - watch_in:
      - service: fabio
    - contents: |
       {{ content|indent(7) }}
{% endfor %}
