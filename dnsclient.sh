#!/bin/bash

systemctl disable systemd-resolved
  systemctl stop systemd-resolved
  rm /etc/resolv.conf
  echo -e "nameserver $1\ndomain aula104.local">/etc/resolv.conf