class Movie 
{ 
public: 
        Movie(const QString &title = "", int duration = 0); 

        void setTitle(const QString &title) { myTitle = title; } 
        QString title() const { return myTitle; } 
        void setDuration(int duration) { myDuration = duration; } 
        QString duration() const { return myDuration; } 

private: 
        QString myTitle; 
        int myDuration; 
};

/*
1. 不需要任何参数的构造函数
2. 复制构造函数
3. 对于这个类逐项的复制足够，没有必要提供复制构造函数和赋值构造函数
*/