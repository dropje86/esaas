dnsmasq:
  config:
    10-consul:
      contents: |
                bind-interfaces
                listen-address=127.0.0.1
                server=/.consul/127.0.0.1#8600
                cache-size=0
                no-negcache
                no-hosts
