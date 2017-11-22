{% set nomad = salt['pillar.get']('nomad', None) %}

{% if not nomad %}
  {{ salt.test.exception("nomad pillar data missing!") }}
{% endif %}
