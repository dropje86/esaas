{% set docker_group_members = salt['pillar.get']('docker:group_members') %}

{% if docker_group_members %}
docker_group:
  group.present:
    - name: docker
    - system: True
    - members: {{ docker_group_members }}
{% endif %}
