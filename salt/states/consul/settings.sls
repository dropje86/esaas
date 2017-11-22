{% set consul = salt['pillar.get']('consul', None) %}

{% if not consul %}
  {{ salt.test.exception("consul pillar data missing!") }}
{% endif %}

{% set pillar_cluster_name = consul['cluster']['name'] %}

{% set master_dict = salt['mine.get']('G@role:consul and G@cluster:{name}'.format(name=pillar_cluster_name), 'network.ip_addrs', 'compound') %}

{% set master_nodes = master_dict.keys() %}

{% if consul.auto_bootstrap -%}
    {% do consul.config.update({'retry_join': master_nodes}) %}
{% else %}
    {% do consul.config.update({'retry_join': consul.config.retry_join}) %}
{% endif %}

{% do consul.config.update({'retry_join_wan': consul.config.retry_join_wan}) %}
