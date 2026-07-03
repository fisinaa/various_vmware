#!/bin/bash
if [ -f /etc/machine-id ]; then
  rm -f /etc/machine-id
  dbus-uuidgen --ensure=/etc/machine-id
  rm /var/lib/dbus/machine-id
  dbus-uuidgen --ensure
fi
