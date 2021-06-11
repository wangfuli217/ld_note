    * 遍历, 从列表第一个元素的前一个位置开始. 用容器初始化一个Java风格迭代器, 使用 hasNext() 和 next() 方法进行遍历.

        QList<double> list;
        ...
        QListIterator<double> i(list);
        while (i.hasNext()) {
            do_something(i.next());
        }

    * 倒退遍历, 从列表最后一个元素的后一个位置开始. 同样适用容器初始化一个迭代器, 而后使用 toBack() 方法
将迭代器放置在最后一个item之后. 使用 hasPrevious() 和 previous() 方法进行遍历.

        QListIterator<double> i(list);
        i.toBack();
        while (i.hasPrevious()) {
            do_something(i.previous());
        }

    * Mutable 迭代器提供当迭代之时进行插入, 修改, 移除元素操作.

        QMutableListIterator<double> i(list);
        while (i.hasNext()) {
            if (i.next() < 0.0)
                i.remove();
        }

    * remove() 函数则是对刚刚跳过去的元素进行操作. 如next() 和 previous() 跳过去的元素.

        QMutableListIterator<double> i(list);
        i.toBack();
        while (i.hasPrevious()) {
            if (i.previous() < 0.0)
                i.remove();
        }

    * setValue()函数用于修改该值, 同样是对刚刚跳过去的元素进行操作

        QMutableListIterator<double> i(list);
        while (i.hasNext()) {
            int val = i.next();
            if (val < 0.0)
                i.setValue(-val);
        }
