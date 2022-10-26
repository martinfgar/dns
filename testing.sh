#!/bin/bash

dig google.com +short
dig -x 192.168.1.100 +short
ping -a -c 1 apache1
ping -a -c 1 apache2.aula104.local
# curl apache1 --no-progress-meter 
# curl apache2 --no-progress-meter 
# curl nginx --no-progress-meter 
ping -a -c 1 amazon.com
ping -a -c 1 ns1