#!/bin/bash

## Set defaults for environmental variables in case they are undefined
USER=${USER:=rstudio}
PASSWORD=${PASSWORD:=rstudio}
EMAIL=${EMAIL:=rstudio@example.com}
## Configure user account name and password (used by rstudio)
useradd -m $USER && echo "$USER:$PASSWORD" | chpasswd
## Let user write to /usr/local/lib/R/site.library
addgroup $USER staff

