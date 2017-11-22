{% set environment = grains['environment'] %}

{{saltenv}}:
  '*':
    - base
    - base.consul
    - base.dnsmasq

  'G@role:consul':
    - {{ environment }}.apache2.consului
    - {{ environment }}.consul.server
    - {{ environment }}.consul.services.consului

  'G@role:fabio':
    - {{ environment }}.fabio
    - {{ environment }}.apache2.fabioui
    - {{ environment }}.consul.services.fabioui

  'G@role:nomad':
    - {{ environment }}.nomad.server
    - {{ environment }}.nomad.jobs.hashiui
    - {{ environment }}.nomad.jobs.esaas-logging

  'G@role:nomad_worker':
    - {{ environment }}.sysctl.nomad_worker
    - {{ environment }}.nomad.client
