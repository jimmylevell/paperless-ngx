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

# Use cont-init.d to run the secrets script early in the init process
# This runs BEFORE any s6 services start, ensuring env vars are available
RUN mkdir -p /etc/cont-init.d && \
    ln -sf /docker/set_env_secrets.sh /etc/cont-init.d/00-secrets.sh

EXPOSE 8080
ENTRYPOINT ["/init"]
