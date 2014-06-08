#!/bin/bash

# We set BCE_PROVISION from the shell / Packer
# BCE_PROVISION="$1"

START_TIME=$(date '+%s')

# apt in general is probably too verbose for our useage - it's hard to detect
# where actual failures may have occurred. Maybe we can reduce verbosity?
APT_GET="apt-get -q -y"
# APT_GET="apt-get -qq -y"

# Ubuntu packages
# rabbitvcs pulls in Ubuntu ipython which we displace later with pip
# Python packages
# < = requires package ; > = pulls in
# boilerpipe < default-jre default-jdk
# boilerpipe > JPype1 charade
# rpy2 < liblzma-dev
# pyyaml < libyaml-dev
# pandas > dateutil pytz numpy
# ipython > tornado pyparsing nose backports.ssl-match-hostname
# sphinx > Pygments docutils Jinja2 markupsafe
# scrapy > Twisted w3lib queuelib cssselect
# scrapy < libxslt1-dev libssl-dev
# flask > Werkzeug itsdangerous
# ipythonblocks < ez_setup
# seaborn < patsy
# seaborn > husl moss statsmodels
# ipython notebook < pyzmq libzmq3-dev
# apt-get installing python-gtk2-dev is much faster than pip-installing gtk2

# XXX - What's this about? Seems not to hold anymore
# rpy2 20140409: Requires this patch to build. Waiting on next release.
# https://bitbucket.org/bioinformed/rpy2/commits/c1c9ddf2910cfb68fe56ee4891ed6785a0b8352b

# XXX - currently, you could pass in extra DEBS and PIPS via the environment.
# But I don't know that this is a good feature.
# XXX - Ryan: "apt-get install foo=1.0.2" can install a specific version of a
# a package as long as it is available in the repository. But we'd have to
# ask the *rutter maintainer to keep older packages or setup our own repo to
# guarantee those packages would be available.
DEBS="${DEBS} curl sqlite3 pandoc r-recommended libjpeg62 fonts-mathjax python-dev python-pip python-setuptools python-gtk2-dev texlive texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended texlive-pictures gedit gedit-plugins gedit-developer-plugins gedit-r-plugin gedit-latex-plugin gedit-source-code-browser-plugin rabbitvcs-gedit thunar-vcs-plugin firefox xpdf evince gv libreoffice libyaml-dev libzmq3-dev libssl-dev libxslt1-dev liblzma-dev lightdm xrdp xfce4 xfce4-terminal xubuntu-default-settings default-jre default-jdk thunar-archive-plugin thunar-media-tags-plugin gigolo"
# Maybe also xfce4-mount-plugin? Doesn't seem to fix the problem with
# not auto-mounting VBox shared folders.

# I've reverted to latest IPython here. It's good stuff, and introduces a
# UI change, so I'd rather users have that. XXX - should use requirements
# versions
PIPS="${PIPS} cython pandas matplotlib scipy rpy2 ipython sphinx scrapy distribute virtualenv apiclient BeautifulSoup boilerpipe bson cluster envoy feedparser flask geopy networkx oauth2 prettytable pygithub pymongo readline requests twitter twitter-text-py uritemplate google-api-python-client jinja facebook nltk ez_setup ipythonblocks scikits.learn sklearn-pandas patsy seaborn pyzmq markdown git+git://github.com/getpelican/pelican.git@011cd50e2e7
ghp-import pytest"

msg="BCE: Updating apt cache..."
echo $msg
$APT_GET update > /dev/null && \
echo DONE: $msg || echo FAIL: $msg

msg="BCE: configure etckeeper with git..."
echo $msg
# Track system changes
$APT_GET install git etckeeper && \
sed -i -e '/^VCS/s/^/#/' -e '/="git"/s/^#//' /etc/etckeeper/etckeeper.conf && \
cd /etc && \
git config --global user.name "BCE provisioner" && \
git config --global user.email "bce@lists.berkeley.edu" && \
etckeeper init && \
echo DONE: $msg || echo FAIL: $msg

echo "BCE: Installing build utilities..."
# This is more robust - redundancy is not a problem!
$APT_GET install build-essential dkms xserver-xorg dmidecode curl \
	software-properties-common && \
echo DONE: $msg || echo FAIL: $msg

# An alternative method would be to manually share the directory on the host
# which actually contains VBoxGuestAdditions.iso. On a Mac that is
# /Applications/VirtualBox.app/Contents/MacOS/. Just like with the host user's
# home directory however, there's no convenient variable representing this
# location within the Shared Folders configuration.

# There's also a `vboxmanage guestcontrol updateadditions` command,
# but that doesn't seem to work from within Packer.

msg="BCE: Installing Guest Additions..."
echo "$msg"
(
    if [ "${BCE_PROVISION}" == "DLAB" ]; then
        # Currently, we attach the Guest additions iso when using Packer.
        # The guest extensions end up as a second CD/DVD drive
        # (/dev/cdrom (aka /dev/sr0) is the Ubuntu ISO)

        mount /dev/sr1 /mnt && \
        /mnt/VBoxLinuxAdditions.run -- --force
        # We break logical chaining here, because it's never working!
        umount /mnt
    else
        # Automate VBox guest additions by downloading the ISO from virtualbox.org.
        V=$(dmidecode | grep vboxVer | sed -e 's/.*_//')
        if [ -z "${V}" ]; then
            V=$(modinfo vboxguest | grep ^version | sed -e 's/.* //' -e 's/_.*//')
        fi

        ISO=VBoxGuestAdditions_${V}.iso
        ISO_URL=http://download.virtualbox.org/virtualbox/${V}/${ISO}
        curl -L -o /tmp/${ISO} ${ISO_URL} && \
        mount -o loop,ro /tmp/${ISO} /mnt && \
        /mnt/VBoxLinuxAdditions.run -- --force && \
        umount /mnt && rm /tmp/${ISO} # XXX: Pretty sure this never gets executed
    fi
) && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg
#echo DONE: $msg || echo "FAIL (but not really?):" $msg

# CRAN repo
# There is no 14.04 CRAN archive yet so it is commented out
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
#echo "#deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu trusty/" > \
#    /etc/apt/sources.list.d/cran.list && \

msg="BCE: Updating OS..."
echo "$msg"
$APT_GET update && \
DEBIAN_PRIORITY=high DEBIAN_FRONTEND=noninteractive \
$APT_GET dist-upgrade && \
echo DONE: $msg  || echo FAIL: $msg
# etckeeper above fails because there were no changes to /etc. There are hooks
# where apt upgrades will be committed automatically with etckeeper. So, we
# should not include the etckeeper step for pure apt steps.

# apt-add-repository is included in software-properties-common which is
# installed in the "Installing build utilities" step.
msg="BCE: Installing R PPAs..." echo "$msg"
# Prefer rrutter and c2d4u PPAs
apt-add-repository -y ppa:marutter/rrutter && \
apt-add-repository -y ppa:marutter/c2d4u && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Installing scientific packages..."
echo "$msg"
$APT_GET install ${DEBS} && \
$APT_GET clean && \ # I guess we need this to avoid running out of disk space.
echo DONE: $msg  || echo FAIL: $msg

# Google Chrome
msg="BCE: Installing google chrome..."
echo "$msg"
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > \
	/etc/apt/sources.list.d/google-chrome.list && \
curl -L https://dl-ssl.google.com/linux/linux_signing_key.pub | \
	apt-key add - && \
$APT_GET update > /dev/null && \
$APT_GET install google-chrome-stable && \
echo DONE: $msg  || echo FAIL: $msg

# R, RStudio
msg="BCE: Installing RStudio..."
echo "$msg"
# XXX - Using Packer, we could just put extra scripts in Packer's json config
# But this needs to be refactored
# XXX - Also, couldn't we (and shouldn't we) just hard-code a URL?
if [ "${BCE_PROVISION}" == "DLAB" ]; then
    RSTUDIO_URL=`python /tmp/getrstudio`
    # Not really necessary, but a good placeholder if this moves
    rm /tmp/getrstudio
else
    RSTUDIO_URL=`python /tmp/getrstudio`
fi && \
curl -L -O ${RSTUDIO_URL} && \
dpkg -i $(basename ${RSTUDIO_URL}) && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Installing Python modules..."
echo "$msg"
for p in ${PIPS} ; do \
	echo $p
	pip -q install --upgrade "${p}" 2>/tmp/pip-err-${p}.log | \
		tee /tmp/pip-out-${p}.log
done && \
echo DONE: $msg || echo FAIL: $msg
# Note, pip won't change /etc

msg="BCE: Setting Xfce4 as default X session"
echo "$msg"
update-alternatives --set x-session-manager /usr/bin/xfce4-session && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Hide boot messages"
echo "$msg"
sed -i \
	-e '/GRUB_HIDDEN_TIMEOUT=/ s/^#//' \
	-e '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/".*"/"quiet splash"/' \
	/etc/default/grub && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Disable sudo password for those in the sudo group"
echo "$msg"
printf "%%sudo\tALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/nopasswd && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

# XXX - we should also set sensible defaults for gedit
msg="BCE: Set a 4-space tabstop for nano"
echo "$msg"
sed -i -e '/# set tabsize 8/s/.*/set tabsize 4/' /etc/nanorc && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Create oski user"
echo "$msg"
(
  if [ "${BCE_PROVISION}" != "DLAB" ]; then
      adduser --gecos "" --disabled-password oski && echo oski:oski | chpasswd
      # Enable oski to sudo without a password
      adduser oski sudo
  fi && \
  adduser oski vboxsf

  # Enable oski to login without a password
  adduser oski nopasswdlogin
) && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Configure oski desktop"
echo "$msg"
(
    # Create a convenient place on the desktop for people to mount
    # their Shared Directories.
    sudo -u oski mkdir /home/oski/Desktop
    sudo -u oski ln -s /media /home/oski/Desktop/Shared

    # Fetch and install Xfce configuration
    # - change desktop background from image to solid color
    # - panel launcher for terminal, file manager, browser, gedit
    # - remove desktop icon for Trash, File System; leave Home
    # - change Application Menu widget to use a generic computer icon from
    #   whatever it is that XFCE uses.
    # - Benoit prefers black-on-white terminal; easier to see on projectors

    # Packer file provisioner copies those files directly to .config
    # assuming standard provisioning will be done with packer
    # so commenting out this next stanza
    #if [ "${BCE_PROVISION}" != "DLAB" ]; then
    #    sudo -u oski rsync -av /vagrant/dot-config /home/oski/.config
    #fi
) && \
echo DONE: $msg || echo FAIL: $msg

# Automatically login oski at boot
# XXX - Is there a way to get oski listed in the login screen (it displays guest user
# if you log out)
msg="BCE: Automatically login oski at boot"
echo "$msg"
printf "[SeatDefaults]\nautologin-user=oski\nautologin-user-timeout=0\n" >> \
	/etc/lightdm/lightdm.conf.d/20-BCE.conf && \
	#/usr/lib/lightdm/lightdm-set-defaults --autologin oski
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

# Clean up the image before we export it
$APT_GET clean
END_TIME=$(date '+%s')

ELAPSED_SECS=$((END_TIME-START_TIME))
printf "Elapsed time: %s minutes\n" $((ELAPSED_SECS/60))