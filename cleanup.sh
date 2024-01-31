#!/usr/bin/env bash

rm -f /etc/dnsmasq.d/certbot-acme-challenge.conf
systemctl restart dnsmasq.service
