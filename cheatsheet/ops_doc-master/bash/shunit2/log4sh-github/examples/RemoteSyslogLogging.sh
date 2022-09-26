#! /bin/sh
#
# log4sh example: remote syslog logging
#
# The nc (netcat) command has the ability to generate the UDP packet to port 514 that is required for remote syslog logging

# load log4sh (disabling properties file warning) and clear the default
# configuration
LOG4SH_CONFIGURATION='none' . ./log4sh
log4sh_resetConfiguration

# set alternative 'nc' command
log4sh_setAlternative nc /bin/nc

# add and configure a SyslogAppender that logs to a remote host
logger_addAppender mySyslog
appender_setType mySyslog SyslogAppender
appender_syslog_setFacility mySyslog local4
appender_syslog_setHost mySyslog somehost
appender_activateOptions mySyslog

# say Hello to the world
logger_info 'Hello, world'