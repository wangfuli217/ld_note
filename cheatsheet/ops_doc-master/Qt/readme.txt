https://github.com/JesseTG/awesome-qt

https://qtguide.ustclug.org/contents.htm # 教程

https://github.com/insideqt/awesome-qt

https://github.com/qyvlik/CollectAwesomeQtQuickDemos

zhouzhiyang.github.io
https://zhuanlan.zhihu.com/p/69531976 # Qt进阶之路

https://github.com/aeagean Qt君
http://www.qter.org/portal.php?mod=list&catid=10 # qter
https://github.com/jxf2008/blog Qt自学笔记

https://github.com/AstrayWu/AstrayWu.github.io/blob/8f8c6585415cb2fe62f776453444706bfca720c9/source/_posts/Qt%E8%B5%84%E6%BA%90%E6%B1%87%E6%80%BB.md 
Qt资源汇总.md

    Linux 下常用的 GUI 库有基于 C++ 的 Qt、GTK+、wxWidgets，以及基于 Java 的 AWT 和 Swing。
其中最著名的就是 Qt 和 GTK+：KDE 桌面系统已经将 Qt 作为默认的 GUI 库，Gnome 桌面系统也将 GTK+ 作为默认的 GUI 库。


Qt设计器——可视化地设计视窗
Qt语言学家，lupdate和lrelease——翻译应用程序使之能够进入国际市场
Qt助手——快速地发现你所需要的帮助
qmake——由简单的宇平台无关的项目文件生成Makefile
qembed——转换数据，比如把图片转还为C++代码
qvfb——在桌面上运行和测试嵌入式应用程序
makeqpf——为嵌入式设备提供预先做好的字体
moc——元对象编译器
uic——用户界面编译器

采用纯代码方式实现 UI 界面是比较复杂的，代码设计的工作量大而繁琐。


https://blog.csdn.net/yjwx0018/article/category/6387355 C++ GUI Qt笔记

1. 我们通常只关注于C++的子类，
2. 通过Qt独创性的"信号和槽"机制、对统一字符编码标准的支持，以及foreach关键字，Qt也在多个方面扩展了C++。
3. Java的每一个源文件都必须严格包含一个类。
4. std:strtod(argv[0],0)
5. #include "square.h" 和 extern double square(double);
6. QApplication和QLabel。对于每个Qt类，都有一个与该类同名(且大写)的头文件，在这个头文件中包含了对该类的定义。
7. QApplication 用来管理整个应用程序所用到的资源。app(argc,argv) Qt支持它自己的一些命令行参数。
8. 按钮、菜单、滚动条和框架都是窗口部件。窗口部件可以包含其他窗口部件。 QMenuBar,QToolBar,QStatusBar和其他窗口部件属于另一个部件
9. 绝大多数应用程序都会将一个QMainWindow或者QDialog来作为自己的窗口
10. 在创建窗口部件的时候，标签通常都是隐藏的，这就允许我们可以先对其进行设置然后再显示他们，从而避免窗口部件的闪烁事件。
11. app.exec() 将应用程序的控制权传递给Qt。
qmake -project   # 生成hello.pro
qmake hello.pro  # Makefile
make             # hello
或者
qmake -tp vc hello.cpp # 通过Visual Stdio编译这个文件
12. "hello world" "<he><i>Hello</i><font color=red>Qt!</font></h2>" 通过一些简单的HTML可以轻松把Qt应用程序的用户接口变得更为丰富多彩
13. QObject::connect(button, SIGNAL(clicked()), &app, SLOT(quit()));
Qt的窗口部件通过发射信号来表明一个用户动作已经发生了或者是一个状态已经改变了。  clicked() 信号。信号可以与函数(slot)相关关联，
以便在发射信号时，槽可以得到自动执行。clicked()信号 -> 槽QApplication对象的quit() 槽连接起来。
14. QLabel 标签，QPushButton 按键 QWidget 应用程序主窗口 spinBox和slider 通过layout->addWidget(spinBox|slider);会"重新定义父对象"
15. QObject::connect(spinBox, SIGNAL(valueChanged(int)),
                     slider, SLOT(setValue(int)));
    QObject::connect(slider, SIGNAL(valueChanged(int)),
                     spinBox, SLOT(setValue(int)));
    spinBox->setValue(35);
QSpinBox 微调部件 QSlider 滑动控件。 spinBox-setValue(35) 只有当前值不是35的时候，才会发射信号。

1）滑块QSlider
   QSlider(水平/垂直,父窗口);
   //设置滑块滑动的范围
   void setRange(int min,int max);
   //滑块滑动时发送的信号，参数表示当前位置
   void valueChanged(int)[signal]
   //设置滑块的位置
   void setValue(int)[slots];
2）选值框QSpinBox
   QSpinBox(父窗口);
   //设置选值框数值变化范围
   void setRange(int min,int max);
   //选值框值改变信号，参数当前的数值
   void valueChanged(int)[signal]
   //设置框当前数值
void setValue(int)[slots];

14. 指定显示风格 ./age -style motif
    编译出来的可执行文件使用 -style 命令行参数可以修改默认的style
15. QHBoxLayout *layout = new QHBoxLayout; 布局管理器 QHBoxlayout QVBoxLayout QGridLayout 水平，垂直和表格
window->setLayout(layout); QWidget默认关联到QApplication，QHBoxLayout通过window->setLayout(layout);关联到QWidget; 而QSpinBox，QSlider
通过layout->addWidget(spinBox|slider); 关联到QHBoxLayout。QHBoxLayout有水平、垂直和表格三种类型。

                                   QObject
QCoreApplication   QWidget                                    QLayout
QAbstractButton    QAbstractSpinBox QAbstartctSlider QFrame   QBoxLayout
QPushButton        QSpinBox         QSlider          QLable   QHBoxLayout

    类中使用Q_OBJECT 宏表示该类可以要定义singnal和slot
16. Qdialog从QWidget类中派生出来。
17. void findNext(const QString &str, Qt::CaseSensitivity cs);
    void findPrevious(const QString &str, Qt::CaseSensitivity cs);
signals 部分声明了当用户点击Find按钮时对话框所发射的两个信号。 # signals 关键字实际上是一个宏
如果前想查询选项生效，对话框就发射findPrevious()信号，否则它就发射findNext()信号
Qt::CaseSensitivity Qt::CaseInsensitivity 大小写敏感；枚举类型
18.  void findClicked();
    void enableFindButton(const QString &text);
slots:为了实现这两个槽，几乎需要访问这个对话框的所有子窗口部件，所以也保留了指向他们的指针。 # slots和signals一样，也是宏
19. QtGui头文件中位构成QtCore和QtGui组成部分的所有类进行定义
    Qt由数个模块构成:QtCore, QtGui Qtnetwork QtOpenGL QtScript QtSql QtSvg和QtXml
  include文件QtGui可省略繁琐的include语句
  Qt最重要的模块为 QtCore, QtGui, QtNetwork, QtOpenGL, QtScript, QtSql, QtSvg, QtXml
  在比较大的程序中, 头文件中包含其他大的头文件, 不是合适的做法, 所以在头文件中不要include QtGui

    tr("Find &what:") 快捷键Alt+W # 创建一个带有快捷键的标签
20. tr() 函数调用是把他们翻译成其他语言的标记。
21. "Find &what" 符号'&'表示快捷键
     label->setBuddy(lineEdit);  # 设置接收快捷键焦点的伙伴
当用户按下Alt+W时，焦点就会移动到这个行编辑器(该标签的伙伴上)上。
  tr函数可以用于转换该字符串至其他语言, 需要声明 Q_OBJECT 宏
  &符号可以用于设置快捷键, 而buddy的功用就是当label获得焦点, 其buddy也就获得了焦点.
22.  findButton->setDefault(true); //默认按钮
    findButton->setEnabled(false);//禁用按钮
    default按钮用于当用户按下回车键时等同于按下该按钮.
setDefault(true), 让find按钮成为对话框的默认按钮。# 默认按钮就是当用户按下Enter键时能按下对应的按钮。
setEnabled(false), 当禁用一个窗口部件时，它通常会显示为灰色，并且不能和用户发生交互操作。
23. connect(lineEdit,    SIGNAL(textChanged(const QString &)), this, SLOT(enableFindButton(const QString &)));
    connect(findButton,  SIGNAL(clicked()),                    this, SLOT(findClicked()));
    connect(closeButton, SIGNAL(clicked()),                    this, SLOT(close()));
enableFindButton(const QString &) 私有槽
由于QObject是FindDialog的父对象之一，所有可以省略connect()函数前面的QObject::
24. setLayout(mainLayout); 将mainLayout安装在FindDialog中并且由其负责对话框的整个区域。
25. rightLayout->addStretch(); # 添加弹簧(伸展器) 用它来占据Find按钮和Close按钮所余下的空白区域。
    addStretch 就像在该处增加了弹簧一样的空白
26. setWindowTitle(tr("Find")); # 设置了显示在对话框标题栏上的标题的内容，
    setFixedHeight(sizeHint().height()); # 让窗口具有一个固定的高度。
    sizeHint() 返回可以返回一个窗口部件所"理想"的尺寸大小。
27. emit findPrevious(text, cs);
emit findNext(text, cs);
emit是Qt中的关键字，像其他At扩展一样，它也会被C++预处理器转换成标准的C++代码。
28. QWinget::setTabOrder() 函数实现Tab键遍历部件
    QWidget::setTabOrder() 设置tab 次序
29. 信号和槽机制是Qt编程的基础，可以让应用程序编程人员把这些互不了解的对象绑定在一起。
槽和普通的C++成员函数几乎是一样的 --- 可以是虚函数；可以被重载；可以是公有的、保护的或私有的，并且
也可以被其他C++成员函数直接调用；还有，它们的参数可以是任意类型。唯一不同的是：槽还可以和信号连接在一起，
着这种情况下，每当发射这个信号的时候，就会自动调用这个槽。
connet(sender, SIGNAL(signal), receiver, SLOT(slot));
senber 和 receiver 是指向QObject的指针，
signal 和 slot     是不带参数的函数名。
实际上SIGNAL()和SLOT()宏会把它们的参数转换成响应的字符串。
29.1 一个信号可以连接多个槽 # 在发射这个信号的时候，会以不确定的顺序一个接一个的调用这些槽
connect(slider, SIGNAL(valueChanged(int)), spinBox, SLOT(setValue(int)));
connect(slider, SIGNAL(valueChanged(int)), this, SLOT(updateStatusBarIndicator(int)));
29.2 多个信号可以连接同一个槽 # 无论发射那个信号都会调用这个槽
connect(lcd, SINGAL(overflow()), this, SLOT(handleMathError()));
connect(calculator, SIGNAL(divisionByZero()), this, SLOT(handleMathError()));
29.3 一个信号可以另一个信号相连接
connect(lineEdit, SIGNAL(textChanged(const QString&)), this, SIGNAL(updateRecord(const QString&)));
当发射第一个信号时，也会发射第二个信号。除此之外，信号和信号之间的连接和信号与槽之间的连接是难以区分的。
29.4 连接可以被删除
disconnect(lcd, SINGAL(overflow()), this, SLOT(handleMathError()));
当删除对象时，Qt会自动移除和这个对象相关的所有连接。
要把信号成功连接到槽(或者连接到另一个信号)，它们的参数 必须具有相同的顺序和相同的类型；
connect(ftp, SIGNAL(rawCommandReply(int, const QString &)), this, SLOT(processReply(int, const QString&)))
例外: 如果信号的参数比它所连接的槽的参数多，那么多余的参数将会被简单的忽略掉:
connect(ftp,SIGNAL(rawCommandReply(int, const QString&)), this, SLOT(checkErrorCode(int)));
如果参数类型不匹配，或者如果信号或槽不存在，则当应用程序使用调试模式构建后，Qt会在运行时发出警告。
与之相类似，如果在信号和槽的名字中包含了参数名，Qt也会发出警告。

30 Qt设计师
1. 创建并初始化子窗口部件。
2. 把子窗口部件放到布局中
3. 设置Tab顺序
4. 建立信号 -- 槽之间的连接
5. 实现对话框中的自定义槽。

qmake -project
qmake gotocell.pro
uic gotocelldialog.ui -o ui_gotocelldialog.h
1. OK按钮总是失败的，
2. Cancel按钮什么也不做
3. 行编辑器可以接受任何文本，而不是只能接受有效的单元格位置坐标。
# 通过简单地增加另外一个间接层就可以解决软件的任何问题。
命名惯例是:将该类与uic所生成的类具有相同的名字，只是没有Ui::前缀而已
   uic gotocelldialog.ui -o ui_gotocelldialog.h
gotocelldialog.ui -> ui_gotocelldialog.h (setupUi() 函数用以初始化控件和窗体)

gotocelldialog.h | gotocelldialog.cpp 继承-> ui_gotocelldialog.h
在实现类gotocelldialog.cpp中实现连接和槽位功能。数据校验和数据处理。
在构造函数中调用 setupUi(this);初始化窗体，注册信号和槽关联关系。

class GoToCellDialog : public QDialog, public Ui::GoToCellDialog
GoToCellDialog继承了QDialog和Ui::GoToCellDialog两个类的信息。这里使用了双继承。

31. QRegExp regExp("[A-Za-z][1-9][0-9]{0,2}");
    lineEdit->setValidator(new QRegExpValidator(regExp, this)); # 通过将this传递给QRegExpValidator,就不用在关心new对象的删除问题
用以实现对QLineEdit中的数据进行有效性验证。
QRegExpValidator,QIntValidator,QDoubleValidator Qt提供了三个内置检验器

QLineEdit::hasAcceptableInput()根据我们在构造函数中设置的许可器返回bool值。
okButton->setEnabled(lineEdit->hasAcceptableInput());


32. connect(okButton, SIGNAL(clicked()), this, SLOT(accept()));
    connect(cancelButton, SIGNAL(clicked()), this, SLOT(reject()));
accept() 可以将对话框返回的结果变量设置为QDialog::Accept(其值等于1)，而rject()槽会把对话框的值设置为QDialog::Rejected(其值等于0)。
当使用这个对话框的时候，可以利用这个结果变量判断用于是否点击了OK按钮，从而执行相应的动作。


33. 改变形状的对话框
33.1 扩展对话框 extension dialog  同时满足普通用户和高级用户需要的应用程序(默认隐藏高级功能)
layout()->setSizeConstraint(QLayout::SetFixedSize); 这样会使用户不能再重新修改这个对话框窗体的大小。
这样一来，布局就会负责对话框重新定义大小的职责，并且也会在显示或隐藏子窗口部件的时候自动重新定义
这个对话框的大小，从而可以确保对话框总是能以最佳的大小尺寸显示出来。
setColumnRange('A', 'Z');  槽根据电子制表软件中选择的列初始化了这些组合框的内容。在(可选的)第二键和第三键的组合框中插入一个None选项。

33.2 对也对话框 multi-page dialog 
1. QTabWidget的用法就像自己的名字一样。它提供了一个可以控制内置QStackedWidge的Tab栏
2. QListWidget和QStackedWidget可以一起使用，将QListWidget::currentRowChanged()信号与QStackedWidget::setCurrentIndex()
槽连接，然后再利用QListWidget的当前项就可以确定应该显示QStackedWidget中的那一页。
3. 与上述QListWidget的用法相似，也可以将QTreeWidget和QStackedWidget一起使用。

34. 动态对话框
动态对话框就是在程序运行时使用的从Qt设计师的.ui文件创建而来的哪些对话框。动态对话框不需要通过uic把.ui文件转换成C++代码
相反，它是在程序运行的时候使用QUiLoader类载入该文件的，就像下面这种方式:
QUiLoader uiloader;
QFile file("sortdialog.ui");
QWidget *sortDianlog = uiLoader.load(&file);
if(sortDialog){
...//TODO
}
可以使用QObjet::findChild<T>()来访问这个窗体中的各个子窗体部件
QComboBox *primaryColumnCombo = sortDialog->findChild<QComboBox*>("primaryColumnCombo");
if(primaryColumnCombo){
...// TODO
}
CONFIG +=uitools
第三章:QMenuBar QToolBar QStatusBar
第六章:QSplitter QScrollArea
按钮  : QPushButton QToolButton QCheckBox QRadioButton
容器  : QGroupBox QFrame
多页窗口:QTabWidget QToolBox
试图窗口:QListView QTreeView QListView(图标) QTableView
富文本引擎: 支持字体规范 文本对齐 列表 表格 图片和超文本链接 QLabel QLabel(图片) QLCDNumber QProgressBar QTextBrower
用户输入: QLineEdit可以使用一个输出掩码，一个检验器或者同时使用两者对它的输入进行限定。
          QTextEdit(QAbstractScrollArea的子类)具有处理大量文本的能力。可以用于编辑普通文本和富文本
          QSpinBox QDoubleSpinBox QComboBox QDataEdit QTimeEdit QDataTimeEdit QScrollBar QSlider QTextEdit QDial
消息框: QProcessDialog 可以记住所有显示的信息内容和错误对话框
        QProgressBar   来对哪些非常耗时的操作进度进行指示
        QInputDialog   当用户只需要输入一行文本或者一个数字的时候
通用对话框: QColorDialog QFontDialog QPageSetupDialog QFileDialog QPrintDialog
            Qt Solutions QFontComboBox 
向导对话框: QWizard

35. private slots:
bool save();
bool saveAs();
void find();
除了save和saveAs槽返回一个bool值外，绝大多数的槽都把void作为它们的返回值。当槽作为一个信号的响应
函数而被执行时，就会忽略这个返回值；但是当把槽作为函数来调用时，其返回值对我们的作用就和调用
任何一个普通C++函数时的作用是相同的。

36. icon 支持 png bmp gif jpeg png pnm svg tiff xbm xpm 等多种格式
为应用程序提供图片的方法有很多种，下面是最常用的方法:
1. 把图片保存到文件中，并且在运行时载入它们。
2. 把xpm文件包含在源代码中。这一方法之所以可行，是因为xpm文件也是有效的C++文件
3. 使用Qt的资源机制。
                                  创建资源文件
RESOURCES += spreadsheet.qrc      加载资源文件
资源文件自身使用了一种简单的XML文件格式。
QIcon(":/images/icon.png")        引用资源文件

------- QAction -------
37. QAction
Qt通过"动作"的概念简化了有关菜单和工具栏的编程。一个动作就是一个可以添加到任意数量的菜单和工具栏上的项。
在Qt中，创建菜单和工具栏包括如下步骤：
1. 创建并设置动作
2. 创建菜单并且把动作添加到菜单上
3. 创建工具栏并且把动作添加到工具栏上。
    newAction = new QAction(tr("&New"), this);                      一个加速键和一个父对象(主窗口)
    newAction->setIcon(QIcon(":/images/new.png"));                  一个图标
    newAction->setShortcut(QKeySequence::New);                      一个快捷键 # QKeySequence::StandardKey 枚举值，确保Qt提供跨平台快捷键
    newAction->setStatusTip(tr("Create a new spreadsheet file"));   一个状态提示
    connect(newAction, SIGNAL(triggered()), this, SLOT(newFile())); 把动作的triggered()信号连接到主窗口的私有槽 newFile()

38. 最近打开文件
    for (int i = 0; i < MaxRecentFiles; ++i) {
        recentFileActions[i] = new QAction(this);
        recentFileActions[i]->setVisible(false);
        connect(recentFileActions[i], SIGNAL(triggered()), 为recentFileAction[]数组添加动作。每个动作都是隐式的，并且被连接到
                this, SLOT(openRecentFile()));             openRecentFile()槽
    }
39. 没有用于终止应用程序的标准化键序列，所以需要在这里明确指定键序列。
    exitAction = new QAction(tr("E&xit"), this);
    exitAction->setShortcut(tr("Ctrl+Q"));                 自定义键序列
    exitAction->setStatusTip(tr("Exit the application"));
    connect(exitAction, SIGNAL(triggered()), this, SLOT(close()));
    
40. 由于槽selectAll()是由QTableWidget的父类之一的AbstractItemView提供的，所有就没有必要再去亲自实现它。
    selectAllAction = new QAction(tr("&All"), this);
    selectAllAction->setShortcut(QKeySequence::SelectAll);
    selectAllAction->setStatusTip(tr("Select all the cells in the "
                                     "spreadsheet"));
    connect(selectAllAction, SIGNAL(triggered()),
            spreadsheet, SLOT(selectAll()));
    
41. 复选动作: 复选动作在菜单中显示时会带一个复选标记，并且在工具栏中它可以实现成切换按钮。
当启用这个动作时，Spreadsheet组件就会显示一个网格。
    showGridAction = new QAction(tr("&Show Grid"), this);
    showGridAction->setCheckable(true);
    showGridAction->setChecked(spreadsheet->showGrid());
    showGridAction->setStatusTip(tr("Show or hide the spreadsheet's "
                                    "grid"));
    connect(showGridAction, SIGNAL(toggled(bool)),
            spreadsheet, SLOT(setShowGrid(bool)));  # setShowGrid(bool) 继承自QTableWidget

42. Auto-Recalculate 自动重新计算
    autoRecalcAction = new QAction(tr("&Auto-Recalculate"), this);
    autoRecalcAction->setCheckable(true);
    autoRecalcAction->setChecked(spreadsheet->autoRecalculate());
    autoRecalcAction->setStatusTip(tr("Switch auto-recalculation on or "
                                      "off"));
    connect(autoRecalcAction, SIGNAL(toggled(bool)),
            spreadsheet, SLOT(setAutoRecalculate(bool)));
通过QActionGroup类的支持，Qt也可以支持相互排斥的动作。

43. About
    aboutAction = new QAction(tr("&About"), this);
    aboutAction->setStatusTip(tr("Show the application's About box"));
    connect(aboutAction, SIGNAL(triggered()), this, SLOT(about()));

    aboutQtAction = new QAction(tr("About &Qt"), this);
    aboutQtAction->setStatusTip(tr("Show the Qt library's About box"));
    connect(aboutQtAction, SIGNAL(triggered()), qApp, SLOT(aboutQt()));  访问qApp全局变量，可以使用QApplication对象的aboutQt()


------- QMenu -------   



------- QObject -------   
const QObject * QObject::sender () [保护]
如果在任何函数调用或信号发射之前在槽中调用的话，返回发送消息的对象的指针。在所有其它情况下，返回未定义的值。
QString objectName () const
void    setObjectName ( const QString & name )

objectName : pushButtonAnderson | pushButtonBruce | pushButtonCastiel

moc hellowidget.h -o moc_hellowidget.cpp
qmake -project "QT+=widgets" 
debug 和 release 两个文件夹，以及 Makefile、Makefile.Debug 和 Makefile.Release 三个文件。
Makefile 是总的生成脚本文件，
Makefile.Debug 用于生成可调试的目标程序，
Makefile.Release 用于生成优化发行版的目标程序，
总的脚本 Makefile 会根据不同的 make 命令生成相应的调试版或优化发行版程序。

mingw32-make
mingw32-make all
mingw32-make debug
mingw32-make release
 

aa. 所有的 Qt 类里面都有 tr 函数(因为 tr 函数在所有 Qt 类的顶级基类 QObject 里定义了)
    tr 函数是代表可翻译字符串的意思，因为 Qt 不仅跨平台，也是跨国跨语种的，所以很注重多国语言的支持， 
只要不是特殊情况，一般都用 tr 函数封装字符串，以后如果做多国语言翻译就会很方便。
bb. 其实任何一个图形控件都可以作为主界面显示
cc. 图形程序与命令行程序一个最大的不同就是图形程序通常不会自动关闭，而是一直等待用户操作， 所以图形程序与用户的交互性都很强。
g++  helloqt.cpp  -I"C:\Qt\Qt5.4.0\5.4\mingw491_32\include"  -L"C:\Qt\Qt5.4.0\5.4\mingw491_32\lib" -lQt5Core -lQt5Gui -lQt5Widgets  -o helloqt
  -I"C:\Qt\Qt5.4.0\5.4\mingw491_32\include" 是指加入包含文件的路径(-I是大写的i，即IncludePath首字母)include 文件夹就是 Qt 库的头文件位置
  -L"C:\Qt\Qt5.4.0\5.4\mingw491_32\lib" 则指定了链接时需要的 Qt 库文件所在位置(-L 是 LibraryPath 首字母)
  -lQt5Core 是指链接到 libQt5Core.a 库文件(-l 是 link 链接的首字母， 目标程序链接 libQt5Core.a 库文件后运行时需要 Qt5Core.dll)
  -lQt5Gui 是指链接到 libQt5Gui.a(运行时对应 Qt5Gui.dll)，这是负责 Qt 程序底层绘制图形界面的库
  -lQt5Widgets 是指链接到 libQt5Widgets.a(运行时对应 Qt5Widgets.dll)，是包含几乎所有 Qt 图形控件和窗口的库
  -o helloqt 是指生成的目标程序名字为 helloqt(默认扩展名 .exe)
  
g++ helloqt.cpp -std=c++0x -I"C:\Qt\Qt5.7.0\5.7\mingw53_32\include" -L"C:\Qt\Qt5.7.0\5.7\mingw53_32\lib" -lQt5Core -lQt5Gui -lQt5Widgets -o hellqt
  对于新的 Qt 5.7.0 以上版本，都必须使用 C++11 选项来编译，g++的C++11选项是 -std=c++0x
    如果需要在 QtCreator 项目文件 *.pro 里面开启 C++11 支持，添加下面一行到 *.pro 文件中：
CONFIG += c++11

  
a. QFile 是基本的文本读写，可以读写文本或二进制数据文件
   QTextStream 专门处理各种字符编码的文本文件，并会自动处理本地化编码
   QDataStream 用于对 Qt 涉及的数据类型进行串行化打包
   目录浏览类 QDir 和文件信息类 QFileInfo
b. Unix/Linux 系统的文件路径分隔符是 '/' ，而 Windows 系统的文件路径分隔符是 '\' 。
   对于 Qt 而言，内部路径字符串统一用 Unix/Linux 系统风格，都是 '/' ，所以 Qt 程序代码里面建议都用 '/' 作为文件路径分隔符，
Qt 在不同的操作系统里面自动会把 '/' 换成本地化的文件路径分隔符来访问本地文件系统，而不需要程序员操心。
c. 
对比项       | Windows                      | Unix/Linux                 | Qt类或函数
路径分隔符   | '\'                          | '/'                        | QDir::​separator() 获取该分隔符
文件系统根   | 多个根，C:\，D:\ 等等        | 唯一的 /                   | QDir::​drives() 枚举文件系统根
目录操作     | 命令行 cd 切换目录，dir 枚举 |命令行 cd 切换目录，ls 枚举 | QDir 负责切换目录，枚举文件夹和文件
文件信息     | 命令行 dir 文件名            | 命令行 ls 文件名           | QFileInfo 负责查询单个文件夹或文件详细信息
磁盘逻辑分区 | NTFS、FAT32                  | Ext3、Ext4、BTRFS等        | QStorageInfo 可以查询分区的信息



//Qt 的顺序容器类有 QList、QLinkedList、QVector、QStack 和 QQueue。
//Qt 还提供关联容器类 QMap、QMultiMap、QHash、QMultiHash 和 QSet。
//QMultiMap 和 QMultiHash 支持一个键关联多个值，QHash 和 QMultiHash 类使用散列函数进行查找，查找速度更快。
//迭代器为访问容器类里的数据项提供了统一的方法，Qt 有两种迭代器类：Java 类型的迭代器和 STL 类型的迭代器。
//两者比较，Java 类型的迭代器更易于使用，且提供一些高级功能，而 STL 类型的迭代器效率更高。

表 1 Java类型的迭代器类
容器类                         只读迭代器                       读写迭代器
QList<T>, QQueue<T>         QListItcrator<T>                QMutableListItcrator<T>
QLinkedList<T>              QLinkedListIterator<T>          QMutableLinkedListIterator<T>
QVector<T>, QStack<T>       QVectorllcrator<T>              QMutableVectorIterator<T>
QSet<T>	QSetItcrator<T>     QMutableSetItcrator<T>
QMap<Key, T>, QMultiMap<Key, T>     QMapIterator<Key, T>	QMutableMapIterator<Key, T>
QHash<Key, T>, QMultiHash<Key, T>   QHashIterator<Key, T>	QMutablcHashlterator<Key, T>

表 4 STL 类型的迭代器类
容器类                         只读迭代器                               读写迭代器
QList<T>, QQueue<T>         QList<T>::const iterator                QList<T>::iterator
QLinkedList<T>              QLinkedList<1>: :const_iterator         QLinkedList<T>::iterator
QVector<T>, QStack<T>       QVector<T>::const_ilerator              QVector<T>::iterator
QSet<T>                     QSet<T>::const_iterator                 QSet<T>::iterator
QMap<Key, P> QMultiMap<Kcy, T>      QMap<Key, T>::const_iterator	QMap<Key, T>:: iterator
QHash<Key, T> QMultiHash<Key, T>	QHash<Key, T>: :const_iterator	QHash<Key, T>::iterator

//Qt 提供一个关键字 foreach (实际是 <QtGlobal> 里定义的一个宏）用于方便地访问容器里所有数据项



https://www.linux-apps.com/
https://zhuanlan.zhihu.com/p/52157955


https://github.com/xtuer/app-template/tree/master/template-qt template