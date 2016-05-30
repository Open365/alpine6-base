FROM mhart/alpine-node:6.2

COPY scripts-base/* scripts-base/

RUN chmod +x scripts-base/* && \
    apk update && \
    scripts-base/buildDependencies.sh --production --install --common=true --dependencies=dnsmasq && \
    echo -e '#!/bin/ash\n ash "$@"' > /bin/bash && chmod +x /bin/bash && \
    npm install -g eyeos-run-server && \
    npm install -g eyeos-tags-to-dns && \
    npm cache clean && \
    echo "user=root" > /etc/dnsmasq.conf && \
    curl -L https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -o serf.zip && \
    unzip ./serf.zip && mv serf /usr/bin/ && rm ./serf.zip && \
    scripts-base/buildDependencies.sh --production --purgue --common=true && \
    rm -r /etc/ssl /var/cache/apk/* /tmp/* && \
    mkdir /root
