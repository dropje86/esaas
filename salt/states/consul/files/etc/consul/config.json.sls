{% from "consul/settings.sls" import consul with context %}
{{ consul.config | json(indent=4) }}
