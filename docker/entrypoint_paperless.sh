#!/bin/bash

# call docker secret expansion in env variables
. /docker/set_env_secrets.sh

# call parent script
exec /init
