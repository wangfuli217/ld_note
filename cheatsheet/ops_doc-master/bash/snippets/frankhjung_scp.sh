====== Copy files to remote host using scp ======


Here is a little script I use to push files using SSH (including [[frank:devops:ssh_keys|SSH keys]]) to hosts.
This is so I can easily login using SSH to remote hosts. Can also be used to push SSH keys for Ansible.
I use [[frank:devops:sshm|SSHM]] which is a little tool to quickly log into remote hosts using an alias.

addhost.sh - add a host to my list of environments

<code bash addhost.sh>
#!/usr/bin/env bash

username=my_username
pubkey=mypubkey.pub

while read -r host
do
    echo "Setting up ${username} for ${host} ..."
    ssh-copy-id -i ~/.ssh/${pubkey} ${username}@${host}
    scp -p _vimrc ${username}@${host}:~/.vimrc
    scp -p _bashrc ${username}@${host}:~/.bashrc
    echo "Host ${host} setup"
done < hosts
</code>

Where ''host'' is a file that lists fully qualified hosts to copy to. For example:

<file>
fhj01.local
fhj02.local
fhj03.local
</file>

Apart from being useful for me at work, it also shows how you can read a list of items in a while loop in bash.

{{tag>bash ssh scp sshm}}