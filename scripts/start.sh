export DISPLAY=:99

if [ "$SCREEN" == "VNC" ] || [ "$SCREEN" == "Record VNC" ]; then
  echo -e "\e[1;4mLaunching VNC Server\e[0m"
  vncserver $DISPLAY -localhost -securitytypes=none
  
  if [ "$SCREEN" == "VNC & Record" ]; then
    echo -e "\e[1;4mLaunching VNC Recorder\e[0m"
    flvrec.py -o build/vnc.flv localhost$DISPLAY > flvrec.log 2>&1 &
  fi
else
  echo -e "\e[1;4mLaunching Virtual Screen\e[0m"
  xvfb $DISPLAY -shmem -ac -screen 0 1024x768x16 > xvfb.log 2>&1 &
fi

if [ "$SELENIUM" == "PhantomJS" ]; then
    echo -e "\e[1;4mLaunching PhantomJS\e[0m"
    phantomjs --webdriver=4444 > phantomjs.log 2>&1 &
else
    echo -e "\e[1;4mLaunching Selenium\e[0m"
    # selenium must be started by a non-root user otherwise chrome can't start
    su - seleuser -c "selenium-standalone start > selenium.log 2>&1 &"
fi
