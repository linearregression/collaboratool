Collaboratool
=============

This project is primarily organized around creating and popularizing the
Berkeley Common Environment (BCE).

Full documentation for the project is available on our gh-pages website:
[http://collaboratool.berkeley.edu](http://collaboratool.berkeley.edu).

*provisioning*: BCE can be created using packer with the appropriate json file.
See the HOWTO.md file for more.

*reference*: This folder contains information that might be useful later.

Collaboratool Image Generation
==============================

The safest base image appears to be the vanilla 64-bit ubuntu server image.

There are several approaches we've tested, including:

 1. A 2-step process of manual base OVA creation followed by scripted deployment
 2. Fully scripted process using vagrant
 3. Fully scripted using packer


For Summer 2014
===============

Dav and Ryan identified and implemented the following specifications for the
summer VM (via the packer method, vagrant method is similar, but is not verified
to produce exactly the following):

    - OS: Ubuntu Server 14.04 (64-bit)
        + Python packages installed via pip/easy_install since it is likely they
          will need to be upgraded mid-term while the Ubuntu python-* packages
          do not change.
        + R packages come from rrutter and c2d4u PPAs since they are kept
          up-to-date while the Ubuntu r-cran-* packages do not change.
        + Hide the grub menu and Linux kernel boot messages.
    - User: Single auto-login user ("oski") with no password sudo. Insecure
      default password of "oski".
    - VirtualBox:
        + Window is resizable for XFCE on Ubuntu (note, not for LXDE).
        + bidirectional clipboard enabled
        + bidirectional drag-n-drop enabled (but only working host to guest)
    - Desktop: XFCE
        + One panel with launchers for Terminal, Browser, File Manager, Text
          Editor (gedit)
        + Substitute solid color for background image
        + Remove desktop icon for Trash and File System. Leave Home icon.
        + Benoit and Ryan suggest an icon on the desktop pointing to /media,
          VirtualBox's parent of all Shared Folders.
        + Black-on-white text in terminal since it is easier to see when
          projected in class
        + Change the panel's Application menu icon to a generic computer icon
          from XFCE's logo.


History
-------

This master branch is a reboot of the repo now in
[collaboratool-archive](https://github.com/dlab-berkeley/collaboratool-archive).
Sadly, while some of the materials copied here were authored by
@BagOfMostlyWater, that history is lost. But, I hope you find that the 2 degrees
of magnitude reduction in repository size is worth it!

Another source of materials while we're settling is in
[collaboratool-base](https://github.com/dlab-berkeley/collaboratool-base), which
represents @davclark's first stab at a minimal provisioning approach.
