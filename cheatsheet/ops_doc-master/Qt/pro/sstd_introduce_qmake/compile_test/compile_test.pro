TEMPLATE = subdirs

CONFIG += ordered

load(configure)
qtCompileTest(testConstexprValue)
qtCompileTest(testFromCharsLongDouble)

SUBDIRS += $$PWD/the_app1
SUBDIRS += $$PWD/the_app2
