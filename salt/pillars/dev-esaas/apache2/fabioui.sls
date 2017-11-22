apache2:
  config:
    ports.conf:
      contents: |
                Listen 8080

  modules:
    enabled:
      - ldap
      - authnz_ldap
      - proxy_http
      - ssl
      - rewrite
    disabled: []

  vhosts:
    enabled:
      fabio.{{ salt['grains.get']('domain') }}.conf:
        contents: |
                  <VirtualHost *:8080>
                      ServerName fabio.{{ salt['grains.get']('domain') }}
                      ServerAlias {{ salt['grains.get']('id') }}

                      ErrorLog /var/log/apache2/fabio.{{ salt['grains.get']('domain') }}-error.log
                      CustomLog /var/log/apache2/fabio.{{ salt['grains.get']('domain') }}-access.log "%h %l %u %t \"%r\" %>s %O"

                      RewriteEngine On
                      RewriteCond expr "! %{HTTP:X-Forwarded-Proto} -strmatch 'https'"
                      RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

                      <Location />
                          AuthBasicProvider "ldap"
                          AuthLDAPURL "ldaps://ldap.example.com/ou=People,dc=example,dc=com"
                          AuthName "consul.{{ salt['grains.get']('domain') }}"
                          AuthType "Basic"
                          AuthUserFile "/dev/null"
                          Require ldap-group cn=groupname,ou=Groups,dc=example,dc=com
                      </Location>

                      ProxyPreserveHost On
                      ProxyPass               / http://localhost:9998/
                      ProxyPassReverse        / http://localhost:9998/
                  </VirtualHost>
    disabled: []
