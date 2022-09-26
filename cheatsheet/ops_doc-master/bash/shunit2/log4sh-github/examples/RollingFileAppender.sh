#! /bin/sh
#
# log4sh example: using the RollingFileAppender
#

# load log4sh (disabling properties file warning) and clear the default
# configuration
LOG4SH_CONFIGURATION='none' . ./log4sh
log4sh_resetConfiguration

# add and configure a RollingFileAppender named R
logger_addAppender R
appender_setType R RollingFileAppender
appender_file_setFile R '/path/to/some/file'
appender_file_setMaxFileSize R 10KB
appender_file_setMaxBackupIndex R 1
appender_activateOptions R

# say Hello to the world
logger_info 'Hello, world'