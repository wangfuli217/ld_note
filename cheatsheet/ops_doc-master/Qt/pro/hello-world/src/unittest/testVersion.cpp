// test generated SCM revision number
// Copyright: This file is in the public domain

#include "AutoTest.h"
#include "app-lib/appVersion.h"
#include <iostream>
using namespace std;

class TestVersionOutput: public QObject
{
    Q_OBJECT

  private slots:
    void printSubversionRevision()
    {
      QString revision(AppVersion::revision());
      QVERIFY( !revision.isEmpty() );
      qDebug() << "SCM revision is " << revision;
    }
};
AUTO_TEST_SUITE(TestVersionOutput);

#include "testVersion.moc"
