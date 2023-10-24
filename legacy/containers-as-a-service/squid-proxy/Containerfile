# podman build -t squid-proxy -f Containerfile .
# podman tag squid-proxy quay.io/kenmoini/squid-proxy:latest
# podman tag squid-proxy quay.io/kenmoini/squid-proxy:$(date +'%F')
# podman push quay.io/kenmoini/squid-proxy:latest
# podman push quay.io/kenmoini/squid-proxy:$(date +'%F')

FROM registry.access.redhat.com/ubi8/ubi:8.8-1067.1698056881

RUN dnf update -y \
 && dnf install -y squid openssl \
 && dnf clean all \
 && rm -rf /var/cache/yum

COPY container_root/ /

RUN update-ca-trust

EXPOSE 3128
EXPOSE 3129

CMD /start.sh