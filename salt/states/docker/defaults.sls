{% set defaults = salt['pillar.get']('docker:defaults', []) %}

docker-defaults:
  file.managed:
    - name: /etc/default/docker
    - source: salt://docker/files/etc/default/docker
    - template: jinja
