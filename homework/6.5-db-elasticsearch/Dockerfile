FROM centos:7

LABEL ELASTIC by ASTORF

ENV ES_HOME=/var/lib/elasticsearch
ENV ES_CONFIG=/var/lib/elasticsearch/config/

USER root

RUN \
  yum update -y && \
  yum install -y perl-Digest-SHA && \
  yum install -y wget && \
  yum install -y tar && \
  yum install -y java-1.8.0-openjdk && \
  yum install -y java-1.8.0-openjdk-devel 
  
RUN \
  useradd -m -u 1000 elasticsearch && \
  mkdir -p ${ES_HOME} && \
  chown elasticsearch:elasticsearch -R ${ES_HOME} 
  
USER elasticsearch  

RUN \
  wget -P /tmp/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-$(arch).tar.gz && \
  tar -C ${ES_HOME} -xvf /tmp/elasticsearch-7.17.0-linux-x86_64.tar.gz --strip-components 1 && \
  rm -f /tmp/elasticsearch-7.17.0-linux-x86_64.tar.gz 

COPY --chown=elasticsearch:elasticsearch config/* ${ES_CONFIG}

EXPOSE 9200
EXPOSE 9300

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]



