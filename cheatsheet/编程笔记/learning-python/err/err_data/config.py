##########################################################################
#                                                                        #
#  This is the config-template for Err. This file should be copied and   #
#  renamed to config.py, then modified as you see fit to run Err the way #
#  you like it.                                                          #
#                                                                        #
#  As this is a regular Python file, note that you can do variable       #
#  assignments and the likes as usual. This can be useful for example if #
#  you use the same values in multiple places.                           #
#                                                                        #
#  Note: Various config options require a tuple to be specified, even    #
#  when you are configuring only a single value. An example of this is   #
#  the BOT_ADMINS option. Make sure you use a valid tuple here, even if  #
#  you are only configuring a single item, else you will get errors.     #
#  (So don't forget the trailing ',' in these cases)                     #
#                                                                        #
##########################################################################

import logging

##########################################################################
# Core Err configuration                                                 #
##########################################################################

# BACKEND selection.
# This configures the type of chat server you wish to use Err with.
#
# The current choices:

# Debug backends to test your plugins manually:
# 'Text'     - on the text console
# 'Graphic'  - in a GUI window

# Commercial backends:
# 'Campfire' - see https://campfirenow.com/ (follow instructions from https://github.com/gbin/err-backend-campfire)
# 'Hipchat'  - see https://www.hipchat.com/
# 'Slack'    - see https://slack.com/
# 'Gitter'   - see https://gitter.im/ (follow instructions from https://github.com/gbin/err-backend-gitter)

# Open protocols:
# 'TOX'      - see https://tox.im/ (follow instructions from https://github.com/gbin/err-backend-tox)
# 'IRC'      - for classic IRC or bridged services like https://gitter.im
# 'XMPP'     - the Extensible Messaging and Presence Protocol (https://xmpp.org/)
# 'Telegram' - cloud-based mobile and desktop messaging app with a focus
#              on security and speed. (https://telegram.org/)

BACKEND = 'Telegram'

# The location where all of Err's data should be stored. Make sure to set
# this to a directory that is writable by the user running the bot.
BOT_DATA_DIR = '/Users/akagi201/Documents/learning-python/err/err_data'

# Set this to a directory on your system where you want to load extra
# plugins from, which is useful mostly if you want to develop a plugin
# locally before publishing it. Note that you can specify only a single
# directory, however you are free to create subdirectories with multiple
# plugins inside this directory.
BOT_EXTRA_PLUGIN_DIR = None

# If you use an external backend as a plugin,
# this is where you tell err where to find it.
# BOT_EXTRA_BACKEND_DIR = '/opt/errbackends'

# Should plugin dependencies be installed automatically? If this is true
# then Err will use pip to install any missing dependencies automatically.
#
# If you have installed Err in a virtualenv, this will run the equivalent
# of `pip install -r requirements.txt`.
# If no virtualenv is detected, the equivalent of `pip install --user -r
# requirements.txt` is used to ensure the package(s) is/are only installed for
# the user running Err.
#AUTOINSTALL_DEPS = True

# The location of the log file. If you set this to None, then logging will
# happen to console only.
BOT_LOG_FILE = None

# The verbosity level of logging that is done to the above logfile, and to
# the console. This takes the standard Python logging levels, DEBUG, INFO,
# WARN, ERROR. For more info, see http://docs.python.org/library/logging.html
#
# If you encounter any issues with Err, please set your log level to
# logging.DEBUG and attach a log with your bug report to aid the developers
# in debugging the issue.
BOT_LOG_LEVEL = logging.INFO

# Enable logging to sentry (find out more about sentry at www.getsentry.com).
# This is optional and disabled by default.
BOT_LOG_SENTRY = False
SENTRY_DSN = ''
SENTRY_LOGLEVEL = BOT_LOG_LEVEL

# Execute commands in asynchronous mode. In this mode, Err will spawn 3 
# seperate threads to handle commands, instead of blocking on each 
# single command.
BOT_ASYNC = True

##########################################################################
# Account and chatroom (MUC) configuration                               #
##########################################################################

# The identity, or credentials, used to connect to a server
BOT_IDENTITY = {
    # XMPP (Jabber) mode
    # 'username': 'err@localhost',  # The JID of the user you have created for the bot
    # 'password': 'changeme',       # The corresponding password for this user
    # 'server': ('host.domain.tld',5222), # server override

    ## HipChat mode (Comment the above if using this mode)
    # 'username' : '12345_123456@chat.hipchat.com',
    # 'password' : 'changeme',
    ## Group admins can create/view tokens on the settings page after logging
    ## in on HipChat's website
    # 'token'    : 'ed4b74d62833267d98aa99f312ff04',
    ## If you're using HipChat server (self-hosted HipChat) then you should set
    ## the endpoint below. If you don't use HipChat server but use the hosted version
    ## of HipChat then you may leave this commented out.
    # 'endpoint' : 'https://api.hipchat.com'

    ## Slack mode (comment the others above if using this mode)
    # 'token': 'xoxb-4426949411-aEM7...',

    ## Telegram mode (comment the others above if using this mode)
    'token': '131266252:AAE7w_snaJZLVUxj-ccdpHgZ49j-WZDd9sA',

    ## IRC mode (Comment the others above if using this mode)
    # 'nickname' : 'Akagi201',
    # 'username' : 'Akagi201',    # optional, defaults to nickname if omitted
    # 'password' : 'goodluck201',             # optional
    # 'server' : 'irc.freenode.net',
    # 'port': 6667,                  # optional
    # 'ssl': False,                  # optional
}

# Set the admins of your bot. Only these users will have access
# to the admin-only commands.
#
BOT_ADMINS = ('akagi201@gmail.com',)

# Chatrooms your bot should join on startup. For the IRC backend you
# should include the # sign here. For XMPP rooms that are password
# protected, you can specify another tuple here instead of a string,
# using the format (RoomName, Password).
# CHATROOM_PRESENCE = ('#akmaker@irc.freenode.net',)

CHATROOM_PRESENCE = ('',)

# The FullName, or nickname, your bot should use. What you set here will
# be the nickname that Err shows in chatrooms. Note that some XMPP
# implementations, notably HipChat, are very picky about what name you
# use. In the case of HipChat, make sure this matches exactly with the
# name you gave the user.
CHATROOM_FN = 'Akagi201'

##########################################################################
# Prefix configuration                                                   #
##########################################################################

# Command prefix, the prefix that is expected in front of commands directed
# at the bot.
#
# Note: When writing plugins,you should always use the default '!'.
# If the prefix is changed from the default, the help strings will be
# automatically adjusted for you.
#
BOT_PREFIX = '!'

# Uncomment the following and set it to True if you want the prefix to be
# optional for normal chat.
# (Meaning messages sent directly to the bot as opposed to within a MUC)
#BOT_PREFIX_OPTIONAL_ON_CHAT = False

# You might wish to have your bot respond by being called with certain
# names, rather than the BOT_PREFIX above. This option allows you to
# specify alternative prefixes the bot will respond to in addition to
# the prefix above.
#BOT_ALT_PREFIXES = ('Err',)

# If you use alternative prefixes, you might want to allow users to insert
# separators like , and ; between the prefix and the command itself. This
# allows users to refer to your bot like this (Assuming 'Err' is in your
# BOT_ALT_PREFIXES):
# "Err, status" or "Err: status"
#
# Note: There's no need to add spaces to the separators here
#
#BOT_ALT_PREFIX_SEPARATORS = (':', ',', ';')

# Continuing on this theme, you might want to permit your users to be
# lazy and not require correct capitalization, so they can do 'Err',
# 'err' or even 'ERR'.
#BOT_ALT_PREFIX_CASEINSENSITIVE = True

##########################################################################
# Access controls and message diversion                                  #
##########################################################################

# Access controls, allowing commands to be restricted to specific users/rooms.
# Available filters (you can omit a filter or set it to None to disable it):
#   allowusers: Allow command from these users only
#   denyusers: Deny command from these users
#   allowrooms: Allow command only in these rooms (and direct messages)
#   denyrooms: Deny command in these rooms
#   allowprivate: Allow command from direct messages to the bot
#   allowmuc: Allow command inside rooms
# Rules listed in ACCESS_CONTROLS_DEFAULT are applied when a command cannot 
# be found inside ACCESS_CONTROLS
#
# Example:
#ACCESS_CONTROLS_DEFAULT = {} # Allow everyone access by default
#ACCESS_CONTROLS = {'status': {'allowrooms': ('someroom@conference.localhost',)},
#                   'about': {'denyusers': ('baduser@localhost',), 'allowrooms': ('room1@conference.localhost', 'room2@conference.localhost')},
#                   'uptime': {'allowusers': BOT_ADMINS},
#                   'help': {'allowmuc': False},
#                  }

# Uncomment and set this to True to hide the restricted commands from
# the help output.
#HIDE_RESTRICTED_COMMANDS = False

# Uncomment and set this to True to ignore commands from users that have no
# access for these instead of replying with error message.
#HIDE_RESTRICTED_ACCESS = False

# A list of commands which should be responded to in private, even if
# the command was given in a MUC. For example:
# DIVERT_TO_PRIVATE = ('help', 'about', 'status')
DIVERT_TO_PRIVATE = ()

# Chat relay
# Can be used to relay one to one message from specific users to the bot
# to MUCs. This can be useful with XMPP notifiers like for example  the
# standard Altassian Jira which don't have native support for MUC.
# For example: CHATROOM_RELAY = {'gbin@localhost' : (_TEST_ROOM,)}
CHATROOM_RELAY = {}

# Reverse chat relay
# This feature forwards whatever is said to a specific user.
# It can be useful if you client like gtalk doesn't support MUC correctly
# For example: REVERSE_CHATROOM_RELAY = {_TEST_ROOM : ('gbin@localhost',)}
REVERSE_CHATROOM_RELAY = {}

##########################################################################
# Miscellaneous configuration options                                    #
##########################################################################

# Define the maximum length a single message may be. If a plugin tries to
# send a message longer than this length, it will be broken up into multiple
# shorter messages that do fit.
#MESSAGE_SIZE_LIMIT = 10000

# XMPP TLS certificate verification. In order to validate offered certificates,
# you must supply a path to a file containing certificate authorities. By
# default, "/etc/ssl/certs/ca-certificates.crt" is used, which on most Linux
# systems holds the default system trusted CA certificates. You might need to
# change this depending on your environment. Setting this to None disables
# certificate validation, which can be useful if you have a self-signed
# certificate for example.
#XMPP_CA_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"

# Influence the security methods used on connection with XMPP-based
# backends. You can use this to work around authentication issues with
# some buggy XMPP servers.
#
# The default is to try anything:
#XMPP_FEATURE_MECHANISMS = {}
# To use only unencrypted plain auth:
#XMPP_FEATURE_MECHANISMS =  {'use_mech': 'PLAIN', 'unencrypted_plain': True, 'encrypted_plain': False}

# Modify the default keep-alive interval. By default, Err will send
# some whitespace to the XMPP server every 300 seconds to keep the TCP
# connection alive. On some servers, or when running Err from behind
# a NAT router, the default might not be fast enough and you will need
# to set it to a lower value. 
#
# It has been reported that HipChat also times out without setting this
# to a lower value (60 seems to work well with HipChat)
#
# If you're having issues with your bot getting constantly disconnected,
# try to gradually lower this value until it no longer happens.
#XMPP_KEEPALIVE_INTERVAL = 300

# Message rate limiting for the IRC backend. This will delay subsequent
# messages by this many seconds (floats are supported). Setting these
# to a value of 0 effectively disables rate limiting.
#IRC_CHANNEL_RATE = 1  # Regular channel messages
#IRC_PRIVATE_RATE = 1  # Private messages
#IRC_RECONNECT_ON_KICK = 5  # Reconnect back to a channel after a kick (in seconds)
                            # Put it at None if you don't want the chat to
                            # reconnect
#IRC_RECONNECT_ON_DISCONNECT = 5  # Reconnect back to a channel after a disconenction (in seconds)

# Allow messages sent in a chatroom to be directed at requester.
#GROUPCHAT_NICK_PREFIXED = False
