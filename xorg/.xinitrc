#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -d "$HOME/Matlab/bin" ] ; then
    PATH="$HOME/Matlab/bin:$PATH"
fi

xcompmgr &

sh ~/.fehbg &

nm-applet --indicator &

dropbox &

# Disable scrolling and tapping while typing
syndaemon -i 0.5 -t -K -R &

# Speedup key repeat rate
# xset r rate [delay] [speed]
xset r rate 250 40

exec i3
#exec $1
