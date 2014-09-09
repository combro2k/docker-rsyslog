# DOCKER-VERSION 1.1.2
# VERSION        0.1

FROM ubuntu:14.04
MAINTAINER Justin Plock <justin@plock.net>
MAINTAINER Martijn van Maurik <docker@vmaurik.nl>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y -q install software-properties-common python-software-properties supervisor
RUN add-apt-repository ppa:adiscon/v8-stable
RUN apt-get update && apt-get -y -q install rsyslog

ADD config/etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD config/etc/supervisor/conf.d /etc/supervisor/conf.d
ADD config/etc/rsyslog.d /etc/rsyslog.d

RUN sed 's/$ModLoad imuxsock/#$ModLoad imuxsock/' -i /etc/rsyslog.conf
RUN sed 's/$ModLoad imklog/#$ModLoad imklog/' -i /etc/rsyslog.conf
RUN sed 's/#$ModLoad imudp/$ModLoad imudp/' -i /etc/rsyslog.conf
RUN sed 's/#$UDPServerRun 514/$UDPServerRun 514/' -i /etc/rsyslog.conf
RUN sed 's/#$ModLoad imtcp/$ModLoad imtcp/' -i /etc/rsyslog.conf
RUN sed 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/' -i /etc/rsyslog.conf

EXPOSE 514/tcp 514/udp

VOLUME /var/log/containers

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
