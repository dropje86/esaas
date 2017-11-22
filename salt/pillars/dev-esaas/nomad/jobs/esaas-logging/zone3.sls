{% set cluster = "esaas-logging" %}
{% set zone = "zone3" %}

{% set es_version = "5.6.4" %}
{% set es_image = "docker-registry.example.com/elasticsearch:{}".format(es_version) %}
{% set config_urlprefix = "https://swiftobjectstorage.example.com/v1/ddae182a54af4c048d31f5f89ef1743d/esaas-configs/{}".format(es_version) %}

nomad:
  jobs:
    {{ cluster }}-{{ zone }}:
      contents: |
                job "{{ cluster }}-{{ zone }}" {
                    region = "{{ grains['region'] }}"
                    datacenters = ["{{ zone }}"]

                    meta {
                      cluster = "{{ cluster }}"
                    }

                    constraint {
                      attribute = "${node.datacenter}"
                      value     = "{{ zone }}"
                    }

                    update {
                        max_parallel = 1
                    }

                    group "master" {
                        count = 1

                        ephemeral_disk {
                            size = 1000
                            sticky = true
                            migrate = true
                        }

                        task "node" {
                            driver = "docker"
                            config {
                                image = "{{ es_image }}"
                                network_mode = "host"
                                volumes = [
                                    "local/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml",
                                    "local/data/:/usr/share/elasticsearch/data/"
                                ]
                            }

                            artifact {
                                source = "{{ config_urlprefix }}/master/elasticsearch.yml"
                                destination = "local/config"
                            }

                            env {
                                ES_JAVA_OPTS = "-Xms1536m -Xmx1536m"
                                AVAILABILITY_ZONE = "${node.datacenter}"
                            }

                            service {
                                name = "{{ cluster }}"
                                port = "transport"

                                tags = [
                                    "master-transport"
                                ]

                                check {
                                    type = "tcp"
                                    port = "transport"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            service {
                                name = "{{ cluster }}"
                                port = "http"

                                tags = [
                                    "master-http"
                                ]

                                check {
                                    type = "tcp"
                                    port = "http"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 1000
                                memory = 2048
                                network {
                                    mbits = 1
                                    port "http" {}
                                    port "transport" {}
                                }
                            }
                        }
                    }

                    group "data" {
                        count = 1

                        ephemeral_disk {
                            size = 25000
                            sticky = true
                            migrate = true
                        }

                        task "node" {
                            driver = "docker"
                            config {
                                image = "{{ es_image }}"
                                network_mode = "host"
                                volumes = [
                                    "local/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml",
                                    "local/data/:/usr/share/elasticsearch/data/"
                                ]
                            }

                            artifact {
                                source = "{{ config_urlprefix }}/data/elasticsearch.yml"
                                destination = "local/config"
                            }

                            env {
                                ES_JAVA_OPTS = "-Xms3072m -Xmx3072m"
                                AVAILABILITY_ZONE = "${node.datacenter}"
                            }

                            service {
                                name = "{{ cluster }}"
                                port = "http"

                                tags = [
                                    "data"
                                ]

                                check {
                                    type = "tcp"
                                    port = "http"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 3000
                                memory = 4096
                                network {
                                    mbits = 1
                                    port "http" {}
                                    port "transport" {}
                                }
                            }
                        }
                    }

                    group "client" {
                        count = 1

                        task "node" {
                            driver = "docker"
                            config {
                                image = "{{ es_image }}"
                                network_mode = "host"
                                volumes = [
                                    "local/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml"
                                ]
                            }

                            artifact {
                                source = "{{ config_urlprefix }}/client/elasticsearch.yml"
                                destination = "local/config"
                            }

                            env {
                                ES_JAVA_OPTS = "-Xms2560m -Xmx2560m"
                                AVAILABILITY_ZONE = "${node.datacenter}"
                            }

                            service {
                                name = "{{ cluster }}"
                                port = "http"

                                tags = [
                                    "client",
                                    "urlprefix-client.{{ salt['grains.get']('domain') }}/"
                                ]

                                check {
                                    type = "tcp"
                                    port = "http"
                                    interval = "3s"
                                    timeout = "1s"
                                }
                            }

                            resources {
                                cpu = 2000
                                memory = 3072
                                network {
                                    mbits = 1
                                    port "http" {}
                                    port "transport" {}
                                }
                            }
                        }
                    }
                }
