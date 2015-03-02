mkdir -p build/logs
export DISPLAY=:99

if [ "$Screen" == "VNC" ] || [ "$Screen" == "VNC & Record" ]; then
  echo -e "\e[1;4mLaunching VNC Server\e[0m"
  #vncserver $DISPLAY -localhost -securitytypes=none
  
  xvfb $DISPLAY -shmem -ac -screen 0 1024x768x16 > build/logs/xvfb.log 2>&1 &
  x11vnc -passwd secret -display :99 -N -forever &

  if [ "$Screen" == "VNC & Record" ]; then
    echo -e "\e[1;4mLaunching VNC Recorder\e[0m"
    flvrec.py -o build/vnc.flv localhost$DISPLAY > build/logs/flvrec.log 2>&1 &
  fi
  
else
  xvfb $DISPLAY -shmem -ac -screen 0 1024x768x16 > build/logs/xvfb.log 2>&1 &
fi

if [ "$Selenium" == "Selenium" ]; then
    echo -e "\e[1;4mLaunching Selenium\e[0m"
    # selenium must be started by a non-root user otherwise chrome can't start
    su - seleuser -c "selenium-standalone start > build/logs/selenium.log 2>&1 &"
elif [ "$Selenium" == "PhantomJS" ]; then
    echo -e "\e[1;4mLaunching PhantomJS\e[0m"
    phantomjs --webdriver=4444 > build/logs/phantomjs.log 2>&1 &
fi
