#!/bin/bash

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout default.key -out default.crt

cat default.key default.crt > ./certs/default.pem

rm default.key default.crt