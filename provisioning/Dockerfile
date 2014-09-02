FROM cboettig/rstudio
MAINTAINER Carl Boettiger <cboettig@ropensci.org>

RUN apt-get -qy install python-pip ed 
ADD packages /tmp/packages
ADD bootstrap-bce.sh /usr/bin/bootstrap-bce.sh
RUN chmod a+x /usr/bin/bootstrap-bce.sh
RUN /usr/bin/bootstrap-bce.sh
