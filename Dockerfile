FROM ubuntu:trusty
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

MAINTAINER Vincent Voyer <vincent@zeroload.net>
RUN apt-get -y update
RUN apt-get install -y -q software-properties-common wget
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update -y
RUN apt-cache showpkg google-chrome-stable
RUN apt-get install -y -q \
  firefox \
  google-chrome-stable \
  openjdk-7-jre-headless \
  nodejs \
  dbus-x11 \
  x11vnc \
  xvfb \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  python-dev \
  python-apt \
  python-pip 
RUN useradd -d /home/seleuser -m seleuser
RUN mkdir -p /home/seleuser/chrome
RUN chown -R seleuser:seleuser /home/seleuser
# fix https://code.google.com/p/chromium/issues/detail?id=318548
RUN mkdir -p /usr/share/desktop-directories
RUN npm install -g \
  selenium-standalone@latest -g \
  phantomjs && \
  selenium-standalone install && \
  pip install vnc2flv
ADD ./scripts/ /home/root/scripts
EXPOSE 4444 5999
CMD ["/home/root/scripts/start.sh"]
