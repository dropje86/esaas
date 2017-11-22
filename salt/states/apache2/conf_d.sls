{% from "apache2/settings.sls" import conf_d with context %}

{% for filename, value in conf_d.get('enabled', {}).iteritems() %}
/etc/apache2/conf-available/{{ filename }}:
  file.managed:
    - contents: |
       {{ value.contents|indent(7) }}
    - watch_in:
      - service: apache2
    - require:
      - pkg: apache2

a2enconf {{ filename }}:
  cmd.run:
    - creates: /etc/apache2/conf-enabled/{{ filename }}
    - require:
      - file: /etc/apache2/conf-available/{{ filename }}
    - watch_in:
      - service: apache2
{% endfor %}

{% for filename in conf_d.get('disabled', []) %}
a2disconf {{ filename }}:
  cmd.run:
    - unless: 'test ! -f /etc/apache2/conf-enabled/{{ filename }}'
    - watch_in:
      - service: apache2
    - require:
      - pkg: apache2
{% endfor %}
