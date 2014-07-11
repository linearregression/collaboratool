---
layout: default
title: Overview
---
<<<<<<< HEAD
### What is BCE?

BCE stands for the Berkeley Common (or Compute, or Collaborative...) Environment.
It is designed to provide a common Linux computational environment for classwork
and research.

### What is "Collaboratool?"

"Collaboratool" was conceived as a project for building, integrating, and
deploying tools that support portable, reproducible data science.  We started
thinking about how to deploy virtualized containers that provide things like
IPython notebooks through the web. We were inspired by
[jiffylab](http://github.com/ptone/jiffylab). From there, we decided that it
made more sense to focus on a complete virtual environment, which is easy to
deploy in a variety of contexts, which is what you'll find here now.

### BCE Vision

We've presented on BCE at SciPy2014. Here are
[slides](https://berkeley.box.com/s/m80jxh3fabbvu93otreh) and [a draft of the
conference paper](https://berkeley.box.com/s/w424gdjot3tgksidyyfl).

The goal for the BCE is to provide both the ready-made environments and also
the "recipes" or scripts setting up these environments. It should be easy for a
competent Linux user to create recipes for custom tools that might not be
broadly useful (and thus, not already in BCE).

BCE is designed for classwork and research in the sciences at Berkeley, broadly defined to
include social science, life science, physical science, and engineering. Using
these tools, users can start up a virtual machine (VM) with a standardized Linux
operating environment containing a set of standard software for scientific
computing. The user can start the VM on their laptop, on a university server, or
in the cloud. Furthermore, users will be able to modify the instructions for
producing or modifying the virtual machine in a reproducible way for
communication with and distribution to others.

We envision the following core use cases:

  - creating a common computing environment for a course or workshop,
  - creating a common computational environment to be shared by a group of researchers or students, and
  - disseminating the computational environment so outsiders can reproduce the results of a group.

What problems does BCE solve for you?

 - No more obscure installation issues - download and run a single virtual
   machine or get the same environment on a bare metal or virtual server.
 - I'm teaching a class - when you tell a student that a program behaves a
   certain way, it does!
 - I'm collaborating on some scientific research - now all of your collaborators
   can run your code without complex installation instructions.

To accomplish this, we envision that BCE will encompass the following:

 - a reproducible workflow that creates the standard VM/image
   with standard scientific computing software such as Python, R, git, etc.,
 - a standard binary image, produced by the workflow, that can be distributed as is and
   used on-the-fly with VirtualBox or VMWare Player with minimal dependencies, and
 - (possibly) an augmented workflow that represents multiple possible distributions tailored
   for different types of uses (e.g., different disciplines, different
   computational needs, class vs. research use, etc.). This might
   represent either a sequence or a tree of possible VMs.


### Who are we?

Collaboratool is a project that started in the
[D-Lab](http://dlab.berkeley.edu), with collaboration from [Computer Science
(EECS)](http://www.eecs.berkeley.edu), the [Statistical Computing Facility
(SCF)](http://statistics.berkeley.edu/computing), [Berkeley Research Computing
(BRC)](http://research-it.berkeley.edu/brc), and [the
School of Information](http://ischool.berkeley.edu).
