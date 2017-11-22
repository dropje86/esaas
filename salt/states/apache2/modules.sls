{% from "apache2/settings.sls" import modules with context %}

{% for mod_name in modules.get('enabled', []) %}
a2enmod {{ mod_name }}:
  cmd.run:
    - creates: /etc/apache2/mods-enabled/{{ mod_name }}.load
    - watch_in:
      - service: apache2
    - require:
      - pkg: apache2
{% endfor %}

{% for mod_name in modules.get('disabled', []) %}
a2dismod {{ mod_name }}:
  cmd.run:
    - unless: 'test ! -f /etc/apache2/mods-enabled/{{ mod_name }}.load'
    - watch_in:
      - service: apache2
    - require:
      - pkg: apache2
{% endfor %}
