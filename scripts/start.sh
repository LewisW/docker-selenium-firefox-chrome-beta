#!/bin/bash

export DISPLAY=:99

mkdir -p /build
chmod -R 777 /build

echo -e "\e[1;4mLaunching Virtual Screen\e[0m"
Xvfb $DISPLAY -shmem -ac -screen 0 1024x768x16 > /build/xvfb.log 2>&1 &

if [ "$SCREEN" == "VNC" ] || [ "$SCREEN" == "Record VNC" ]; then
  echo -e "\e[1;4mLaunching VNC Server\e[0m"
  
  x11vnc -localhost -nopw -display $DISPLAY -N -forever > /build/vnc.log 2>&1 &

  if [ "$SCREEN" == "Record VNC" ]; then
    echo -e "\e[1;4mLaunching VNC Recorder\e[0m"
    flvrec.py -o build/vnc.flv localhost$DISPLAY > /build/flvrec.log 2>&1 &
  fi
  
fi

if [ "$SELENIUM" == "PhantomJS" ]; then
    echo -e "\e[1;4mLaunching PhantomJS\e[0m"
    phantomjs --webdriver=4444 > /build/phantomjs.log 2>&1
else
    echo -e "\e[1;4mLaunching Selenium\e[0m"
    # selenium must be started by a non-root user otherwise chrome can't start
    su - seleuser -c "selenium-standalone start > /build/selenium.log 2>&1"
fi
