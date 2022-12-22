#!/bin/bash

source /etc/sysconfig/squid

/usr/libexec/squid/cache_swap.sh

/usr/lib64/squid/security_file_certgen -c -s /etc/squid/certs/ssl_db -M 64MB

/usr/sbin/squid -k parse -f ${SQUID_CONF}

/usr/sbin/squid --foreground $SQUID_OPTS -f ${SQUID_CONF}