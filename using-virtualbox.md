---
layout: default
title: Using VirtualBox
---
### Getting the VM up and running

  * Download and install VirtualBox from the [VirtualBox
    website](https://www.virtualbox.org/wiki/Downloads). This is the tool the
    runs the virtual machine for you.
  * Download the BCE VM in the form of an [OVA
    file](https://berkeley.box.com/s/y04d3p41eau1cz97uusf).
  * Open VirtualBox and import the BCE-0.1.3.ova file you just downloaded by
    going to "File->Import Appliance" and then selecting the .ova file from
    wherever you downloaded it to (possible 'Downloads' in your home directory
    on the machine).
  * Wait a few minutes...
  * Start the virtual machine by clicking on the tab for "BCE-0.1.3" (or
    whatever you've named it) on the left side and then clicking "Start" at the
    top. This will start a virtual Linux computer within your own machine. After
    a few seconds you should see black screen and then soon you'll see the
    desktop of the VM.

You now have a machine that has all the software installed as part of BCE,
including IPython and useful Python packages and R, RStudio and useful R
packages.

You can get a terminal window that allows you to type commands in a UNIX-style
shell by clicking on the icon of the black box with the `$` symbol on the top
panel. Using this you can start IPython Notebook by simply typing "ipython
notebook" or  R by simply typing 'R' at the prompt in the terminal. This starts
a bare-bones R session. To start RStudio, either type 'rstudio' at the prompt on
go to "Applications->Programming->RStudio".

You can restart the VM at any time by opening VirtualBox and clicking on the tab
for the VM and clicking "Start" as you did above.

### Sharing folders and copying files between your computer and the VM

One useful thing will be to share folders between the VM and the host machine so
that you can access the files on your computer from the VM. Do the following:

  * Got to "Devices->Shared Folder Settings" and click on the icon of a folder
    with a "+" on the right side.
  * Select a folder to share, e.g. your home directory on your computer by
    clicking on "Folder Path" and choosing "Other" and navigating to the folder
    of interest. For our purposes here, assume we click on "Documents".
  * Click "make permanent" and "auto-mount" and then click "Ok".
  * Reboot the machine by going to applications button on the left of the top
    toolbart, clicking on "Log Out", and choosing "Restart" in the window that
    pops up.
  * Once the VM is running again, click on the "Shared" folder on the desktop.
    You should see the folder "sf_Documents" (or whatever the folder name you
    selected was, in place of 'Documents'). You can drag and drop files to
    manipulate them.
  * Alternatively, from the Terminal, you can also see the directory by doing
    "cd ~/Desktop/shared/sf_Documents" and then "ls" will show you the files.
    Be careful: unless you selected "read only" at the same time as "make
    permanent", any changes to the shared folder on the VM affects the folder in
    the 'real world', namely your computer.

### Enabling Virtualization in your computer's BIOS

While most computers support hardware virtualization, not all computer vendors enable this feature as shipped from the factory. If your computer does not have virtualization enabled, the VM will either not run or run very slowly. To turn this feature on, try these instructions based on [Red Hat instructions](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html):

* Reboot your computer
* Right when the computer is coming up from the black screen, press `Delete`, `Esc`, `F1`, `F2`, or `F4`. Each computer manufacturer uses a different key but it should show a brief message at boot telling you which one to press. If you miss it the first time, reboot and try again. It helps to tap the key about twice a second when the computer is coming up.
* In the BIOS settings, find the configuration items related to the CPU. These can be in under the headings `Processor`, `Chipset` or `Northbridge`.
* Enable virtualization; the setting may be called `VT-x`, `AMD-V`, `SVM`, or `Vanderpool`. Enable `Intel VT-d` or `AMD IOMMU` if the options are available.
* Save your changes and reboot.

### Enabling Virtualization within your VM

If you are planning on hosting virtual machines *within* your VM or if you need to run a 64-bit guest system on your 32-bit computer, you will need to turn on hardware virtualization in the VirtualBox settings. Visit the Settings window of your VM and click the **System** icon, then the **Acceleration** tab. Check **Enable VT-x/AMD-V** and **Enable Nested Paging**.
