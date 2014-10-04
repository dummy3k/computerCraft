gh (github helper)
==================

Download this:
```
> pastebin get xxC3swG6 gh
```

Now you can download all current versions of my lua scripts like so:
```
> gh fox
```

This will download ```fox.lua``` from my repository and save it as
```fox``` on the ComputerCraft turtle.

If you want to clone my github repository, you will need to edit ```gh.lua``` and replace my user name with yours. Then you should update the pastebin url in this document.

gps_host
========

This script is intended as helper to set up a GPS Network.
Wireless signals in ComputerCraft go further if the sender is higher
in the air. With this script you can set the current position of the turtle and tell it to go to, say Y-level 250. 

Download the necessary files:
```
> gh gps_host startup
> gh util
> gh fox
```

Set the *current* coordinates:
```
> startup set <X> <Y> <Z>
```

Place some coal in the first slot of the turtle. Tell the turtle to
which Y-Level it should rise. The turtle will consume as much coal as 
necessary. You can remove surplus coal, before the turtle goes up.
```
> startup up 10
```

One the turtle reaches the specified altitude it will start serving
GPS requests. If the turtle reboots (after a server reboot) it will
automatically serve GPS requests again.

cclog
=====

Install ```mpt```

```
> pastebin run 09QAQFaN
```

Add to ```/etc/ccpt/sources```
```
https://raw.githubusercontent.com/dummy3k/computerCraft/master/sources.txt
```

