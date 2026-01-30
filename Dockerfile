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

# Create s6-overlay init script to run secrets before services start
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d
RUN mkdir -p /etc/s6-overlay/s6-rc.d/init-secrets
RUN echo "oneshot" > /etc/s6-overlay/s6-rc.d/init-secrets/type
RUN echo "/docker/set_env_secrets.sh" > /etc/s6-overlay/s6-rc.d/init-secrets/up
RUN chmod +x /etc/s6-overlay/s6-rc.d/init-secrets/up
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/init-secrets

EXPOSE 8080
ENTRYPOINT ["/init"]
