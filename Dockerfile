FROM ubuntu

MAINTAINER georgesoteriou

RUN apt-get update
RUN apt-get -y install wget screen unzip curl

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_VERSION="template"
ENV GAME_MOD="template"
ENV GAME_PARAMS="template"
ENV MODLOADER_VER="template"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID terraria
RUN chown -R terraria $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R terraria /opt/scripts

USER terraria

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
