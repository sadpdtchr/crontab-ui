FROM alpine:latest

RUN   mkdir /crontab-ui; touch /etc/crontabs/root; chmod +x /etc/crontabs/root

WORKDIR /crontab-ui

LABEL maintainer "@sadpdtchr"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      python \
      py-lxml \
      git \
      gcc \
      libxml2-dev \
      python3
RUN   pip3 install -e git+https://github.com/C2Devel/boto.git@2.46.1-CROC14#egg=boto && pip3 install c2client

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

ENV   HOST 0.0.0.0

ENV   C2_PROJECT="PSadovov"
ENV   S3_URL="https://storage.cloud.croc.ru:443"
ENV   EC2_URL="https://api.cloud.croc.ru:443"
ENV   AWS_CLOUDWATCH_URL="https://monitoring.cloud.croc.ru:443"
ENV   EC2_ACCESS_KEY="${C2_PROJECT}:psadovov@ccs.croc.ru"
ENV   EC2_SECRET_KEY="P6jEB+GLRdqtg/b9torB9Q"
ENV   AWS_ACCESS_KEY_ID="$EC2_ACCESS_KEY"
ENV   AWS_SECRET_ACCESS_KEY="$EC2_SECRET_KEY"

ENV   PORT 8000

ENV   CRON_PATH /etc/crontabs
ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
