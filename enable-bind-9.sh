#!/bin/bash

DNSIP=$1
apt-get update
apt-get install -y bind9 bind9utils bind9-doc
ttl='$ttl'
cat <<EOF >/etc/bind/named.conf.options
acl "trusted" {
    192.168.33.0/24;
};

options {
    directory "/var/cache/bind";
    dnssec-validation auto;

    listen-on-v6 { any; };
    forwarders { 1.1.1.1;  1.0.0.1;  };
};
EOF

cat <<EOF >/etc/bind/named.conf.local
zone "aula104.local" {
        type master;
        file "/var/lib/bind/aula104.local";
        };
zone "33.168.192.in-addr.arpa" {
        type master;
        file "/var/lib/bind/192.168.33.rev";
        };
EOF

cat <<EOF >/var/lib/bind/aula104.local
$ttl 3600
aula104.local.     IN      SOA     ns.aula104.local. dns.aula104.local. (
                3            ; serial
                7200         ; refresh after 2 hours
                3600         ; retry after 1 hour
                604800       ; expire after 1 week
                86400 )      ; minimum TTL of 1 day
aula104.local.          IN      NS      ns.aula104.local.
ns.aula104.local.       IN      A       $DNSIP
apache1.aula104.local   IN      A       192.168.33.12
apache2.aula104.local   IN      A       192.168.33.13
nginx.aula104.local     IN      A       192.168.33.14

; aqui pones los hosts
EOF

cat <<EOF >/var/lib/bind/192.168.33.rev
$ttl 3600
33.168.192.in-addr.arpa.  IN      SOA     ns.aula104.local. dns.aula104.local. (
                3            ; serial
                7200         ; refresh after 2 hours
                3600         ; retry after 1 hour
                604800       ; expire after 1 week
                86400 )      ; minimum TTL of 1 day
33.168.192.in-addr.arpa.  IN      NS      ns.aula104.local.
12.33.168.192   IN  PTR     apache1.
13.33.168.192   IN  PTR     apache2.
14.33.168.192   IN  PTR     nginx.
11.33.168.192   IN  PTR     ns.
; aqui pones los hosts inversos


EOF

cp /etc/resolv.conf{,.bak}
cat <<EOF >/etc/resolv.conf
nameserver 127.0.0.1
domain aula104.local
EOF

named-checkconf
named-checkconf /etc/bind/named.conf.options
named-checkzone aula104.local /var/lib/bind/aula104.local
named-checkzone 33.168.192.in-addr.arpa /var/lib/bind/192.168.33.rev
sudo systemctl restart bind9