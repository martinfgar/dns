#!/bin/bash

 echo -e "[Resolve]\nDNS=$1\nDomains=aula104.local">/etc/systemd/resolved.conf
 systemctl daemon-reload
 systemctl restart systemd-resolved