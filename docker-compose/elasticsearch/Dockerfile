FROM elasticsearch:8.5.0

USER root

COPY plugins/elasticsearch-analysis-ik-8.5.0.zip /tmp/

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch \
    file:///tmp/elasticsearch-analysis-ik-8.5.0.zip

RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/plugins

USER elasticsearch
