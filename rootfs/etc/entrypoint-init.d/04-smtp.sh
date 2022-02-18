#!/usr/bin/env bash

echo "account default" > /etc/msmtprc
echo "from $SMTP_DEFAULT_FROM" >> /etc/msmtprc
echo "host $SMTP_HOST" >> /etc/msmtprc
echo "port $SMTP_PORT" >> /etc/msmtprc

if [ -z "$SMTP_EHLO_DOMAIN" ]; then
  echo "domain $(hostname)" >> /etc/msmtprc
else
  echo "domain $SMTP_EHLO_DOMAIN" >> /etc/msmtprc
fi

if [ ! -z "$SMTP_USERNAME" ] && [ ! -z "$SMTP_PASSWORD" ]; then
  echo "tls on" >> /etc/msmtprc
  echo "tls_certcheck $SMTP_TLS_CERT_CHECK" >> /etc/msmtprc
  echo "auth on" >> /etc/msmtprc
  echo "user $SMTP_USERNAME" >> /etc/msmtprc
  echo "password $SMTP_PASSWORD" >> /etc/msmtprc
fi
