#include <QCoreApplication>
#include <QVector>
#include <QDebug>
#include <QList>

template<typename T>
void fill(T& container) {
    for(int i{0}; i < 20; ++i)
        container.append(i);
}

template<typename T>
void display(const T& container) {
    for(int i{0}; i < container.length(); ++i) {
        if (i > 0) {
            auto current = reinterpret_cast<std::uintptr_t>(&container.at(i));
            auto previous = reinterpret_cast<std::uintptr_t>(&container.at(i-1));
            auto distance{current - previous};

            qInfo() << QString::number(i) << "at: " << current << "previous: " << previous << "distance: " << distance;
        } else {
            qInfo() << QString::number(i) << &container.at(i) << "distance: 0";
        }
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QVector<int> vec{QVector<int>()};
    QList<int> list{QList<int>()};
    fill(vec);
    fill(list);

    qInfo() << "Int takes: " << sizeof(int);

    qInfo() << "Displaying vector:";
    display(vec);
    qInfo() << "Displaying list:";
    display(list);

    return a.exec();
}
