fabio:
  version: 1.5.2-1
  properties:
    fabio: |
           proxy.cs = cs=ssl;type=path;cert=/etc/fabio/ssl
           proxy.addr = :80,:443;cs=ssl
