FROM mhart/alpine-node:6.2

RUN apk update && apk add --no-cache curl make gcc g++ git python dnsmasq && \
    echo -e '#!/bin/ash\n ash "$@"' > /bin/bash && chmod +x /bin/bash && \
    npm install -g eyeos-run-server && \
    npm install -g eyeos-tags-to-dns && \
    npm cache clean && \
    echo "user=root" > /etc/dnsmasq.conf && \
    curl -L https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -o serf.zip && \
    unzip ./serf.zip && mv serf /usr/bin/ && rm ./serf.zip && \
    apk del curl make gcc g++ git python && \
    rm -r /etc/ssl /var/cache/apk/* /tmp/* && \
    mkdir /root
