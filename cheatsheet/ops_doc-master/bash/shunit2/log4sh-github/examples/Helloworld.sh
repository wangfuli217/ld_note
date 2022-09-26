#
# log4sh example: Hello, world properties file
#

# Set root logger level to INFO and its only appender to A1
log4sh.rootLogger=INFO, A1

# A1 is set to be a ConsoleAppender.
log4sh.appender.A1=ConsoleAppender

# A1 uses a PatternLayout.
log4sh.appender.A1.layout=PatternLayout
log4sh.appender.A1.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n