GPS Host
========

This script is intended as helper to set up a GPS Network.
Wireless signals in ComputerCraft go further if the sender is higher
in the air. With this script you can set the current position of the turtle and
tell it to go to, say Y-level 250. 

Download the necessary files:

```
mpt install gpshost
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
