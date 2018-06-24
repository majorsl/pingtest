# pingtest
Tests 2 hosts with pings and upon failure, resets your router with a X10 module.

At one time or another you’ve all had to physically power off and on your cable modem to reset your internet connection. I probably have more traffic than most and many a morning I’ve woken up to a dead internet connection, or worse, it goes out during the day when I’m away.

I’ve been a fan of X10 home control units for awhile, I’ve also had two of their “Firecracker” computer serial interface modules sitting in a box for at least 10 years. What does this have to do with the above?

I have an X10 Appliance Module control unit in between the outlet and my cable modem, a simple and cheap FTDI based USB to Serial interface connecting my Firecracker to my server, and a little open source program called HEYU that easily controls the Firecracker. I put these together with a shell script on my server that pings hosts of my choosing on the internet at regular intervals, and if the host cannot be reached, the script tells the X10 unit to turn off the modem and turn it back on via the Firecracker module and notifies me.

Posted also is an example launchd plist (macOS), adjust the interval (in seconds) to set the amount of time in between ping tests. Just use a cron entry for unix/linux.

pingtestmac.sh is one that uses notification for the Mac.

pingtestpi.sh is one that I use with a Raspberry Pi and Domoticz, but should work with any standard unix/linux.

