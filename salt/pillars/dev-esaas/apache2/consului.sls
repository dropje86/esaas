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
      consul.{{ salt['grains.get']('domain') }}.conf:
        contents: |
                  <VirtualHost *:8080>
                      ServerName consul.{{ salt['grains.get']('domain') }}
                      ServerAlias {{ salt['grains.get']('id') }}

                      ErrorLog /var/log/apache2/consul.{{ salt['grains.get']('domain') }}-error.log
                      CustomLog /var/log/apache2/consul.{{ salt['grains.get']('domain') }}-access.log "%h %l %u %t \"%r\" %>s %O"

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
                      ProxyPass               / http://localhost:8500/
                      ProxyPassReverse        / http://localhost:8500/
                  </VirtualHost>
    disabled: []
