#include <QCoreApplication>
#include <QDebug>
#include <QSettings>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QCoreApplication::setOrganizationName("Org");
    QCoreApplication::setOrganizationDomain("Domain");
    QCoreApplication::setApplicationName("App");

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    settings.setValue("test", 123);

    qInfo() << settings.value("test").toString();
    qInfo() << settings.value("test").toInt();

    return a.exec();
}
