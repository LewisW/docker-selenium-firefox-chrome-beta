#!/bin/bash

# Script courtesy of https://github.com/UserTaken/docker-armitage-vnc/blob/master/vncpasswd

PASS=${PASS:-"docker"}
LENGTH=`echo -n $PASS | wc -c`

if [ "$LENGTH" -lt "6" ]; then
	echo -e "\x1B[01;33mYour VNC password is less than\x1B[0m" "\x1B[01;31m6 characters.\x1B[0m" "\x1B[01;33mSetting to default.\x1B[0m"
	export PASS=docker
fi

expect <<EOF
	spawn vncpasswd
	expect {
		-exact "Password:" { send "$PASS\r"; exp_continue }
		-exact "Verify:" { send "$PASS\r"; exp_continue }
		-exact "Would you like to enter a view-only password \(y/n\)?" { send "n\r"; exp_continue }
	}
EOF

echo -e "\x1B[01;33mYour VNC password is\x1B[0m" "\x1B[01;31m$PASS\x1B[0m" "\x1B[01;33mrunning on port\x1B[0m" "\x1B[01;31m59000.\x1B[0m"
