// A sample unit test
// Copyright: This file is in the public domain

#include "AutoTest.h"

class TestQString: public QObject
{
    Q_OBJECT
  private slots:

    void toUpper()
    {
      // 1. setup
      QString str = "Hello";
      // 2. execute
      // 3. check
      QCOMPARE(str.toUpper(), QString("HELLO"));
      // 4. teardown
    }
};

AUTO_TEST_SUITE(TestQString);

#include "testApp.moc"
