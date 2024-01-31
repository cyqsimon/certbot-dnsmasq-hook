#!/usr/bin/env bash

echo "txt-record=_acme-challenge.$CERTBOT_DOMAIN,\"$CERTBOT_VALIDATION\"" > /etc/dnsmasq.d/certbot-acme-challenge.conf

systemctl restart dnsmasq.service
sleep 3
