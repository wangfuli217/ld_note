. ../log4sh

APP_NAME='mySMTP'
APP_CONFIG="smtp_appender.log4sh"

TEST_SUBJECT='This is a Subject worth testing'
TEST_TO='icmp@nidey.com'


log4sh_doConfigure "${APP_CONFIG}"

logger_info "<INFO>Hello, world!"
logger_warn "<WARN>Hello, world!"

# sendmail replace mail 