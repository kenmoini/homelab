#!/bin/bash

source /etc/sysconfig/squid

SSL_DB_PATH="${SSL_DB_PATH:-"/etc/squid/certs"}"
SSL_DB_SIZE="${SSL_DB_SIZE:-"64MB"}"

/usr/libexec/squid/cache_swap.sh

/usr/lib64/squid/security_file_certgen -c -s ${SSL_DB_PATH}/ssl_db -M ${SSL_DB_SIZE}

/usr/sbin/squid -k parse -f ${SQUID_CONF}

/usr/sbin/squid --foreground $SQUID_OPTS -f ${SQUID_CONF}
