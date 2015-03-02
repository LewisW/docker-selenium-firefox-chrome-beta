mkdir -p build/logs
export DISPLAY=:99

echo -e "\e[1;4mLaunching Virtual Screen\e[0m"
xvfb $DISPLAY -shmem -ac -screen 0 1024x768x16 > build/logs/xvfb.log 2>&1 &

if [ "$SCREEN" == "VNC" ] || [ "$SCREEN" == "Record VNC" ]; then
  echo -e "\e[1;4mLaunching VNC Server\e[0m"
  
  #vncserver $DISPLAY -localhost -securitytypes=none
  x11vnc -localhost -nopw -display $DISPLAY -N -forever & > build/logs/vnc.log 2>&1 &

  if [ "$SCREEN" == "VNC & Record" ]; then
    echo -e "\e[1;4mLaunching VNC Recorder\e[0m"
    flvrec.py -o build/vnc.flv localhost$DISPLAY > build/logs/flvrec.log 2>&1 &
  fi
  
fi

if [ "$Selenium" == "Selenium" ]; then
    echo -e "\e[1;4mLaunching Selenium\e[0m"
    # selenium must be started by a non-root user otherwise chrome can't start
    su - seleuser -c "selenium-standalone start > build/logs/selenium.log 2>&1 &"
elif [ "$Selenium" == "PhantomJS" ]; then
    echo -e "\e[1;4mLaunching PhantomJS\e[0m"
    phantomjs --webdriver=4444 > build/logs/phantomjs.log 2>&1 &
fi
