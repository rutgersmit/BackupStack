FROM ubuntu

COPY . .

RUN apt-get update && apt-get install -y rsync

RUN mkdir /source_data
RUN mkdir /config

VOLUME /config/id_rsa.pub

ENV REMOTE_HOST=
ENV REMOTE_PORT=22
ENV REMOTE_PATH=/
ENV REMOTE_USER=

CMD ["bash", "/start.sh"] 