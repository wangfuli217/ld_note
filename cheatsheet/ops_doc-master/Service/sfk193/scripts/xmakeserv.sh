#!/bin/bash
#
# XMakeServ 0.5 - Cross network make of projects.
# Compile server script.
# 
# Receive files, and run commands. Running commands
# always requires a password given by client.
# requires:
#   sfk on the build server, download by
#     32 bit: wget http://stahlworks.com/sfkux
#     64 bit: wget http://stahlworks.com/sfkux64
#       then: mv sfkux sfk; chmod +x sfk
# Store and edit this using UNIX LINE ENDINGS (LF only).

# === server parameters ===
export SFK_FTP_PW=mycmdpw123

# === 1. run build server for one user ===
sfk sftserv -rw -run -port=2201
