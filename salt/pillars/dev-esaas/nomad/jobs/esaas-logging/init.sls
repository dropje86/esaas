{% set environment = grains['environment'] %}
{% set cluster = "esaas-logging" %}

include:
  - {{ environment }}.nomad.jobs.{{ cluster }}.zone1
  - {{ environment }}.nomad.jobs.{{ cluster }}.zone2
  - {{ environment }}.nomad.jobs.{{ cluster }}.zone3
  - {{ environment }}.nomad.jobs.{{ cluster }}.kibana
