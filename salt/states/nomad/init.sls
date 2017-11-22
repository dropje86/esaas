{% from "nomad/settings.sls" import nomad with context %}

nomad:
  pkg.installed:
    - version: {{ nomad.version }}
  service.running: []

nomad-config:
  file.serialize:
    - name: /etc/nomad/config.json
    - dataset: {{ nomad.config }}
    - formatter: json
    - watch_in:
      - service: nomad

include:
  - .jobs
