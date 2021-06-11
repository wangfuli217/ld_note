#!/bin/bash
#
# XMakeTarg 0.5 - Cross network make of projects.
# Target server script.
# 
# Receive binary file updates, instantly, without
# complex user configuration or certificate setup.
# requires:
#   sfk on the target, 32 bit ARM download by
#           wget http://stahlworks.com/sfkarm
#     or    curl -o sfk http://stahlworks.com/sfkarm
#     then  mv sfkarm sfk; chmod +x sfk
# Store and edit this using UNIX LINE ENDINGS (LF only).

# === set file transfer password ===
export SFK_FTP_PW=mybinpw456

# === run file receive server on default port 2121 ===
sfk sftserv -rw
