{% from "apache2/settings.sls" import config with context %}

{% for filename, value in config.iteritems() %}
/etc/apache2/{{ filename }}:
  file.managed:
    - contents: |
       {{ value.contents|indent(7) }}
    - watch_in:
      - service: apache2
    - require:
      - pkg: apache2
{% endfor %}
