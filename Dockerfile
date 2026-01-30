###############################################################################################
# levell paperless - BASE
###############################################################################################
FROM ghcr.io/paperless-ngx/paperless-ngx:latest as levell-paperless-base

RUN mkdir -p /docker

# update the image
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y net-tools
RUN apt-get install -y dos2unix

###############################################################################################
# levell paperless - PRODUCTION
###############################################################################################
FROM levell-paperless-base as levell-paperless-deploy

COPY docker/entrypoint_paperless.sh /docker/entrypoint.sh
COPY docker/set_env_secrets.sh /docker/

RUN chmod +x /docker/entrypoint.sh
RUN dos2unix /docker/entrypoint.sh

RUN chmod +x /docker/set_env_secrets.sh
RUN dos2unix /docker/set_env_secrets.sh

# Create s6-overlay init script to run secrets expansion very early
# This needs to run in the init phase before any services start
RUN mkdir -p /etc/s6-overlay/s6-rc.d/init-secrets && \
    echo "oneshot" > /etc/s6-overlay/s6-rc.d/init-secrets/type && \
    printf '#!/bin/bash\nexec /docker/set_env_secrets.sh' > /etc/s6-overlay/s6-rc.d/init-secrets/up && \
    chmod +x /etc/s6-overlay/s6-rc.d/init-secrets/up && \
    mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/init-secrets

# Ensure init-secrets runs before init-migrations (paperless service)
RUN if [ -d /etc/s6-overlay/s6-rc.d/init-migrations ]; then \
    echo "init-secrets" > /etc/s6-overlay/s6-rc.d/init-migrations/dependencies.d/init-secrets; \
    fi

EXPOSE 8080
ENTRYPOINT ["/init"]
