#!/usr/bin/env python3
# coding: utf-8

from sys import argv
from subprocess import call
import dbus

libnotify_id = 3

def print_kbd_light(value):
    icon_name = "/usr/share/icons/Faba/48x48/notifications/notification-keyboard-brightness.svg"
    brightness = int(value)
    if brightness < 10:
        space = "      "
    elif brightness < 100:
        space = "     "
    else:
        space = "    "
    bar = "".join(["─" for x in range(1, int(brightness / 5))])
    message = "%s%s%s" % (brightness, space, bar)
    call(["dunstify", "-i", icon_name, "-r", str(libnotify_id), message])

def kb_light_set(delta):
    bus = dbus.SystemBus()
    kbd_backlight_proxy = bus.get_object('org.freedesktop.UPower', '/org/freedesktop/UPower/KbdBacklight')
    kbd_backlight = dbus.Interface(kbd_backlight_proxy, 'org.freedesktop.UPower.KbdBacklight')

    current = kbd_backlight.GetBrightness()
    maximum = kbd_backlight.GetMaxBrightness()
    new = max(0, current + delta)

    if new >= 0 and new <= maximum:
        current = new
        kbd_backlight.SetBrightness(current)

    # Return current backlight level percentage
    return 100 * current / maximum

if __name__ == '__main__':
    if len(argv[1:]) == 1:
        if argv[1] == "--up" or argv[1] == "+":
            # ./kb-light.py (+|--up) to increment
            print_kbd_light(kb_light_set(1))
        elif argv[1] == "--down" or argv[1] == "-":
            # ./kb-light.py (-|--down) to decrement
            print_kbd_light(kb_light_set(-1))
        else:
            print("Unknown argument:", argv[1])
    else:
        print("Script takes exactly one argument.", len(argv[1:]), "arguments provided.")

