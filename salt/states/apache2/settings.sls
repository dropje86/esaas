{% set apache2_pillar = salt['pillar.get']('apache2', {}) %}
{% set config = apache2_pillar.get('config', {}) %}
{% set conf_d = apache2_pillar.get('conf_d', {}) %}
{% set modules = apache2_pillar.get('modules', {}) %}
{% set vhosts = apache2_pillar.get('vhosts', {}) %}
