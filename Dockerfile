FROM python:3.11-alpine
LABEL maintainer="Felippe Rodrigues"
LABEL description="Application for deploying and running Scrapy spiders. Originally created by Zentek Servicios Tecnologicos, forked for simple purpose of bumping the Python version."

ENV PYTHONUNBUFFERED 1

RUN set -ex && apk --no-cache --virtual .build-deps add build-base g++ bash curl gcc libgcc tzdata psutils supervisor linux-headers openssl-dev postgresql-dev libffi-dev libxml2-dev libxslt-dev

RUN ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
RUN echo "Pacific/Auckland" > /etc/timezone

RUN pip install pip==24.2
COPY ./requirements.txt /
RUN pip install -r requirements.txt

RUN mkdir /etc/scrapyd
RUN mkdir -p /scrapyd/logs
COPY scrapyd.conf /etc/scrapyd/
COPY supervisord.conf /etc/

VOLUME /scrapyd
EXPOSE 6800

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
