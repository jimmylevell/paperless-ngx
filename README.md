# About paperless-ngx
[![Publish levell paperless docker image](https://github.com/jimmylevell/paperless-ngx/actions/workflows/action.yml/badge.svg)](https://github.com/jimmylevell/paperless-ngx/actions/workflows/action.yml)

Paperless service of levell.

## Frameworks used
- paperless-ngx

# Docker image details
## Postgres
Base image: paperless-ngx
Exposed ports: 5432
Additional installed resources:
- Troubleshooting: vim, net-tools, dos2unix


### Configuration
Store the secret of the admin user in docker secret
```
printf paperlesspassword | docker secret create paperless_password -
```

# Deployment
## General
Service: paperless

Data Path: /home/docker/levell/paperless/

## Postgres
### General
Access URL: none

### Attached Networks
- levell - access to levell services
