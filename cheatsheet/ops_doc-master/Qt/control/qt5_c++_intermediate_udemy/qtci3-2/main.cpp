#include <QCoreApplication>
#include <QDebug>
#include <QSettings>
#include <QStringList>
#include <QRandomGenerator>

void saveAge(QSettings* settings, const QString& group, const QString& name, unsigned age) {
    settings->beginGroup(group);
    settings->setValue(name, age);
    settings->endGroup();
}

int getAge(QSettings* settings, const QString& group, const QString& name) {
    settings->beginGroup(group);
    if(!settings->contains(name)){
        qWarning() << "Settings does not contain " << name << " in group " << group;
        settings->endGroup();
        return 0;
    }

    bool ok{};
    int value = settings->value(name).toInt(&ok);
    settings->endGroup();

    if(!ok) {
        qWarning() << "Failed to convert to int";
        return 0;
    }

    return value;
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QCoreApplication::setOrganizationName("Org");
    QCoreApplication::setOrganizationDomain("Domain");
    QCoreApplication::setApplicationName("App2");

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    QStringList hobbits;
    hobbits << "Frodo" << "Sam" << "Bilbo" << "Merry" << "Pippin";

    foreach(QString hobbit, hobbits) {
        uint value = QRandomGenerator::global()->generate();
        saveAge(&settings, "hobbits", hobbit, value);
    }

    settings.sync();

    qInfo() << settings.fileName();

    foreach(QString group, settings.childGroups()) {
        settings.beginGroup(group);
        qInfo() << "Group: " << group;
        foreach(QString key, settings.childKeys()) {
            qInfo() << "... key: " << key << " = " << settings.value(key).toInt();
        }
        settings.endGroup();
    }

    return a.exec();
}
