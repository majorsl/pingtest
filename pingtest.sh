#!/bin/sh
# Version 2.1.2 *REQUIREMENTS BELOW*
#
# 1. Working HEYU installed. http://www.heyu.org/
# 2. X10 Serial CM17A (script written for this model, but can use others.)
# 3. X10 Appliance Module, don't use a Dimmer Module or anything else - you could damage your router!
# 4. terminal-notifier (Homebrew: brew install terminal-notifier or https://github.com/julienXX/terminal-notifier)
#
# Script to ping two hosts and if both are non-responsive, reset router with an X10.
# Appliance Module.

#HOSTs are the hosts to test ping.
HOST1="google.com"
HOST2="mozilla.org"

#MODULE is the code for your X10 Appliance Module attached to your router.
MODULE="C1"

#Ping HOST once and do not print any output to the screen, return code of ping used for test.
ping -c1 $HOST1 2>&1 >/dev/null

#Assign the return code to RET so we can preserve it for after the if. 0=success, anything else and ping failed.
RET=$?

#Give 15 second pause in case it was a temporary glitch or problem with HOST1 then try HOST2.
sleep 15

#Ping HOST once and do not print any output to the screen, return code of ping used for test.
ping -c1 $HOST2 2>&1 >/dev/null

#Assign the return code to RET2 so we can preserve it for after the if. 0=success, anything else and ping failed.
RET2=$?

if [ ${RET} -eq 0 ] || [ ${RET2} -eq 0 ]; then
	echo "**Successful ping test, exiting.**"
	else
	#Turn off router, 3x to X10 module to be sure command arrives; X10 is stubborn sometimes.
	COUNTER=0
	while [ $COUNTER -lt 3 ]; do
		/usr/local/bin/heyu foff "$MODULE"
		sleep 5
		let COUNTER=COUNTER+1
	done
	#Turn on router, 3x to X10 module to be sure command arrives; X10 is stubborn sometimes.
	COUNTER=0
	while [ $COUNTER -lt 3 ]; do
		/usr/local/bin/heyu fon "$MODULE"
		sleep 15
		let COUNTER=COUNTER+1
	done
	#Send notice to Notification Center.
	DATE=`date +%h" "%m" "%l:%M%p`
	/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier -title 'Ping Test' -message "Could not ping test hosts, router reset on $DATE. (X10 $MODULE)" -sender com.apple.Terminal
fi
