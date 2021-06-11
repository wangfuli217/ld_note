#include <QTextStream>
#include <QStringList>
#include <QVector>

QTextStream& operator<<(QTextStream& out, const QStringList &sl);

int main(void)
{
	QTextStream out(stdout);

	QList<QString> l1{ "1","2","3","4","5" };
	QList<QString> l2 = QVector<QString>(5, "1").toList();

	QStringList sl1(l1);
	QStringList sl2(l2);

	sl1.swap(sl2);
	sl2.push_back("7");
	sl2.push_front("0");
	sl2.insert(sl2.end() - 1, "6");
	sl2.pop_back();
	sl2.pop_front();

	out << "sl1: " << sl1 << "\n"
		<< "sl2: " << sl2 << "\n"
		<< "sl1.size = " << sl1.size() << "\n"
		<< "sl1[1] = " << sl1[1] << "\n"
		<< "sl2[2] = " << sl2.at(2) << "\n"
		<< "sl2.front = " << sl2.front() << "\n"
		<< "sl2.back = " << sl2.back()
		<< endl;

	QStringList sl3{ "Bill Murray","John Doe","Bill Clinton" };
	sl3 = sl3.filter("Bill");

	out << "sl3: " << sl3 << endl;

	QString str = "a,,b,c";
	QStringList sl4 = str.split(',');
	QStringList sl5 = str.split(',', QString::SkipEmptyParts);

	out << "sl4: " << sl4 << "\n"
		<< "sl5: " << sl5
		<< endl;

	return 0;
}

QTextStream& operator<<(QTextStream& out, const QStringList &sl)
{
	if (!sl.empty())
	{
		for (auto &i : sl)
		{
			out << i << " ";
		}
	}
	return out;
}
