#! /usr/bin/env fish

# Create SSH key
ssh-keygen -t rsa -b 4096 -C "volpegabriel@gmail.com"
eval (ssh-agent -s)
ssh-add $HOME/.ssh/id_rsa
