{% from "apache2/settings.sls" import apache2_pillar with context %}

apache2-pkg:
{% if apache2_pillar.get('version') %}
  pkg.installed:
    - name: apache2
    - version: {{ apache2_pillar.get('version') }}
{% else %}
  pkg.installed:
    - name: apache2
{% endif %}
