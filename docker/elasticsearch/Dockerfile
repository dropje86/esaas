ARG VERSION=5.5.0
FROM docker.elastic.co/elasticsearch/elasticsearch:$VERSION

ARG VERSION
ARG ES_JAVA_OPTS
ARG KIBANA_PASS
ARG MONITOR_PASS

COPY jvm.options /usr/share/elasticsearch/config/jvm.options
COPY x-pack/roles.yml /usr/share/elasticsearch/config/x-pack/roles.yml

RUN /usr/share/elasticsearch/bin/x-pack/users useradd kibana-esaas -p ${KIBANA_PASS} -r kibana_system \
  && /usr/share/elasticsearch/bin/x-pack/users useradd monitor-esaas -p ${MONITOR_PASS} -r prometheus

USER root

COPY es-docker /usr/share/elasticsearch/bin/es-docker

RUN mkdir -p /tmp/elastic-scripts \
    && chown -R elasticsearch: /usr/share/elasticsearch/config \
    && /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch https://github.com/vvanholl/elasticsearch-consul-discovery/releases/download/${VERSION}.0/elasticsearch-consul-discovery-${VERSION}.0.zip \
    && /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/${VERSION}.0/elasticsearch-prometheus-exporter-${VERSION}.0.zip
