docker-selenium-firefox-chrome-beta
===================================

A Dockerfile starting a selenium standalone server with Chrome, Firefox, PhantomJS, VNC & a VNC recorder.

It exposes:
- selenium standalone server running on `localhost:4444`
- vnc server running on `localhost:5999`, password: `secret`

Running:

```shell
docker pull vvoyer/docker-selenium-firefox-chrome
docker run --privileged -p 5999:6999 -d --name selenium lewisw/selenium
```
