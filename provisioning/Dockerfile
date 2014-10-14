FROM ubuntu:14.04 
MAINTAINER Carl Boettiger <cboettig@ropensci.org>

ENV DEBIAN-FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8

## Not sure why the shell script isn't installing these?
RUN apt-get update && apt-get install -y \
  ed \
  libxml2 \
  libxslt1-dev \
  python-pip \
  libjpeg62 \
  libcurl4-openssl-dev \
  r-cran-rjava \
  dnsutils

## Generate the appropriate UTF-8 locale
RUN locale-gen en_US.UTF-8

## Get additional build dependencies to avoid pip-install failures...
RUN apt-get build-dep -y python-matplotlib

## Copy over the BCE scripts and bootstrap ##
COPY packages /tmp/packages
COPY bootstrap-bce.sh /usr/bin/bootstrap-bce.sh
RUN chmod a+x /usr/bin/bootstrap-bce.sh
RUN /usr/bin/bootstrap-bce.sh


## Secure ipython notebook setup
COPY setup_ipython_notebook.sh /usr/bin/setup_ipython_notebook
RUN chmod a+x /usr/bin/setup_ipython_notebook

## Expose default ports for external services. (Must be linked a runtime)
## as follows: RStudio: 8787, ipython-notebook: 8888, ssh: 22 secure-ipython: 9999
EXPOSE 8787
EXPOSE 8888
EXPOSE 9999
EXPOSE 22

## To have a container run multiple & persistent tasks, we use the 
## very simple supervisord as recommended in Docker documentation.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"] 

