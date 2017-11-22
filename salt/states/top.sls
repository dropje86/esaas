base:
  '*':
    - sysctl
    - timezone
    - dnsmasq
    - consul

  'G@role:consul':
    - apache2

  'G@role:fabio':
    - easyssl
    - fabio
    - apache2

  'G@role:nomad':
    - nomad

  'G@role:nomad_worker':
    - docker
    - nomad
