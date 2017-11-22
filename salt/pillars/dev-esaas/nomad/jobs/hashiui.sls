nomad:
  jobs:
    hashiui:
      contents: |
                job "hashiui" {
                    region = "{{ grains['region'] }}"
                    datacenters = ["zone1", "zone2", "zone3"]

                    group "web" {
                        count = 1

                        task "hashiui" {
                            driver = "docker"
                            config {
                                image = "jippi/hashi-ui:v0.22.0"
                                network_mode = "host"
                            }

                            env {
                                NOMAD_ADDR = "http://nomad.service.consul:4646"
                                CONSUL_ENABLE = 1
                                NOMAD_ENABLE = 1
                            }

                            service {
                                name = "${JOB}"
                                port = "http"

                                check {
                                    type = "http"
                                    path = "/nomad"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 500
                                memory = 128
                                network {
                                    mbits = 1
                                    port "http" {}
                                }
                            }
                        }

                        task "nginx" {
                            driver = "docker"
                            config {
                                image = "ygersie/nginx-ldap-lua:1.11.3"
                                network_mode = "host"
                                volumes = [
                                    "local/config/nginx.conf:/etc/nginx/nginx.conf"
                                ]
                            }

                            template {
                                data = <<EOF
                worker_processes 2;

                events {
                  worker_connections 1024;
                }

                env NS_IP;
                env NS_PORT;

                http {
                  access_log /dev/stdout;
                  error_log /dev/stderr;

                  auth_ldap_cache_enabled on;
                  auth_ldap_cache_expiration_time 300000;
                  auth_ldap_cache_size 10000;

                  ldap_server ldap_server1 {
                    url ldaps://ldap.example.com/ou=People,dc=example,dc=com?uid?sub?(objectClass=inetOrgPerson);
                    group_attribute_is_dn on;
                    group_attribute member;
                    satisfy any;
                    require group "cn=groupname,ou=Groups,dc=example,dc=com";
                  }

                  map $http_upgrade $connection_upgrade {
                    default upgrade;
                    '' close;
                  }

                  server {
                    listen {% raw %}{{ env "NOMAD_PORT_http" }}{% endraw %};

                    location = /health {
                      return 200;
                    }

                    location / {
                      auth_ldap "Login";
                      auth_ldap_servers ldap_server1;

                      set $target '';
                      set $service "hashiui.service.consul";
                      set_by_lua_block $ns_ip { return os.getenv("NS_IP") or "127.0.0.1" }
                      set_by_lua_block $ns_port { return os.getenv("NS_PORT") or 53 }

                      access_by_lua_file /etc/nginx/srv_router.lua;

                      proxy_set_header Upgrade $http_upgrade;
                      proxy_set_header Connection $connection_upgrade;

                      proxy_read_timeout 31d;

                      proxy_pass http://$target;
                    }
                  }
                }
                EOF
                                destination = "local/config/nginx.conf"
                                change_mode = "noop"
                            }

                            service {
                                port = "http"

                                tags = [
                                    "urlprefix-hashi-ui.{{ salt['grains.get']('domain') }}/"
                                ]

                                check {
                                    type = "http"
                                    path = "/health"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 100
                                memory = 64
                                network {
                                    mbits = 1
                                    port "http" {}
                                }
                            }
                        }
                    }
                }
