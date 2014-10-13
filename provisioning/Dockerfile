FROM ubuntu:14.04 
MAINTAINER Carl Boettiger <cboettig@ropensci.org>

ENV DEBIAN-FRONTEND noninteractive

## Not sure why the shell script isn't installing these?
#RUN apt-get update && apt-get install -y ed libxml2 libxslt1-dev python-pip 


## Copy over the BCE scripts and bootstrap
COPY packages /tmp/packages
COPY bootstrap-bce.sh /usr/bin/bootstrap-bce.sh
RUN chmod a+x /usr/bin/bootstrap-bce.sh
RUN /usr/bin/bootstrap-bce.sh


## Can we set a sensible locale?
ENV LC_ALL en_US.UTF-8


## Expose default ports for external services. (Must be linked a runtime)
## as follows: RStudio: 8787, ipython-notebook: 8888, ssh: 22
EXPOSE 8787
EXPOSE 8888
EXPOSE 22

## To have a container run multiple & persistent tasks, we use the 
## very simple supervisord as recommended in Docker documentation.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"] 

