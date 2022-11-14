FROM python:3.10-slim-buster
MAINTAINER Eric Busboom "eric@civicknowledge.com"

VOLUME /opt/metapack
WORKDIR  /opt/metapack

RUN  apt-get update && \
     apt-get install -y g++ gcc  python3-dev libxml2 libxml2-dev libxslt-dev  bash git cron  curl unzip

RUN cd /tmp &&\
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN pip install metapack-build metapack-wp publicdata_census invoke #2

RUN git clone https://github.com/metatab-packages/template-collection.git  collection

ADD metapack.cron /etc/cron.d/metapack.base
ADD boto.cfg /etc/boto.cfg

# Now append all commands in crons file to crontab file
RUN cat /etc/cron.d/metapack.base >> /etc/cron.d/metapack

RUN crontab /etc/cron.d/metapack

ADD metapack.yaml /etc/metapack.yaml

ADD build_metapack.sh /opt/metapack/build_metapack.sh
RUN chmod +x /opt/metapack/build_metapack.sh

CMD ["cron", "-f", "-L15"] 