# Why shut down you computer at :
- I don't go to bed at a consistent time for health, productivity, and social reasons
- When I don't go to bed early, chances are I am coding / watching something - so all on my mac
- The system suggestions to 'go to bed' are not dominant enough to make me go to bed, I simply tune them out

## How:
- I will write a program that will schedule to shut down the mac at 12am
- I will distribute it as a brew formula to make it easy to install, bash is not available in Sandboxed apps, so no App Store

## What:
- Install with `brew install hard-sleep`

# TODO:

- Write the program locally - no pkg!
- Use it for a week
- Package with Homebrew
- Post about it
- TELL MY FRIENDS TO TRY IT

# Later:
- Pick a cool name
  - mac-dead-zone
  - kill-my-mac
  - kill-at
- How can I make editing the configuration difficult?
- By allowing to skip the shutdown once by looking at a message to self you wrote when setting this up, and forcing to look at it for 5 minutes before allowing to skip


# Implementation

- Run manually first time
  - Run on startup
  - Run at a certain time - lets start with this: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/TP40001762-104142
  - **picked** run on a schedule and check time in the script

- How to distribute the shell script to run?
- How to have it be installed by brew into correct location
- How to load the agent?
  - Put in the ~Library/LaunchAgents
  - Use launchctl to load? launchd cannot be started by the user
- How to look at logs?

- When run
- Check what time it is - if it is in the dead zone - play you are in the dead zone https://open.spotify.com/track/7xJ8xGw68KCazVjHC7cEp5?si=377207fb81c0496c
- You fucker have restarted your computer, bonk, go to bed

# Shut down hook - prevents shutting down if an app asks to be checked before closing
https://discussions.apple.com/thread/5033645?sortBy=best

Testing if oscript will ignore this. In browser console

```js
// https://developer.mozilla.org/en-US/docs/Web/API/Window/beforeunload_event
addEventListener("beforeunload", (event) => {
    event.preventDefault()
});
```

Solution: `sudo defaults delete com.apple.loginwindow LogoutHook`

# Alternatives:
- Work on the discipline in other ways
- SetApp claims to have multiple solutions https://setapp.com/how-to/shutdown-timer-on-mac:
  - System Settings > Energy Saver - schedule shut down [deprecated]
  - Almighty - many different shortcuts
    - AppStore - unpopular
    - indigoodies ? new distribution channel https://indiegoodies.com/almighty
  - terminal `sudo shutdown -h 60` shut down in an hour.
    - Not great, because it can be stopped by killing the process
    - Actually maybe not such a bad idea. Simply run this command as a detached process

I have looked into my options to shut down the mac:
- `shutdown` command
  - Requires sudo, no idea how to maintain the password without storing it in plaintext, also priving sudo to an app seems like a bad idea
- `osascript` command to run an applescript 
  - `osascript -e 'tell application "System Events" to shut down'`
  - **Picked** because it does not require sudo
  - Suspicious that I can do this without sudo, but tested in the terminal and it worked :D Not complaining.
