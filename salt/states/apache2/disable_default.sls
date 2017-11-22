a2dissite 000-default.conf:
  cmd.run:
    - onlyif: test -f /etc/apache2/sites-enabled/000-default.conf
    - watch_in:
      - module: apache2-reload
    - require:
      - pkg: apache2
