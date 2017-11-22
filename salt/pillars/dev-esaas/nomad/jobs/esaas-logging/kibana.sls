{% set cluster = "esaas-logging" %}

{% set kibana_version = "5.6.4" %}
{% set kibana_image = "ebayclassifiedsgroup/kibana:{}".format(kibana_version) %}

nomad:
  jobs:
    {{ cluster }}-kibana:
      contents: |
                job "{{ cluster }}-kibana" {
                    region = "{{ grains['region'] }}"
                    datacenters = ["zone1", "zone2", "zone3"]

                    meta {
                      cluster = "{{ cluster }}"
                    }

                    update {
                        max_parallel = 1
                    }

                    group "kibana" {
                        count = 1

                        constraint {
                            distinct_hosts = true
                        }

                        task "node" {
                            driver = "docker"
                            config {
                                image = "{{ kibana_image }}"
                                network_mode = "host"
                            }

                            env {
                                ELASTICSEARCH_URL = "https://client.{{ salt['grains.get']('domain') }}:443"
                                SERVER_PORT = "${NOMAD_PORT_http}"
                            }

                            service {
                                name = "{{ cluster }}"
                                port = "http"

                                tags = [
                                    "kibana",
                                    "urlprefix-kibana.{{ salt['grains.get']('domain') }}/"
                                ]

                                check {
                                    type = "tcp"
                                    port = "http"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 500
                                memory = 768
                                network {
                                    mbits = 1
                                    port "http" {}
                                }
                            }
                        }
                    }
                }
