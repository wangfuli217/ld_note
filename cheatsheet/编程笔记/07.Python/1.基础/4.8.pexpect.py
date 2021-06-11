# wget https://pypi.python.org/packages/source/p/pexpect/pexpect-3.3.tar.gz
# tar zxvf pexpect-3.3.tar.gz
# cd pexpect-3.3
# python setup.py install


#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pexpect
def ssh_cmd(ip, passwd, cmd):
    ret = -1
    ssh = pexpect.spawn('ssh root@%s "%s"' % (ip, cmd))
    try:
        i = ssh.expect(['password:', 'continue connecting (yes/no)?'], timeout=5)
        if i == 0 :
            ssh.sendline(passwd)
        elif i == 1:
            ssh.sendline('yesn')
            ssh.expect('password: ')
            ssh.sendline(passwd)
        ssh.sendline(cmd)
        r = ssh.read()
        print r
        ret = 0
    except pexpect.EOF:
        print "EOF"
        ssh.close()
        ret = -1
    except pexpect.TIMEOUT:
        print "TIMEOUT"
        ssh.close()
        ret = -2
    return ret
ssh_cmd("192.168.0.102","361way","uptime")