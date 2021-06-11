方法1；
{
    // set value to a key
    QVector<double> vect(3);
    vect[0] = 1.0;
    vect[1] = 0.540302;
    vect[2] = -0.416147;
}
方法2:
{
    // append a pair
    QVector<double> vect;
    vect.append(1.0);
    vect.append(0.540302);
    vect.append(-0.416147);
}
方法3:
{
    // or use the << operator
    vect << 1.0 << 0.540302 << -0.416147;
}

遍历:
{
    double sum = 0.0;
    for(int i=0; i<vect.size(); i++)
        sum += vect[i];
}


