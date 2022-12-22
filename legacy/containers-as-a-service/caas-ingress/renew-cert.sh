#!/bin/bash

set -e
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#cd $DIR

TARGET_DIR="/opt/service-containers/ingress"
cd $TARGET_DIR

echo "$(date) About to renew certificates" >> /var/log/letsencrypt-renew.log
podman run \
       -i \
       --rm \
       --name certbot \
       -v $TARGET_DIR/letsencrypt:/etc/letsencrypt \
       -v $TARGET_DIR/webroot:/webroot \
       certbot/certbot \
       renew -w /webroot

echo "$(date) Cat certificates" >> /var/log/letsencrypt-renew.log

function cat-cert() {
  dir="${TARGET_DIR}/letsencrypt/live/$1"
  cat "$dir/privkey.pem" "$dir/fullchain.pem" > "./certs/$1.pem"
}

for dir in ${TARGET_DIR}/letsencrypt/live/*; do
  if [[ "$dir" != *"README" ]]; then
    cat-cert $(basename "$dir")
  fi
done

echo "$(date) Reload haproxy" >> /var/log/letsencrypt-renew.log
podman restart ingress-haproxy

echo "$(date) Done" >> /var/log/letsencrypt-renew.log