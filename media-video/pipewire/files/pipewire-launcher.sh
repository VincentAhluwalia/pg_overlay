#!/bin/sh

# PipeWire launcher script for XDG compliant desktops on OpenRC.
#
# systemd users are very _STRONGLY_ advised to use the much
# more reliable and predictable user units instead.

# WARNING: This script assumes being run inside XDG compliant session,
# which means D-Bus session instance is expected to be correctly set up
# prior to this script starting. If that is not true, things may break!

# Best to reap any existing daemons and only then try to start a new set.
pkill -u "${USER}" -x pipewire\|wireplumber 1>/dev/null 2>&1

# The core daemon which by itself does probably nothing.
@GENTOO_PORTAGE_EPREFIX@/usr/bin/pipewire &

# The so called pipewire-pulse daemon used for PulseAudio compatibility.
# Commenting this out will stop the PA proxying daemon from starting,
# however ALSA (with pipewire-alsa), JACK (with jack-sdk) and PW API using
# clients will still have access to audio and may end up clashing with
# non-PW apps over HW control (most notably, /usr/bin/pulseaudio daemon).
@GENTOO_PORTAGE_EPREFIX@/usr/bin/pipewire -c pipewire-pulse.conf &

# Finally a session manager is required for PipeWire to do anything.
exec @GENTOO_PORTAGE_EPREFIX@/usr/bin/wireplumber
