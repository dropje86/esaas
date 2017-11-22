{% from "apache2/settings.sls" import vhosts with context %}

{% for filename, value in vhosts.get('enabled', {}).iteritems() %}
/etc/apache2/sites-available/{{ filename }}:
  file.managed:
    - contents: |
       {{ value.contents|indent(7) }}
    - watch_in:
      - module: apache2-reload
    - require:
      - pkg: apache2

a2ensite {{ filename }}:
  cmd.run:
    - creates: /etc/apache2/sites-enabled/{{ filename }}
    - require:
      - file: /etc/apache2/sites-available/{{ filename }}
    - watch_in:
      - module: apache2-reload
{% endfor %}

{% for filename in vhosts.get('disabled', []) %}
a2dissite {{ filename }}:
  cmd.run:
    - unless: 'test ! -f /etc/apache2/sites-enabled/{{ filename }}'
    - watch_in:
      - module: apache2-reload
    - require:
      - pkg: apache2
{% endfor %}
