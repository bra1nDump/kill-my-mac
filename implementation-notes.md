## Scheduled run
- Run on startup
- Run at a certain time - lets start with this: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/TP40001762-104142
- **picked** run on a schedule and check time in the script

## Distributing
- How to distribute the shell script to run?
- How to have it be installed by brew into correct location
- How to load the agent?
  - Put in the ~Library/LaunchAgents
  - Use launchctl to load? launchd cannot be started by the user
- How to look at logs?

- When run
- Check what time it is - if it is in the dead zone - play you are in the dead zone https://open.spotify.com/track/7xJ8xGw68KCazVjHC7cEp5?si=377207fb81c0496c
- You fucker have restarted your computer, bonk, go to bed

## Storing configuration
For binaries installed through Homebrew on macOS, user configuration is typically stored in one of several locations depending on the nature of the application and its configuration needs:

Home Directory:
~/.config/ - Many applications use this directory for storing configuration files, following the XDG Base Directory Specification.

## Handling sleep 
## pmset -g interesting man page exserpt
INVOKE: pmset -g stats
Sleep Count:1040
Dark Wake Count:1025   -- I assume this is the wake ups due to the launch agents
User Wake Count:30

pmset -g live
System-wide power settings:
Currently in use:
 standby              1
 Sleep On Power Button 1
 hibernatefile        /var/vm/sleepimage
 powernap             1
 networkoversleep     0
 disksleep            10
 sleep                0 (sleep prevented by coreaudiod, useractivityd, powerd, sharingd)
 hibernatemode        3
 ttyskeepawake        1
 displaysleep         0     --- ???
 tcpkeepalive         1
 lowpowermode         0
 womp                 1

-g [?] (with no argument) will display the settings currently in use.
-g live [?] displays the settings currently in use.
-g custom displays custom settings for all power sources.
-g cap displays which power management features the machine supports.
-g sched displays scheduled startup/wake and shutdown/sleep events.
-g ups displays UPS emergency thresholds.
-g ps / batt displays status of batteries and UPSs.
-g pslog displays an ongoing log of power source (battery and UPS) state.
-g rawlog displays an ongoing log of battery state as read directly from battery.
-g therm shows thermal conditions that affect CPU speed. Not available on all platforms.
-g thermlog shows a log of thermal notifications that affect CPU speed. Not available on all platforms.
-g assertions displays a summary of power assertions. Assertions may prevent system sleep or display sleep. Available 10.6 and later.
-g assertionslog shows a log of assertion creations and releases. Available 10.6 and later.
-g sysload displays the "system load advisory" - a summary of system activity available from the IOGetSystemLoadAdvisory API. Available 10.6 and later.
-g sysloadlog displays an ongoing log of lives changes to the system load advisory. Available 10.6 and later.
-g ac / adapter will display details about an attached AC power adapter. Only supported for MacBook and MacBook Pro.
-g log [!] displays a history of sleeps, wakes, and other power management events. This log is for admin & debugging purposes.
-g uuid [?] displays the currently active sleep/wake UUID; used within OS X to correlate sleep/wake activity within one sleep cycle.  history
-g uuidlog [?] displays the currently active sleep/wake UUID, and prints a new UUID as they're set by the system.
-g history [?] is a debugging tool. Prints a timeline of system sleeplwake UUIDs, when enabled with boot-arg io=0x3000000.
-g historydetailed Prints driver-level timings for a sleep/wake. Pass a UUID as an argument.
-g powerstate [?] [class names] Prints the current power states for I/O Kit drivers. Caller may provide one or more I/O Kit class names (separated by spaces) as an argument. If no
classes are provided, it will print all drivers' power states.
-g powerstatelog [-i interval] [class names] Periodically prints the power state residency times for some drivers. Caller may provide one or more I/O Kit class names (separated by
spaces). If no classes are provided, it will log the IOPower plane's root registry entry. Caller may specify a polling interval, in seconds with -i <polling interval>; otherwise it
defaults to 5 seconds.
-g stats Prints the counts for number sleeps and wakes system has gone thru since boot.
-g systemstate Prints the current power state of the system and available capabilites.
-g everything [?] Prints output from every argument under the GETTING header. This is useful for quickly collecting all the output that pmset provides. Available in 10.8.

## Avoid storing state, avoid repeat warnings - I can't figure out this algebra problem
I want:
- To only fire each warning once
- Avoid creating state in the file system with something like "last warning shown XX"
- Allow configurable frequency wnen the script runs (currently hardcoded to a single minute)

I implemented a naive idea of checking proximity to a value, so soft equals with a delta. I have a function that checks if two values are within a delta. There is certainly a relation between the frequency of running the script and what value to pass as the delta.

This also depends on how accurate is the firing time? Every 60 seconds is probably worse than every calendar minute, because the latter should fire on the boundary once the new clock minute elapses. - Not possible, lowest frequency is specifying a minute of the hour, thats once per hour. So every 60 seconds is likely since the launch of the agent. If the agent is started on the 59.98 clock second in the minute (aka the minute is about to flip), the delay between launchd and date in the script returning will result in certain minutes being skipped and neighboring appearing twice.

I can just ignore this problem :D This only matters for the warnings, and I get 2 anyways.

## Shut down hook - prevents shutting down if an app asks to be checked before closing
https://discussions.apple.com/thread/5033645?sortBy=best

Testing if oscript will ignore this. In browser console

```js
// https://developer.mozilla.org/en-US/docs/Web/API/Window/beforeunload_event
addEventListener("beforeunload", (event) => {
    event.preventDefault()
});
```

Solution: `sudo defaults delete com.apple.loginwindow LogoutHook`

