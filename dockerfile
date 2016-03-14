# Usage: FROM [image name]
FROM debian

# Usage: MAINTAINER [name]
MAINTAINER weezhard

# Variables
ENV GRAFANA_VERSION 2.6.0


# Install wget
RUN apt-get update && \
    apt-get install -y -q wget

# Install grafana
RUN wget -q https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz -O /opt/grafana.tar.gz && \
    cd /opt && tar -xzvf grafana.tar.gz && \
    mv /opt/grafana-$GRAFANA_VERSION /opt/grafana

# Clean apt
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /opt/grafana.tar.gz

## Adduser grafana
RUN useradd grafana
RUN chown -R grafana:grafana /opt/grafana


#COPY conf/custom.ini /opt/grafana/conf/custom.ini

# Volume, Expose and Startup
VOLUME ["/opt/grafana/data", "/opt/grafana/data/logs"]

EXPOSE 3000

ENTRYPOINT ["/opt/grafana/bin/grafana-server", "--homepath=/opt/grafana", "cfg:default.paths.data=/opt/grafana/data", "cfg:default.paths.logs=/opt/grafana/data/logs"]
