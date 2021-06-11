#!/usr/bin/python
# One-Click Regression Test Script 

import os
import sys
import string
import subprocess
import time
import signal
import getopt
import pexpect
from xml.dom import minidom

class COneClickRegTest:

    # Set class numbers and clean up previous log files if exist
    def __init__(self):
        signal.signal(signal.SIGINT, self.handler)
        self.myafs_dir = os.getenv('myafs') # Project code will reside here and need to configure 'myafs' in shell first
        self.testsuite_dir = os.getcwd()
        self.token = 'your_password' # Token used for checking-out/updating code
        self.subproc_id = -1 # Store sub-process ID
        self.share_dir = str(self.myafs_dir) + '/SharedFiles' # Configure the SHARED directory to store test results
 
        # Configure log information
        self.debug_log = 'log.txt' 
        self.debug_fullname = os.getcwd() + os.sep + self.debug_log
        self.sum_log = 'summary'
        self.sum_fullname = str(self.myafs_dir) + '/cecregres/runresults/' + str(self.sum_log)

        # Remove previous log files if exist
        if os.path.isfile(self.debug_fullname):
            os.remove(self.debug_fullname)
        if os.path.isfile(self.sum_fullname):
            os.remove(self.sum_fullname)

    def __del__(self):
        pass

    # Set environment variable PYTHONPATH
    def set_python(self):
        python_path = os.getenv('PYTHONPATH')
        ret_val =string.find(python_path, self.myafs_dir)
        if (-1 == ret_val) :
            test_lib = self.myafs_dir + '/cecsim_addons'
            new_python_path = '%s:%s:%s' %(self.myafs_dir, test_lib, python_path)
            os.putenv('PYTHONPATH', new_python_path)

    # Check out(get a new copy of) project code
    def checkout_code(self):
        # Delete directory if project code exists
        if os.path.isdir('%s/project_code' %self.myafs_dir):
            del_cmd = 'rm -rf %s/project_code' %self.myafs_dir
            del_proc = subprocess.Popen(del_cmd, stdin=None, stdout=None, stderr=None, shell=True)
            self.subproc_id = del_proc.pid
            del_proc.wait()
            assert (0 == del_proc.returncode)

        # Get a new copy of project code
        os.chdir('%s' %self.myafs_dir)

        try:
            chkout_cmd = 'cvs co project_code' 
            child = pexpect.spawn(chkout_cmd)
            child.expect('password:')
            child.sendline(self.mytoken)
            child.interact()
        except:
            pass
        
    # Update CVS repository 
    def update_code(self):
        os.chdir('%s/project_code' %self.myafs_dir)
        try:
            chkout_cmd = 'cvs update'
            child = pexpect.spawn(chkout_cmd)
            child.expect('password:')
            child.sendline(self.mytoken)
            child.interact()
        except:
            pass

    # Build image
    def build_code(self):
        build_cmd = "cd %s/project_code && 'Your_build_command'" %self.myafs_dir
        build_proc = subprocess.Popen(build_cmd, stdin=None, stdout=None, stderr=None, shell=True)
        self.subproc_id = build_proc.pid
        build_proc.wait()
        assert (0 == build_proc.returncode)

    # Run regression test suite 
    def run_testsuite(self):
        os.chdir(self.testsuite_dir)
        try :
            ut_cmd = 'Your_unit_test_command  2>&1 > %s' %self.debug_log
            ut_proc = subprocess.Popen(ut_cmd, stdin=None, stdout=None, stderr=None, shell=True)
            self.subproc_id = ut_proc.pid
            ut_proc.wait()
            assert(0 != ut_proc.returncode)
        except:
            print 'run_cecsim is interrupted.'

    # Collect test results
    def store_logs(self):
        xml_file = self.share_dir + '/Sprint.xml'
        print 'XML config file:', xml_file

        cur_date = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
        print 'current date:', cur_date

        try:
            xmldoc = minidom.parse(xml_file)
           
            min_num_node = xmldoc.getElementsByTagName('min-sprint')[0]
            min_num = int(min_num_node.firstChild.data)

            max_num_node = xmldoc.getElementsByTagName('max-sprint')[0]
            max_num = int(max_num_node.firstChild.data)
 
            cur_num = min_num
            while cur_num <= max_num :
                node_name = 'sprint' + str(cur_num)
                cur_node = xmldoc.getElementsByTagName(node_name)[0]
                sprint_date = cur_node.firstChild.data
                if sprint_date <= cur_date[0:7]:
                    cur_num = cur_num + 1
                else:
                    break
        except:
            print 'Error: Parse XML file failed.'

        print 'Current sprint is', cur_num-1
        log_dir = self.share_dir + '/Sprint' + str(cur_num-1) +  '-' + cur_date
        print log_dir
        os.mkdir(log_dir)
        os.system('mv %s %s' %(self.debug_fullname, log_dir))
        os.system('mv %s %s' %(self.sum_fullname, log_dir))
     
    def handler(self, signum, frame):
        if (-1 != self.subproc_id) :
            os.killpg(self.subproc_id, signal.SIGINT)
        sys.exit(-1)

    def usage(self):
        print 'usage: %s                  : Run regression test only' %sys.argv[0]
        print '   or: %s -b or --build    : Build image and run regression test.' %sys.argv[0]
        print '   or: %s -c or --checkout : Check out code (will delete the old one first, if exists), compile it, then run regression test.' %sys.argv[0]
        print '   or: %s -u or --update   : Update code, compile it, then run regrssion test.' %sys.argv[0]
        print '   or: %s -h or --help     : Print Help (this message) and exit.' %sys.argv[0]

    def main(self):
        try:
            opts, args = getopt.getopt(sys.argv[1:], 'bchu', ['build', 'checkout', 'help', 'update'])
        except getopt.error, msg:
            print msg 
            print "for help use --help"
            sys.exit(2)

        # process options
        build_flag = 0 
        for o, a in opts:
            if o in ('-h', '--help'):
                self.usage()
                sys.exit() 
            elif o in ('-c', '--checkout'):
                print 'The following actions will be executed.'
                print ' -- Check out code, will DELETE it frist, if exists.'
                print ' -- Build image.'
                build_flag = 1
                break
            elif o in ('-u', '--update'):
                print 'The following actions will be executed.'
                print ' -- UPDATE code.'
                print ' -- Build image.'
                build_flag = 2
                break
            elif o in ('-b', '--build'):
                print 'The following actions will be executed.'
                print ' -- Build image.'
                build_flag = 3
                break
            else:
                self.usage()
                sys.exit() 

        if (0 == build_flag) :
            if 2 <= len(sys.argv):
                self.usage()
                sys.exit()
            print 'The following action will be executed.'

        print ' -- Run test suite.' 
        print ' -- Store test results.' 

        raw_input("\nPress 'Enter' key to continue...(Ctrl+C to break)\t")
        print 'One-click Regresstion Test start ...'
       
        if (1 == build_flag) : # Perform 'checkout' option
            self.checkout_code()
            self.build_code()
        elif (2 == build_flag) : # Perform 'update' option
            self.update_code()
            self.build_code()
        elif (3 == build_flag) : # Perform 'build' option
            self.build_code()

        self.set_python()
        self.run_testsuite()
        self.store_logs()
        print 'One-click Regresstion Test finished.'

if __name__ == '__main__':

    ocrt = COneClickRegTest()
    ocrt.main()

