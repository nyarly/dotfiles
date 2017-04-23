#!/bin/bash
sudo mount /var/mother/
sudo cp /etc/resolv.conf /var/mother/etc/resolv.conf
sudo mount -t proc none /var/mother/proc/
sudo mount --rbind /dev/ /var/mother/dev/
sudo mount /dev/vg0/usr-portage /var/mother/usr/portage
sudo chroot /var/mother/ /bin/bash
