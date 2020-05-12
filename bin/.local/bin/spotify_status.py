#!/usr/bin/env python

import sys
import dbus
import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    '-t',
    '--trunclen',
    type=int,
    metavar='trunclen'
)

args = parser.parse_args()

# Set default parameters
trunclen = args.trunclen or 25

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
    status = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

    artist = metadata['xesam:artist'][0] if metadata['xesam:artist'] else ''
    song = metadata['xesam:title'] if metadata['xesam:title'] else ''

    if not artist and not song or status == 'Paused':
        print('')
    else:
        if len(song) > trunclen:
            song = song[0:trunclen]
            song += '...'
            if ('(' in song) and (')' not in song):
                song += ')'

        if not artist:
            print(song)
        elif not song:
            print(artist)
        else:
            print("%s: %s" % (artist, song))

except Exception as e:
    if isinstance(e, dbus.exceptions.DBusException):
        print('')
    else:
        print(e)
