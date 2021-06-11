#ifndef AUTOTEST_H
#define AUTOTEST_H

// This file is a slight modification of the proposals at the following URLs:
// http://qtcreator.blogspot.com/2009/10/running-multiple-unit-tests.html
// http://qtcreator.blogspot.com/2010/04/sample-multiple-unit-test-project.html

#include <QTest>
#include <QList>
#include <QString>
#include <QSharedPointer>
#include <QtDebug>

namespace AutoTest
{
  typedef QList<QObject*> TestList;

  inline TestList& testList()
  {
    static TestList list;
    return list;
  }

  inline bool findObject(QObject* object)
  {
    TestList& list = testList();
    if (list.contains(object))
    {
      return true;
    }
    foreach (QObject* test, list)
    {
      if (test->objectName() == object->objectName())
      {
        return true;
      }
    }
    return false;
  }

  inline void addTest(QObject* object)
  {
    TestList& list = testList();
    if (!findObject(object))
    {
      list.append(object);
    }
  }

  inline int run(int argc, char *argv[])
  {
    const int ERROR = -1;
    int ret = 0;
    int failed = 0;
    int passed = 0;

    foreach (QObject* test, testList())
    {
      if( QTest::qExec(test, argc, argv) == 0 )
      {
        ++passed;
      }
      else
      {
        ++failed;
        ret = ERROR;
      }
    }

    qDebug() << "Overall result:" << ((ret==0)?"PASS,":"FAIL,")
             << passed << "suites passed," << failed << "suites failed";

    return ret;
  }
}

template <class T>
class Test
{
  public:
    QSharedPointer<T> child;

    Test(const QString& name) : child(new T)
    {
      child->setObjectName(name);
      AutoTest::addTest(child.data());
    }
};

#define AUTO_TEST_SUITE(className) static Test<className> t(#className)

#define TEST_MAIN \
  int main(int argc, char *argv[]) \
  { \
    return AutoTest::run(argc, argv); \
  }

#endif // AUTOTEST_H
