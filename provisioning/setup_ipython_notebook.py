#!/usr/bin/env python

'''Make it easy to set up password / encryption for IPython notebook

It would probably be more elegant to do this with a shell script, actually'''

from subprocess import call

from IPython.lib import passwd

# This is particularly pathological
print 'generating the default IPython profile files'
call('ipython profile create'.split())
print 'DONE!'

user_password = raw_input('Please type a password to use for the notebook: ')
print '\nPlease add/change the following lines in'
print '.ipython/profile_default/ipython_notebook_config.py'
print '(You are welcomet to change the port number, move the certificate, etc.)'

config = """c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 9999
c.NotebookApp.certfile = u'/home/oski/ipython.pem'
c.NotebookApp.password = u'{}'"""

print config.format(passwd(user_password))

print """
Once you've done the above and actually generated a certificate, you
can run the notebook server as normal:

ipython notebook

You'll need to enable access from your web browser's IP, for example using
Amazon's EC2 console. Be sure you're using HTTPS and the correct port number!"""

print """
To generate a certificate, run the following command (the program will ask you some
questions, and you can answer however you like):

openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout ipython.pem -out ipython.pem"""
