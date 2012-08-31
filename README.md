dotfiles
========

These are basically for my personal use, but feel free to check them and reuse some scripts.

'dotsync.sh' is the tool which handles pushing/pulling to github

Maybe the best tricks belong to .bashrc, where three functions 

* Detect if GNU Screen is running in order to show an "S" on the prompt (PS1)
* Show the return value of the previous command if it is different than zero
* Show the history line if the retval is zero

I reuse these dotfiles on many machines, so there is some trickery to detect the
machine it's running on

```shell
# Override the "--color=auto" which doesn't work on a Mac
require_machine fightclub && alias ls='ls -G' 
```
