#!/bin/sh
#set wayland
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

systemctl --user start graphical-session.target

#clipboard
#wl-clip-persist --clipboard regular --reconnect-tries 0 &
#wl-paste --type text --watch cliphist store &

#wallpaper daemon
#awww-daemon &

