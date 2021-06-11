一些Qt函数返回一个容器 。如果想使用STL风格的迭代器遍历某个函数的返回值，则必须复制此容器
并且遍历这个副本。
例如，下面的代码给出了如何遍历由QSplitter::sizes()返回的QList<int>的正确方式：
QList<int> list = splitter->sizes();
QList<int>::const_iterator i = list.begin();
while(i != list.end()){
    do_something(*i);
    ++i;
}

下面是错误的代码
QList<int>::const_iterator i = splitter->sizes().begin();
while( i!= splitter->sizes.end()){
    do_something(*i);
    ++i;
}


