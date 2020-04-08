FROM quay.io/pires/docker-elasticsearch:6.1.3

MAINTAINER pjpires@gmail.com

# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config

# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery
ENV ACCESS_KEY access_key
ENV SECRET_KEY secert_key
ENV S3_ENDPOINT endpoint
ENV S3_PROTOCOL https
ENV STATSD_HOST=statsd.statsd.svc.cluster.local
ENV SEARCHGUARD_SSL_TRANSPORT_ENABLED=true
ENV SEARCHGUARD_SSL_HTTP_ENABLED=true

# Fix bug installing plugins
ENV NODE_NAME=""

# Install search-guard-ssl
# RUN ./bin/elasticsearch-plugin install https://repo1.maven.org/maven2/com/floragunn/search-guard-ssl/6.1.3-25.1/search-guard-ssl-6.1.3-25.1.zip

# Install s3 repository plugin
RUN ./bin/elasticsearch-plugin install -b repository-s3

# Install gcs repostory plugin
RUN ./bin/elasticsearch-plugin install -b repository-gcs

# Install statsd plugin
RUN ./bin/elasticsearch-plugin install -b https://github.com/Automattic/elasticsearch-statsd-plugin/releases/download/6.1.3.0/elasticsearch-statsd-6.1.3.0.zip

# Install prometheus plugin
RUN ./bin/elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/6.1.3.0/elasticsearch-prometheus-exporter-6.1.3.0.zip

ADD scripts /elasticsearch/scripts

RUN apk add --update-cache jq
