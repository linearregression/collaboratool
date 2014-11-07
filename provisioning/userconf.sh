#!/bin/bash

# Maintainer: Carl Boettiger <cboettig@ropensci.org>
# Supporting script for Dockerfile
# Provides RStudio Server configuration for user login

## Set defaults for environmental variables in case they are undefined
USER=${USER:=rstudio}
PASSWORD=${PASSWORD:=rstudio}
EMAIL=${EMAIL:=rstudio@example.com}
USERID=${USERID:=1000}
userdel getent passwd "$USERID" | cut -d: -f1
useradd -m $USER -u $USERID 
echo "$USER:$PASSWORD" | chpasswd
addgroup $USER staff

