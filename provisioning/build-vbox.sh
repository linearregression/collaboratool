# Note, 2>&1 redirects to wherever stdout is directed when it gets processed
# Pipes get parsed before redirects
# This is why we place it before the pipe
# See: http://mywiki.wooledge.org/BashFAQ/055
# ps - Bash is just a crazy sorthand for some C code

packer build -only=virtualbox-iso BCE-14.04-amd64.json  2>&1 | tee packer-vbox-out.log
