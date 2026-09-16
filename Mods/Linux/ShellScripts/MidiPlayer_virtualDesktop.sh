#!/bin/sh

# Introducing the Specializer for Falcosoft Soundfont MidiPlayer!
# Just plop this file next by the `MidiPlayer.exe`
# You need to have Wine Staging the latest version. If you're using 32-bit version, then it'll automatically engage WoW64 mode
# Falcosoft Soundfont MidiPlayer is split window, yuck!! So we had to put it inside Wine Explorer virtual desktop, or else you'll suffer trouble on window positioning and focus.
# Set the language to supported by Wine (already set below, export `LC_ALL` thingy), or else you'll fallback to whatever the first, usually Arabic

echo "Specializer for Falcosoft Soundfont MidiPlayer"
echo "Enjoy your MIDI!"
echo "(JOELwindows7)"

# Set Locale to EN (US). If Wine does not support your system language, it'll fallback to whatever the first it got.
export LC_ALL="en_US.UTF-8"

# Showtime!! Engage Wine Explorer in virtual desktop, which inside has this MidiPlayer now!
exec wine explorer /desktop=Falcosoft,2560x1440 MidiPlayer.exe

# by JOELwindows7  
# Perkedel Technologies  
# GNU GPL v3