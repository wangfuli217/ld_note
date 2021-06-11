= Chapter 1: Getting Started =
== 1.1 Hello Qt ==
* 命令行创建
{{{
// 创建了proj文件
qmake -project
// 创建makefile
qmake hello.pro
// 创建vs版本
qmake -tp vc hello.pro
}}}
* QLabel 文本可以使用HTML代码
== 1.2 Making Connection ==
* QPushButton
* QApplication::quit()
== 1.3 Laying Out Widgets ==
* 控件: QWidget, QSpinBox, QSlider
* 编译出来的可执行文件使用 -style 命令行参数可以修改默认的style
* layout还可以自动设置其内的组件为该layout所在组件的子组件.
== 1.4 Using the Reference Documention ==

= Chapter 2: Creating Dialogs =
== 2.1 Subclassing QDialog ==
* 对话框程序一般用于设置程序的选项和选择.
* 类中使用Q_OBJECT 宏表示该类可以要定义singnal和slot
* Qt::CaseSensitivity 为枚举类型, 可取值Qt::CaseSensitive 和  Qt::CaseInsensitive
* 控件: QCheckBox
* 使用前向声明速度可能更快
* include文件QtGui可省略繁琐的include语句
* Qt最重要的模块为 QtCore, QtGui, QtNetwork, QtOpenGL, QtScript, QtSql, QtSvg, QtXml
* 在比较大的程序中, 头文件中包含其他大的头文件, 不是合适的做法, 所以在头文件中不要include QtGui
* tr函数可以用于转换该字符串至其他语言, 需要声明 Q_OBJECT 宏
* &符号可以用于设置快捷键, 而buddy的功用就是当label获得焦点, 其buddy也就获得了焦点.
* default按钮用于当用户按下回车键时等同于按下该按钮.
* QLineEdit 的 textChanged 信号
* addStretch 就像在该处增加了弹簧一样的空白
* layout可以自动设置组件的父子关系
* QWidget::sizeHint() 可以返回组件"理想的"大小
* Qt 使用 meta-object 编译器来编译 meta-object 系统
* QWidget::setTabOrder() 设置tab 次序
== 2.2 Signals and Slots in Depth ==
* slot和普通的C++成员函数相同, 可以是虚拟的, 可以被重载, 可以为公有, 保护或者私有函数. 可以直接调用该函数. 参数可以为任何类型. 唯一不同的就是当信号发出的时候就会自动调用该slot函数
* signal和slot
    - 一个signal可以连接多个slot
    - 多个signal可以连接一个slot
    - 一个signal可以连接另一个signal
    - 连接可以被移除
	- signal和slot必须含有相同的参数和次序. 如果signal的参数多于slot的参数数, 多余的参数则会抛弃.
    - 在connect中, 参数不要写出名称, 只需写出类型即可.
    - signal和slot在QObject中实现, 不仅仅局限于GUI程序. 可以为任意QObject派生类所使用.
* Qt的Meta-Object系统: 可以捆绑两个独立的软件组件, 且组件之间无需互相了解
    - 该系统提供了两个关键服务: signals-slots 和 introspection(反省)
    - introspection功能是实现signals-slots的必要部分, 同时允许应用程序员在运行时期得到关于QObject派生类的"meta-information", 该信息包含该对象支持的signals和slots列表以及类名称.
    - 该机制支持属性(Designer扩展的)和文本翻译(国际化), 并且为QtScript模块的基础, 可动态添加属性.
    - Qt通过工具moc来实现meta-object系统.
    - 该机制的作用如下:
        # Q_OBJECT宏声明了一些每个QObject派生类必须实现的introspection函数: metaObject(), tr(), qt_metacall(),以及其他
        # moc工具生成Q_OBJECT所声明函数和所有信号的实现代码
        # QObject中如connect和disconncet这样的成员函数使用这些introspection函数来完成它们的工作.
* 注意循环connect导致的无限循环问题
== 2.3 Rapid Dialog Design ==
* 创建对话框的基本步骤:
    # 创建和初始化子widget
    # 将子widget放入layout中
    # 设置tab次序
    # 建立signal-slot连接
    # 实现对话框自定义slot
* Designer在设计过程中, 如果设计完layout之后, 可使用Form/Adjust Size来重置大小.
* Designer设计的form使用setupUi()函数调用一个QWidget对象来安装该form.
* 从QDialog和Designer设计的类派生新类来实现额外的功能
* 在setupUi函数安装了ui form之后, 其会自动根据命名惯例将slot on_objectName_signalName()连接至对应的ObjectName的signalName信号上.
* 可以使用 validator 限制输入的范围.
* Qt提供了三个内置的validator: QIntValidator, QDoubleValidator, 和 QRegExpValidator
* slot accept()函数将dialog的返回值设置为QDialog::Accepted()(等于1). reject则设置返回值为QDialog::Rejected()(等于0)
* QLineEdit::hasAcceptableInput()  用验证器验证输入内容是否符合validator的要求
* QDialogButtonBox 可以指定按钮并根据操作系统正确地显示出来, 在Designer中则是将Button Box添加至Form上. 有成员函数 button() 和信号 accepted(), rejected()
== 2.4 Shape-Changing Dialog ==
* 最常用的变形对话框为扩展对话框和多页面对话框.
* 按钮的 checkable 属性
* Designer中, 组合框右键菜单的编辑条目菜单.
* 代码技巧: 类似的widget由于内容不同其大小有可能不同, 如需设置相同大小可用如下代码:
{{{c++
primaryColumnCombo->setMinimumSize(secondaryColumnCombo->sizeHint());
// secondaryColumnCombo的内容为None, 比PrimaryColumnCombo的内容要多, 所以重新设置
}}}
* 用户不能改变大小: QLayout::setSizeConstraint(QLayout::SetFixedSize);
* 多页面对话框
    - QTabWidget --- 提供tab bar控制其内置的QStackedWidget
    - QListWidget 和 QStackedWidget 配合使用, QListWidget的当前条目显示哪个QStackedWidget显示
        - QListWidget::currentRowChanged() 信号连至 QStackedWidget::setCurrentIndex() 槽
    - QTreeWidget 和 QStackedWidget 类似QListWidget
== 2.5 Dynamic Dialog ==
* 动态对话框
    - 是指用Qt Designer创建的.ui文件在运行期间创建的对话框
    - 我们可以在运行期间使用QUiLoader类加载ui文件
{{{c++        
QUiLoader uiLoader;
QFile file("sortdialog.ui");
QWidget *sortDialog = uiLoader.load(&file);
if (sortDialog) {
	...
}
}}}
	* 我们可以使用QObject::findChild<T>()访问该form的子widget
{{{c++
QComboBox *primaryColumnCombo =
	sortDialog->findChild<QComboBox *>("primaryColumnCombo");
if (primaryColumnCombo) {
	...
}
}}}
	* QUiLoader 位于特定的库里, 需要增加配置: CONFIG += uitools
== 2.6 Built-in Widget and Dialog Classes ==
* 内置的widget和对话框类
    - 按钮: QPushButton, QToolButton, QCheckBox, QRadioButton
    - 单页容器: QGroupBox, QFrame
    - 多页容器: QTabWidget, QToolBox
    - 条目视图: QListView, QTreeView, QTableView
    - 显示: QLabel, QLCDNumber, QProgress, QTextBrowser
    - 输入: QSpinBox, QDoubleSpinBox, QComboBox, QDateEdit, QTimeEdit, QDateTimeEdit, QScrollBar, QSlider, QTextEdit, QLineEdit, QDial
    - 反馈对话框: QInputDialog, QProgressDialog, QMessageBox, QErrorMessage
    - 颜色和字体对话框: QColorDialog, QFontDialog
    - 文件和打印对话框: QPageSetupDialog, QFileDialog, QPrintDialog
    - Qt的QWizard对话框
* QTabWidget可以设置其tab的形状和位置.
* 滚动条的机制在QAbstractScrollArea中实现, 这个类是条目视图和其他可滚动widget的基类
* Qt提供富文本(rich text), 支持编辑带格式的文本
* QLabel用于显示纯文本, HTML, 图像
* QTextBrowser为只读QTextEdit的子类, 可显示带格式的文本, 相对于QLabel, 可以用于显示大量的文本内容, 提供滚动条, 键盘和鼠标可以控制浏览.
* QLineEditor支持输入mask和validator, QTextEditor为QAbstractScrollArea的派生类, 可以输入大量的文本. 可以设置输入纯文本还是富文本(rich text), 两者都集成了剪贴板.
* Qt提供了消息框和错误对话框. QProgressDialog 或者 QProgressBar 显示时间进度. QInputDialog 用于输入单行信息.
* 设置颜色, 字体, 文件或者打印的标准通用对话框集合. 颜色选择可使用Qt的颜色选择widget, 字体也有内置的QFontComboBox
* QWizard提供了创建wizerd的框架.
* Qt Solutions提供了额外的widget. 包括颜色选择器, thumbwheel control, pie menus, property browser, 复制对话框.

= Chapter 3 Creating Main Windows =
== 3.1 Subclassing QMainWindow(从QMainWindow 派生类) ==
* Qt Designer的在线手册中的"Create Main Windows in Qt Designer"章节.
* QMainWindow 类
* closeEvent是QWidget的虚函数, 当关闭窗口时自动调用, 在派生类中可以重新实现该函数.
* 一个信号引发的slot函数, 该信号会忽略该slot的返回值.
* 设置主窗口的中心widget
* Qt支持的图像文件格式: BMP, GIF, JPEG, PNG, PNM, SVG, TIFF, XBM, XPM
* QWidget::setWindowIcon() 设置窗口图标.
* 设定平台专有的应用程序图标可见文档的 appicon.html
* Qt 应用程序使用图像的方法:
	* 保存图像至文件, 运行期间加载
	* 在源代码中包含XPM文件(XPM文件也是有效的C++文件)
	* 使用Qt资源机制
* Qt资源机制, 存储图像在一个子目录中的资源树中.
* 如果需要使用资源系统, 我们必须创建资源文件, 并在.pro文件中添加一行标识资源文件: RESOURCES = spreadsheet.qrc
* 资源文件仅仅是简单的XML格式
{{{
<RCC>
<qresource>
    <file>images/icon.png</file>
    ...
    <file>images/gotocell.png</file>
</qresource>
</RCC>
}}}
* 资源文件编译成应用程序的可执行文件, 所以它们不可能会丢失.
* 需要使用前缀 :/, 如 :/images/icon.png
    
== 3.2 Creating Menus and Toolbars ==
* 在Qt中创建菜单和工具条有以下三个步骤:
	# 创建和设置Action
	# 创建菜单, 且将actions放入其中.
	# 创建工具条, 且将actions放入其中.
* QAction的成员函数: setIcon, setShortcut, setStatusTip. 信号: triggered.
* 大多数窗口系统有标准的键盘快捷键用于特定的动作. 例如: New动作有一个快捷键 Ctrl+N. 可以通过 QAction::setShortcut 连接至合适的 QKeySequence::StandardKey 枚举值.
* QApplication对象的aboutQt()可以弹出官方的关于对话框.
* QMainWindow::menuBar () --- 第一次调用则创建一个菜单条
* QMenuBar::addMenu()创建一个Menu Widget, QMenu::addMenu() 可以添加子菜单, QMenuBar::addSeparator() 可以在菜单之间添加间隔
* widget增加右键菜单的方法:
	* 首先给需要的Widget调用函数addAction, 而后调用setContextMenuPolicy(Qt::ActionsContextMenu); 设置关联菜单
	* 是重载QWidget::contextMenuEvent函数, 创建一个QMenu对象, 在该对象中放置actions, 然后调用exec()实现
* QMainWindow::addToolBar() --- 增加工具条

== 3.3 Setting Up the Status Bar ==
* QMainWindow::statusBar() 函数得到其指针, 而后可用 QStatusBar()::addWidget() 给该状态栏添加内容, 这个函数第二个参数默认为0, 表示不拉伸. 设置为1, 则当窗口缩放之时, 该部分会延长缩小.
* 可以给 QLabel 添加缩进, QLabel::setIndent().

== 3.4 Implementing the File Menu ==
* QMessageBox::warning(), information(), question(), critical()
* QFileDialog::getOpenFileName() 打开文件对话框.  QFileDialog::getSaveFileName 保存文件对话框, QFileDialog::DontConfirmOverwrite作为参数可以使得其覆盖无需确认.
* QWidget的close() slot会调用closeEvent(), 重实现 QWidget::closeEvent() 就可以拦截该消息.
* 我们可以设置QApplication's quitOnLastWindowClosed 属性为假, 这样最后一个窗口关闭后, 程序仍可运行, 直至调用QApplication::quit()
* QFileInfo(fullFileName).fileName(); 得到文件名
* Qt列表容器的prepend()函数用于列表, 列表类的方法之一, 作用是插入列表的开头, removeAll() 移除某项的所有相同条目.
* QVariant类型可以保存许多C++和Qt类型的数据
* 在QAction中可以保存需要的数据在Data中, 使用setData()实现.
* QObject::sender() 该函数可以在slot中得到sender object的指针, 对于多个signal连接至一个slot时很有用. 
* 使用qobject_cast<T>()基于meta-information动态转换一个对象. 得到请求的QObject派生类对象的指针.

== 3.5 Using Dialogs ==
* 这里使用无模式对话框, 每次需要使用的时候, 调用其 show(), raise(), activeWindow() 函数.
* 使用show()显示对话框则该对话框为无模式对话框(除非在之前使用setModel()设置为模式对话框). 如果使用 exec() 显示对话框则该对话框为模式对话框.
* 模式对话框一般在栈中创建.
* QTableWidgetSelectionRange --- 存储表格选择区域的左上和右下所在行列
* 这里有关于如何处理sort对话框的三个方法
	# 在主窗口的sort()函数中, 创建sort对话框, 而后根据该对话框所选择的值设置比较对象, 而后使用该比较对象调用表格的排序函数, sort对话框只能用于一处.
	# 在主窗口的sort()函数中, 创建sort对话框, 在对话框内设置比较对象, 而后sort()函数可以获取该比较对象,  而后使用该比较对象调用表格的排序函数, 这样sort对话框可以用于多处.
	# 将sort对话框的指针发送给表格对象. 由表格对象直接处理.
* About对话框 --- QMessageBox::about(), 使用父窗口的图标.

== 3.6 Storing Settings ==
* QSettings在不同的平台中, 存储在不同的地方. Windows程序则存储在系统注册表里.
	* 其构造函数参数含组织名称和应用程序名称, 方便其查找和写入
    * QSettings 存储类 key-value对的设定, key类似文件系统路径, subkey则类似路径语法(如findDialog/matchCase)
    * 可使用beginGroup()和endGroup()
{{{c++
settings.beginGroup("findDialog");
settings.setValue("matchCase", caseCheckBox->isChecked());
settings.setValue("searchBackward", backwardCheckBox->isChecked());
settings.endGroup();        
}}}

    * QSetting的value则可以为int, bool, double, QString, QStringList, 或者任意QVariant支持的类型.
        
== 3.9 Multiple Documents ==
* 在main流程中使用new创建新窗口
* 修改程序为多文档程序
    * File|New: 使用new创建新窗口
    * File|Close: 关闭当前主窗口
    * File|Exit: 关闭所有窗口
* 给窗口设置属性Qt::WA_DeleteOnClose, 当关闭的时候删除该widget在内存中的资源, 节省内存. 
* 使用窗口类静态成员来设置所有窗口都共享的信息, 例如最近打开文件.
* foreach (QWidget *win, QApplication::topLevelWidgets());  // 可以用来遍历应用程序的所有窗口
    
== 3.10 Splash Screens ==
* QSplashScreen实现Splash Screen效果
* QSplashScreen在主窗口显示之前显示一张图像, 并在图像上写信息用来告知用户应用程序的初始化过程.
* splash代码一般位于main()函数中, 在调用QApplication::exec()之前
{{{c++
QSplashScreen *splash = new QSplashScreen;
splash->setPixmap(QPixmap(":/images/splash.png"));
splash->show();
Qt::Alignment topRight = Qt::AlignRight | Qt::AlignTop;
splash->showMessage(QObject::tr("Setting up the main window..."),
    topRight, Qt::white);
... ...
splash->showMessage(QObject::tr("Loading modules..."),
    topRight, Qt::white);
... ...
splash->showMessage(QObject::tr("Establishing connections..."),
    topRight, Qt::white);
... ...
splash->finish(&mainWin);
delete splash;
return app.exec();
}}}

= Chapter 4 Implementing Application Functionality =
== 4.1 The Central Widget ==
* QMainWindow的中心区域可以是任意类型的widget.
	# 使用标准的Qt Widget
	# 使用自定义widget
	# 使用带layout管理器的简单QWidget, 其内包含一些子widget
	# 使用splitter(分割器) --- QSplitter
	# 使用MDI区域 --- QMdiArea widget
* 本例使用QTabelWidget的派生类用于中间widget. QTableWidget支持了许多spreadsheet操作, 但不支持剪贴板操作, 不理解spreadsheet公式

== 4.2 Subclassing QTableWidget ==
* QTabelWidget为一有效的网格来显示两维稀疏数组. 随着用户的滚动显示需要的网格. 当用户输入内容时, 会自动创建一个QTabelWidgetItem保存文本.
	- 另外一个更多功能的table是 QicsTable, 见 http://www.ics.com/    
* QTabelWidgetItem 是一个纯数据类, Cell是其派生类.
* 一般而言, QTabelWidget在一空白单元格输入文本时, 会自动创建一QTabelWidgetItem来保存该文本. 这里使用QTableWidgetItem的派生类Cell来代替, 可以通过方法setItemPrototype来实现.
* setSelectionMode(ContiguousSelection); --- 矩形的选择内容
* setHorizontalHeaderItem(i, item); --- 设置第一行的头内容
* 最后生成的QTableWidget内有一些子Widget, 分别为两个QHeaderView, 两个QScrollBar, 中心为一个被称为viewport的特殊widget.  
* 将数据存储为条目的方式在QListWidget和QTreeWidget中也运用到, 操作为QListWidgetItems 和 QTreeWidgetItem
	- QTableWidgetItem则可以保存一些属性, 如字符串, 字体, 颜色和图标, 以及返回QTableWidget的指针. 也保存QVariant数据. 派生该item类可以提供额外的功能.
* QTableWidget::setItem 可以插入一个item.

== 4.3 Loading and Saving ==
* 使用QFile和QDataStream实现文件操作
{{{c++
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly)) {
        ... ...
    }
    QDataStream out(&file);
    out.setVersion(QDataStream::Qt_4_3);
    out << quint32(MagicNumber);
    
    QApplication::setOverrideCursor(Qt::WaitCursor);
    out << .......
    QApplication::restoreOverrideCursor();
}}}
* QApplication::setOverrideCursor和QApplication::restoreOverrideCursor可以设置其上的光标.
* 整数类型: qint8, quint8, qint16, quint16, qint32, quint32, qint64, quint64, 这些类型可以确保使用确定大小的数据类型.
* QDataStream确定了数据类型的精确二进制表达. 例如, quint16存储问big-endian次序的2个字节, QString则存储为一个字符串长度以及之后的Unicode字符.
* QDataStream 使用二进制近期的大多数版本, 可以明确指定QDataStream的版本, 解决读取的兼容问题
* QDataStream不仅可以用于QFile, 也可用于QBuffer, QProcess, QTopSocket, QUdpSocket, QSalSocket
* QTextStream可以用来读取写入文本文件
{{{c++
	// 读取
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly)) {
        QMessageBox::warning(this, tr("Spreadsheet"),
                             tr("Cannot read file %1:\n%2.")
                             .arg(file.fileName())
                             .arg(file.errorString()));
        return false;
    }

    QDataStream in(&file);
    in.setVersion(QDataStream::Qt_4_3);

    quint32 magic;
    in >> magic;
    if (magic != MagicNumber) {
        QMessageBox::warning(this, tr("Spreadsheet"),
                             tr("The file is not a Spreadsheet file."));
        return false;
    }

    clear();

    quint16 row;
    quint16 column;
    QString str;

    QApplication::setOverrideCursor(Qt::WaitCursor);
    while (!in.atEnd()) {
        in >> row >> column >> str;
        setFormula(row, column, str);
    }
    QApplication::restoreOverrideCursor();
    return true;
}}} 

== 4.3 Implementing the Edit Menu ==
* QApplication::clipboard() 可以访问系统剪贴板. QClipboard使用setText()和text()设置文本和读取文本.
* QTableWidgetSelectionRange 可以表示 QTableWidget的选择范围. 可以使用QTableWidget::selectedRanges()返回选择范围的一个列表.
* QTabwidget派生类的构造函数设置选择模式为 QAbstractItemView::ContiguousSelection, 这样不会有多个选择范围.
* QString::split将字符串切割成字符串列表.
* 删除QTableWidgetItem对象就可以清空该区域. QTableWidget::selectedRanges() 返回选择的item列表.
* QTableWidget的selectRow()和selectColumn()可以选择行和列.
* QApplication::beep()
    
== 4.5 Implementing the Other Menus ==
* Cell调用函数setDirty, 告知其需要重计算.当QTableWidget在下次调用该Cell的text()函数时, 其值会被重计算.
* QTableWidget::viewport()调用update()函数重绘, 其会调用每个Cell的text()方法获取值, 这样可以重计算所有Cell
* QTableWidget自QTableView继承了setShowGrid() slot.
* qStableSort() 函数算法, 可以排序一个StringList容器, 关键是要写好比较函数或仿函数. qStableSort比较的两个元素如果相等, 则依然保持他们排序前的次序.
    
== 4.6 Subclassing QTableWidgetItema ==
* QTableWidgetItem 派生类不能使用 Q_OBJECT, 因为其不从QObject派生. 不需要在派生类构造函数中设置父容器, 因为 QTableWidget调用setItem()方法插入一个item时, 自动设置为其父容器.
* QTableWidgetItem可以保存数据, 最常使用的role有两个, 一个是编辑的role, 一个是显示的role, 大部分时候相同.
* 当QTableWidget需要创建一个新的item时, 其调用setItemPrototype()方法, 该方法的参数则为item的clone方法所创建的实例.
* QTableWidget的data和setData方法
* QTableWidgetItem有方法text(), 等同于 data(Qt::DisplayRole).toString().
* 可以在QTableWidgetItem的data()方法中设置对齐.(Qt::TextAlignmentRole)
* QVariant使用缺省构造函数构造的对象是一个"invalid" variant.
* 这里设置 cachedValue 和 cacheIsDirty为 mutable 成员变量, 是因为可以在value()函数中改变这两个值, 而value函数则在data()中被调用, 而data()是一个常量函数.
* value() 函数
	- 如果有 单引号"'", 则表示为字符串
	- 如有"=", 则计算
	- 否则直接转换为double
	- 如果都不是就直接输出字符串
* 略过 evalExpression()以及两个辅助函数 evalTerm() 和 evalFactor().
    
= Chapter 5: Creating Custom Widgets =
* 创建自定义widget的方法: 现有Qt Widget派生或者直接从QWidget派生生成, 或者整合自定义widget和Qt Designer, 使得其看起来像是内置 widget.
== 5.1 Customizing Qt Widgets ==
* 本章节例子: 让SpinBox实现十六进制数的显示和使用
	* 类HexSpinBox继承自类QSpinBox, 构造函数, 重写基类函数validate, valueFromText, textFromValue, 增加私有成员QRegExpValidator *validator;
* 输入文本的验证
	- 可能的三个返回值: Invalid, Intermediate, Acceptable
{{{c++
    QValidator::State HexSpinBox::validate(QString &text, int &pos) const
    {
        return validator->validate(text, pos);
    }
}}}
    - QSpinBox在用户按下spin box的向上和向下箭头时, 调用下面的函数更新
{{{c++
    QString HexSpinBox::textFromValue(int value) const
    {
        return QString::number(value, 16).toUpper();
    }
}}}
    - 当用户在编辑区输入一个值并回车的时候, 调用下面的函数. 执行字符串到值的转换
{{{c++
    int HexSpinBox::valueFromText(const QString &text) const
    {
        bool ok;
        return text.toInt(&ok, 16);
    }
}}}
* 实现自定义widget的步骤
	# 选择合适的Qt Widget
	# 派生类
	# 重写部分虚函数改变其行为.
* 如果我们仅仅想改变一个widget的外观, 我们可以应用一个style sheet或者实现一个自定义style, 而不是派生该widget类.

== 5.2 Subclassing QWidget ==
* 在Qt Designer中设计自定义widget
	# 使用"Widget"创建一个新的form
	# 将需要的widget添加至该form, 并布局这些widget
	# 设置signals和slots的连接
	# 如果signals和slots还不能实现所有的行为, 则从QWidget和该uic生成类派生一个新类, 完成必要的代码实现这些行为
* 当然, 也可使用纯代码实现自定义widget, 不管是什么方法, 最后生成的类都为 QWidget 的派生类.
* 如果widget没有自己的signal和slot, 且未重实现任何虚函数, 则其可能组合已有的widget, 而无需一个派生类. 可见章节1的age程序.
* 可以从QWidget派生类, 并重实现一些事件处理函数来绘制该widget, 对鼠标点击做出反应.
* 在派生和创建一个自定义widget之前, 检查是否已有这个widget. 可见Qt Solution或者商业和非商业第三方的widget.
* 代码中使用 Q_PROPERTY() 宏声明自定义属性. 每个属性有一个数据类型, 读取函数, 可选的写入函数, 主要用于 Qt Designer 可以看到这些属性.
* 当我们在 Qt Designer 中使用该 widget 时, 自定义属性出现在属性编辑器中, 位于QWidget派生的属性下方. 属性可以是 QVariant 支持的任意类型.
* 全局颜色常量: Qt::black.
* QImage 数据类型, QImage::Format_ARGB32格式, QImage类可以使用1位, 8位, 32位深度.
* QRgb 为32位无符号整数, 使用qRgba和qRgb组合它们的参数为一个32位的ARGB整数值. 所以可这么写: QRgb red = qRgb(255, 0, 0); QRgb red = qRgba(255, 0, 0, 255); QRgb red = 0xFFFF0000;
* Qt 提供了两个类型保存颜色: QRgb和QColor, QRgb只用于QImage, 用来保存32位像素数据. QColor用于许多有用的函数保存颜色.除了QImage.
* size policy用来告知layout 系统是否可以拉伸和收缩.
    - QSizePolicy::Minimum 用来告诉layout管理器该widget的size hint是其最小值. 即可以拉伸, 但不能收缩至比该值更小的大小.
* QImage::converToFormat 改变图像格式.
* QWidget::update()告知应用要进行重绘.
* QWidget::updateGeometry() 用于告知包含这个widget的layout, 该widget的size hint发生了变化. 而后该layout则会自动适应新的size hint
* 产生paint 事件的几种情况
	- 第一次显示该widget
	- 该widget的大小发生变化
	- 被其他窗口覆盖, 且重新显示被覆盖的地方.
    - 我们也可以通过调用 QWidget::update()和QWidget::repaint()函数使得paint事件发生.
		- repaint() 需要立即重绘
		- update() 则将绘制事件放入处理进程事件列表.
* QPainter::drawLine() 绘制线条.
* 可以通过变换改变QPainter的坐标, 如平移, 缩放, 旋转, 切边. 
* 每个widget都带有一个调色板, 例如用于widget的背景颜色, 文本颜色.
	- 一个widget的调色板由三个颜色组组成: 活跃的(active), 非活跃的(inactive), 不能够使用的(disabled).
		- 活跃组用于当前活跃窗口
		- 非活跃组用于其他窗口
		- disable使用组用于任意窗口的disable widget
    - QWidget::palette() 返回该widget的调色板 QPalette对象, 颜色组则通过枚举类型 QPalette::ColorGroup 指定.
    - 可通过当前调色板(QWidget::palette())和不同的role得到笔刷brush, 如QPalette::foreground(), 可以同笔刷中得到其颜色, 如 QBrush::color().
* QPainter::fillRect()填充一个矩形.
* mousePressEvent() 处理函数
* mouseMoveEvent 事件在按下鼠标之时移动鼠标才产生, 除非你调用了QWidget::setMouseTracking() 函数改变其行为.
* QMouseEvent::buttons() 是鼠标按键的位或(bitwise OR)结果.
* QPoint的x()和y()方法. QRect::contains()方法测试一个点是否位于一个矩形中.
* Qt::WA_StaticContents 属性, 该属性用于告知Qt该widget的内容在大小变化时不需要改变, 内容始终对应在widget的左上角.
	- 每当大小变化是, paint 事件只对原来未显示的内容起作用.
    
== 5.3 Integrating Custom Widgets with Qt Designer ==
* 在Qt Designer中使用自定义widget, 有两种方法:
    - "提升"方法
    - 插件方式
* 在Widget上直接提升自定义widget的方法
    # 创建基Widget在Qt Designer上
    # 右键该widget, 选择 Promote to Custom Widget
    # 填充弹出对话框的类名和头文件名称
* 而后该uic生成的代码会包含上面填充的头文件, 而非基Widget的头文件. 而在Qt Designer, 显示的还是基Widget, 修改基Widget的属性.
* 缺点:
	- 不能够在Qt Designer修改该自定义widget的自定义属性
	- 不能够显示该Widget, 而是显示其基Widget
* 插件方式, 则生成一插件库让Qt Designer在运行期间动态加载
	- 首先, 我们必须派生 QDesignerCustomWidgetInterface 类以及重实现一些虚函数.
{{{c++
    #include <QDesignerCustomWidgetInterface>

    class IconEditorPlugin : public QObject,
                             public QDesignerCustomWidgetInterface
    {
        Q_OBJECT
        Q_INTERFACES(QDesignerCustomWidgetInterface)

    public:
        IconEditorPlugin(QObject *parent = 0);

        QString name() const;
        QString includeFile() const;
        QString group() const;
        QIcon icon() const;
        QString toolTip() const;
        QString whatsThis() const;
        bool isContainer() const;
        QWidget *createWidget(QWidget *parent);
    };
}}}
* IconEditorPlugin是一个工厂类, 其封装了IconEditor组件.  Q_INTERFACES() 宏告诉moc该类第二个基类为插件接口.
{{{c++
    IconEditorPlugin::IconEditorPlugin(QObject *parent)
        : QObject(parent)
    {
    }
    
    // 返回插件的名称
    QString IconEditorPlugin::name() const
    {
        return "IconEditor";
    }

    // 该函数用于返回自定义widget的头文件名称. 会在uic工具生成的代码中包含该头文件
    QString IconEditorPlugin::includeFile() const
    {
        return "iconeditor.h";
    }

    // 用于Qt Designer的widget分组
    QString IconEditorPlugin::group() const
    {
        return tr("Image Manipulation Widgets");
    }
    
    // 返回在Qt Designer用于表示该自定义widget的图标
    QIcon IconEditorPlugin::icon() const
    {
        return QIcon(":/images/iconeditor.png");
    }
    
    QString IconEditorPlugin::toolTip() const
    {
        return tr("An icon editor widget");
    }        
    
    // 用于"What's This?"
    QString IconEditorPlugin::whatsThis() const
    {
        return tr("This widget is presented in Chapter 5 of <i>C++ GUI "
                  "Programming with Qt 4</i> as an example of a custom Qt "
                  "widget.");
    }

    // 该自定义widget是否为容器
    bool IconEditorPlugin::isContainer() const
    {
        return false;
    }
    
    // Qt Designer 通过该函数创建该widget的实例
    QWidget *IconEditorPlugin::createWidget(QWidget *parent)
    {
        return new IconEditor(parent);
    }
    
    // 使用该宏来使得其该插件可用于Qt Designer
    // 第一个参数为插件的名称, 第二个则为实现的类
    Q_EXPORT_PLUGIN2(iconeditorplugin, IconEditorPlugin)
}}}
    * 编译这个插件的工程文件:
{{{
    TEMPLATE     = lib
    CONFIG      += designer plugin release
    HEADERS      = ../iconeditor/iconeditor.h \
                   iconeditorplugin.h
    SOURCES      = ../iconeditor/iconeditor.cpp \
                   iconeditorplugin.cpp
    RESOURCES    = iconeditorplugin.qrc
    DESTDIR      = $$[QT_INSTALL_PLUGINS]/designer
    // QT_INSTALL_PLUGINS --- Qt的插件安装目录
}}}
* qmake构建工具预定义的变量, $$[QT_INSTALL_PLUGINS] --- Qt安装目录中的插件目录.
* 可以使用QDesignerCustomWidgetCollectionInterface将多个自定义widget集成至一个plugin中

== 5.4 Double Buffering ==
* 双缓存是GUI程序的一个技术, 由两个部分组成: 在屏幕背后渲染一个widget到一个off-screen pixmap上, 而后将该pixmap拷贝至屏幕. 这个技术可以避免屏幕出现闪烁.
* 当一个widget的渲染很复杂以及需要重复绘制时, 可以使用双缓存技术.
	- 长时间保存像素映射(pixmap), 随时准备下一个paint事件, 当接收到paint事件时, 拷贝该pixmap至widget
* 对于一个图形或plotting widget, 可用第三方widget, 如 GraphPak, KD Chart, Qwt.
* Qt 提供了一个 QRubberBand 用于绘制 rubber bands.
* QPointF 是一个浮点版本的QPoint
* 应当使用枚举值来表示常量,  enum { Margin = 50 };
* 先在屏幕后将像素写到pixmap, 然后拷贝该pixmap至屏幕的widget
* QWidget::setBackgroundRole() 设置填充背景的方式, 本例使用调色板的"dark"成分代替"window"成分作为擦除Widget的颜色. 用于填充任何更大大小的窗口新增部分的像素, 在paint事件之前进行前冲.
	- 注意还需要调用 setAutoFillBackground(true); 来启动该机制.
	- 缺省情况, 子widget都是继承父widget的背景
* QSizePolicy::Expanding 表示widget可以拉伸收缩. QSizePolicy::Preferred 表示widget尽量选择size hint的大小, 可以收缩至 size hint的最小值, 拉伸则未定义.
* QtWidget::setFocusPolicy(Qt::StrongFocus) 表示该widget可通过鼠标点击或者键击tab接受焦点.
	- 本例接受焦点后, 该widget会接受键盘事件, 本例+表示放大, -表示缩小. 方向键则用于上下左右滚动.
	- QtWidget::adjustSize() 表示设置为该widget的size hint的大小
* 通常在顶层widget调用show()方法之后, 其所有的子widget都会显示, 除非该widget已经调用了方法hide().
* 本例 setPlotSetting()表示设置一个PlotSetting, 每当放大一次该plot, 则调用PlotSetting构造函数构建一个新的缩放.
* 这里调用refreshPixmap() 更新显示内容. 而不是调用update(), 先更新QPixmap至最新, 而后调用update()拷贝pixmap至widget
* minimumSizeHint()方法设置 widget 的最小大小.
* QPainter::drawPixmap --- 将pixmap绘制到painter上.
* painter当前palette的light颜色.
* 如果要绘制一个焦点矩形, 则painter调用drawPrimitive(), 第一个参数为QStyle::PE_FrameFocusRect, 第二个参数为QStyleOptionFocusRect对象. 第二个参数调用initFrom()设置widget对象, 且必须指定背景颜色.
{{{c++
        QStyleOptionFocusRect option;
        option.initFrom(this);
		option.backgroundColor = palette().dark().color();
		painter.drawPrimitive(QStyle::PE_FrameFocusRect, option);
}}}    
* 如果想绘制当前风格的焦点矩形, 则用如下代码, 或使用一个QStylePainter对象代替一般的painter.
{{{c++
		style()->drawPrimitive(QStyle::PE_FrameFocusRect, &option, &painter,
			this);
}}} 
* QStylePainter的drawPrimitive()函数调用相同名字的QStyle函数, 可用于绘制"primitive elements", 如面板, 按钮, 焦点矩形. 在一个应用中所有widget有相同的style(QApplication::style()), 可以使用 QWidget::setStyle() 覆盖
* 自定义 widgets可以通过使用 QStyle 绘制或者使用内置Qt widget作为子widget实现style-aware(和原生系统一致的风格).
* 大小变化则会引发resizeEvent函数的调用
* Qt 提供了两个机制用于控制光标的形状
	- QWidget::setCursor() 设置当光标在widget上方时的形状, 如果没有对应的光标, 则使用其父widget的光标设置. 顶层widget缺省使用 箭头光标
	- QApplication::setOverrideCursor() 设置在整个应用程序中使用的光标形状, 调用restoreOverrideCursor() 恢复
* QRect::normalized() 可以确保该rect的width和height不为负值.
* QWidget::unsetCursor() 恢复光标.
* 可以通过 QKeyEvent::modifiers() 处理modifer键, 有 Shift, Ctrl, Alt
* QWheelEvent::delta() 函数返回滚轮滚动的距离, 通常每度八个单位距离, 每步15个度.
* QScrollArea 会自动处理鼠标滚轮事件, 所以不再需要重实现 wheelEvent() 方法.
* QWidget::update() 使用四个参数表示一个小的重绘矩形区域.
* 将 widget 内容绘制进一个pixmap.
{{{c++
    pixmap = QPixmap(size());
    pixmap.fill(this, 0, 0);

    QPainter painter(&pixmap);
    painter.initFrom(this);
    // ... 一些绘制操作
    update();
}}}
	- 使用QWidget::size()设置pixmap的大小, 使之匹配.
	- QPixmap::fill 填充widget的erase color.
	- 使用 QPainter 对pixmap进行绘制.
	- QPainter::initFrom 可以获取来自其他widget的笔, 北京, 字体.
	- 最后使用 update() 更新.
* QPainter::setClipRect() 设置裁剪区域(即绘制的区域).

= Chapter 6 Layout Management =
* Qt提供的layout: QHBoxLayout, QVBoxLayout, QGridLayout, QStackedLayout.
* 使用layout的一个理由是使得widget适应字体, 程序界面语言以及平台的变化.
* 其他可以执行layout管理的类: QSplitter, QScrollArea, QMainWindow, QMdiArea
	- QSplitter 会提供以一个splitter条让用户可以拖动或者重置widget的大小.
	- QMdiArea则支持MDI(多文档接口)

== 6.1 Laying Out Widgets on a Form ==
* 这里管理子widget的layout有三种方式: 绝对位置, 手工layout, layout 管理器
* 绝对位置方式, 通过各个子widget调用setGeometry来设定位置和大小, 主widget则调用setFixedSize设置固定大小
	- 使用绝对位置的缺点:
		# 用户不能重置其大小
		# 一些文本可能由于字体的变化或者语言的变化而被截去部分内容
		# 在某些style中, widget可能会有不适当的大小
		# 必须手工计算大小和位置, 乏味且容易出错, 维护困难
* 手工layout, 位置仍然绝对, 但是大小可以适应窗口的大小. 通过重写 resizeEvent() 方法, 在其中设置子widget的几何.
* layout 管理器方法, 考虑每个widget的size hint(该size hint依赖于widget的字体, 内容), 同时也考虑最小和最大大小.
	- 根据字体的变化, 内容的变化, 窗口大小的变化自动修正大小.
	- 三个最重要的layout类是QHBoxLayout, QVBoxLayout, QGridLayout, 这三者都为QLayout的派生类
	- 一个layout内的边缘和子widget之间的空格由当前widget的style决定. 也可以使用QLayout::setContentsMargins()和QLayout::setSpacing()来改变
	- QGridLayout的语法: layout->addWidget(widget, row, column, rowSpan, columnSpan);
	- addStretch() 用来告知layout 管理器填充该处的空白.
	- layout 管理器的优点:
		# 添加或者移除一个widget, layout会自动修正以适应新的情况, 对hide()和show()也有同样的效果.
		# 当子widget的size hint发生改变时, layout 管理器会自动修改以适应新的size hint
		# 根据子widget的size hint和最小值来设置layout的最小值
	- 有时我们需要修改size policy和widget的size hint来实现我们想要的布局.
	- QSizePolicy有垂直和水平的成分, size policy的值有:
		# Fixed --- 固定的layout, 不能拉伸和收缩. 使用size hint的大小
		# Minimum --- 表示该widget的最小值就是size hint. 不能够收缩至比该值更小的值. 但可填充可用的空间.
		# Maximum --- 表示该widget的最大值就是size hint, 该widget可以收缩至其最小值 minimum size hint
		# Preferred --- 该widget的size hint就是其优先值, 在必要的时候可以收缩和拉伸
		# Expanding --- 表示该widget可以收缩和拉伸, 尤其是其愿意拉伸.
	- Expanding 和 Preferred的区别: 当一个form包含两者的widget, 该form大小变化时, 额外的空白处则会给Expanding widget, 而Preferred widget保持为其size hint的大小
	- MinimumExpanding 和 Ignored这两个Size Policy不再经常使用
	- 为了补充水平和垂直部分的size policy, 我们还设定了拉伸因子(strectch factor), 可以设置widget在水平或垂直方向的拉伸比例, 比如让一个widget为另一个widget的两倍, 可以设置拉伸因子一个为2, 一个为1.
	- 如果对一个widget不满意, 我们还可以派生该widget类, 重写其sizeHint()函数
    
== 6.2 Stacked Layouts ==
* QStackedLayout 类对一系列子widget布局, 或者"分页". 且每次只显示一个页面, 隐藏其他页面的内容.
	- Qt提供QStackedWidget, 其为内置QStackedLayout的QWidget.
* 页数是从0开始, 设置当前页 setCurrentIndex, 得到一个子widget的页号则使用indexOf().
* QListWidget可以和QStackedLayout配合使用.
{{{c++
    listWidget = new QListWidget;
    listWidget->addItem(tr("Appearance"));
    listWidget->addItem(tr("Web Browser"));
    listWidget->addItem(tr("Mail & News"));
    listWidget->addItem(tr("Advanced"));

    stackedLayout = new QStackedLayout;
    stackedLayout->addWidget(appearancePage);
    stackedLayout->addWidget(webBrowserPage);
    stackedLayout->addWidget(mailAndNewsPage);
    stackedLayout->addWidget(advancedPage);
    connect(listWidget, SIGNAL(currentRowChanged(int)),
            stackedLayout, SLOT(setCurrentIndex(int)));
    ...
    listWidget->setCurrentRow(0);
}}} 
	- currentRowChanged(int)信号发送给setCurrentIndex(int) slot 实现页面切换
	- setCurrentRow()  设置当前页面
* 在Qt Designer中实现分页
	- 用"dialog"模板或者"widget"模板创建新的form
	- 添加QListWidget和QStackedWidget
	- 填充每个页面的widget和layout
	- 水平方向布局这两个widget
	- signal和slot连接 currentRowChanged(int) --> setCurrentIndex(int)
	- 设置list widget的currentRow属性为0
    
== 6.3 Splitters ==
* QSplitter的子widget根据创建的顺序自动排列在一起. 相邻的widget之间有splitter bar. 下面是创建的代码
{{{c++
    int main(int argc, char *argv[])
    {
        QApplication app(argc, argv);

        QTextEdit *editor1 = new QTextEdit;
        QTextEdit *editor2 = new QTextEdit;
        QTextEdit *editor3 = new QTextEdit;

        QSplitter splitter(Qt::Horizontal);
        splitter.addWidget(editor1);
        splitter.addWidget(editor2);
        splitter.addWidget(editor3);
        ...
        splitter.show();
        return app.exec();
    }
}}}
* QSplitter 派生自QWidget, 像其他的widget一样使用.
* 复杂的布局可以嵌套使用水平或垂直QSplitter
* MailClient的例子
{{{c++
    MailClient::MailClient()
    {
        ...
        rightSplitter = new QSplitter(Qt::Vertical);
        rightSplitter->addWidget(messagesTreeWidget);
        rightSplitter->addWidget(textEdit);
        rightSplitter->setStretchFactor(1, 1);

        mainSplitter = new QSplitter(Qt::Horizontal);
        mainSplitter->addWidget(foldersTreeWidget);
        mainSplitter->addWidget(rightSplitter);
        mainSplitter->setStretchFactor(1, 1);
        setCentralWidget(mainSplitter);

        setWindowTitle(tr("Mail Client"));
        readSettings();
    }
}}}
	- setStretchFactor 设置拉伸因子, 默认情况是随着大小变化, 各部分的比例不变, 第一个参数是以第一个widget为0的索引值, 第二个参数设置拉伸因子, 缺省为0
* 我们可以通过调用 QSplitter::setSizes() 来移动splitter handles.
* 保存设置
{{{c++
    QSettings settings("Software Inc.", "Mail Client");
    settings.beginGroup("mainWindow");
    settings.setValue("geometry", saveGeometry());
    settings.setValue("mainSplitter", mainSplitter->saveState());
    settings.setValue("rightSplitter", rightSplitter->saveState());
    settings.endGroup();
    // 读取设置
    QSettings settings("Software Inc.", "Mail Client");
    settings.beginGroup("mainWindow");
    restoreGeometry(settings.value("geometry").toByteArray());
    mainSplitter->restoreState(
            settings.value("mainSplitter").toByteArray());
    rightSplitter->restoreState(
            settings.value("rightSplitter").toByteArray());
    settings.endGroup();
}}}
* QWidget::saveGeometry(), QWidget::restoreGeometry, QSplitter::saveState(), QSplitter::restoreState() 实现注册表保存和恢复QWidget的几何和QSplitter的状态.
* Qt Designer也完全支持QSplitter, 将widgets放入一个splitter中, 将子widget正确地放置进他们想要的位置, 还可以选择它们以及在splitter中设置水平和垂直的布局.

== 6.4 Scrolling Areas ==
* 如果需要使用滚动条, 最好使用QScrollArea而不是自己实现QScrollBar和滚动功能, 因为这样太复杂
    - 使用QScrollArea的方法是调用setWidget使得该widget成为QScrolllArea viewport的子类. 可通过QScrollArea::viewport()访问viewport
{{{c++
        QScrollArea scrollArea;
        scrollArea.setWidget(iconEditor);
        scrollArea.viewport()->setBackgroundRole(QPalette::Dark);
        scrollArea.viewport()->setAutoFillBackground(true);
        scrollArea.setWindowTitle(QObject::tr("Icon Editor"));
}}}
* 通过调用setWidgetResizable(true)告知该QScrollArea可以自动的重置widget的大小. 这样使得其可以利用size hint之外的空间
* 缺省情况是当viewport比widget更小的时候才显示滚动条, 如果想滚动条永远显示, 则使用以下代码:
{{{c++
    scrollArea.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOn);
    scrollArea.setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOn);
}}}
* QScrollArea派生自QAbstractScrollArea, QTextEdit和QAbstractItemView的基类为QAbstractScrollArea.

== 6.5 Dock Windows and Toolbars ==
* Dock Window表示那些可以在QMainWindow内停靠的窗口且可以独立浮动的窗口.
	- QMainWindow 提供了四个浮动区域, 上,下, 左, 右.
* 每个dock window都有其标题条, 可通过QDockWidget::setFeatures() 设置其属性
* QMainWindow::setCorner(Qt::TopLeftCorner, Qt::LeftDockWidgetArea); // 设置左上角区域属于左边的dock widget区域
* 如果我们想要一个浮动的工具条, 我可以简单地将其放置进一个QDockWidget中.
* 如何在一个QDockWidget包装一已存widget, 且插入右边的dock区域
{{{c++
    QDockWidget *shapesDockWidget = new QDockWidget(tr("Shapes"));
    shapesDockWidget->setObjectName("shapesDockWidget");
    shapesDockWidget->setWidget(treeWidget);
    shapesDockWidget->setAllowedAreas(Qt::LeftDockWidgetArea
                                         | Qt::RightDockWidgetArea);
    addDockWidget(Qt::RightDockWidgetArea, shapesDockWidget);
}}}
	- setAllowedAreas()限制可以接受该dock窗口可以dock的区域.
	- 每个对象都有一个对象名, 在调试的时候有用
	- Dock widget和Toolbar都需设置对象名, 这样可使用函数QMainWindow::saveState()和QMainWindow::restoreState() 保存和恢复几何和状态.
* 工具条
{{{c++
    QToolBar *fontToolBar = new QToolBar(tr("Font"));
    fontToolBar->setObjectName("fontToolBar");
    fontToolBar->addWidget(familyComboBox);
    fontToolBar->addWidget(sizeSpinBox);
    fontToolBar->addAction(boldAction);
    fontToolBar->addAction(italicAction);
    fontToolBar->addAction(underlineAction);
    fontToolBar->setAllowedAreas(Qt::TopToolBarArea
                                 | Qt::BottomToolBarArea);
    addToolBar(fontToolBar);
}}}
* 在QMainWindow派生类的构造函数中给工具条添加 ComboBox, SpinBox, 一些QToolButtons
* 保存和恢复设置, 使用 QMainWindow::saveState()和QMainWindow::restoreState()保存和恢复工具条, dock窗口的位置.
{{{c++
    // 保存
    QSettings settings("Software Inc.", "Icon Editor");
    settings.beginGroup("mainWindow");
    settings.setValue("geometry", saveGeometry());
    settings.setValue("state", saveState());
    settings.endGroup();
    // 恢复
    QSettings settings("Software Inc.", "Icon Editor");
    settings.beginGroup("mainWindow");
    restoreGeometry(settings.value("geometry").toByteArray());
    restoreState(settings.value("state").toByteArray());
    settings.endGroup();
}}}
* QMainWindow还给dock window和Toolbar提供了右键菜单, 用于关闭隐藏或显示一个工具条或者一个dock窗口.

== 6.6 多文档接口 ==
* 一个MDI应用程序通过使用QMdiArea类作为中心widget以及让每个文档窗口作为一个QMdiArea的子窗口
    - 子窗口菜单-MDI应用程序提供了一个Window菜单管理窗口和窗口列表, 激活的文档窗口会有选中标志
* 在构造函数中, 创建一个QMdiArea对象并设置为中心widget, 并将该QMdiArea的subWindowActivated()信号发送给一个slot, 实现菜单的更新
* 在构造函数的结尾部分有一行代码: QTimer::singleShot(0, this, SLOT(loadFiles())); 
	- 表示0秒的间隔之后调用loadFiles(). 在事件循环为空闲时, 计时器运行完时间, 事实上表示当构造函数完成之后, 主窗口显示之时, 调用loadFiles()函数
	- 如果不这样做, 当有大量的文件之时, 直到文件加载完毕之后构造函数还未必完成时, 用户也许会在屏幕上看不到任何东西. 而认为程序失败.
{{{c++
void MainWindow::loadFiles()
{
    QStringList args = QApplication::arguments();
    args.removeFirst();
    if (!args.isEmpty()) { 
		foreach (QString arg, args) 
			openFile(arg); 
		mdiArea->cascadeSubWindows(); 
	} 
	else { 
		newFile(); 
	} 
	mdiArea->activateNextSubWindow();
}
}}}
* QApplication构造函数自动移除类似 -style 和 -font 这样的Qt专用命令行选项.
* 关联编辑器和复制剪贴菜单
{{{c++
    connect(editor, SIGNAL(copyAvailable(bool)),
            cutAction, SLOT(setEnabled(bool)));
    connect(editor, SIGNAL(copyAvailable(bool)),
            copyAction, SLOT(setEnabled(bool)));
}}}
* QMdiArea的addSubWindow() 函数可以创建一个新的QMdiSubWindow: QMdiSubWindow *subWindow = mdiArea->addSubWindow(editor);    
* QActionGroup 确保一组菜单只有一个菜单能被选中.
* QMdiArea::activeSubWindow() --- 返回其活跃窗口
* QMdiSubWindow::widget() 获取一个子窗口中的组件.
* qobject_cast<Editor *> --- 用于强制转换.
* 当一个子窗口被激活或者最后一个子窗口被关闭时, 发送信号 subWindowActivated()
* 可以实现一些功能的QMdiArea的slots: closeActiveSubWindow(), closeAllSubwindows(), tileSubWindows(), cascadeSubWindows().
* QMdiArea::subWindowList() --- 返回子窗口列表.
* 如果要求一个代码编辑组件, 我们可以考虑使用 Scintilla, 见  http://www.riverbankcomputing.co.uk/qscintilla/
* 任意 Qt Widget 都可以在一个 QMdiSubWindows中做作为一个 MDI 区域的子窗口.
* QTextEdit::document() 返回一个 QTextDocument 对象指针.
* WA_DeleteOnClose 属性可以防止用户关闭编辑器窗口的内存泄漏.
* 无论用户何时修改编辑器中的文本, 其内的QTextDocument都会发送contentsChanged()信号.
* QTextCursor::hasSelection ()  --- 返回当前文本光标是否选择了文本
* QAction::setChecked() --- 设置选中该Action
* QWidget::fontMetrics 可以返回 QFontMetrics 对象表示其上的字体信息. QFontMetrics::width(), QFontMetrics::lineSpacing()可以返回相关信息.

= Chapter 7 Event Processing =
* 大多数事件的生成用于反映用户的操作, 但有些, 例如timer则是独立于系统之外生成.
* 事件和信号的区别: 当使用一个widget的时候, 信号有用, 当实现一个widget的时候, 事件有用.
== 7.1 Reimplementing Event Handlers ==
* 在Qt中, 任何事件都是QEvent派生类的实例. Qt 处理上百种事件类型, 通过枚举值来标识出事件类型.
	- 举个例子: QEvent::type() 返回 QEvent::MouseButtonPress 则表示一个鼠标按下事件.
* 许多的事件类型都需要存储更多的信息, 这些信息存储在派生类中. 例如鼠标按下事件需要知道是哪个按键被按下以及指针所在位置. 这些都保存在QEvent的派生类QMouseEvent中.
* 通过QObject::event()函数将事件通知给对象.
	- QWidget中event()的实现将大多数常用类型的事件发送给专门的事件处理函数, 例如 mousePressEvent(), keyPressEvent(), paintEvent().
	- 可以在QEvent参考文档中查看许多其他类型的事件, 可以创建自定义事件类型并发送给我们自己的处理函数.
* 键盘事件通过重写keyPressEvent()和keyReleaseEvent()实现.
	- Modifier键: Ctrl, Shift, Alt, 可以在keyPressEvent()中使用QKeyEvent::modifiers()进行检查.
    - 例如判断 Ctrl + Home
{{{c++
    switch (event->key()) {
    case Qt::Key_Home:
        if (event->modifiers() & Qt::ControlModifier) {
            goToBeginningOfDocument();
        }
        else
        {
            goToBeginningOfLine();
        }
        break;
    ... ...
    }
}}}
* 一般而言, Tab和Shift+Tab用于切换widget. 如果想拦截这两个键, 可以在QWidget::event()处理, 该函数在keyPressEvent()之前被调用,
{{{c++
        bool CodeEditor::event(QEvent *event)
        {
            if (event->type() == QEvent::KeyPress) {
                QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
                if (keyEvent->key() == Qt::Key_Tab) {
                    insertAtCurrentPosition('\t');
                    return true;
                }
            }
            return QWidget::event(event);
        }
}}}
* 实现键绑定更高层的方法是使用Action
{{{c++
    goToBeginningOfLineAction =
            new QAction(tr("Go to Beginning of Line"), this);
    goToBeginningOfLineAction->setShortcut(tr("Home"));	// 连接
    connect(goToBeginningOfLineAction, SIGNAL(activated()),
            editor, SLOT(goToBeginningOfLine()));

    goToBeginningOfDocumentAction =
            new QAction(tr("Go to Beginning of Document"), this);
    goToBeginningOfDocumentAction->setShortcut(tr("Ctrl+Home"));
    connect(goToBeginningOfDocumentAction, SIGNAL(activated()),
            editor, SLOT(goToBeginningOfDocument()));
}}}
	- 如果用户界面接口不会显示该命令, 则可使用QShortcut来实现该快捷键功能, 这个类内部通过QAction支持键的绑定.
	- 可以用QAction::setShortcutContext() 或者 QShortcut::setContext() 修改QAction或者QShortcut的键绑定的激活状态.
* 三个事件处理函数 timerEvent(), showEvent(), hideEvent()
* 计时器的ID必为非零数字.
* updateGeometry() 用于通知widget的layout manager其子widget的size hint可能发生变化, 让其进行修正.
* QFontMetrics::size() 可以获取大小信息.
* QPainter::drawText() 绘制文本.
* QObject::startTimer() 函数启动一个计时器, 在showEvent()中设置计时器, 可以使得在widget完全显示之后启动计时器
{{{c++
    void Ticker::timerEvent(QTimerEvent *event)
    {
        if (event->timerId() == myTimerId) {
            ++offset;
            if (offset >= fontMetrics().width(text()))
                offset = 0;
            scroll(-1, 0);
        } else {
            QWidget::timerEvent(event);
        }
    }
}}}
* 本例使用 QWidget::scroll()替换update(), 更有效率, 每次只需要绘制多出的1像素位置的内容.
* QObject::killTimer 停止一个计时器.
* 除了使用 Timer events, 还可以使用 QTimer 管理多个计时器, 在每个时间间隔后 QTimer 发送一个 timeout() 信号. QTimer 还提供一个便利的接口用于发送一次的计时器.
    
== 7.2 Installing Event Filter ==
* Qt的事件模型一个非常强大的功能就是一个QObject的实例可以监视另一个QObject实例的事件, 在后者QObject的实例看到这个事件之前.
* 通过建立监视器可以监控子widget的事件, 来实现特定功能, 使用事件过滤器. 具体有两个步骤:
	- 通过在目标上调用installEventFilter()函数来注册目标对象的监视器对象
	- 在监视器的eventFilter()函数中处理目标对象的事件
* 一般最好在构造函数中注册监视器对象
{{{c++
        firstNameEdit->installEventFilter(this);
        lastNameEdit->installEventFilter(this);
        cityEdit->installEventFilter(this);
        phoneNumberEdit->installEventFilter(this);
}}}
	* 这四个widget首先将发送调用本widget的eventFilter()函数, 而后再到其自身的处理函数
{{{c++
        bool CustomerInfoDialog::eventFilter(QObject *target, QEvent *event)
        {
            if (target == firstNameEdit || target == lastNameEdit
                    || target == cityEdit || target == phoneNumberEdit) {
                if (event->type() == QEvent::KeyPress) {
                    QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
                    if (keyEvent->key() == Qt::Key_Space) {
                        focusNextChild();
                        return true;
                    }
                }
            }
            return QDialog::eventFilter(target, event);
        }
}}}
* 上面代码实现空格键切换widget, 注意如果实现了需要的功能返回true, 这样就不会事件传递到目标对象.
* QWidget::focusNextChild() 焦点转移到下一个子widget上.
* 五个处理与过滤事件的层次
	- 我们可以重新实现特定的事件处理函数
	- 我们可以重新实现QObject::event()
		- 用于在到达具体的事件处理函数之前处理该事件, 例如Tab键. 另外在重实现该函数的过程中需要调用基类的event()用于处理我们没有显式处理的事件
		- 还可用于处理没有特定事件处理函数的的事件类型, 例如 QEvent::HoverEnter().
	- 我们可以在单个QObject上安装event filter
		- 一个对象使用installEventFilter()安装了多个事件过滤器, 其会依次激活这些过滤器, 顺序为最近安装到第一个安装的次序.
	- 我们可以在QApplication 对象上安装一个event filter, 所有对象的所有事件都会发送给eventFilter()函数. 常用于调试, 还可用于处理发送给disabled widget的鼠标事件, 这个时间通常被 QApplication 抛弃掉.
	- 我们可以实现QApplication的派生类, 以及重新实现notify().
		- Qt调用QApplication::notify()发送事件, 重新实现该函数是获得所有事件的唯一方法, 在任何event filter有机会处理事件之前.
* 许多类型的事件, 包括鼠标和按键事件, 都会进行传递. 当目标对象没有处理该事件, 则其父widget会进行处理该事件. 直到顶层对象.

== 7.3 Staying Responsive during Intensive Processing ==
* 调用QApplication::exec()之后, 开始事件循环, 首先是处理显示和绘制widget的事件, 而后循环运行检查是否有新的事件, 而后分发这些事件至对象.
* 使用多线程处理一些耗时的任务, 以避免界面不响应
* 另一个处理耗时任务界面不响应的方法是在耗时代码中不断调用 QApplication::processEvents() 来处理任意 pending 的事件, 而后返回控制权给调用者.
	- 事实上 QApplication::exec只是在while循环内部调用processEvents().
* 在耗时的处理函数中使用qApp->processEvents(); 
 	- 使用 qApp->processEvents(QEventLoop::ExcludeUserInputEvents); 代替上者可以避免其他重要的操作如关闭程序. 主要是忽略鼠标和键盘事件.
* QProgressDialog是一个进程条, 用于告知当前处理的程度
* 我们不需要自己调用 QProgressDialog的show()来显示这个进程对话框, 它会自动处理这个操作. 如果显示时间很短, 则根本不会显示这个对话框.
	- QProgressDialog 类: setLabelText, setRange, setModel, setValue, wasCanceled
* 计时器通过设置0毫秒的计时器用于在空闲时期进行处理
* 用QApplication::hasPendingEvents和计时器来判断当前是否还有悬挂的事件未处理.

= Chapter 8 2D Graphics =
* Qt 4.2 介绍了完全新的"graphics view"结构, 该结构的中心内容为 QGraphicsView, QGraphicsScene, QGraphicsItem 类. 提供了高层接口用于 item-based graphics, 且支持items上标准的用户操作, 包括移动, 选择, 分组.

== 8.1 Painting with QPainter ==
* 在图形设备上绘制, 仅仅需要将设备的指针传递给QPainter构造函数的参数, 如: QPainter painter(this);
	- QPainter的三个重要的设置: pen, brush, font
	- 重要draw函数: drawPoint, drawLine, drawPolyLine, drawPoints, drawLines, drawPolygon, drawRect, drawRoundRect, drawEllipse, drawArc, drawChord, drawPie, drawText, drawPixmap, drawPath
	- pen 用于绘制线条和图形轮廓, 由颜色, 宽度, 线条风格(line style), 线头风格(cap style), 连接风格(join style)组成.
		- Cap 和 joint styles: FlatCap, SquareCap, RoundCap, MiterJoint, BevelJoint, RoundJoint
		- Line Style: SolidLine, DashLine, DotLint, DashDotLine, DashDotDotLine, NoPen
	- brush 表示用于填充几何体的模式, 由颜色和风格组成. 也可以是一个纹理或者一个 gradient.
		- style: SolidPattern, Dense1Pattern, Dense2Pattern, Dense3Pattern, Dense4Pattern, Dense5Pattern, Dense6Pattern, Dense7Pattern, HorPattern, VerPattern, CrossPattern, BDiagPattern, FDiagPattern, DiagCrossPattern, NoBrush
	- font 用于绘制文本, 含有许多属性, 其中包含 family和 点大小
* 可以用setPen, setBrush, setFont和QPen, QBrush, QFont对象来修改这些设置
{{{c++
	QPainter painter(this);
	painter.setRenderHint(QPainter::Antialiasing, true);
	painter.setPen(QPen(Qt::black, 15, Qt::SolidLine, Qt::RoundCap,
	                    Qt::MiterJoin));
	painter.setBrush(QBrush(Qt::blue, Qt::DiagCrossPattern));
	painter.drawPie(80, 80, 400, 240, 60 * 16, 270 * 16);
}}} 
* painter.setRenderHint(QPainter::Antialiasing, true); // 可以实现反锯齿
{{{c++
	QPainter painter(this);
	painter.setRenderHint(QPainter::Antialiasing, true);

	QPainterPath path;
	path.moveTo(80, 320);
	path.cubicTo(200, 80, 320, 80, 480, 320);

	painter.setPen(QPen(Qt::black, 8));
	painter.drawPath(path);
}}} 
* QPainterPath 可以指定用于连接基本图形的元素来指定任意的向量形状: 如直线, 椭圆形, 多边形, 弧, 贝塞尔曲线 和其他绘制路径.
	- 一个路径可以表示一条轮廓, 以及该轮廓所标示的面积, 该面积可以用笔刷填充.
* gradient fill是一个可选的单色填充方式, Gradient依赖于颜色插值以得到两个颜色之间的平滑转换. 常用于生成3D效果.
	- Qt 提供三个gradient类型: 线性, 圆锥体的(conical), 径向的(radial)
	- 线性: 有两个控制点用于定义, 通过一系列线上的"颜色点"来连接两个点. 如:
{{{c++
        QLinearGradient gradient(50, 100, 300, 350);
        gradient.setColorAt(0.0, Qt::white);
        gradient.setColorAt(0.2, Qt::green);
        gradient.setColorAt(1.0, Qt::black);
}}}
	- 两个控制点之间的位置用0到1之间的浮点数表示.
	- Radial: 通过中心点(Xc,Yc), 半径r, 焦点(Xf, Yf)来定义,
	- Conical: 通过中心点(Xc, Yc)和角度a来定义.
* 其他的属性:
	- background brush 用于填充以下内容的背景, 几何形状(在笔刷模式的背后), 文本, 或者背景模式为 Qt::OpaqueMode 的bitmaps(其缺省为 Qt::TransparentMode).
	- brush origin 为笔刷模式的起点, 通常为widget的左上角.
	- clip region为设备上可以绘制的区域.
	- viewport, window, world transform --- 可以确定逻辑QPainter坐标到物理绘制设备坐标的映射. 缺省情况两者一致
	- composition mode --- 定义新绘制的像素如何与原有像素相互影响. 默认是alpha 混合, 即"source over".
* 我们可以通过 save()保存当前painter的状态, 通过restore()恢复.

== 8.2 Coordinate System Transformations ==
* 缺省的坐标系统, 左上角(0, 0), X轴正向方向向右, Y轴正向方向向下, 每个像素的大小为 1x1
* 如果我们在(100, 100)上绘制一个像素, 则其中心为(100.5, 100.5), 所占据的矩形区域为(100, 100, 101, 101), 其结果可能在两个方向上平移0.5个单位.
* 所以一个像素的中心是0.5, 只有当禁用反锯齿的时候+0.5.
	- 如果开启了反锯齿, 在点(100, 100)绘制黑色. 则四个点(99.5, 99.5), (99.5, 100.5), (100.5, 99.5), (100.5, 100.5)为灰色.
	- 如果不想使用这个效果, 可以移动QPainter (+0.5, +0.5), 或者指定半个像素的坐标
	- 图8.7到图8,9显示了一个矩形在不同笔宽度和反锯齿情况下如何在屏幕上绘制.
	- viewport 为在物理坐标系下具体的任意矩形. windows则是逻辑坐标下的矩形. 
	- 如果设备为 320x200 的widget, viewport 和 window 都为相同的 320 x 200 矩形, 且左上角位置为(0, 0), 这种情况逻辑和物理坐标系统相同.
	- 窗口-视图机制 可以让绘制代码独立于绘制设备的分辨率和大小
	- 下面的代码为将逻辑坐标扩展为(-50, -50) 到 (50, 50), 中心为(0, 0)
		- 这里(-50, -50) 对应于物理坐标(0, 0), (50, 50) 对应于物理坐标(320, 200)
{{{c++
        painter.setWindow(-50, -50, 100, 100);    // 从(-50, -50)到(50, 50), 中心点为(0, 0)
}}}
	- 世界变换为应用于window-viewport转换的额外转换矩阵. 允许平移, 缩放, 旋转, 切变.
	- 如果我们想要在45度角绘制文本
{{{c++
        QTransform transform;
        transform.rotate(+45.0);
        painter.setWorldTransform(transform);
        painter.drawText(pos, tr("Sales"));
}}}
	- 可以指定多个转换, 如在(50, 50)处旋转.
{{{c++
	QTransform transform;
	transform.translate(+50.0, +50.0);
	transform.rotate(+45.0);
	transform.translate(-50.0, -50.0);
	painter.setWorldTransform(transform);
	painter.drawText(pos, tr("Sales"));
}}} 
	- 如果经常使用同一个转换, 可以保存一个QTransform对象, 在需要的时候使用
* QDateTime::currentDateTime() 获取当前时间.
* QTimer有slot stop() 用于停止该定时器.
* QTimer调用setSingleShot(true), 表示在时间结束之后只发送一次time out信息. 否则缺省计时器会重复启发直至他们停止或者销毁.
* 可以使用QFont::setPointSize() 设置字体的点大小.
* qBound() 函数, 确保返回第二个参数的值在第一个和第三个参数之间.
* 使用 QDateTime封装日期, 可以避免午夜时间变化的bug.
* viewport表示了设备上绘制的区域. 如代码:
{{{c++
    int side = qMin(width(), height());

    painter.setViewport((width() - side) / 2, (height() - side) / 2,
                        side, side);
    painter.setWindow(-50, -50, 100, 100);
}}} 
* qMin() 可以返回最小值.
* 本节的例子使用QConicalGradient, QRadialGradient, QLinearGradient实现了非常漂亮的效果, 这几个可以当作笔刷使用

== 8.3 High-Quality Rendering with QImage ==
* 有时我们需要权衡速度和精确度之间的关系. 当精确度比效率更重要时, 我们将绘制到QImage, 而后将结果拷贝至屏幕. 这将使用Qt的内置绘制引擎.
	- 唯一的限制是QImage的创建参数为QImage::Format_RGB32 或 QImage::Format_ARGB32_Premultiplied
* "premultiplied ARPG32" 格式表示红,绿,蓝通道预先乘以alpha通道并存储起来. 代码:
{{{c++
        void MyWidget::paintEvent(QPaintEvent *event)
        {
            QImage image(size(), QImage::Format_ARGB32_Premultiplied);
            QPainter imagePainter(&image);
            imagePainter.initFrom(this);
            imagePainter.setRenderHint(QPainter::Antialiasing, true);
            imagePainter.eraseRect(rect());
            draw(&imagePainter);
            imagePainter.end();

            QPainter widgetPainter(this);
            widgetPainter.drawImage(0, 0, image);
        }
}}}
	- 上面代码先用QPainter绘制QImage, 而后绘制到屏幕
	- 主要使用方法 QPainter::initFrom(), QPainter::setRenderHint(), QPainter::eraseRect(), QPainter::end(), QPainter::drawImage().
	- 一个非常好的功能就是Qt图形引擎支持合成模式, 源和目标像素可以混合. 在所有的绘制操作都可以实现这点, 如笔, 笔刷, 渐进和图像绘制
	- 缺省的合成模式为: QImage::CompositionMode_SourceOver, 表示源像素会覆盖在目标像素之上, 根据alpha值设置透明度.
	- 可通过  QPainter::setCompositionMode() 来设置合成模式. 如:
{{{c++
        QImage resultImage = checkerPatternImage;
        QPainter painter(&resultImage);
        painter.setCompositionMode(QPainter::CompositionMode_Xor);
        painter.drawImage(0, 0, butterflyImage);
}}}
	- XOR 源和目标. 注意XOR模式对Alpha部分也是有效的.

== 8.4 Item-Based Rendering with Graphics View ==
* QPainter对于绘制自定义widget和比较少的条目时是比较理想的方法
* 绘制大量的条目和内容时的解决方案
	- 图形视图结构包含场景, 由QGraphicsScene类表示, 场景中的项目, 由QGraphicsItem的子类表示.
	- 通过在view中显示使场景可见. 这里用QGraphicsView类表示视图. 相同的场景可以在多个视图中显示. 如显示一个巨大场景的不同部分, 不同的转换.
* 预定义好的QGraphicsItem派生类, 如QGraphicsLineItem, QGraphicsPixmapItem, QGraphicsSimpleTextItem, QGraphicsTextItem
	- 也可以自己创建自定义派生类
* QGraphicsScene控制图形元素的集合, 有三个layer, 背景层, item层, 前景层. 背景和前景层通常由QBrushes指定, 但其也可以通过重实现 drawBackground() 或 drawForeground() 来得到完全的控制.
	- 我们可以基于pixmap创建一个纹理QBrush作为背景. 前景则可以设置半透明的白色给出一个渐隐效果, 或者使用一个cross pattern 提供 grid overlay 效果.
	- 场景可以告知我们哪些items相交, 哪些被选择, 某点在有哪个item, 某区域有哪些items. 一个场景的图形items可以是顶层(其父为场景)或者子层(其父为其他的item). 任何应用于一个item的变换都会应用于其子items上.
	- graphics view架构提供了分组items的两个方式, 一个为简单地使一个item成为另一个item的孩子. 另一个方式使用 QGraphicsItemGroup, 使得多个item可以看成单个item.
	- QGraphicsView 是显示一个scene的widget, 提供了滚动条, 可以对场景应用变换. 支持场景的缩放和旋转.
	- 视图则管理场景. 视图可用内置的2D绘制引擎, 也可以用Opengl. 在其构造之后可以调用setViewport()以及使用opengl.
	- 视图可以用打印一个场景或者场景的一部分.
	- 这个结构使用三个不同的坐标系统 - 视图坐标, 场景坐标和项目(item)坐标 -- 带有一个坐标系统向另一个坐标系统映射的函数.
		- 视图坐标系统位于QGraphicsView的视图内部. 场景坐标系统是逻辑坐标系统, 用于放置场景上的顶层项目(item).
		- item坐标系统用于表示每个项目, 且其中心为(0, 0), 即item的位置.
		- 事实上我们关心系统坐标, 用于放置顶层item, item坐标可以放置子item以及进行绘制item.
	- 为了介绍图形视图, 本例使用了两个例子, 第一个例子为简单的图表编辑器,
	- 第二个例子为annotated map程序显示如何处理大量的图形对象, 如何有效的渲染以及缩放
	- 图8.16展示的图表应用程序允许用户创建节点和链接. 节点是那些在圆角矩形内显示纯文本的图形items. 链接为连接一对节点的线条. 选中的节点使用更粗的笔绘制一个虚线轮廓.
* QGraphicsItem不是QObject的派生类, 如果想要使用signal和slot, 可以实现多个继承, 其中一个基类为QObject. 其可以调用函数 setLine 绘制直线.
* QGraphicsItem::setFlags(QGraphicsItem::ItemIsSelectable) 设置item可以被选择.
* QGraphicsItem::setZValue 设置显示的Z值.
* QGraphicsItem::setPen 设置笔.
* QGraphicsItem::pos 返回图形item相对于场景的位置(顶层item)或者相对于父item的位置(子item)
* QGraphicsItem::setLine 绘制两点之间的线条.
* Q_DECLARE_TR_FUNCTIONS()宏用于添加一个tr()函数至该类. 即便它不是QOjbect的派生类, 这样可以让我们简单的使用tr(), 而不是静态的QObject::tr() 或者 QApplication::translate()
* 当我们实现了QGraphicsItem的派生类时, 如果想要手工绘制内容, 则需要重新实现boundingRect()和paint()
	- 如果我们不重新实现 shape(), 基类则会回到boundingRect()函数, 这里我们重新实现shape()用于返回更精确的形状, 该形状可以考虑到节点的圆角.
	- graphic view结构使用围绕矩形(bounding rectangle)确定一个项目是否要需要绘制. 这使得其能够非常快速地显示任意大的场景, 任意给定时候都只会显示一部分的场景
	- 形状(shape)则确定某点是否在一个item之内, 或确定两个items是否相互碰撞.
* 提供属性对话框用于编辑节点的位置, 颜色和文本. 双击节点则可修改文本.
* QGraphicsItem::itemChange() 重实现该处理函数, 当item属性变化时调用该函数.
* QGraphicsItem::setFlags(ItemIsMovable | ItemIsSelectable);  --- 设置该item可以移动和可被选择.
* 下面的代码删除该节点的所有Link, 而无论该Link是否被销毁了, 如果使用qDeleteAll() 以避免一些副作用.
{{{c++
        foreach (Link *link, myLinks)
            delete link;
}}}
* QGraphicsItem::update() 将一个重绘消息放入序列中. 当item的围绕矩形可能发生变化时, 则在任何可能影响围绕矩形的操作之前调用 prepareGeometryChange().
* 求一个节点的矩形框
* QApplication::font() 返回一个字体信息. QFontMetricsF::boundingRect() 得到一个字符串的矩形.
{{{c++
    const int Padding = 8;
    QFontMetricsF metrics = qApp->font();
    QRectF rect = metrics.boundingRect(myText);
    rect.adjust(-Padding, -Padding, +Padding, +Padding);
    rect.translate(-rect.center());
    return rect;    
}}}
	* QFontMetrics计算的围绕矩形左上角坐标总为(0, 0)
* QGraphicsItem::boundingRect()方法, 当QGraphicsView 确定一个item是否需要绘制时, 调用该方法.
* 可使用QPainterPath精确的描述圆角矩形, 可以使得当鼠标位于角落且不在圆角矩形之内时, 不会选择该矩形. 要实现这个功能需要重写 shape() 函数.
* QGraphicsItem::paint() 用于绘制该item, 其第二个参数可以获取该item的状态, 这个参数为 QStyleOptionGraphicsItem 类型, 其可以测试 QStyle::State_Selected 来判断是否选中了该item.
* QStyleOptionGraphicsItem是一个不经常使用的类, 提供了几个公有成员变量,
	- 如当前layout方向, 字体metrics, palette, 矩形, 状态(是否选中, "是否有焦点", 以及其他), 转换矩阵, 以及细节层次Lod,
* 重新实现 QGraphicsItem::itemChange, 当项目变化时作出一些反应
* 当用户拖动一个节点(node)时, 调用 itemChange() 处理函数, 其第一个参数为 ItemPositionHasChanged. 
* QInputDialog::getText() 输入对话框. 
* QGraphicsItem::mouseDoubleClickEvent() 鼠标双击事件.
* 首先要创建一个 graphics scene, 通过其构造函数指定原点和宽度高度. 而后创建一个graphics view视觉化该场景.
* QGraphicsView::setDragMode() 可以用于设置拖曳模式, 如 QGraphicsView::RubberBandDrag 即为拖曳一个框来选择items.
* 选择的项目可以通过按Ctrl键多选
	- QGraphicsScene 可以发射信号 selectionChanged, 调用addItem 增加item, clearSelection取消选择, selectedItems返回选中项目的列表
	- QGraphicsItem::setSelected() 设置该item的选择状态.
	- QGraphicsItem::setZValue() 设置item的Z值.
	- QGraphicsItem可调用setPos设置位置, setSelected表示选中与否
	- QGraphicsView 可调用removeAction 移除菜单, 调用addAction添加菜单
* QMutableListIterator 用于遍历一个列表; qDeleteAll 用于删除容器所有元素
* QColorDialog::getColor()  调用颜色对话框
* QApplication::clipboard()->setText(str); --- 使用剪贴板
* QApplication::clipboard()->text(); --- 得到剪贴板文本
* QString::split --- 分割字符串为QStringList
* QColor构造函数接受QColor::name()返回的名称.
* QStringList 用mid 得到部分的列表, 用join合起来成一个字符串
* 本节第二个例子
* QGraphicsItem::paint()的第二个参数QStyleOptionGraphicsItem可以获取LOD值.
* 通过设置 ItemIgnoresTransformations 的flag, 可以使得所绘制文本不随场景缩放而缩放文本.
	- QGraphicsScene: setBackgroundBrush设置背景笔刷
	- Lod可以表示为缩放因子, QStyleOptionGraphicsItem::levelOfDetail 表示为其缩放因子
* QGraphicsView派生一个类, 实现特定的特色, 如缩放和使用鼠标滚轮.
	- 调用setDragMode, 可设置拖曳模式, 如 setDragMode(ScrollHandDrag); 支持拖曳滚动.
	- 实现wheelEvent函数, 可实现鼠标滚轮事件. 而后调用QGraphicsView::scale函数实现缩放
* 我们的graphic view有许多的功能, 如可以拖放, 图形iteam可以有tooltip和自定义光标.
* 实现动画的方法:
	- 可通过给项目设置QGraphicsItemAnimations和QTimeLine 来实现动画.
	- 还可以通过从QObject派生创建一个自定义的graphics item子类(多继承), 而后重实现 QObject::timerEvent() 函数, 来实现动画.
    
== 8.5 Printing ==
* 对于Qt来说, 打印和在QWidget, QPixmap, QImage上绘制一样, 由以下步骤组成
	# 创建一个QPrinter作为绘制设备
	# 弹出QPrintDialog, 让用户选择一个打印机并设置一些属性.
	# 创建一个QPainter, 让其对QPrinter进行操作
	# 使用QPainter绘制一个页面
	# 调用QPrinter::newPage() 绘制下一个页面
	# 重复第四步和第五步直至所有页面打印完毕
* 在Windows和Mac OS中, QPrinter使用系统的打印驱动. 在Unix中, 它生成PostScript并将其发送给ip或ipr(或者使用QPrinter::setPrintProgram()发送给程序集)
	- QPrinter也可以通过调用setOutputFromat(QPrinter::PdfFormat)生成PDF文件
	- 通过QPrintDialog的对象调用exec()来执行打印对话框.
	- 可将QPrinter对象作为参数传送给QPainter, 而后QPainter绘制图像实现打印一个图像. drawImage
	- QSize::scale() 缩放一个size到一个大小.
	- QPainter::drawImage() 绘制一个图像.
* 默认情况, QPainter窗口被初始化, 因此printer和屏幕有相同的分辨率(通常为一英寸72到100个点), 使得其很容易重用widget的打印代码用于打印.
* 如果要打印一个graphics view scenes也很简单, 将QPrinter作为第一个参数传送给QGraphicsScene::render()或者QGraphicsView::render().
	- 如果只想绘制场景的一部分, 则将目标矩形(打印页面的位置)和源矩形作为参数发送给render()的可选参数.
* 打印多个页面, 我们可以一次打印一页, 而后调用newPage()到下一页. 这里有个问题, 就是我们可以在每页上打印多少的信息.
* 两个处理打印多页面的方法
	- 我们可以将我们的数据转换成HTML, 而后使用QTextDocument渲染它. QTextDocument是Qt的富文本引擎
	- 手动执行绘制和页面中断
* 富文本方式打印:
{{{c++
	QTextDocument textDocument;
	textDocument.setHtml(html);
	textDocument.print(&printer);
}}}
* 使用Qt::escape() 转换特殊符号为HTML符号, 如 &, <, >
* 本节还演示了如何给一个QStringList进行分页打印. 写了一个函数, 根据高度进行分页
{{{c++
    void PrintWindow::paginate(QPainter *painter, QList<QStringList> *pages,
                            const QStringList &entries)
}}}
	- 在例子中函数 int PrintWindow::entryHeight(QPainter *painter, const QString &entry) 计算每个条目的高度, 其使用 QPainter::boundingRect() 计算垂直高度.
	- 通过QPrintDialog, 用户可以设定拷贝次数, 打印范围, 请求页面顺序(顺序还是反序)
	- 可通过调用QPrintDialog::setEnabledOptions() 来确定哪些选项不能由用户设定
* QPrinter的 fromPage() 和 toPage() 返回用户选择的打印页数.
* QPrinter::numCopies() 则返回用户设置的打印拷贝次数. 由应用程序负责打印拷贝次数.

= Chapter 9 Drag and Drop =
* 拖放是在一个程序内部或者多个不同程序之间转移信息的直观方法. 拖曳另外还提供用于移动和拷贝数据的剪贴板支持.
* 本章节的主要内容: 给一个应用程序添加拖放以及如何处理自定义格式. 如何重用拖放代码来添加剪贴板支持.
	- 拖放代码能够重用两者都用了基于QMimeData类的机制. QMimeData提供了一些格式的数据

== 9.1 Enabling Drag and Drop ==
* 拖放包含两个动作: 拖和放, Qt的Widget可以作为拖的地点, 也可以作为放的地点, 或者两者都是.
	- 本章节第一个例子是一个主窗口有一个QTextEdit, 从桌面或者文件浏览器拖一个文本文件至该应用程序, 而后应用程序加载该文件至QTextEdit
* 重新实现QWidget的两个函数 dragEnterEvent 和 dropEvent
	- QWidget::setAcceptDrops --- 表示是否接受拖放的放
	- 当拖动一个对象至一widget时调用dragEnterEvent函数.
	- QDragEnterEvenet::acceptProposedAction() 可以表示用户可以将该拖曳对象放置到该widget之上.
* QDragEnterEvent::mimeData() 可以得到其QMimeData信息. text/uri-list的MIME类型用于存储一个一致资源标识符(uniform resource identifiers)的列表, 其可以是文件名称, URL, 或者全局资源列表.
	- 由 Internet Assigned Numbers Authority(IANA)来定义这些标准的MIME类型.
	- 由用斜线分隔类型的类型以及子类型组成. 
	- 剪贴板和拖放系统使用MIME类型来标识不同类型的数据.
	- 要查询官方的MIME类型列表可见网址: http://www.iana.org/assignments/media-types/
	- QMimeData::urls() 可以得到QUrls的列表, 用于读取其本地地址, hasFormat得到其格式类型
* 当用户放置一个物体在widget之上时, 调用dropEvent() 处理函数.
	- QMimeData::urls() 获取一个 QUrls的列表.
* 还可实现dragMoveEvent() 和 dragLeaveEvent(), 但大多数程序用不上
* QListWidget用于第二个例子, 实现列表元素的拖放, 五个重实现的事件处理函数:
	- void mousePressEvent(QMouseEvent *event);
	- void mouseMoveEvent(QMouseEvent *event);
	- void dragEnterEvent(QDragEnterEvent *event);
	- void dragMoveEvent(QDragMoveEvent *event);
	- void dropEvent(QDropEvent *event);
* QWidget::setAcceptDrops() --- 设置是否可以接受拖放.
* QApplication::startDragDistance() --- 应用程序允许拖放的最小距离, 一般为四个像素
* QPoint::manhattanLength () --- 计算该向量的 manhattan 长度, 用于快速计算该向量的近似长度
* 实现拖放功能
	- 创建一个QDrag对象, 并调用setMimeData 设置一个 QMimeData 对象
		- 创建一个QMimeData对象, 调用setText设置文本.
		- QMimeData 可以处理许多类型对象的拖放(images, URLs, colors, etc), 以及可以把任意的MIME类型表示成QByteArrays.
	- 调用QDrag::setPixmap 设置当拖放发生时光标上显示的图像
	- QDrag::exec() 启动拖放并进行拖放, 阻塞应用程序直至用户完成拖放或者拖放取消.
		- 其将所支持拖放动作的组合值值作为参数, 如Qt::CopyAction, Qt::MoveAction, Qt::LinkAction
		- 并返回当前所执行的拖放动作. 当没有执行的话则返回 Qt::IgnoreAction
		- 执行什么拖放动作要看源widget和目标widget允许支持什么, 以及当拖放发生时哪些modifier键被按下(Ctrl, Alt, Shift)
	- 在QDrag::exec() 执行之后, Qt拥有拖放对象的所有权, 一般不再需要它以及删除掉它.
	- QDragEnterEvent::source()可以得到拖放的来源widget, QDragEnterEvent::accept() --- 接受拖放, etDropAction() --- 设置拖放动作
	- 重写dragMoveEnter和dragEnter函数, 两者内部代码一致.
	- 重写dropEvent()处理函数处理drop动作.
* 如果我们仅仅想要在应用程序的一个widget内部移动数据, 可以使用mousePressEvent() 和 mouseReleaseEvent() 实现

== 9.2 Supporting Custom Drag Types ==
* 如果想要拖放自定义数据, 我们需要选择以下可选的步骤:
	- 我们可以将任意数据使用QMimeData::setData()保存为QByteArray, 而后使用QMimeData::data() 读取
	- 我们可以实现QMimeData的派生类, 且重新实现 formats() 和 retrieveData()函数 来处理我们的自定义数据类型
	- 为了在单个应用程序的拖放操作, 我们可以实现QMimeData的派生类, 使用我们所需的任意数据结构来保存数据
* 第一个方法不用派生任何类, 但是其有几个缺点: 即便拖放最后没有接受, 我们也需要转转数据类型为 QByteArray. 且如果我们想要很好地提供一些MIME类型与大范围应用程序的交互, 我们则需要多次存储数据(每个MIME类型一次). 如果数据很大, 则其会减缓应用. 
* 第二个和第三个方法则可以避免或者最小化这些的问题, 如果配合使用这两个方法可以让我们完全控制数据
* 第一个例子可以支持的MIME类型有: text/plain, text/html, text/cav, 首先使用第一个方法
	- QMimeData 调用 setText 和 setHtml , setData 存放不同的数据(如 text/csv 类型)
	- setSelectionMode 设置widget的选择模式, 这里使用 QAbstractItemView::SelectionMode 选择模式.
* QMimeData的派生类, 重实现 formats() 和 retrieveData() 方法.
	- formats() 返回支持的格式, 类型为 QStringList. 最好将"最好"的格式放在列表中第一项.
	- retrieveData() 返回给定MIME类型的数据.
	- 不要假定支持某返回MIME类型.	
* 本例中, 我们使用 UTF-8编码来编码CSV文本. 如果我们想要能够确定使用正确的编码, 我们可以使用 text/plain MIME 类型的字符集参数来指定一个显式的编码. 这里有一些例子:
{{{
	text/plain;charset=US-ASCII
	text/plain;charset=ISO-8859-1
	text/plain;charset=Shift_JIS
	text/plain;charset=UTF-8
}}}

== 9.3 Clipboard Handling ==

* QApplication::clipboard() 得到剪贴板 QClipboard对象, 处理该系统对象非常简单: setText, setImage, setPixmap, text, image, pixmap.
* 如果想要通过剪贴板处理许多格式的数据, 我们可以参照上节使用QMimeData完成这个功能. 派生 QMimeData 类, 并重实现一些虚函数.
* 如果我们在拖放过程中已经实现了 QMimeData的派生类, 则自定义的数据可以通过setMimeData和mimeData方法对剪贴板进行读写.
* X11系统, 可以通过点击中间滚轮粘贴一个选择内容. 如果想要实现这个功能, 就需要将 QClipboard::Selection 作为额外的参数传递给各种剪贴板的调用. 例如:
{{{c++
void MyTextEditor::mouseReleaseEvent(QMouseEvent *event)
{
    QClipboard *clipboard = QApplication::clipboard();
    if (event->button() == Qt::MidButton
            && clipboard->supportsSelection()) {
        QString text = clipboard->text(QClipboard::Selection);
        pasteText(text);
    }
}
}}}
* 只有在X11系统上, supportsSelection() 函数才会返回为真.
* 如果你想要当剪贴板内容变化时被通知到, 则让QClipboard::dataChanged() 信号连接至自定义的slot

= Chapter 10 Item View Classes =
* 通过使用 Qt的item view类来处理数据集.
* model-view-controller(MVC)结构.
	- model:表示数据集模型，负责读取和修改数据. 每个数据集类型都有其模型. 但它们给视图都是统一的API接口无需考虑其内部的数据集.
	- view: 向用户显示数据.
	- controller: 用于视图和模型之间的纽带. 转换用户动作为请求浏览或者编辑数据
* 在Qt中, 不使用controller, 而是提供delegate, delegate可以控制如何渲染和编辑一个条目(item), Qt 提供了每个view类型的默认代理, 对于大多数应用来说已经足够了.
* 使用模型-视图结构, 可以在模型中只获取那些显示在视图的数据.  
* 一个模型可以有多个视图, 用户可以以不同的方式与数据交互, 当模型发生变化时, 多个视图会更新内容显示正确的数据.
* 在许多情况下, 我们只需要显示少量的相关条目给用户. 我们可以用一些条目视图类(QListWidget, QTableWidget, QTreeWidget), 以及在这些类中直接放置条目. 在内部, 这些便利类使用自定义模型, 使得items在views上可见.
	- 我们可以使用Qt的视图(QListView, QTableView, QTreeView)连接一个数据模型, 数据模型可以是一个自定义模型或者一个Qt的预定义模型.
	- 如果数据集在数据库中, 可以组合QTableView和QSqlTableModel
    
== 10. 1 Using the Item View Convenience Classes ==
* 使用Qt的item view类的派生类要比定义一个自定义模型简单得多. 当我们不需要分离视图模型时这种方法更加合适.
* QListWidget::setIconSize() 可以设置图标的大小.
* QListWidget, QListWidgetItem
	- QListWidgetItem 有一些 role, 每个role都有其关联的QVariant,
		- 常用的role有 Qt::DisplayRole, Qt::EditRole, Qt::IconRole. 对于这些role还有便利的方法设置和读取数据, 如 setText,setIcon 等函数
		- 我们还可通过Qt::UserRole常量所表示的数字值或者更大的数字值来定义自定义role.
* QDialog 类, 可以重实现done()方法. 当点击OK或者Cancel按钮时会调用该函数
	- 如果我们对ListWidget的条目中的字符串感兴趣的话, 则可以通过两个方法得到: item->data(Qt::DisplayRole).toString() 和 item->text()
	- 缺省情况下, QListWidget为只读属性, 如果我们想要编辑条目, 则使用QAbstractItemView::setEditTriggers() 来设置视图编辑的触发.
		- 例如: QAbstractItemView::AnyKeyPressed 表示用户可以通过键盘输入来开始编辑.
		- 当然我们也可通过编辑按钮(也许为添加和编辑按钮)以及Signals和Slots的连接来处理编辑操作.
* QTableWidget::setHorizontalHeaderLabels 设置列头, 默认情况 QTableWidget 提供一个垂直的头列, 其有行号的标签, 从1开始.
* 缺省情况下 QTableWidget允许编辑, 按下F2或者直接键盘输入内容即可. view中用户所做的虽有改变都会自动地反射至 QTableWidgetItem中.
	- 可通过调用setEditTriggers(QAbstractItemView::NoEditTriggers) 禁止编辑
	- QTableWidget::rowCount() --- 行数
	- QTableWidget::insertRow() --- 插入一行
	- QTableWidget::setItem() --- 设置某个位置的item
	- QTableWidgetItem::setTextAlignment() --- 设置item的对齐方式
	- QTableWidget::setCurrentItem() --- 设置当前item
* QTreeWidget 默认只读
* tree widget的head view 控制 tree 列的大小. 这里设置大小重置模式为 Stretch. 即表示列可以填充可用的空间, 这种模式, 用户或者程序上不能重置列的大小. 
	- QTreeWidget::header()
	- QHeaderView::setResizeMode --- 设置重置大小模式  
	- QTreeWidget::sortByColumn() --- 设置按照哪个列进行排序.
	- QTreeWidget::setFocus() --- 设置焦点.
	- QSettings --- 用于跨平台的应用程序设置
		- beginGroup
		- childGroups
		- childKeys
		- endGroup
	- QTreeWidget
		- invisibleRootItem --- 得到不可见的根项目, 即默认根
		- setFocus
		- setHeaderLabels --- 设置列头的标签
		- sortByColumn        
* 这里简单的方法总结为, 读取整个数据集至item view widget, 使用 item 对象表示数据元素, (如果item可以编辑)可以写回数据源.
        
== 10.2 Using Predefined Models ==
* Qt可用于视图类的预定义模型
	- QStringListModel --- 存储字符串列表.
	- QStandardItemModel --- 存储任意的有层次的数据.
	- QDirModel --- 封装一个本地文件系统.
	- QSqlQueryModel --- 封装SQL的一个结果集.
	- QSqlTableModel --- 封装一个SQL表格.
	- QSqlRelationalTableModel --- 封装一个带foreign keys的SQL表格.
	- QSortFilterProxyModel --- 排序以及或过滤另一个模型.
* QStringListModel
	- setStringList --- 设置模型中的字符串列表
	- stringList --- 返回模型中的字符串列表
	- inserRows --- 插入一些行
	- removeRows --- 移除一些行
* QListView
	- setEditTriggers 设置触发编辑的操作 
	- setModel 设置Model模型
	- setCurrentIndex --- 设置当前的 QModelIndex 对象.
	- edit() --- 进入编辑模式
	- currentIndex --- 返回当前的 QModelIndex 对象.
* QModelIndex
	- row() --- 返回该index所在行.
* QAbstractItemModel
	- insertRows() --- 插入一些行
	- removeRows() --- 删除一些行
* 模型中的每个数据条目都有一个对应的"model index", 有一个QModelIndex对象表示.
	- QModelIndex有三个组成部分: row, column, 和指向该模型的指针. 对于一维列表模型, column通常为0
	- 在模型上实行插入操作, 其会自动反映到视图.
* 使用 QDirModel 类用于实现文件目录对话框. 该对话框可显示文件和目录列表. 其封装了电脑的文件系统, 可显示和隐藏不同的文件属性. 可过滤文件, 进行多种排序.
* QDirModel
	- setReadOnly --- 设置是否只读
	- setSorting --- 设置排序
	- index --- 获取索引
	- rmdir --- 删除一个目录
	- remove --- 删除一个文件
	- mkdir --- 创建一个目录
	- fileInfo --- 获取信息, 比如是目录还是文件.
* QTreeView
	- setModel --- 设置模型
	- header --- 获取头
	- currentIndex 
	- expand --- 展开一个索引
	- scrollTo --- 滚动至该索引
	- resizeColumnToContents --- 使得该列长度符合内容.
* QHeaderView --- 设置头的一些属性
	- setStretchLastSection
	- setSortIndicator
	- setSortIndicatorShown
	- setClickable
* QModelIndex
	- expand --- 展开该目录
	- scrollTo
	- resizeColumnToContents
	- isValid
	- fileInfo
* QFileInfo
	- isDir
* QDir::currentPath() --- 获取当前目录
* QMessageBox::information 用于显示信息
* 最后一个例子, 显示如何使用 QSortFilterProxyModel, 不同于其他预定义Model,该model包装了其他已有mdoel并操作在模型内部和视图之间传递的数据.
	- 通过 QColor::colorNames() 获取颜色名称列表
	- 三个 QRegExp::PatternSyntax 值: QRegExp::RegExp, QRegExp::Wildcard, QRegExp::FixedString.
	- QStringListModel
		- setStringList
	- QSortFilterProxyModel
		- setFilterKeyColumn --- 设置要过滤的列
		- setFilterRegExp --- 设置过滤正则表达式
		- setSourceModel --- 设置源model
	- QListView
		- setEditTriggers
	- QComboBox
		- addItem
	- QRegExp::PatternSyntax
* 首先创建一个 ORegExp::PatternSyntax 对象表示组合框中的当前选项. 而后根据该对象创建一个 QRegExp 对象, 最后 QSortFilterProxyModel 使用该QRegExp对象作为一个参数调用 setFilterRegExp() 方法.
    
== 10.3 Implementing Custom Models ==
* 使用自定义模型, 首先介绍Qt的模型/视图结构的核心概念 
	- 模型中的每个数据元素都有一个model index和一系列属性, 属性称之为roles.
	- 之前我们常见的role有 Qt::DisplayRole 和 Qt::EditRole. 还有一些role用于辅助数据(如Qt::ToolTipRole, Qt::StatusTipRole 和 Qt::WhatsThisRole), 以及控制基本显示属性的role(Qt::FontRole, Qt::TextAlignmentRole, Qt::TextColorRole 和 Qt::BackgroundColorRole)
	- 对于列表(list)模型而言, 唯一相关的索引组成是行号, 通过 QModelIndex::row() 得到.
	- 对于表格(table)模型而言, 唯一相关的索引组成就是行号和列号, 通过 QModeleIndex::row() 和 QModelIndex::column()得到
	- 对于列表和表格模型, 每个元素的父母都是根元素. 该根元素是一个无效的QModelIndex.
	- 对于tree模型而言, 除了顶层元素只有根目录, 其余的都有父母元素, 通过 QModeIndex::parent()得到.
		- 每个元素都有它的role数据, 有零个或多个孩子.
* Qt 提供的模型基类: QAbstractListModel, QAbstractTableModel, QAbstractItemModel. QAbstractItemModel 支持许多的模型, 包括基于递归数据结构的模型. 当使用一维或二维数据集时, QAbstractListModel和QAbstractTableModel类则提供了便利.
* 派生自 QAbstractTableModel --- 提供了一个抽象模型, 可用于派生自定义表格模型.
	- 重写的函数, 必须重写的函数有rowCount(), columnCount(), data(), 本例我们还实现了 headerData().
	- data() 方法实现 --- 在 Display Role 中, 根据Index获取行号和列号所对应的货币种类, 而后得到两者的货币汇率比.
	- 可以通过字符串控制显示的浮点数格式.
	- headerData() 可以用于设置头行或头列的显示.
	- QAbstractItemModel::reset() 告知那些正在使用model的view, 其数据已经失效, 需要重新请求数据.
	- index() 和 parent()由QAbstractTabelMode缺省实现.
	- 下面函数的实现注意一些情况, 主要是是能够更新视图.
		- insertRows() --- 必须在插入新的一行之前调用 beginInsertRows(), 在之后调用 endInsertRows()
		- insertColumns() --- 必须在插入新的一行之前调用 beginInsertColumns(), 在之后调用 endInsertColumns()
		- removeRows() --- 必须在删除一行之前调用 beginRemoveRows(), 在之后调用 endRemoveRows()
		- removeColumns() --- 必须在删除一行之前调用 beginRemoveColumns(), 在之后调用 endRemoveColumns()
* 抽象模型类
	- 继承关系: QObject ---> QAbstractItemModel ---> (QAbstractListModel, QAbstractTableModel)
	- 对于只读表格模型, 我们必须实现三个函数 rowCount(), columnCount(), data(), 本例还实现了 headerData()
	- 对于 rowCount, columnCount函数来说, 在QAbstractTableMset guifont=Bitstream_Vera_Sans_Mono:h11:cANSIodel中, 其函数参数parent没意义
	- QModelIndex可通过方法 row(), column()获得行序号和列序号
	- 当放置行和列的头时会调用headerData() 函数, 第一个参数为行和列序号.
	- QAbstractItemModel::reset() 用于告知所有使用模型的视图它们的数据是无效的, 强迫它们更新数据.
* 第二个例子, 增加了几个函数的实现, 如setData()和flags()
	- 如果需要编辑模式则还要实现 QAbstractTableModel::setData(), 以及 QAbstractTableModel::flags()用于返返回 Qt::ItemIsEditable内的值
	- 当用户编辑item时, 会调用 setData() 函数, 如提供的模型索引有效, 两个城市为不同城市, 要修改的数据元素的role为 Qt::EditRole, 则该函数存储用户输入的值至distances vector中.
	- QAbstractItemModel::createIndex 根据列号和行号创建一个索引. 这里是在对角线的另一端创建一个相同两个城市的索引.
	- 当模型索引的item发生变化时, 我们发送 dataChanged() 信号.
	- 重写flags()方法, 用于告知item可以做什么. 默认实现为 Qt::ItemIsSelectable | Qt::ItemIsEnabled. 本例则在非对角线的位置上添加 flag Qt::ItemIsEditable.
	- setData() 方法返回true或者false来表示编辑是否成功.
	- QVector::resize() 重置大小, QVector::fill() 填充
	- QAbstractItemModel::reset() 通知view它们的可见item必须重新进行获取.
	- qSwap() 交换两个变量. 
* 最后一个例子展示一个指定布尔表达式的分析树. 一个布尔表达式不但是简单字符数字的标识符, 如"bravo", 同时使用"&&", "||", "!"操作符还有括号的简单表达式构造出一个复杂的表达式. 如 "a || (b && !c)".
* 布尔分析器应用程序由四个类组成:
	- BooleanWindow 是一个可以让用户输入布尔表达式及显示对应分析树的窗口.
	- BooleanParser 从一个布尔表达式生成一个分析树
	- BooleanModel 是封装一个分析树的一个树模型
	- Node 在一个分析树中表示一个item
* 代码
	- 每个节点都有一个类型名, 一个字符串(也许为空), 一个父节点(也许为空), 一个子节点列表(也许为空).
	- qDeleteAll() 用于删除一个容器指针. 该函数不会设置这些指针为0, 如避免在析构函数外部误用, 最好使用clear() 方法
	- 本例使用QAbstractItemModel, 可以实现一个有等级关系的模型, 此次还需要实现index()和parent()
	- setRootNode() 函数用来设置根节点.
	- 重实现index() 函数. 当为某个子item(或者父item为无效QModelIndex的顶层item)创建一个 QModelIndex 时调用该函数. 对于表格和列表模型, 我们不需要重实现该方法, 因为 QAbstractListModel 和 QAbstractTableModel的默认实现足够了.
	- 我们可以在 QModelIndex 中存储一个内部节点的指针. QModelIndex 让我们可以存储一个void*指针或者表示列号行号的整数值.
{{{c++
	return static_cast<Node *>(index.internalPointer());
}}}
	- 获取父节点的QModelIndex需要知道父节点的row, 即相对于祖父节点的row.
	- QTreeView 类没有垂直的头列.
* 为了发现和解决自定义数据模型的问题, 可以使用Trolltech Labs的 ModelTest 类. 
    
== 10.4 Implementing Custom Delegates ==
* 使用delegate渲染和编辑各自的item.
	- 如果我们想要更好的渲染, 可在data()的内部实现中, 处理Qt::FontRole, Qt::TextAlignmentRole, Qt::TextColorRole, Qt::BackgroundColorRole,
	- 如想要更自由的控制, 我们可以实现自己的delegate类.
	- 本例的时间item则划分为分和秒, 并可用QTimeEdit 进行编辑
* 例子
	- 本例的TableWidget不使用默认的deletegate, 而使用自定义的deletgate.
	- TrackDelegate的基类为 QItemDelegate
		- 为了可以编辑数据, 我们必须重新实现createEditor(), setEditorData(), setModelData().
		- 我们也可实现paint()函数改变渲染
		- 在paint()可以使用QItemDelegate::drawDisplay() 和QItemDelegate::drawFocus()函数绘制文本和焦点矩形, 更加方便一些. 当然我们也可以使用QPainter进行绘制.
			- 本例在其中设置了时间格式字符串以及文本的对齐方式.
	- 重写QItemDelegate::createEditor()函数里, 调用 QTimeEditor 设置需要的元素.
		- 其还要连接信号 editingFinished() 至自定义的slot commitAndCloseEditor()
	- slot commitAndCloseEditor() 发送 信号 commitData() 和 closeEditor() 来关闭该编辑器
	- 当用户按下回车键或者移动焦点至QTimeEdit之外(但不包括按下 Esc), 则会发送 eidtingFinished() 信号. 
	- commitData() 用于通知 view, 告知其用编辑的数据替换已有的数据. closeEditor() 信号则用来通知 view 不再需要eidtor, 此时 model 会删除这个eidtor.
	- 当用户按下 Esc 时, view则删除该eidtor.
* Qt 4.4 希望引入 QStyledItemDelegate 类, 并使用它作为默认的代理. 不想 QItemDelegate, QStyledItemDelegate 依赖于绘制其 items 的当前 style.
* 当用户开始编辑时, view调用createEditor()创建一个editor, 而后setEditorData() 使用item的当前数据初始化该editor. 
* 当用户完成编辑(例如, 在editor widget之外左键点击, 或者按下回车或Tab键), 而不是取消时, model 必须更新 editor 的数据. 这里重实现 setModelData() 方法.
* 可以创建一个自定义 delegate 以更好地控制对模型中任意item的编辑和渲染. 由于 QModelIndex 可以传送给我们重新实现的 QItemDelegate 函数, 我们可以根据列, 行, 矩形区域, 父节点, 或者它们的任意组合, 甚至单个item, 来进行这些items的编辑和渲染.
* model/view 架构还可以创建自定义的view, 使得其item不以列表, 表格, 或者树的形式渲染. 例如 examples/itemviews/chart 的 Chart 例子. 这个自定义的view 以扇形图标的形式渲染模型数据.
* 相同的模型可以用多个views来查看. 这个架构还支持选择, 即两个或多个views使用相同的模型时, 每个view可以设置有其自己独立的选择, 或者这些选择可以被这些views共享.
* 查看相关 模型/视图 类 http://doc.trolltech.com/4.3/model-view-programming.html
* 查看相关例子 http://doc.trolltech.com/4.3/model-view-programming.html

= Chapter 11 Container Classes =
* 容器类为可以在内存中存储给定类型元素的模板类. Qt提供了它自己的容器类.
	- Qt的顺序容器: QVector<T>, QLinkedList<T>, and QList<T>, 关联容器: QMap<K, T>, QHash<K, T>.
	- 还提供了通用算法用于任意的容器. 例如 qSort() 排序一个顺序容器. qBinaryFind() 而在一个已排序的顺序容器执行二叉查找. 
	- QString 为一个16位Unicode字符串, QByteArray为一8位字符数组. QVariant 为可以存储大多数C++和Qt值类型的类型
    
== 11.1 Sequential Containers ==
* QVector 可以在构造函数中初始化大小, 使用[]操作符给items分配值.
* QVector<T>, 使用append()扩展内容. 或用 << 操作符替代 append() 函数, 可使用 [] 和count() 函数进行遍历
* Vector元素如果创建时没有分配显式的值, 则使用元素其类的默认构造函数. 基本类型和指针类型则初始化为0.
* QLinkedList<T>链表: find()函数, append()函数, insert()函数. 下面的代码为在两个元素间插入一个元素:
{{{c++
QLinkedList<QString> list;
list.append("Clash");
list.append("Ramones");

QLinkedList<QString>::iterator i = list.find("Ramones");
list.insert(i, "Tote Hosen");
}}} 
* QList<T> 顺序容器, 支持随机访问, 它的接口和QVector一样是index-based. 在QList<T>的尾部插入和删除都很快. 就算有1000个items, 在中间进行删除也很快.
* QStringList, 为QList<QString>的派生类.
* QStack<T>, QQueue<T>, QStack<T>有函数push(), pop(), top(). QQueue<T> 有函数enqueue(), dequeue(), head().
* 容器元素的类型可以是基本类型, 如指针, 指针类型, 或者有默认构造函数, 复制构造函数, 分配操作符的类. 满足这些限定的类有 QByteArray, QDateTime, QRegTime, QRegExp, QString, QVariant. 从 QObject派生的类不满足这些限定, 因为它们没有复制构造函数和分配操作符. 实践中我们可以存储QObject类型的指针作为容器元素.
* 容器元素类型可以也是容器, 注意分离两个连续的尖括号＞．
* c++提供的默认复制构造函数和分配操作符会逐元素复制.
* Java风格迭代器更易用. STL风格迭代器可以组合Qt和STL的通用算法, 所以更强大.
* Java风格的迭代器类型有两个: 只读迭代器和读写迭代器. 只读迭代器有QVectorIterator<T>, QLinkedListIterator<T>, QListIterator<T>. 读写迭代器则在它们的名字中加上Mutable, 例如 QMutableVectorIterator<T>.
* 对于 Java风格迭代器要注意的是它们不直接指向元素, 而是位于第一个item之前, 或者最后一个item之后, 或者两个item之间.
	* 遍历, 从列表第一个元素的前一个位置开始. 用容器初始化一个Java风格迭代器, 使用 hasNext() 和 next() 方法进行遍历.
{{{c++
        QList<double> list;
        ...
        QListIterator<double> i(list);
        while (i.hasNext()) {
            do_something(i.next());
        }
}}}
	* 倒退遍历, 从列表最后一个元素的后一个位置开始. 同样适用容器初始化一个迭代器, 而后使用 toBack() 方法将迭代器放置在最后一个item之后. 使用 hasPrevious() 和 previous() 方法进行遍历.
{{{c++
        QListIterator<double> i(list);
        i.toBack();
        while (i.hasPrevious()) {
            do_something(i.previous());
        }
}}}
	* Mutable 迭代器提供当迭代之时进行插入, 修改, 移除元素操作.
{{{c++
        QMutableListIterator<double> i(list);
        while (i.hasNext()) {
            if (i.next() < 0.0)
                i.remove();
        }
}}}
	* remove() 函数则是对刚刚跳过去的元素进行操作. 如next() 和 previous() 跳过去的元素.
{{{c++
        QMutableListIterator<double> i(list);
        i.toBack();
        while (i.hasPrevious()) {
            if (i.previous() < 0.0)
                i.remove();
        }
}}}
	* setValue()函数用于修改该值, 同样是对刚刚跳过去的元素进行操作
{{{c++
        QMutableListIterator<double> i(list);
        while (i.hasNext()) {
            int val = i.next();
            if (val < 0.0)
                i.setValue(-val);
        }
}}}
	* insert() 用于插入, 而后迭代器则位于新的item和之后的item之间.
	* 另有两种STL风格的迭代器: C<T>::iterator 和 C<T>::const_iterator
	* 我们可以使用 ++ 和 -- 操作符将STL风格的迭代器移动至下一个或上一个item. 一元 * 操作符返回当前的 item. 对于 QVector<T>, 迭代器和常量迭代器类型很少做为 T* 和 const T* 的 typedef.
	* 很少的 Qt 函数返回一个容器, 如果我们想要使用一个STL风格的迭代器迭代一个函数的返回容器, 我们必须拷贝该容器, 而后在该拷贝上迭代.
	* 这是因为每一次 QSplitter::sizes() 调用的时候传值方式返回一个新的 QList<int>, 其会自动删除之前调用返回的 QList<int>. 所以下面的操作会有不可预料的行为.
{{{c++
        QList<int> list = splitter->sizes();
}}}
	* 下面代码是错误的
{{{c++
        QList<int>::const_iterator i = splitter->sizes().begin();
}}}
	* 对于Java-style的迭代器, 不需要拷贝, 因为其在内部会实现. 这是因为迭代器在其背后采用一个拷贝, 确保我们总在该函数第一次返回的数据上迭代.
{{{c++
        QListIterator<int> i(splitter->sizes());
        while (i.hasNext()) {
            do_something(i.next());
        }
}}}
* 拷贝的代价并不大, 和拷贝单个指针一样快, 这是由于其隐式的共享. 只有当拷贝中其中一个正在发生改变时才会进行数据的拷贝. 这一切都在背后自动处理. 因此, 隐式共享有时也称为"copy on write".
* Qt 使用隐式共享用于所有的容器及其他许多的类, 包括 QByteArray, QBrush, QFont, QImage, QPixmap, QString. 这使得这些类传值传递时非常有效率, 无论在作为函数参数还是作为函数返回值时.
* 为了尽量使用隐式共享的好处, 这里一些习惯:
	# 当只读访问vector和list的时候, 我们应当尽量使用 at()而不是使用[]访问容器元素. 由于用[]就不知道是进行读还是写操作.
	# 当迭代 STL 风格的容器时. 无论何时我们在非常量的一个容器上调用 begin() 和 end(), 如果数据是共享的, 则Qt强迫发生一个深度拷贝. 为了避免这个无效率的行为, 我们使用常量迭代器, 如 constBegin(), constEnd().
* Qt 提供了一个在顺序容器中迭代items的方法, 即 foreach 循环. 其看起来如下:
{{{c++
QLinkedList<Movie> list;
...
foreach (Movie movie, list) {
    if (movie.title() == "Citizen Kane") {
        std::cout << "Found Citizen Kane" << std::endl;
        break;
    }
}
}}}
* 当进入该循环时, foreach循环自动的进行该容器的拷贝, 并使用该拷贝.
* 隐式共享是如何工作的
	- 数据的共享常在多线程程序中不作为一个选项考虑, 这是因为关联计数中的竞争状况. 而在Qt中, 这不是一个问题, 其内, 容器类使用汇编语言指令执行原子级的关联计数操作. 这个技术Qt使用者可以通过 QSharedData 和 QSharedDataPointer 类来使用.
* 支持break和continue循环语句, 如果循环体由一个语句构成, 则不需要括号. 迭代变量可以定义于循环之外. 如下面的 Movie movie:
{{{c++
QLinkedList<Movie> list;
Movie movie;
...
foreach (movie, list) {
    if (movie.title() == "Citizen Kane") {
        std::cout << "Found Citizen Kane" << std::endl;
        break;
    }
}
}}}
* 在循环之外定义迭代器变量, 这是当容器元素的数据类型拥有一个逗号时唯一的选项. 如 QPair<QString, int>


== 11.2 Associative Containers ==
* 关联容器用于保存任意数量相同的条目, 由关键词索引. Qt 提供了两个主要的关联容器类型 QMap<K, T> 和 QHash<K, T>
* QMap<K, T>数据结构以升序的关键词顺序存储key-value对. 在内部, QMap<K, T>实现为一个 skip-list. 
	- 内部的插入语法是 insert, 也可以用[]
{{{c++
        QMap<QString, int> map;
        map.insert("eins", 1);
        map.insert("sieben", 7);
        map.insert("dreiundzwanzig", 23);

        map["eins"] = 1;
        map["sieben"] = 7;
        map["dreiundzwanzig"] = 23;
}}}
	- 不过使用[]访问的话, 如果没有找到该元素, 会生成一个值为空的条目. 为了避免创建这个值为空的条木, 可以使用value()来访问.
{{{c++
		int val = map.value("dreiundzwanzig");
        
		int seconds = map.value("delay", 30);
        // 这个代码等同于以下代码:
        int seconds = 30;
        if (map.contains("delay"))
            seconds = map.value("delay");    
}}}
* QMap<K, T>中K, T的数据类型可以是基本数据类型如int, double, 指针类型, 或者有一个缺省构造函数, 拷贝构造函数, 分配操作符的类. 另外, K类型必须提供一个 operator<() 方法.
* QMap<K, T> 提供了两个便利函数, keys() 和 values() 返回两个QList列表
* QMap 可以使用 insertMulti() 函数以拥有多个相同关键字的 key-value 对. 
* QMultiMap<K, T> 可以有多个相同的关键词, values(const Key &)的重载函数可以返回该给定关键字的所有值的列表.
{{{c++
	QMultiMap<int, QString> multiMap;
	multiMap.insert(1, "one");
	multiMap.insert(1, "eins");
	multiMap.insert(1, "uno");
            
	QList<QString> vals = multiMap.values(1);
}}}

* QHash<K, T> 与 QMap<K, T> 类似. 但对QHash而言, 其对K的模板类型有不同的要求, 其K的查找比QMap更快, 以及QHash<K, T> 并不是有序排列
	- 对 QHash<K, T>而言, K必须能够提供 operator==() 操作. 以及被qHash()函数支持, 返回一个key的hash值.
	- Qt已经提供了整数类型, 指针, QChar, QString 和 QByteArray类型的qHash()函数.
	- QHash<K, T> 自动分配一个主号用于内部hash表格, 且随插入和移除重置该表格大小.
		- 也可通过调用reserve() 指定其期望存储在hash中的item数量. squeeze() 则根据当前条目数量收缩 hash表
* 一个常用的做法是, 根据我们期望的item最大数量调用 reserve(), 而后插入数据, 如果最后的items数量少于预期, 则调用 squeeze() 最小化内存使用.
	- QHash<K, T> 一般一个关键词对应一个值. 但如想一个关键词有多个值, 可通过调用 insertMulti()函数或者 QMultiHash<K, T>的派生类实现.
* 除了 QHash之外, 还提供了 QCache, QCache<K, T> 用于表示关联至一个关键字的cache对象. 还有QSet<K>容器则只存储关键字.
	- 这两者内部都依赖于 QHash<K, T>, 且对K的类型都有和 QHash<K, T>一样的要求.
* 用 Javs-Style 的迭代器进行遍历, 与顺序容器有些不同, 最主要的不同就是 next() 和 previous() 函数返回的是表示一个 key-value 值对的对象. 可通过 key() 和 value() 方法访问其key和value部分.
{{{c++
        QMap<QString, int> map;
        ...
        int sum = 0;
        QMapIterator<QString, int> i(map);
        while (i.hasNext())
            sum += i.next().value();
}}}
* 如果我们想要同时访问key和value, 我们可以忽略next()和previous()的返回值, 而是用迭代器的key()和value()函数, 这两个操作都是在刚跳过的item上进行.
{{{c++ 
        QMapIterator<QString, int> i(map);
        while (i.hasNext()) {
            i.next();
            if (i.value() > largestValue) {
                largestKey = i.key();
                largestValue = i.value();
            }
        }    
}}}
	- 可变迭代器则通过 setValue() 来修改关联至当前item的值
{{{c++
        QMutableMapIterator<QString, int> i(map);
        while (i.hasNext()) {
            i.next();
            if (i.value() < 0.0)
                i.setValue(-i.value());
        }
}}}
* STL风格的迭代器也提供了 key() 和 value() 函数, 对于非常量的迭代器类型, value() 返回一个非常量的关联, 当我们迭代时, 允许我们改变值.
* foreach 循环同样可以在关联容器上工作, 但只在 key-value 对的value部分上工作. 如果我们想要同时使用items的key和value部分, 我们可以在嵌套的foreach循环中调用keys()和values(const K&)函数.
{{{c++
        QMultiMap<QString, int> map;
        ...
        foreach (QString key, map.keys()) {
            foreach (int value, map.values(key)) {
                do_something(key, value);
            }
        }
}}}

== 11.3 Generic Algorithms ==
*  <QtAlgorithms> 头文件声明了一系列模板函数, 用于实现容器的基本算法, 大部分函数在STL风格迭代器上操作.
* <algorithm> STL头文件提供的更完整的通用算法集可用于Qt容器和STL容器.
	- qFind() 返回该容器内符合查找要求的迭代器指针.
	- qBinaryFind() 算法类似 qFind(), 除了假设其内元素按升序排序, 二叉查找速度更快.
	- qFill() 使用某值填充容器.
{{{c++
        QLinkedList<int> list(10);
        qFill(list.begin(), list.end(), 1009);
}}}
	- qCopy() 从一个容器拷贝至另一个容器.
		- qCopy()还可以用于在相同的容器内复制值, 只要源范围和目标范围不重合.
	- qSort() 排序, 默认升序, 如要想要降序排序, 则使用 qGreater<T>() 作为第三个参数.
{{{c++
        qSort(list.begin(), list.end(), qGreater<int>());
}}}
	- qStableSort() 排序, 类似qSort, 但当两者比较的相同时, 则其顺序排序在比较前后都会保持一致.
	- qDeleteAll() 删除容器内的所有指针, 删除后由于这些元素在容器内显示为悬挂指针,  所以我们通常还要调用clear()清理该元素
{{{c++
        qDeleteAll(list);
        list.clear();
}}}
	- qSwap() 交换两个变量的值
	- <QtGlobal>还有一些有用的函数, 如 qAbs()函数, qMin(), qMax()
    
== 11.4 Strings, Byte Arrays, and Variants ==
* QString , QByteArray, QVariant 这三个类和容器有许多共通的地方, 在一些上下文中可作为容器的另一个选择. 同样和容器一样, 这些类使用隐式共享作为一个内存和速度的优化.
* C++本身提供了两个类型的字符串: 传统的以'\0'为结尾的C风格字符数组, std::string类.
* QString使用16为Unicode值. Unicode包含 ASCII 和 Latin-1和它们的数字值作为一个子集, 
	- 使用QString, 不需要担心是否能分配足够的内存和字符串是否以'\0'结束. QString可看成QChars的容器, 可包含'\0', length()返回整个字符串的大小, 包括'\0'字符.
	- 可用+, +=连接字符串 由于QString自动在字符串数据的尾部预分配内存, 所以重复地扩充字符来构建一个字符串会非常地快. 
{{{c++
QString str = "User: ";
str += userName + "\n";
}}}
	- 也可使用 append()函数实现+=一样的功能
{{{c++
// 使用append()方法的等价代码.
str = "User: ";
str.append(userName);
str.append("\n");
}}}
	- 也可使用sprintf函数来组合字符串: str.sprintf("%s %.1f%%", "perfect competition", 100.0);
		- 这个函数支持和C++库sprintf()函数一样的格式说明符.
	- 也可用arg()来用其他字符串或数字构建新的字符串: str = QString("%1 %2 (%3s-%4s)").arg("permissive").arg("society").arg(1950).arg(1970);
		- arg()的重载可以处理多个数据类型, 一些重载有额外的参数用于控制field width, numerical base, 浮点精度.
		- arg()可处理多个数据类型. 胜过sprintf(), 因为其是类型安全的. 完全支持Unicode. 允许translator重排序"%n"参数. 
	- QString可使用QString::number()将数字转换成字符串, 或者使用setNum()函数
{{{c++
	str = QString::number(59.6);
	str.setNum(59.6);
}}}
	- 其逆操作为 toInt(), toLongLong(), toDouble()
	- 要使用 qDebug() << arg 语法, 则需要包含 <QtDebug> 头文件, 而使用 qDebug("...", arg) 语法则只需要包括任意一个Qt头文件即可.
	- mid()函数用于得到子字符串.
{{{c++
	QString str = "polluter pays principle";
	qDebug() << str.mid(9, 4);
}}}
	- left(), right() 也可以得到子字符串.
	- 我们可以使用indexOf()函数查找字符串是否包含特定字符, 子字符串, 或者正则表达式, 查找失败则返回-1, 可选参数有起始位置和是否大小写敏感.
{{{c++
	QString str = "the middle bit";
	int i = str.indexOf("middle");        
	// 失败的话i为-1
}}}
	- startsWith(), endsWith() 查看字符串的开头或者结尾是否符合要求
{{{c++
	if (url.startsWith("http:") && url.endsWith(".png"))
	...
	// 上面的代码比下面的要简单且快
	if (url.left(5) == "http:" && url.right(4) == ".png")
	...
}}}
	- 如果我们正在比较用户可见的字符串, 可以用 localeAwareCompare().
	- 比较的时候如想忽略大小写, 则调用toUpper() 或 toLower()
	- replace() 字符串替换
{{{c++
	QString str = "a cloudy day";
	str.replace(2, 6, "sunny");
}}}
	- 也可用 remove() 和 insert()
{{{c++
	str.remove(2, 6);
	str.insert(2, "sunny");        
}}}
	- replace()的一个重载版本也可替换所有第一个参数的字符串为第二个参数的字符串.
{{{c++
	str.replace("&", "&amp;");
}}}
	- trimmed() 可以清除字符串开头和末尾的空格符
	- simplified()函数: 清除字符串开头和尾端的空格符, 且将字符串之内的空格符都设置为一个空格
	- split() 可将字符串分割至QStringList, 第二个参数用于表示空的子串是否应保留(默认保留).
	- join() 将QStringList连接成一个字符串
	- 判断一个字符串是否为空: isEmpty() 或者 length()是否等于0
	- QString 可用+连接一个const char*字符串: str += " (1870)";
		- 为了转换一个常量 char * 为一个 QString, 其简单地使用一个 QString 转换, 或者调用函数 fromAscii() 或者 fromLatin1().
	- 为了转换一个QString为一个常量char*, 使用toAscii() 或者 toLatin1() 返回一个 QByteArray. 而后使用QByteArray::data() 或者 QByteArray::constData() 可返回一个const char*
{{{c++
	printf("User: %s\n", str.toAscii().data());
}}}
	- Qt提供 qPrintable()宏 等同于执行序列 toAscii().constData()
{{{c++
	printf("User: %s\n", qPrintable(str));
}}}
	- 当在 QByteArray 上调用 data() 或者 constData() 时, 其返回 QByteArray 对象拥有的字符串. 这意味着我们不需要担心内存泄漏, Qt会自动回收内存. 即我们要小心不要使用该指针太长时间. 如果 QByteArray 并不存储在一个变量中, 其会自动地在语句尾部删除.
* QByteArray 类的API类似 QString, 如left(), right(), mid(), toLower(), toUpper(), trimmed() 和 simplified().
	- QByteArray 常用于存储原生二进制数据和八位编码文本字符串. 一般来说, 我们推荐使用QString处理文本, 因为其支持 Unicode
	- QByteArray 也可支持带'\0'结尾的const char* 字符串. 很容易传递一个 QByteArray 至一个需要常量字符串参数的函数, 也支持在其内部包含'\0'字符
* QVariant 可以用于处理在相同的变量中存储不同类型的数据:
	- 可以保存许多的Qt类型的值: 包括QBrush, QColor, QCursor, QDateTime, QFont, QKeySequence, QPalette, QPen, QPixmap, QPoint, QRect, QRegion, QSize, QString,
	- 还可以保存C++数字的类型如double, int, 容器类型 QMap<QString, QVariant>, QStringList, List<QVariant>.
	- item view 类, 数据库模型, QSetting 扩展地使用 variant. 允许我们读写任意QVariant兼容类型的item数据, 数据库数据, 用户偏好. 
	- 使用QVariant通过嵌套的容器类型值来创建任意复杂的数据结构, 代码如下:
{{{c++
	QMap<QString, QVariant> pearMap;
	pearMap["Standard"] = 1.95;
	pearMap["Organic"] = 2.25;

	QMap<QString, QVariant> fruitMap;
	fruitMap["Orange"] = 2.10;
	fruitMap["Pineapple"] = 3.85;
	fruitMap["Pear"] = pearMap;
}}}
	- 当在一个有variant值的map上迭代时, 我们需要使用 type() 检查一个varian所拥有的类型以作出合适的反应.
	- QVariant被Qt的meta-object系统使用, 且因此是QtCore模块的一部分, 然而, 当我们连接至QtGui模块, QVariant可以存储GUI相关的类型, 如 QColor, QFont, QIcon, QImage, QPixmap
{{{c++
	QIcon icon("open.png");
	QVariant variant = icon;
}}}
	- 为了返回 QVariant中GUI相关类型的值, 我们可以使用 QVariant::value<T>()模板成员函数:
{{{c++
	QIcon icon = variant.value<QIcon>();
}}}
	- value<T>也可用于非GUI数据类型和QVariant之间的转换, 但是我们一般使用 to...() 函数进行转换(如 toString()).
	- QVariant也可以存储自定义类型, 但是需要其有缺省构造函数, 拷贝构造函数. 然后使用 Q_DECLARE_METATYPE()宏注册该类型, 通常在一个头文件中类定义之下使用该宏.
{{{c++
	Q_DECLARE_METATYPE(BusinessCard)
}}}
    - 这允许我们写如下的代码:
{{{c++
	BusinessCard businessCard;
	QVariant variant = QVariant::fromValue(businessCard);
	...
	if (variant.canConvert<BusinessCard>()) {
	BusinessCard card = variant.value<BusinessCard>();
	...
	}
}}}
	- 由于编译器限制, 其不被MSVC6支持, 你可用qVariantFromValue(), qVariantValue<T>(), qVariantCanConvert<T>() 替换
	- 如果自定义类型有<<和>>操作符用于从QDataStream写入和读取,  我们可以使用qRegisterMetaTypeStreamOperators<T>()注册它们.
		- 这样我们可以使用QSetting存储自定义类型的偏好.
		- 如 qRegisterMetaTypeStreamOperators<BusinessCard>("BusinessCard");
* 还有其他容器: QPair<T1, T2>, QBitArray, QVarLengthArray<T, Prealloc>
	- QVarLengthArray<T, Prealloc>是QVector<T>的底层选择, 因为其在栈上预分配内存且不隐式共享, 它的花费少于QVector<T>, 更适合于轻量级的循环.
* 算法: qCopyBackward(), qEqual(). 见文档: http://doc.trolltech.com/4.3/qtalgorithms.html
* 容器的更多细节, 包括时间复杂度和增长策略的信息, 见文档: http://doc.trolltech.com/4.3/containers.html


= Chapter 12 Input/Output =
* Qt 提供了QIODevice类支持I/O, 以及其派生类
	- QFile --- 访问本地文件系统中或者内嵌资源中(in embedde resources)的文件
	- QTemporaryFile --- 在本地文件系统中创建和访问临时文件
	- QBuffer --- 对一个 QByteArray读写数据.
	- QProcess --- 运行外部程序或处理进程间的通讯.
	- QTcpSocket --- 使用TCP在网络上传输一个数据流.
	- QUdpSocket --- 在网络上发送和接收UDP数据报
	- QSslSocket --- 在网络上使用 SSL/TLS 传输一个加密的数据流.
* QProcess, QTcpSocket, QUdpSocket, QSslSocket 为sequential devices, 即数据只能访问一次. 从第一个字节开始连续处理至最后一个字节.
* QFile, QTemporaryFile, QBuffer 为随机访问设备. 在任何位置可以访问任意次数, 用 QIODevice::seek() 函数重新设置文件指针的位置.
* Qt 提供了两个高层stream类用于读取和写入任意I/O设备: QDataStream 用于二进制数据, QTextStream 用于文本.
	- 这些类处理了一些问题, 如字节排序和文本编码, 确保运行于不同的平台或者不同的国家的Qt应用程序可以相互读写文件.
* QFile 访问单个文件很容易. 无论是文件系统中的文件还是嵌入可执行应用中当作资源的文件.
	- Qt还提供了 QDir 和 QFileInfo类, 可以处理目录和其内文件的信息.
* QProcess 允许我们启动外部程序, 并可通过标准输入, 标准输出和标准错误频道与其通讯(cin, cout, cerr)
* 我们可设置外部程序会用到的环境变量和工作目录. 缺省情况下, 通讯是异步的(非堵塞的), 但在一定的操作下也可能堵塞.

== 12.1 Reading and Writing Binary Data ==
* 加载和保存二进制文件最简单的方法是实例化一个QFile, 而后打开文件, 以及通过 QDataStream对象访问.
	- QDataStream提供跨平台的存储格式, 支持基本C++类型(int和double), Qt数据类型, Qt容器. 包括 QByteArray, QFont, QImage, QPixmap, QString, QVariant, 以及 Qt 容器类, 如 QList<T>, QMap<K, T>.
{{{c++
	QImage image("philip.png");

	QMap<QString, QColor> map;
	map.insert("red", Qt::red);
	map.insert("green", Qt::green);
	map.insert("blue", Qt::blue);

	QFile file("facts.dat");
	if (!file.open(QIODevice::WriteOnly)) {
	std::cerr << "Cannot open file for writing: "
		<< qPrintable(file.errorString()) << std::endl;
	return;
	}

	QDataStream out(&file);
	out.setVersion(QDataStream::Qt_4_3);

	out << quint32(0x12345678) << image << map;
}}}
	- qPrintable宏用于QString返回一个const char*, 另一个方法是用QString::toStdString()返回一个std::string, <iostream>有一个这个类型的<<操作符重载.
	- 创建一个QDataStream对象并设置其版本号, 在Qt 4.3中, 最广泛的格式是版本9, 我们可以硬编码常量9或者使用 QDataStream::Qt_4_3 符号名. 
	- 调用 quint32用于确保整数保存为无符号32位整数格式. 为了确保两台电脑之间的交通能力, QDataStream默认标准化为big-endian, 可通过 setByteOrder() 改变字节顺序.
	- 如果我们想要验证实际已被写入的数据, 我们可以调用flush()检查它的返回值(真表示成功).
{{{c++
        quint32 n;
        QImage image;
        QMap<QString, QColor> map;

        QFile file("facts.dat");
        if (!file.open(QIODevice::ReadOnly)) {
            std::cerr << "Cannot open file for reading: "
                      << qPrintable(file.errorString()) << std::endl;
            return;
        }

        QDataStream in(&file);
        in.setVersion(QDataStream::Qt_4_3);

        in >> n >> image >> map;
}}}
	- 该QDataStream调用setVersion, 版本和之前一样, 使用版本号用于确保应用程序可以读取和写入数据
	- 例如当QDataStream存储一个QByteArray时, 第一个32位字节表示后面字节的数量. QDataStream 可用于读取和写入原始数据, 而不使用字节数量的头部分. 使用readRawBytes()和writeRawBytes()方法
	- QDataStream读取时的错误处理也很简单, status()的返回值如为 QDataStream::Ok, QDataStream::ReadPastEnd 或者 QDataStream::ReadCorruptData
	- 当发生错误时, >> 操作符会读取0或者空值. 这表示我们可以随意读取整个文件而不需要担心错误, 只需最后检查一下status()值即可.
	- QDataStream可处理一系列C++和Qt数据类型, 参考文档 http://doc.trolltech.com/4.3/datastreamformat.html
	- 我们也可使用自定义类型, 但需要重载 << 和 >> 操作符.
{{{c++
        class Painting
        {
        public:
            Painting() { myYear = 0; }
            Painting(const QString &title, const QString &artist, int year) {
                myTitle = title;
                myArtist = artist;
                myYear = year;
            }

            void setTitle(const QString &title) { myTitle = title; }
            QString title() const { return myTitle; }
            ...

        private:
            QString myTitle;
            QString myArtist;
            int myYear;
        };

        QDataStream &operator<<(QDataStream &out, const Painting &painting);
        QDataStream &operator>>(QDataStream &in, Painting &painting);
        
        QDataStream &operator<<(QDataStream &out, const Painting &painting)
        {
            out << painting.title() << painting.artist()
                << quint32(painting.year());
            return out;
        }    

        QDataStream &operator>>(QDataStream &in, Painting &painting)
        {
            QString title;
            QString artist;
            quint32 year;

            in >> title >> artist >> year;
            painting = Painting(title, artist, year);
            return in;
        }
}}}
	- 提供自定义数据类型流操作符的一些好处, 其中一个是允许我们使用自定义类型的容器可以流输出输入.
{{{c++
		QList<Painting> paintings = ...;
		out << paintings;

		QList<Painting> paintings;
		in >> paintings;
}}} 
	- 对自定义类型提供流操作的另一个好处就是我们可以将这些类型的值存储为QVariantS, 而后注册该类型qRegisterMetaTypeStreamOperators<T>(), 这样该类型就可以广泛使用, 比如被 QSetting 使用, 具体可见第11章.
	- QDataStream 的读和写注意次序要完全相同. 才能够读出正确的数据. 这是Qt使用者唯一需要负责的事情.
	- QDataStream 我们可以读写标准的二进制格式, 主要是通过在基本类型(quint16 或者 float)上使用流操作符读写标准二进制格式. 或者使用 readRawBytes() 和 writeRawBytes()函数. 如果QDataStream仅仅读写基本的C++数据类型, 那么我们不需要调用setValue()函数
	- QDataStream::Qt_4_3 硬编码, 如果之后的版本有些数据类型发生了变化, 比如QFont增添了新属性, 则该版本的QDataStream则不能保存和读取该新属性.
	- 解决方法:
		- 在文件中保存 QDataStream 版本.
{{{c++
		// 写入:
        QDataStream out(&file);
        out << quint32(MagicNumber) << quint16(out.version());

        // 读出:
        quint32 magic;
        quint16 streamVersion;

        QDataStream in(&file);
        in >> magic >> streamVersion;

        if (magic != MagicNumber) {
            std::cerr << "File is not recognized by this application"
                      << std::endl;
        } else if (streamVersion > in.version()) {
            std::cerr << "File is from a more recent version of the "
                      << "application" << std::endl;
            return false;
        }

        in.setVersion(streamVersion);
}}}
	- 读的时候, QDataStream的版本只能比源数据的大或相等, 否则报错.
	- 魔法数字是一个常量, 用于惟一地标识出文件类型.
	- 如果文件格式包含自己的版本号, 我们可以使用它推导出 stream 版本号, 而非显式存储它. 例如下面我们应用程序的版本为1.3
{{{c++
		QDataStream out(&file);
		out.setVersion(QDataStream::Qt_4_3);
		out << quint32(MagicNumber) << quint16(0x0103);
}}} 
	- 而后基于应用程序的版本号确定QDataStream的版本.
{{{c++
		QDataStream in(&file);
		in >> magic >> appVersion;
		
		if (magic != MagicNumber) {
		    std::cerr << "File is not recognized by this application"
		              << std::endl;
		    return false;
		} else if (appVersion > 0x0103) {
		    std::cerr << "File is from a more recent version of the "
		              << "application" << std::endl;
		    return false;
		}
		
		if (appVersion < 0x0103) {
		    in.setVersion(QDataStream::Qt_3_0);
		} else {
		    in.setVersion(QDataStream::Qt_4_3);
		}
}}} 
* 总的来说, 处理 QDataStream 版本有三个策略: 硬编码版本号, 显示读写版本号, 根据应用程序版本使用不同的硬编码版本. 所有这些策略确保旧版本应用程序所写的数据可以被新版本应用程序读取. 
* 如果我们想一次读写一个文件, 则避免使用QDataStream, 而是用 QIODevice的 write() 和 readAll() 方法
{{{c++
        bool copyFile(const QString &source, const QString &dest)
        {
            QFile sourceFile(source);
            if (!sourceFile.open(QIODevice::ReadOnly))
                return false;

            QFile destFile(dest);
            if (!destFile.open(QIODevice::WriteOnly))
                return false;

            destFile.write(sourceFile.readAll());

            return sourceFile.error() == QFile::NoError
                   && destFile.error() == QFile::NoError;
        }
}}}
	- 调用readAll之后, 源数据的所有内容都被写入 QByteArray, 写入QByteArray 比逐条目存放要用更多的内存. 但其有些优点:
		- 它可以调用 qCompress() 和 qUnCompress() 压缩和解压数据. 另外还可以用进行压缩操作.
		- 另一个选择是使用 Qt 解决方案中的 QtIOCompressor, 一个 QtCompressor 压缩其写的流和解压其读的流. 而不在内存中存储整个文件.
	- 另一个更适合使用QIODevice的场景就是QIODevice可以调用peek()函数返回下一个数据字节而不需要移动设备指针. 其和ungerChar()函数一样"未读取"一个字节. 这一点可以作用在随机访问设备(如文件)以及连续设备(如网络的sockets). 
	- 可以用函数 seek() 设置设备的位置, 该设备需要支持随机访问.
* 二进制文件提供了最通用和最紧密的数据存储方式. QDataStream使得访问二进制数据很容易.

== 12.2 Reading and Writing Text ==
* Qt 提供了 QTextStream类来读写纯文本文件, 或者其他文本格式的文件, 如HTML, XML 和源代码
	- QTextStream 负责 Unicode和系统本地编码以及其他编码的转换. 透明地处理不同操作系统的不同换行符(Window为"\r\n", Unix和Mac都是"\n").
	- QTextStream 使用 16 位QChar类型作为数据的基本单位. 在字符和字符串之外, QTextStream 支持 C++ 的基本数字类型, 其可以与字符串相互转换. 
{{{c++
		QFile file("sf-book.txt");
		if (!file.open(QIODevice::WriteOnly)) {
		    std::cerr << "Cannot open file for writing: "
		              << qPrintable(file.errorString()) << std::endl;
		    return;
		}
		
		QTextStream out(&file);
		out << "Thomas M. Disch: " << 334 << endl;
}}} 
	- 读取的时候则要注意, 其无法分辨出不同的字符串, 而QDataStream则不存在这个问题, 因为其存储一个数据都事先保存其大小.
	- 对于复杂的文件格式, 可能需要一个完全成熟的分析器. 类似的一个分析器可能通过在一个QChar上使用操作符>>逐字符读取数据. 或者使用 QTextStream::readLine() 逐行读取数据. 
	- 对于在整个文本上工作的分析器, 我们可以通过使用 QTextStream::readAll() 读取完整的文件.
	- 默认情况下, QTextStream 使用系统的本地编码(美国和欧洲大部分都为ISO 8859-1 或 ISO 8859-15), 可以用setCodec() 更改, 如: stream.setCodec("UTF-8");
	- UTF-8编码是一个流行的 ASCII-cmpatible 编码, 可以表示完全的Unicode字符集.
	- QTextStream 有一些选项进行设置. 可通过传递一些叫流操作(stream manipulators)的特殊对象, 在流上修改流的状态. 或者通过一些函数进行修改.
		- 设置数字底数(2进制, 8进制...), 大写数字, 十六进制选项. 代码如右: out << showbase << uppercasedigits << hex << 12345678;
		- setIntegerBase(int) --- 设置整数底数. 参数有 0(当读取时基于前缀的自动检测), 2, 8, 10, 16.
		- setNumberFlags(NumerFlags)
			- ShowBase --- 显示前缀, 2("0b"), 8("0"), 16("0x")
			- ForceSign --- 永远在实数中显示符号
			- ForcePoint --- 永远在数字中显示十进制分隔符
			- UppercaseBase --- 使用底数前缀的大写版本
			- UppercaseDigits --- 使用十六进制数的大写字母
		- setRealNumberNotation(RealNumberNotation)
			- FixedNotation --- 定点标记(例如, "0.000123")
			- ScientificNotation --- 科学标记(例如, "1.234568e-04")
			- SmartNotation --- 顶点标记或者科学标记, 看哪个更紧凑
		- setRealNumberPrecision(int)
			- 设置应当生成数字的最大数量(默认为6)
		- setFieldWidth(int)
			- 设置域(field)的最小大小(默认为0)
		- setFieldAlignment(FieldAlignment
			- AlignLeft
			- AlignRight
			- AlignCenter
			- AlignAccountingStyle
		- setPadChar(QChar)
			- 设置用于padding(填充) fields的字符(默认为空格)
	- 可以使用成员函数来设置选项.
{{{c++
	out.setNumberFlags(QTextStream::ShowBase | QTextStream::UppercaseDigits);
	out.setIntegerBase(16);
	out << 12345678;
}}}
	- 和QDataStream 一样, QTextStream 可对 QIODevice的派生类进行操作, 如 QFile, a QTemporaryFile, a QBuffer, a QProcess, a QTcpSocket, a QUdpSocket, a QSslSocket
	- 另外QTextStream还可以直接对QString进行操作
{{{c++
            QString str;
            QTextStream(&str) << oct << 31 << " " << dec << 25 << endl;
}}}
	- 在之前章节中的SpreadSheet例子中, 使用 QTextStream 代替 QDataStream, 可以增加文本的可读性以及更易编辑:
{{{c++
        QTextStream out(&file);
        for (int row = 0; row < RowCount; ++row) {
            for (int column = 0; column < ColumnCount; ++column) {
                QString str = formula(row, column);
                if (!str.isEmpty())
                    out << row << " " << column << " " << str << endl;
            }
        }

        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            QStringList fields = line.split(' ');
            if (fields.size() >= 3) {
                int row = fields.takeFirst().toInt();
                int column = fields.takeFirst().toInt();
                setFormula(row, column, fields.join(' '));
            }
        }
}}}
		- QStringList::takeFirst() 删除第一个元素, 并返回该元素.
		- QTextStream::readLine() 读取一行.
	- QTextStream::atEnd() 是否到了尾部.
	- QTextStream >> QChar 读入一个字符.
	- QTextStream << QChar 写入一个字符.
* 当我们在程序中仅使用 Qt 的工具类时, 我们不需要一个 QApplication 对象. 见网页 http://doc.trolltech.com/4.3/tools.html , 这里有所有工具类的列表. 
* 如果我们的程序是控制台程序, 则其 .pro 文件和GUI应用程序的有所不同. 如下:
{{{
TEMPLATE      = app
QT            = core
CONFIG       += console
CONFIG       -= app_bundle
SOURCES       = tidy.cpp
}}} 
	- 这里仅使用 QtCore 库, 允许窗口上的控制台输出. 不想要Mac OS上一个bundle中的应用生存.
* 为了读写 纯 ASCII 文件或者 ISO 8589-1 文件,  可以直接使用QIODevice的API函数, 而不是使用QTextStream. 且必须在 open() 函数中指定 QIODevice::Text 标志. 
{{{c++
    file.open(QIODevice::WriteOnly | QIODevice::Text); // 注意指定 QIODevice::Text 标志
}}}
	- 当写入时, 这个标志在Windows系统中告知 QIODevice 转换 '\n' 字符为 "\r\n", 当读取时, 这个标志告知设备在所有平台上忽略'\r'字符. 
    
== 12.3 Traversing Directories ==
* QDir 类提供了跨平台的方法, 用于浏览目录和得到文件的信息.
* 下面的代码读取一个目录以及其任意深度子目录中图像文件所占的空间.
{{{c++
	qlonglong imageSpace(const QString &path)
	{
	    QDir dir(path);
	    qlonglong size = 0;

	    QStringList filters;
	    foreach (QByteArray format, QImageReader::supportedImageFormats())
	        filters += "*." + format;

	    foreach (QString file, dir.entryList(filters, QDir::Files))
	        size += QFileInfo(dir, file).size();

	    foreach (QString subDir, dir.entryList(QDir::Dirs
	                                           | QDir::NoDotAndDotDot))
	        size += imageSpace(path + QDir::separator() + subDir);

	    return size;
	}
}}}
* 我们通过使用一个给定的路径创建一个 QDir 对象. 其有可能是当前目录的相对路径或者是绝对路径. 
* QDir::entryList 有两个参数, 第一个问文件名过滤器的列表, 其可以包含 '*' 和 '?' 通配符. 第二个参数用于指定我们想要哪种类型的条目(普通文件, 目录, 驱动器, 等等.).
* 方法 QImageReader::supportedImageFormats() 得到所有QImageReader支持的图像文件格式
* QFileInfo(dir, file) 可以访问文件的属性
* QDir::separator() --- QDir 在所有平台上将'/'看成目录分隔符, 另外, Windows 认定 '\' 为目录分隔符. 我们可以调用静态函数 QDir::toNativeSeparators() 转换斜线为正确的平台专有的分隔符.
* QDir::currentPath(),  QDir::homePath()
* QDir还提供了其他方法: entryInfoList() (返回 QFileInfo 对象的一个列表), rename(), exists(), mkdir(), rmdir().
* QFile提供的静态方法: remove(), exists()
* QFileSystemWatcher类则可监视文件和目录的变化, 发生变化则发送信号directoryChanged(), fileChanged()
    
== 12.4 Embedding Resources ==
* Qt 可以将二进制数据或文本放置在应用可执行文件内部. 可以使用QFile像文件系统的普通文件一样读取嵌入的文件.
* 可通过 rcc 将资源转换成C++代码, 可通过添加下面一行至.qrc文件告知qmake需要包含特定规则运行rcc.
{{{c++
        RESOURCES = myresourcefile.qrc
}}}
	- 该 myresourcefile.qrc 文件是一个XML文件, 是嵌入可执行文件的文件列表.
{{{c++
<RCC>
<qresource>
    <file>datafiles/phone-codes.dat</file>
</qresource>
</RCC>
}}} 
* 在应用程序中, 通过 :/ 路径前缀识别出资源. 在这个例子中, 文件有路径 :/datafiles/phone-codes.dat, 可以使用QFile像其他文件一样读取.
* 内嵌数据的有点: 不会遗失, 可以创建独立的可执行文件(如果也使用静态链接的话). 缺点, 内嵌数据改变时需要替换整个可执行文件, 可执行文件的大小可能更大.
* 资源文件文档见:http://doc.trolltech.com/4.3/resources.html.

== 12.5 Inter-Process Communication ==
* 本例使用的类以私有形式继承 Ui::ConvertDialog 类. 这避免了在 form 函数之外访问该 form 的 widget.
* 由于 Qt Designer 的自动连接机制, on_browseButton_clicked() 自动连接至  Browse button 的点击信号.
* QProcess 可运行外部程序且与其互动, 该类异步工作, 后台完成其工作所以不影响用户界面接口的反映. 当外部程序拥有数据或者完成时发送信号通知我们.
* QProcess的信号
{{{c++
    connect(&process, SIGNAL(readyReadStandardError()),
            this, SLOT(updateOutputTextEdit()));
    connect(&process, SIGNAL(finished(int, QProcess::ExitStatus)),
            this, SLOT(processFinished(int, QProcess::ExitStatus)));
    connect(&process, SIGNAL(error(QProcess::ProcessError)),
            this, SLOT(processError(QProcess::ProcessError)));
}}}
	- 上面三个进程相关的信号.
	- QProcess::start() 启动应用程序, 这用于异步的操作.
	- 启动: process.start("convert", args);
	- QProcess::readAllStandardError() --- 读取该进程标准错误输出的内容
	- QString::fromeLocal8Bit() --- QByteArray 转换至 QString
	- QProcess::CrashExit --- 一个退出状态的枚举值.
* QTemporaryFile 创建一个具有唯一名称的临时文件
* QProcess::execute() 执行外部程序直至程序完成才能够允许用户操作. 这用户同步的操作.
	- 使用execute(), 就不需要signal-slot, 如果你需要更好的控制, 可以仍然使用start()来启动, 而后使用QProcess::waitForStarted()和 QProcess::waitForFinished()来阻塞程序
* 使用 QProcess 访问已存在的功能程序可节省开发时间, 另一种方法是链接提供了已有功能的库.
* 如果使用 QProcess 启动其他的GUI应用程序, 想要在应用程序之间通讯, 则我们可能使用Qt网络类或Windows上的ActiveQt 扩展.
* 如果我们仅仅是想打开用户偏好的浏览器或email客户端, 调用QDesktopServices::openUrl()即可

= Chapter 13 Databases =
* 通过 QSqlDatabase 对象表示一个数据库连接. Qt 使用驱动在不同的数据库 APIs 之间通讯. Qt 的桌面版本包括接下来的驱动:
	- QDB2 --- IBM DB2 版本 7, 以及之后的版本.
	- QIBASE --- Borland InterBase
	- QMYSQL --- MYSQL
	- QOCI --- Oracle (Oracle 的调用接口)
	- QODBC --- ODBC (包括微软的SQL服务器)
	- QPSQL --- PostgreSQL 7.3 以及之后版本
	- QSQLITE --- SQLite 版本3
	- QSQLITE2 --- SQLite 版本2
	- QTDS --- Sybase Adaptive Server
* 由于许可证限制, 不是所有Qt的驱动器都可用于Qt开源版本. 在Qt自身中包含SQL驱动器或者将它们构建为插件.
	- 配置Qt的时候, 我们可以选择在Qt自身内部包含 SQL 驱动或者将驱动构建为插件. Qt 提供了一个 SQLite 数据库, 这是一个 public domain in-process database.
* 当构建 Qt 时就必须允许 SQL 支持. 例如, 可以通过传递 -qt-sql-sqlite 命令行选项给配置脚本或者通过在Qt安装器中设置合适的选项来编译内置的SQLLit支持的Qt.
* QSqlQuery类提供了直接执行SQL语句和处理它们结果的方法. QSqlTableModel 和 QSqlRelationalTableModel 提供了合适的抽象, 可用于避免 SQL 语法的高层数据库接口.

== 13.1 Connecting and Querying ==
* 要执行SQL查询, 首先要建立与数据库的连接, 通常我们在被称之为应用程序启动的单个函数中设置数据库的连接. 代码如下:
{{{c++
    bool createConnection()
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        db.setHostName("mozart.konkordia.edu");
        db.setDatabaseName("musicdb");
        db.setUserName("gbatstone");
        db.setPassword("T17aV44");
        if (!db.open()) {
            QMessageBox::critical(0, QObject::tr("Database Error"),
                                  db.lastError().text());
            return false;
        }
        return true;
    }
}}}
	- 首先, QSqlDatabase::addDatabase() 创建一个QSqlDatabase 对象, 第一个参数表示使用哪个驱动器访问数据库, 这里使用MySQL
	- 接下来, 我们设置数据库host名称, 数据库名称, 用户名称, 密码, 而后调用 open() 函数打开连接.
	- 一旦连接建立起来, 我们可以使用 QSqlQuery 执行任何底下数据库支持的SQL语句.
{{{c++
        QSqlQuery query;
        query.exec("SELECT title, year FROM cd WHERE year >= 1998");
}}}
	- 我们可以通过query的结果集进行浏览
{{{c++
        while (query.next()) {
            QString title = query.value(0).toString();
            int year = query.value(1).toInt();
            std::cerr << qPrintable(title) << ": " << year << std::endl;
        }
}}}
	- QSqlQuery::next()函数可以逐步浏览record set结果, value()函数返回一个域的值, 类型为QVariant.
		- 可以存储在数据库中的不同类型的数据可以映射到对应的C++类型和Qt类型, 且存储于 QVariants 中. 例如 VARCHAR 表示一个字符串, 一个 DATATIME 表示为一个 QDateTime.
	- QSqlQuery() 还提供了其他的方法用于浏览result set: first(), last(), previous(), seek(). 对于某些数据库来说, 这些函数比next()更慢和更费内存.
		- 在调用exec()之前调用QSqlQuery::setForwardOnly(true), 且只用next()浏览结果集, 这样可以优化在大数据集上的操作.
	- 早期我们可以将SQL查询作为参数传递给 QSqlQuery::exec() 函数, 我们也可将SQL语句作为参数传送给QSqlQuery构造函数, 其会立即执行: QSqlQuery query("SELECT title, year FROM cd WHERE year >= 1998");
	- 我们在query上调用isActive()检查错误
{{{c++
        if (!query.isActive())
            QMessageBox::warning(this, tr("Database Error"),
                                 query.lastError().text());
}}}
	- 执行插入操作
{{{c++
        QSqlQuery query("INSERT INTO cd (id, artistid, title, year) "
                        "VALUES (203, 102, 'Living in America', 2002)");
}}}
	- numRowsAffected() 则返回SQL语句影响的行的数目(-1表示错误)
	- 如果我们需要插入大量的record或者我们想要避免将值转换成字符串, 我们可以使用prepare()
		- prepare() 指定一个包含占位符的查询, 而后绑定我们想要插入的值. Qt 支持 Qracle 风格和 ODBC 风格语法的占位符用于所有数据库. 
{{{c++
        QSqlQuery query;
        query.prepare("INSERT INTO cd (id, artistid, title, year) "
                      "VALUES (:id, :artistid, :title, :year)");
        query.bindValue(":id", 203);
        query.bindValue(":artistid", 102);
        query.bindValue(":title", "Living in America");
        query.bindValue(":year", 2002);
        query.exec();
}}}
	- 相同的结果, 使用ODBC风格, 上面使用的是ORACLE风格:
{{{c++
        QSqlQuery query;
        query.prepare("INSERT INTO cd (id, artistid, title, year) "
                      "VALUES (?, ?, ?, ?)");
        query.addBindValue(203);
        query.addBindValue(102);
        query.addBindValue("Living in America");
        query.addBindValue(2002);
        query.exec();
}}}
	- 在调用 exec() 之后, 我们可以调用 bindValue() 或 addBindValue() 绑定新的值, 而后调用 exec() 再次执行有新值的查询.
	- 占位符常用于指定指定二进制数据或包含non-ASCII或non-Latin-1字符的字符串. 在这些场景背后, Qt 使用 Unicode 以及这些支持 Unicode 的数据库和不支持 Unicode 的数据库. Qt 透明地转换字符串为合适的编码.
	- Qt支持 SQL 和数据库 transaction, 对QSqlDatabase对象调用transaction()函数, 而后调用commit()或者rollback()完成这个transaction(业务).
{{{c++
        QSqlDatabase::database().transaction();
        QSqlQuery query;
        query.exec("SELECT id FROM artist WHERE name = 'Gluecifer'");
        if (query.next()) {
            int artistId = query.value(0).toInt();
            query.exec("INSERT INTO cd (id, artistid, title, year) "
                       "VALUES (201, " + QString::number(artistId)
                       + ", 'Riding the Tiger', 1997)");
        }
        QSqlDatabase::database().commit();
}}}
	- QSqlDatabase::database() 函数返回一个 QSqlDatabase 对象表示我们之前在 createConnection() 中创建的连接. 我们可以在该数据库关联的 QSqlDriver 上使用 hasFeature() 测试该数据库是否支持 transactions.
{{{c++
        QSqlDriver *driver = QSqlDatabase::database().driver();
        if (driver->hasFeature(QSqlDriver::Transactions))
            ...
}}}
	- 还可以测试其他的数据库功能, 包括数据库是否支持 BLOBs(binary large objects), Unicode, 和 prepared queries.
	- 调用 QSqlDriver::handle() 和 QSqlResult::handle() 访问数据库底层处理和底层查询结果集处理, 注意这两个函数非常危险, 除非你的确知道你在干什么且非常小心, 可以看他们例子中的文档以及其风险的解释.
	- 如果我们想创建多个连接, 我们可以传递第二个参数一个名称给addDatabase()
{{{c++
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "OTHER");
        db.setHostName("saturn.mcmanamy.edu");
        db.setDatabaseName("starsdb");
        db.setUserName("hilbert");
        db.setPassword("ixtapa7");
}}}
	- 我们可以将这个名称传递给database()函数得到该QSqlDatabase对象的指针
{{{c++
        QSqlDatabase db = QSqlDatabase::database("OTHER");
}}}
	- 为了使用其他连接进行查询, 我们将该QSqlDatabase对象传递给QSqlQuery构造函数
{{{c++
        QSqlQuery query(db);
        query.exec("SELECT id FROM artist WHERE name = 'Mando Diao'");
}}}
	- 多个连接对于同时执行多个transaction非常有用, 由于一个连接只能处理一个活跃的transaction. 当我们使用多个数据库连接时, 我们还可以有一个未命名的连接, 如果没有指定连接, 则 QSqlQuery 将会使用那个连接.
	- QSqlTableModle类 为一高级接口, 允许我们避免使用 raw SQL 执行大多数常见的 SQL 操作(SELECT, INSERT, UPDATE, DELETE). 这个类也可独立地操作一个数据库而不需要任何GUI. 其也可作为用于 QListView 和 QTableView 的一个数据源.
{{{c++
        QSqlTableModel model;
        model.setTable("cd");
        model.setFilter("year >= 1998");
        model.select();
        // 等同于: SELECT * FROM cd WHERE year >= 1998
}}}
	- 通过QSqlTableModel::record() 返回一个record, 通过 value() 访问指定的域
{{{c++
        for (int i = 0; i < model.rowCount(); ++i) {
            QSqlRecord record = model.record(i);
            QString title = record.value("title").toString();
            int year = record.value("year").toInt();
            std::cerr << qPrintable(title) << ": " << year << std::endl;
        }
}}}
	- 或者, value() 最好使用索引值, QSqlRecord::value() 函数的参数为一个域的名称或者一个域的索引, 当在大数据集上操作时, 其建议通过它们的索引指定域.
{{{c++
        int titleIndex = model.record().indexOf("title");
        int yearIndex = model.record().indexOf("year");
        for (int i = 0; i < model.rowCount(); ++i) {
            QSqlRecord record = model.record(i);
            QString title = record.value(titleIndex).toString();
            int year = record.value(yearIndex).toInt();
            std::cerr << qPrintable(title) << ": " << year << std::endl;
        }
}}}
	- 插入一个record, 我们可以调用insertRows()创建空白行, 而后使用setData()设置每个列(域)的值, 最后使用 submitAll() 提交所有的插入操作.
{{{c++
        QSqlTableModel model;
        model.setTable("cd");
        int row = 0;
        model.insertRows(row, 1);
        model.setData(model.index(row, 0), 113);
        model.setData(model.index(row, 1), "Shanghai My Heart");
        model.setData(model.index(row, 2), 224);
        model.setData(model.index(row, 3), 2003);
        model.submitAll();
}}}
	- 在调用 submitAll() 之后, 该record可能移动至不同的行位置, 这一点依赖于表格如何排序. 
	- 对于用于一个SQL模型的标准模型来说, 我们必须调用submitAll() 将任何的变动写入数据库.
	- 为了更新一个记录, 我们首先定位在该 QSqlTableModle 中我们想要修改的记录上(例如, 使用select()方法), 而后我们提取该记录, 更新我们想要改变的域, 以及将我们的改动写入数据库中.
{{{c++
        QSqlTableModel model;
        model.setTable("cd");
        model.setFilter("id = 125");
        model.select();
        if (model.rowCount() == 1) {
            QSqlRecord record = model.record(0);
            record.setValue("title", "Melody A.M.");
            record.setValue("year", record.value("year").toInt() + 1);
            model.setRecord(0, record);
            model.submitAll();
        }
}}}
	- 我们使用 QSqlTableModel::record() 返回一个 record. 我们使用 QSqlRecord::setValue() 修改该record某域的值. 使用 QSqlTableModel::setRecord() 设置了一个record.
	- 我们也可使用setData()实现更新数据, 和对 non-SQL 模型所做的一样, 我们根据给定行和列返回模型的索引.
{{{c++
		model.select();
		if (model.rowCount() == 1) {
		    model.setData(model.index(0, 1), "Melody A.M.");
		    model.setData(model.index(0, 3),
		                  model.data(model.index(0, 3)).toInt() + 1);
		    model.submitAll();
		}
}}}
	- 删除一个 record, removeRows() 的调用第一个参数为要删除的record中第一个record的行号, 第二个参数为要删除的record的数量.
{{{c++
        model.setTable("cd");
        model.setFilter("id = 125");
        model.select();
        if (model.rowCount() == 1) {
            model.removeRows(0, 1);
            model.submitAll();
        }
}}}
	- 或删除所有的记录集:
{{{c++
        model.setTable("cd");
        model.setFilter("year < 1990");
        model.select();
        if (model.rowCount() > 0) {
            model.removeRows(0, model.rowCount());
            model.submitAll();
        }
}}}
* 如果项目要使用 SQL 类, 我们需要在 .pro 文件中加上下面一行.
{{{
		QT += sql
}}} 
    
== 13.2 Viewing Tables ==
* 前一个章节演示 QSqlQuery与QSqlTableModel互动, 这个章节演示在QTableView演示QSqlTableMode
* 模型设置
{{{c++
        model = new QSqlTableModel(this);
        model->setTable("scooter");
        model->setSort(Scooter_Name, Qt::AscendingOrder);
        model->setHeaderData(Scooter_Name, Qt::Horizontal, tr("Name"));
        model->setHeaderData(Scooter_MaxSpeed, Qt::Horizontal, tr("MPH"));
        model->setHeaderData(Scooter_MaxRange, Qt::Horizontal, tr("Miles"));
        model->setHeaderData(Scooter_Weight, Qt::Horizontal, tr("Lbs"));
        model->setHeaderData(Scooter_Description, Qt::Horizontal,
                                tr("Description"));
        model->select();
}}}
	- 使用了 setHeaderData() 设置了自己的列标题.
	- setSort() 设置排序, 通过select() 放置数据.
{{{c++
        view = new QTableView;
        view->setModel(model);
        view->setSelectionMode(QAbstractItemView::SingleSelection);
        view->setSelectionBehavior(QAbstractItemView::SelectRows);
        view->setColumnHidden(Scooter_Id, true);
        view->resizeColumnsToContents();
        view->setEditTriggers(QAbstractItemView::NoEditTriggers);

        QHeaderView *header = view->horizontalHeader();
        header->setStretchLastSection(true);    
}}}
	- QSqlTableModel 间接地从 QAbstractItemModel 派生. 所以其很容易当作 QTableView 的源.
	- QTableView::setSelectionMode, setSelectionBehavior 可以设置其只能选择单行. QTableView::setColumnHindden() 隐藏某一列. QTableView::resizeColumnsToContents() 使列大小满足其内容. QTableView::setEditTriggers() 设置其触发器. QTableView::horizontalHeader() 得到其 QHeaderView 对象. 
	- QHeaderView::setStretchLastSection()
* 用于显示只读表格的一个选择就是使用 QSqlTableModel 的基类, QSqlQueryModel. 这个类提供了 setQuery() 函数. 所以其可能设置复杂的 SQL 查询以提供一个或多个表格特定的view. 例如, 使用 joins.
	- 不像本章节的例子, 许多的数据库都有很多表和外部关键码关联.
	- Qt提供了QSqlRelationalTableModel, 为QSqlTableModel的派生类. 可以显示和编辑带外部关键码表格.
	- QSqlRelationalTableModel 和 QSqlTableModel非常相似, 除了可以添加 QSqlRelation 给模型. 每个QSqlRelation用于每个外键.
	- 在许多情况下, 一个外键有一个ID域和一个名称域, 通过使用一个 QSqlRelationTableModel, 我们可以确保当场景备用对应的ID域是实际使用的ID时, 用户可以看到和改变名称域. 为了正确的作用这一点, 我们必须在用于显示模型的view上设置一个 QSqlRelationalDelegate(或者我们自己的一个自定义派生类)

== 13.3 Editing Records Using Forms ==
* 本例使用了3个表
{{{c++
    CREATE TABLE location (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(40) NOT NULL);

    CREATE TABLE department (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(40) NOT NULL,
        locationid INTEGER NOT NULL,
        FOREIGN KEY (locationid) REFERENCES location);

    CREATE TABLE employee (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(40) NOT NULL,
        departmentid INTEGER NOT NULL,
        extension INTEGER NOT NULL,
        email VARCHAR(40) NOT NULL,
        startdate DATE NOT NULL,
        FOREIGN KEY (departmentid) REFERENCES department);
}}}
* 本例使用 QSqlRelationalTableModel, 而非 QSqlTableModel, 因为我们要使用 foreign keys.
	- QDateWidgetMapper 该类允许我们映射form的一个widget至对应数据模型的某列.
* QDateEdit::setCalendarPopup() --- 让其可以弹出一个日历. QDateEdit::setDateRange() --- 设置日期范围. QDate::currentDate() --- 得到当前日期. QDate::addDays() --- 添加天数得到新的日期.					  
* QLineEdit::setValidator() --- 设置编辑器的格式. QIntValidator 用于验证文本编辑框, 让其只用整数.
* QDialogButtonBox::addButton() --- 根据role添加按钮, 本例有 QDialogButtonBox::ActionRole, AcceptRole.
* 我们使用一个 QSqlRelationalTableModel, 以及设置一个外键关联. setRelation() 根据外键域的索引和一个QSqlRelation设置关联. QSqlRelation 构造函数的参数有外键所在的表格, 外键域名称, 表示该外键域值的显示域的名称.
* QSqlRelationTableModel::relationModel() 可以得到该关联的表格模型.
* QComboBox::setModelColumn() --- 设置显示模型的哪个列. 
* QSqlTableModel::fieldIndex() --- 根据名称得到模型索引. 
* QDataWidgetMapper 反射一个数据库record的域到其映射的widget上. 并反射这些widget做出的变化至数据库中. 我们可以自己负责提交变化, 也可以告诉mapper让其自动提交变化. 这里我们使用 mapper->setSubmitPolicy() 实现.
* 给该mapper其作用的model, 这里 model 有一个外键, 我们必须给其一个 QSqlRelationDelegate, 该 delegate 确保来自 QSqlRelation 的显示列的值显示给用户, 而不是将 raw IDs 显示给用户. 该 delegate 还确保如果用户开始编辑, 虽然组合框显示了display values, 但是 mapper 实际上将对应的索引值(外键)写至数据库. 
* 如果外键关联的表格有大量的records, 则最好创建我们自己的delegate, 且使用它显示一个有查找能力的"值列表", 而不是依赖于 QSqlRelationalTableModel的默认组合框.
* QDataWidgetMapper::addMapping() 添加映射
* QDataWidgetMapper::setCurrentIndex() 设置当前的record
* QDataWidgetMapper::toFirst() 设置第一个record为当前record
* 如果我们使用手动提交策略, 我们可能需要实现我们自己的slot, 在其内我们提交当前的record而后再浏览以避免遗漏修改.
* 在QDataWidgetMapper::submit()之后会遗失当前行. 所以需要事先使用 QDataWidgetMapper::currentIndex() 获取当前行. 另外虽然提交策略为 QDataWidgetMapper::AutoSubmit, 但只有当用户改变焦点之时才会自动提交.
* QSqlRelationalTableModel::insertRow(), QSqlRelationalTableModel::removeRow() 插入和移除行.
* 当删除一行时, 我们需要手动提交删除. 因为自动提交仅应用于records变化时. 最后注意删除的行是否记录的最后一行.
* QDataWidgetMapper 还可用于任意的数据模型, 包括非SQL模型. 另一种方法是使用 QSqlQuery 直接使用数据填充该form, 并更新数据库. 

== 13.4 Presenting Data in Tabular Forms ==
* Employee的model设置过滤器
* 插入一行时, 如果我们想提供默认值, 我们应当在insertRow() 调用之后立刻调用 setData() 函数实现.
* Model还有 beforeInsert() 信号, 其发生在用户编辑之后, 在数据库插入一行之前.
	- 同样, 还有类似的信号 beforeDelete() 和 beforeUpdate().
* 使用 transaction(业务)保证关联完整性.
* 本例使用了: QSqlDatabase::database().transaction(); QSqlDatabase::database().rollback(); QSqlDatabase::database().commit();

= Chapter 14 Multithreading =
* 在本章中, 我们先介绍如何派生QThread, 如何使用QMutex, QSemaphore, QWaitCondition进行同步. 在事件循环中如何进行线程之间的通讯.

== 14.1 Creating Threads ==
* 创建线程
	- 通过派生类QThread, 重实现函数run()来提供多线程.
* 本章节例子:
	- 除了实现run(), 还增加了两个函数 setMessage() 和 stop()
	- volatile 关键字, 可能会在其他线程修改该变量, 如果不用该关键字, 编译器会优化该变量. 导致产生不正确的结果
	- 调用 run() 函数开始执行线程. 离开 run() 函数时终止线程.
	- QThread提供了 terminate()函数, 当线程还在运行的手终止它, 不推荐使用该函数, 其没有给线程任何机会去清理它. 调用start()启动线程.
* QThread::isRunning() 判断是否运行.
* 在 QCloseEvent::accept() 之前使用 QThread::wait() 确保所有线程完全退出, 得到一个干净的状态.
{{{c++
        threadA.stop();
        threadB.stop();
        threadA.wait();
        threadB.wait();
}}}
 
== 14.2 Synchronizing Threads ==
* Qt 提供了以下用于同步的类: QMutex, QReadWriteLock, QSemaphore, QWaitCondition.
* QMutex 类用于保护一个变量或者一段代码在任何时候只有一个线程能够访问它, 函数 lock(), unlock(). tryLock()函数当该mutex已经锁定时立刻返回.
* QMutex 提供了 lock() 函数用于锁定该 mutex. 如果该 mutex 未锁定, 当前线程立即捕获它并锁定它. 否则当前线程就会堵塞直至拥有该mutex的线程解锁这个mutex. 也就是, 当 lock() 的调用返回时, 当前线程拥有该 mutex, 直到它调用 unlock() 为止. QMutex 还提供了 tryLock() 函数, 其当该 mutex 已经锁定时也立即返回.
{{{c++
	void Thread::run()
	{
	    forever {
	        mutex.lock();
	        if (stopped) {
	            stopped = false;
	            mutex.unlock();
	            break;
	        }
	        mutex.unlock();
	
	        std::cerr << qPrintable(messageStr);
	    }
	    std::cerr << std::endl;
	}
	
	void Thread::stop()
	{
	    mutex.lock();
	    stopped = true;
	    mutex.unlock();
	}
}}}
* QMutexLocker 类简化了 mutex 的处理. 其构造函数接受一个 QMutex 作为参数且锁定它. 析构函数解锁该 mutex.
{{{c++
	void Thread::run()
	{
	    forever {
	        {
	            QMutexLocker locker(&mutex);
	            if (stopped) {
	                stopped = false;
	                break;
	            }
	        }
	
	        std::cerr << qPrintable(messageStr);
	    }
	    std::cerr << std::endl;
	}
	
	void Thread::stop()
	{
	    QMutexLocker locker(&mutex);
	    stopped = true;
	}
}}} 
* QReadWriteLock 类允许多个线程同时进行只读访问.
{{{c++
	MyData data;
	QReadWriteLock lock;
	
	void ReaderThread::run()
	{
	    ...
	    lock.lockForRead();
	    access_data_without_modifying_it(&data);
	    lock.unlock();
	    ...
	}
	
	void WriterThread::run()
	{
	    ...
	    lock.lockForWrite();
	    modify_data(&data);
	    lock.unlock();
	    ...
	}
}}} 
	- 我们也可使用 QReaderLocker 和 QWriteLocker 类锁定和解锁一个 QReadWriteLock.
* QSemaphore是 mutexes 另外一个的一般化. 可用于保护一些数量的相同资源.
{{{c++
	QSemaphore semaphore(1);
	semaphore.acquire();
	semaphore.release();

	// 对应 
	QMutex mutex;
	mutex.lock();
	mutex.unlock();
}}}
	- QSemaphore 构造函数可以是任意数字, 表示其控制的资源. 可多次调用 acquire() 获取资源.
	- QSemaphore 其典型应用使用一定大小的共享循环缓存在两个线程之间传输一定大小的数据.
{{{c++
              const int DataSize = 100000;
              const int BufferSize = 4096;
              char buffer[BufferSize];
}}}
	- 这个例子中, 生产者线程将数据写入 buffer 中, 直到写入到 buffer 的尾部, 而后从 buffer 的开头重新开始覆盖已有的数据. 当数据产生之后, 消费者线程读取数据.
	- 这个生产者-消费者的例子其对同步的需要有两重: 如果生产者生成的数据太快, 其会覆写消费者尚未读取的数据; 如果消费者读取数据太快, 其会跳过生产者正在写的数据而读取到垃圾数据.
	- 这里使用两个 QSemaphore 对象解决该问题.
{{{c++
              QSemaphore freeSpace(BufferSize);
              QSemaphore usedSpace(0);
}}}
		- freeSpace semaphore 控制生产者可以填充数据的buffer. usedSpace semaphore 控制消费者可以读取的区域. freeSpace semaphore 初始化为 4096, 即意味着可以请求许多的资源. 
{{{c++
              void Producer::run()
              {
                     for (int i = 0; i < DataSize; ++i) {
                            freeSpace.acquire();
                            buffer[i % BufferSize] = "ACGT"[uint(std::rand()) % 4];
                            usedSpace.release();
                     }
              }
              void Consumer::run()
              {
                     for (int i = 0; i < DataSize; ++i) {
                            usedSpace.acquire();
                            std::cerr << buffer[i % BufferSize];
                            freeSpace.release();
                     }
                     std::cerr << std::endl;
              }
}}}
		- 通过usedSpace和freeSpace的acquire和release实现资源的共享使用
* 解决生产者和消费者同步问题的另一个方法是使用 QWaitCondition 和 QMutex. 当达到某些条件时,  一个 QWaitCondition 允许一个线程唤醒其他的线程.
{{{c++
			const int DataSize = 100000;
			const int BufferSize = 4096;
			char buffer[BufferSize];

			QWaitCondition bufferIsNotFull;
			QWaitCondition bufferIsNotEmpty;
			QMutex mutex;
			int usedSpace = 0;

			void Producer::run()
			{
				for (int i = 0; i < DataSize; ++i) {
					mutex.lock();
					while (usedSpace == BufferSize)
						bufferIsNotFull.wait(&mutex);
					buffer[i % BufferSize] = "ACGT"[uint(std::rand()) % 4];
					++usedSpace;
					bufferIsNotEmpty.wakeAll();
					mutex.unlock();
				}
			}
 
			void Consumer::run()
			{
				for (int i = 0; i < DataSize; ++i) {
					mutex.lock();
					while (usedSpace == 0)
						bufferIsNotEmpty.wait(&mutex);
					std::cerr << buffer[i % BufferSize];
					--usedSpace;
					bufferIsNotFull.wakeAll();
					mutex.unlock();
				}
				std::cerr << std::endl;
			}
}}}
	- 在生产者中, 我们开始检查缓存是否满的, 如果是满的, 我们则等待"缓存不是满的"条件. 当满足这个条件时, 我们写入一个字节至缓存, 增加 usedSpace 技术, 且唤醒任何等待"缓存不是空的"条件为真的线程.
	- 这里我们使用一个 mutex 保护 usedSpace 变量的所有访问. QWaitCondition::wait() 函数可以采用一个锁定的mutex作为它的第一个参数, 表示在阻塞当前线程时解锁该mutex, 在返回时锁定该 mutex.
	- 消费者线程则做完成相反的事情, 其等待"缓存不为空"条件, 且唤醒所有等待"缓存非满"条件的线程.
	- 对于这个例子, 我们可以进行如下的替换:
{{{c++
	while (usedSpace == BufferSize)
    	bufferIsNotFull.wait(&mutex);

	// 替换为
	if (usedSpace == BufferSize) {
    	mutex.unlock();
   		bufferIsNotFull.wait();
    	mutex.lock();
	}
}}} 
	- 然而, 只要我们允许多于一个生产者线程, 很容易打破上面想要的结果. 其他生产者线程可以在wait() 调用之后mutex.lock()语句之前立即捕捉到这个mutex, 而后使得"buffer非满"这个条件再次为假. 所以将 mutex 传递给 QWaitCondition 可以避免其他线程捕捉到该 mutex.
* 到此所有的例子, 我们的线程访问相同的全局变量, 但有些多线程引用需要有个全局变量在不同线程中有不同的值. 即称之为 thread-local storage 或者 thread-specific data. 这里使用 QThreadStorage<T> 类实现.
* QThreadStorage<T> 常用于 caches. 通过在不同线程中有单独的cache, 我们避免锁定, 解锁的花费, 以及可能等待一个 mutex.
{{{c++
       QThreadStorage<QHash<int, double> *> cache;

       void insertIntoCache(int id, double value)
       {
              if (!cache.hasLocalData())
                     cache.setLocalData(new QHash<int, double>);
              cache.localData()->insert(id, value);
       }

       void removeFromCache(int id)
       {
              if (cache.hasLocalData())
                     cache.localData()->remove(id);
       }
}}}
	- 这个 cache 变量每个线程有一个指针指向一个 QHash<int, double>. (因为某些编译器的问题, QThreadStorage中该 template 类型必须是一个指针类型), 第一次我们在一个特定的线程中使用这个cache, hasLocalData() 返回false, 以及我们创建一个 QHash<int, double> 对象.
	- 除了用于 caching, QThreadStorage<T> 可以用于全局错误状态变量(类似于 errno) 以确保一个线程中的修改不会影响其他的线程.
      
== 14.3 Communicating with the Main Thread ==
* 当Qt 应用程序启动之后, 只有一个主线程在运行, 只有主线程才能创建QApplication和QCoreApplication对象, 并调用exec()运行. 而后等待事件和处理事件.
	- 主线程可以创建其他线程, 这些线程之间的通讯可以使用mutexes, read-write locks, semaphores, wait conditions.
	- 但是这些技术不能使用主线程与这些线程之间. 这是因为它们会锁定事件循环和冻结用户界面接口.
	- 解决主线程和辅助线程之间的通讯可以使用signal-slot连接.
		- signal-slot机制同步操作, 即当发送signal的时候立刻调用slot.
		- 然而当我们连接的对象生存在其他线程时, 这个机制就会变成异步. (这个行为可通过QObject::connect()的第五个参数改变)
		- 在背后, 通过分发一个事件实现这些连接. 接收者对象所在线程的事件循环调用该slot. 默认情况下, 一个 QObject 存在于创建它的线程中, 可以通过调用 QObject::moveToThread() 函数改变其所在线程. 
* 例子代码:
{{{c++
    connect(&thread, SIGNAL(transactionStarted(const QString &)),
            statusBar(), SLOT(showMessage(const QString &)));
    connect(&thread, SIGNAL(allTransactionsDone()),
            this, SLOT(allTransactionsDone()));
}}}
	- QThread派生类的构造函数和析构函数都是由主线程调用, run()函数则是在自己的线程内执行.
	- 在基类的析构函数隐式调用之前, 调用 QThread::wait() 函数. 这个例子里构造函数调用了 start() 函数. 当调用 wait() 失败时, 可能会因为此时线程试图访问类成员变量导致崩溃.
	- 该线程类的run函数, 只有接收到EndTransaction才会跳出循环.
* 可以使用 QImage::mirrored() 反转图像.
* QImage的方法:mirrored().
* Qt多线程的监控和等待条件:
       http://doc.trolltech.com/qq/qq21-monitors.html
       http://doc.trolltech.com/qq/qq22-monitors2.html
      
== 14.4 Using Qt's Classes in Secondary Threads ==
* 不同的线程可以同时安全地调用一个函数, 该函数可以说是线程安全的.
	- 如果不同线程在相同的共享数据上并发地调用两个线程安全的函数, 其结果总是定义好的.
	- 当一个类被称为是线程安全的, 即表明不同的线程同时调用它所有的函数时不会互相干扰, 即使它们在同一个对象上进行操作.
	- Qt的线程安全类包括 QMutex, QMutexLocker, QReadWriteLock, QReadLocker, QWriteLocker, QSemaphore, QThreadStorage<T>, QWaitCondition. 以及QThread 的部分API和一些其他的函数都是线程安全的, 特别是 QObject::connect(), QObject::disconnect(), QCoreApplication::postEvent(), QCoreApplication::removePostedEvents().
* 大部分的Qt 非GUI类都满足一个要求: 其是可再进入的(reentrant).
* 一个类是再进入的, 即该类的不同句柄可以同时被不同的线程使用. 然而在不同的线程中访问相同的可再进入对象是不安全的.
* 这种访问应该使用一个 mutex 来保护.
* 在 Qt 参考文档中标记了那些再进入的类.
* 任何没有关联全局或其他共享数据的C++类是再进入的
* QObject是可再进入的, 但是需记住以下内容:
	- 一个QObject的子对象必须在其父对象所在的线程中创建
		- 意味着一个辅助线程中创建的Qbject永远不会把QThread作为该QObject的父系. 因为QThread只能在主线程或者其他辅助线程中创建.
	- 在删除相应的QThread对象之前, 必须删除所有在该辅助线程中创建的QObject.
		- 这个可以在QThread::run()的堆栈中创建对象来实现自动删除.
	- QObject必须在其创建的线程中删除.
		- 如果你需要删除其他线程中的对象, 你可以调用 QObject::deleteLater() 函数来代替, 其分发一个"延迟删除"事件
* 无GUI对象的派生类如 QTimer, QProcess, 和网络类都是可再进入的, 我们可以在任意线程中使用它们. 只要该线程有一个事件循环.
	- 对于辅助线程而言, 可以通过调用QThread::exec()开始事件循环. 或者通过函数 QProcess::waitForFinished() 和 QAbstractSocket::waitForDisconnected()开始事件循环.
Qt 的 GUI 支持构建在底层库上, 由于从这些这些底层库所继承而来的限制. QWidget 和它的派生类都不是再进入的. 其结果就是我们不能直接在辅助线程中调用一个widget的函数.
	- 如果我们想要在辅助线程中改变一个 QLabel 的文本, 我们可以发送一个信号连接至 QLabel::setText() 或者从该线程中调用 QMetaObject::invokeMethod().
{{{c++
	void MyThread::run()
	{
		...
		QMetaObject::invokeMethod(label, SLOT(setText(const QString &)),
		Q_ARG(QString, "Hello"));
		...
	}
}}}
* 许多 Qt 的 non-GUI 类, 包括 QImage, QString, 和容器类, 使用隐式共享作为一个优化技术. 虽然这个优化技术通常使得一个类成为非再进入的, 但在Qt中这不是一个问题, 因为Qt使用原子的汇编语言指令实现线程安全的关联计数, 这样使得 Qt 的隐式共享类是可再进入的类.
* Qt的 QtSql模块也可用于多线程技术, 但其有自身限制, 这些限制每个数据库都有所不同, 可见文档
       http://doc.trolltech.com/4.3/sql-driver.html.
       http://doc.trolltech.com/4.3/threads.html


= Chapter 15 Networking =
* Qt 提供了 QFtp, QHttp类来处理FTP和HTTP. QTcpSocket和QUdpSocket类实现TCP和UDP传输协议.
* TCP 是可靠的面向连接的协议, 在节点之间进行数据流传输. UDP是非可靠的无连接协议, 基于网络节点之间发送的不连续的数据包.
	- 对于服务器, 我们还需要 QTcpServer 类处理进来的TCP连接.
* 可以使用 QSslSocket 代替 QTcpSocket 建立安全的 SSL/TLS 连接.
    
== 15.1 Writing FTP Clients ==
* QFtp 在Qt中实现实现FTP协议的客户方, 其提供了不同的函数执行大多数常用的FTP操作以及可以执行任意的FTP命令.
* QFtp 类是异步工作的, 当我们调用类似 get() 或 put() 的一个函数时其立即返回, 当控制传递回 Qt 的事件处理循环时发生数据传输. 这确保了当 FTP 命令执行时, 用户界面接口对外界有反应.
* 创建一个 QCoreApplication 对象, 而不是创建一个 QApplication 对象, 可以避免链接至 QtGUI 库.
* OCoreApplication::arguments() --- 返回命令行参数, 保存为QStringList格式. 第一个条目为程序名称, 移除所有类似 -style 的Qt参数,
* QUrl 类提供了一个高层接口用于提取 URL 的不同部分, 可以提取它的文件名, 路径, 协议和端口.
* 当QFtp 完成所有请求的处理时, QFtp 会发送 done(bool) 信号. bool 参数指定一个错误是否发生.
* QFile::setFileName(), QFile::open(), QFile::close() --- 打开/关闭一个文件.
* FTP的命令形成队列并在Qt的事件循环中执行, 通过QFtp的 done(bool) 信号指示所有命令的完成. 
* 注意在接受到 QFtp 对象的 done() 信号之后在关闭 QFtp 写入的文件. 这是因为 FTP 命令是异步执行, 有可能在相关函数处理结束后 FTP 命令还在处理中.
* QFtp 提供了一些FTP命令:　connectToHost(), login(), close(), list(), cd(), get(), put(), remove(), mkdir(), rmdir(), rename()  所有这些函数安排了一个 FTP 命令且返回一个 ID 号来标识该命令. 其也有可能控制传输模式(缺省为passive)以及传输类型(缺省为binary).
* 可以使用rawCommand()执行任意的FTP命令. 如: ftp.rawCommand("SITE CHMOD 755 fortune");
* 当开始执行一个命令时, QFtp发送commandStarted(int)信号. 当命令完成时发送commandFinished(int, bool)信号. int参数为命令ID.
* 如果我们对单个命令的过程有兴趣, 我们可以在安排该命令时存储 ID 号. 跟踪 ID 号允许我们对用户提供详细的反馈. 代码如下:
{{{c++
	bool FtpGet::getFile(const QUrl &url)
	{
	    ...
	    connectId = ftp.connectToHost(url.host(), url.port(21));
	    loginId = ftp.login();
	    getId = ftp.get(url.path(), &file);
	    closeId = ftp.close();
	    return true;
	}
	
	void FtpGet::ftpCommandStarted(int id)
	{
	    if (id == connectId) {
	        std::cerr << "Connecting..." << std::endl;
	    } else if (id == loginId) {
	        std::cerr << "Logging in..." << std::endl;
	    ...
	}
}}}
	- 另一个提供反馈信息的方法是使用 stateChanged() 信号. 当连接进入新状态时会发送该信号(QFtp::Connecting, QFtp::Connected, QFtp::LoggedIn, 等).
* 大多数应用中, 我们仅对作为一个整体的命令序列的过程有兴趣. 这种情况, 我们简单地连接 done(bool) 信号. 当命令序列为空时发送该信号.
* listInfo(const QUrlInfo &) 信号 --- 当QFtp需要列出一个目录的表单时遇到每一个文件都会发送该信号.
* 当一个错误发生时, QFtp 自动地清空命令队列, 即意味着如果连接或者登录失败, 则队列中接下来的命令将永远不会执行. 如果我们在错误已经发生之后用相同的 QFtp 对象安排新的命令进入队列, 这些命令则会被安排且被执行.
* 在应用程序的 .pro 文件中, 我们需要使用接下来的行连接至 QtNetwork 库:
{{{
	QT += network
}}} 
* 当我们请求一个目录列出列表表示每个其检索到的文件时 QFtp 发送一个 listInfo(const QUrlInfo &) 信号.
* QDir::mkpath() 创建目录.
* QFtp::cd(), QFtp::list() 设置 QFtp 当前目录和列出该目录下文件. QFtp::list() 会发送 listInfo() 信号.
* QUrlInfo::isFile() 判断是否是一个文件. QUrlInfo::isSymLink() 判断是否是一个符号链接. QUrlInfo::isDir() 判断是否是一个目录. 略过  QUrlInfo::isSymLink() 可以让我们不会进入无限的循环.
	- 如果我们在QFtp的get函数中第二个参数设置为Null, 或者省略该函数, 则当每次有新的数据可以用到时会发送readyRead()信号,
	- 而后可以通过read()和readAll()读取该数据.
* 本例的信号如下, 每个list()结束, 完成该目录, 发送done().
{{{c++
    connectToHost(host, port)
    login()

    cd(directory_1)
    list()
        emit listInfo(file_1_1)
            get(file_1_1)
        emit listInfo(file_1_2)
            get(file_1_2)
        ...
    emit done()
    ...

    cd(directory_N)
    list()
        emit listInfo(file_N_1)
            get(file_N_1)
        emit listInfo(file_N_2)
            get(file_N_2)
        ...
    emit done()
}}}
	- 如果一个目录中有20个文件, 下载到第5个文件出了错误. 剩下的文件则可能不会下载了
		- 解决方法是每个文件使用一次GET命令, 而后等到done(bool), 然后才安排新的GET操作.
		- 我们可以简单地将文件名放入一个 QStringList 中, 而不是立即调用 get(). 且我们在 done(bool)中在QStringList中下一个要下载的文件上调用 get()函数. 信号发送如下:
{{{c++
            connectToHost(host, port)
            login()

            cd(directory_1)
            list()
            ...
            cd(directory_N)
            list()
                emit listInfo(file_1_1)
                emit listInfo(file_1_2)
                ...
                emit listInfo(file_N_1)
                emit listInfo(file_N_2)
                ...
            emit done()

            get(file_1_1)
            emit done()

            get(file_1_2)
            emit done()
            ...

            get(file_N_1)
            emit done()

            get(file_N_2)
            emit done()
            ...
}}}
* 我们还可以每个文件使用一个 QFtp 对象, 其可以让我们通过单独的 FTP 连接平行下载文件, 
* 如果我们不想使用QFile, 而是把内容保存在内存中, 可以使用QBuffer, 其为QIODevice的派生类, 包装了QByteArray. 如
{{{c++
        QBuffer *buffer = new QBuffer;
        buffer->open(QIODevice::WriteOnly);
        ftp.get(urlInfo.name(), buffer);
}}}
* 我们还可以忽略 QFtp::get() 的第二个I/O设备参数, 或者该参数传递了一个空指针. QFtp 类则在每次有一个新数据可用时发送 readyRead() 信号. 且该数据可以使用 read() 或 readAll() 读取.

== 15.2 Writing HTTP Clients ==
* QHttp 类实现了Qt中HTTP的客户方, 提供了许多函数执行普通的HTTP操作, 包括get(), post(), 还提供了发送任意 HTTP 请求的手段. QHttp 类是异步工作的, 当我们调用类似 get() 或 post() 函数时, 该函数立即返回, 随后发生数据传输. 当控制返回到 Qt 的事件循环时, 它确保正在处理HTTP请求时应用程序的界面接口保持对外部的反应. 
* 例子, 构造函数
{{{c++
        HttpGet::HttpGet(QObject *parent)
            : QObject(parent)
        {
              connect(&http, SIGNAL(done(bool)), this, SLOT(httpDone(bool)));
        }
        bool HttpGet::getFile(const QUrl &url)
        {
            if (!url.isValid()) {
                std::cerr << "Error: Invalid URL" << std::endl;
                return false;
            }

            if (url.scheme() != "http") {
                std::cerr << "Error: URL must start with 'http:'" << std::endl;
                return false;
            }

            if (url.path().isEmpty()) {
                std::cerr << "Error: URL has no path" << std::endl;
                return false;
            }

            QString localFileName = QFileInfo(url.path()).fileName();
            if (localFileName.isEmpty())
                localFileName = "httpget.out";

            file.setFileName(localFileName);
            if (!file.open(QIODevice::WriteOnly)) {
                std::cerr << "Error: Cannot write file "
                          << qPrintable(file.fileName()) << ": "
                          << qPrintable(file.errorString()) << std::endl;
                return false;
            }

            http.setHost(url.host(), url.port(80));
            http.get(url.path(), &file);
            http.close();
            return true;
        }
}}}
	- QHttp 的 done() 信号.
	- 同FTP操作, 不需要登录. 仅仅设置host和端口.
	- HTTP 请求被安排成队列且在Qt事件处理循环中异步执行. 通过 QHttp 的 done(bool) 信号指出请求的完成.
{{{c++
        void HttpGet::httpDone(bool error)
        {
            if (error) {
                std::cerr << "Error: " << qPrintable(http.errorString())
                          << std::endl;
            } else {
                std::cerr << "File downloaded as "
                          << qPrintable(file.fileName()) << std::endl;
            }
            file.close();
            emit done();
        }
}}}
	- main代码
{{{c++
        int main(int argc, char *argv[])
        {
            QCoreApplication app(argc, argv);
            QStringList args = QCoreApplication::arguments();

            if (args.count() != 2) {
                std::cerr << "Usage: httpget url" << std::endl
                          << "Example:" << std::endl
                          << "   httpget http://doc.trolltech.com/index.html"
                          << std::endl;
                return 1;
            }

            HttpGet getter;
            if (!getter.getFile(QUrl(args[1])))
                return 1;

            QObject::connect(&getter, SIGNAL(done()), &app, SLOT(quit()));

            return app.exec();
        }
}}}
* QHttp 类提供了许多操作, 如setHost(), get(), post(), head(). 如果一个站点要求验证, 则调用setUser() 设置用户名称和密码
	- QHttp 可以使用一个程序员提供的 socket, 而不是它自己内部的 QTcpSocket. 这使得它可以使用一个安全地 QSslSocket 实现 SSL 或 TLS 上的 HTTP.
	- 为了发送一个 "name = value" 列表至 CGI 脚本, 我们可以使用 post() 函数:
{{{c++
        http.setHost("www.example.com");
        http.post("/cgi/somescript.py", "x=200&y=320", &file);
}}}
	- 我们可以传递的参数有8位字符串或者一个开放的 QIODevice, 例如 QFile.
	- 为了更多的控制, 我们可以使用 request() 函数, 其可以接受一个任意的 HTTP 头和数据.
{{{c++
        QHttpRequestHeader header("POST", "/search.html");
        header.setValue("Host", "www.trolltech.com");
        header.setContentType("application/x-www-form-urlencoded");
        http.setHost("www.trolltech.com");
        http.request(header, "qt-interest=on&search=opengl");
}}}
	- 当开始执行request的时候发送 requestStarted(int)信号, 当request完成的时候发送requestFinished(int, bool) 信号
		- 这些信号内的int参数表示一个请求的标识ID.
	- 如果我们对单个请求的过程有兴趣, 我们在安排请求序列时存储请求 ID 号. 跟踪 ID 号可以让我们提供详细的反馈给用户.
	- 大多数应用中, 我们仅对作为一个整体的命令序列的过程有兴趣. 这种情况, 我们简单地连接 done(bool) 信号. 当命令序列为空时发送该信号.
	- 当一个错误发生时, 自动地清空命令队列, 如果我们在错误已经发生之后用相同的 QHttp 对象安排新的命令进入队列, 这些命令则会如常被安排和发送.

== 15.3 Writing TCP Client–Server Applications ==
* QTcpSocket 和 QTcpServer 类可用于实现TCP客户端和服务器.
	- TCP是大部分应用程序的网络协议的基础, 包括FTP和HTTP, 也可用于自定义协议
	- TCP是面向流的协议. 对于应用程序而言, 就像一个很大的春文件一样. 建立在TCP之上的高层协议可以分为面向行或面向块的.
		- 面向行 --- 每次传输文本的一行, 每行有一个新行终止符.
		- 面向块 --- 每次传输一定数量的二进制数据块, 每块由一个size域组成, 其后有该大小的数据.
	- QTcpSocket间接从QIODevice 派生而来, 所以其可以使用 QDataStream 或 QTextStream 进行读写.
		- 唯一要注意的与读取文件不同的地方, 在我们使用>>操作符之前, 我们要确保已经从管道(peer)中接收到足够的数据. 否则这样做失败时会产生未定义的行为
* QTcpSocket 封装了 TCP 连接.
* buttonBox->button(QDialogButtonBox::Close) --- 得到QDialogButtonBox的一个特定按钮
* tableWidget->verticalHeader()->hide(); --- 隐藏列头.
* QTcpSocket 的几个信号: connected(), disconnected(), readyRead(), error(QAbstractSocket::SocketError)
* 连接至服务器: tcpSocket.connectToHost("tripserver.zugbahn.de", 6178);
	- QTcpSocket::connectToServer() 连接一个服务器.
	- 如想使用本地的HOST, 则可用 QHostAddress::LocalHost
	- onnectToHost是异步的函数, 所以其立即返回, 连接的建立还在其后进行.
	- 连接建立和运行时则会发出 connected() 信号, 建立失败则会发出 error(QAbstractSocket::SocketError) 信号.
	- 本例 connect() 信号会连接至 slot sendRequest()
		- 用户输入的TCP数据
			- quint16 --- 块的大小(字节为单位, 不包括该域)
			- quint8 --- 请求类型(通常为'S')
			- QString --- 本例, 离开城市
			- QString --- 本例, 到达城市
			- QDate --- 到达日期
			- QTime --- 旅行的大概时间
			- quint8 --- 离开('D')或到达('A')
	- 代码示例:
{{{c++
            void TripPlanner::sendRequest()
            {
                QByteArray block;
                QDataStream out(&block, QIODevice::WriteOnly);
                out.setVersion(QDataStream::Qt_4_3);
                out << quint16(0) << quint8('S') << fromComboBox->currentText()
                    << toComboBox->currentText() << dateEdit->date()
                    << timeEdit->time();

                if (departureRadioButton->isChecked()) {
                    out << quint8('D');
                } else {
                    out << quint8('A');
                }
                out.device()->seek(0);
                out << quint16(block.size() - sizeof(quint16));
                tcpSocket.write(block);

                statusLabel->setText(tr("Sending request..."));
            }
}}}
	- 发送请求: tcpSocket.write(block);
* updateTableWidget() slot对应于readyRead()信号, 当QTcpSocket从服务器接收新的数据之时发送该信号.
	- 当接收的大小为0xFFFF表示没有数据可以接收.
	- 接收的数据格式
		- quint16 --- 块的大小(不包括该域)
		- QData --- 离开日期
		- QTime --- 离开时间
		- quint16 --- 时长
		- quint6 --- 变化数量
		- QString --- 火车类型
	- 关闭TCP
		- tcpSocket.close();
	- QDataStream 可以使用 QByteArray 作为 I/O 设备, 我们可以使用 QDataStream::seek() 到达某特定位置. QByteArray::size() 可以得到其大小.
	- QTcpSocket::write() 将块发送给服务器.
	- 当服务器关闭连接时, 会发送给QTcpSocket的disconnected()信号.
	- 使用QTcpSocket的errorString()显示错误信息,  QTcpSocket 的 error(QAbstractSocket::SocketError) 信号.
* QTableWidget::setRowCount() --- 可以设置行数, 如增加一行.
* 当 QTcpSocket 开始从服务器接收新的数据时, 发送 readyRead() 信号.
* 我们也许一次接收一整个块, 或一块的部分, 或者一个又一半的块, 或者所有的块.
* QTcpSocket::close() 关闭一个 socket.
* QTcpSocket 的 disconnected()信号表示服务器关闭连接.
* QTcpSocket::errorString() --- 返回最后一次错误的信息.
* 实现服务器, 服务器由两个类组成: TripServer 和 ClientSocket. TripServer 继承自 QTcpServer, 该类允许我们接收TCP连接.
	- ClientSocket重新实现 QTcpSocket 以及处理单个连接.
	- 任何时候, 只要有客户端正在服务, 则内存中可放置这些数量的 ClientSocket 对象. 当客户端试图连接服务器正在监听的端口时调用该函数.
	- TripServer 重新实现了函数 incomingConnection().
		- 在函数内部, 创建了一个新的 ClientSocket 对象, 其作为该 QTcpServer 的孩子, 当连接终止时会自动删除该对象, 并调用其setSocketDescriptor()函数.
	- 在ClientSocket设置了两个signal-slot连接, 两个信号分别为 readyRead() 和 disconnected().
		- disconnected -- deleteLater(), deleteLater 则是由QObject派生而来的函数, 用于当控制返回到Qt的事件处理循环时删除该对象.
			- 这样确保但连接中断之后会删除该对象.
	- 通过调用QTcpSocket::listen()来实现监听.
* 使用 QByteArray 作为 QDataStream 的 I/O 设备可以让其在写完整个数据后得到其大小, 而后再通过 QTcpSocket 的 write() 函数发送.
* QTcpSocket 函数也可以直接使用 << 操作符发送数据.
* QHostAddress::Any 特殊IP地址 0.0.0.0 可以表示本地 host 上显示的任意 IP interface.
* 一般服务器希望无GUI, 在Qt中有这样的类 QtService
* 本例是使用面向块的, 如果使用面向行的, 则QTcpSocket的 canReadLine() 和 readLine() 函数更简单. 在连接至readyRead()信号的slot 函数中调用这两个函数.
{{{c++
        QStringList lines;
        while (tcpSocket.canReadLine())
            lines.append(tcpSocket.readLine());
}}}
	- 为了发送数据, 我们可在QTcpSocket上使用一个QTextStream.
	- 如果处理许多连接的话, 当有一个请求时, 服务器无法处理其他连接, 应当为每个连接启动一个新线程, 例子见 examples/network/threadedfortuneserver
    
== 15.4 Sending and Receiving UDP Datagrams ==
* QUdpSocket 类用于发送和接收UDP数据报, UDP 是不可靠的, 面向数据包的协议. 使用UDP是因为其比TCP更轻量级.
	- 对于 UDP, 数据被当作包裹(数据包)从一个host发送到另一个host. 没有任何关于连接的概念, 如果一个 UDP 包裹没有派发成功, 则不会有任何错误报告给发送者.
* 使用一个 QUdpSocket 和其他程序通讯.
	- 发送数据:
{{{c++
        void WeatherBalloon::sendDatagram()
        {
            QByteArray datagram;
            QDataStream out(&datagram, QIODevice::WriteOnly);
            out.setVersion(QDataStream::Qt_4_3);
            out << QDateTime::currentDateTime() << temperature() << humidity()
                << altitude();

            udpSocket.writeDatagram(datagram, QHostAddress::LocalHost, 5824);
        }
}}}
	- 发送代码: udpSocket.writeDatagram(datagram, QHostAddress::LocalHost, 5824);
		- 通过 QUdpSocket::writeDatagram() 发送数据包, 第二个参数和第三个参数为IP和端口.
		- QHostAddress::LocalHost 表示本地IP地址 127.0.0.1
* 不想 QTcpSocket::connectToHost, QUdpSocket::writeDatagram 不接受一个 host 名称, 仅接受 host 地址. 如果我们想要解析一个 host 名为其IP地址, 则有两个选择. 假设我们准备在查找发生时堵塞, 则可以使用静态函数 QHostInfo::fromName(), 否则, 我们可以使用静态函数 QHostInfo::lookupHost(), 其会立即返回且当查找完成时其调用该slot, 传递一个包含对应地址的 QHostInfo 对象.
	- 接收UDP数据报, 首先设置signal - slot连接
{{{c++
            connect(&udpSocket, SIGNAL(readyRead()), this, SLOT(processPendingDatagrams()));
}}}
	- 使用 UDP 监听前需要绑定一个端口, 使用函数 QUdpSocket::bind() 实现.
* 通常只有一个数据包, 但我们不排序在 readyRead() 信号之前发送了几个数据包. 这里我们可以忽略所有的数据包, 除了最后一个.
	- 使用QUdpSocket的信号 readyRead().
	- 读取数据:
{{{c++
        do {
            datagram.resize(udpSocket.pendingDatagramSize());
            udpSocket.readDatagram(datagram.data(), datagram.size());
        } while (udpSocket.hasPendingDatagrams());
}}}
	- pendingDatagramSize() 函数得到第一个数据报的大小, readDatagram() 读取数据报内容.
* QUdpSocket::writeDatagram() 函数可以传递一个 host 地址和端口号, 所以 QUdpSocket 可以从其通过 bind() 函数绑定的 host 和端口读取. 且写入其他的 host 和端口.


= Chapter 16 XML =
* XML(eXtensible Markup Language)为一通用的文本格式, 用于数据交换和数据存储, 由 W3C开发的轻量级SGML, 语法类似HTML. XML-compliant 版本的 HTML 称之为 XHTML.
	- 对于流行的SVG XML 格式, QtSvg模块提供了类可以加载和渲染SVG图像. QtMmlWidget可以渲染XML格式的MathML. 为了渲染使用 MathML XML 格式的文档, 可以使用 Qt 解决方案中的 QtMmlWidget.
* Qt 4.4 预期包含额外的高层类用于处理 XML, 其包括了 XQuery 和 XPath 的支持, 这些都在单独的 QtXmlPatterns 模块中.
	- 为了通常的XML处理, Qt提供了QtXml模块, 提供了三个不同的APIs读取XML文档
		- QXmlStreamReader 为一快速读取XML的分析器, 用于读取 well-formed XML, 非常适合于写 one-pass 分析器.
		- DOM 转换XML文档为树结构, 应用可以在该树上进行浏览. 可以让我们以任何次序浏览一个表示 XML 文档的树, 允许我们实现 multi-pass 分析算法.
		- SAX(Simple API for XML) 通过虚函数直接向应用程序报告"分析事件".
	- 为了写XML文件, Qt提供了三个选项:
		- 我们可以使用QXmlStreamWriter, 最简单的方法, 比手动生成的XML更可靠.
		- 我们可以在内存中把数据表示成DOM树, 且要求该树将其自身写入文件, 当一个 DOM 树已经用于当作应用程序的主数据结构, 使用 DOM 生成 XML 更合理.
		- 手动生成XML文件

== 16.1 Reading XML with QXmlStreamReader ==
* 使用 QXmalStreamReader 是 Qt 中读取 XML 最快和最简单的方法. 因为分析器是增量地工作(works incrementally), 对于以下几个地方很有用, (1)在一个 XML 文档上发现给定 tag 的所有位置. (2) 读取也许不适合在内存中的非常大的文件. (3)用于防治自定义数据结构以反映一个 XML 文档的内容. 
* QXmlStreamReader 分析器以图16.1中列出的token来工作. 每次调用 readNext() 函数, 读取下一个 token, 并将该 tocken 设置为当前 token. 当前 token 的属性依赖于 token 的类型, 且使用表格中的获取函数来访问.
<br />
| Token Type            | Example        | Getter Functions                                              |
|-----------------------|----------------|---------------------------------------------------------------|
| StartDocument         | N/A            | isStandaloneDocument                                          |
| EndDocument           | N/A            | isStandaloneDocument                                          |
| StartElement          | <item>         | namespaceUri(), name(), attributes(), namespaceDeclarations() |
| EndElement            | </item>        | namespaceUri(), name()                                        |
| Characters            | AT&amp;T       | text(), isWhitespace(), isCDATA()                             |
| Comment               | <!-- fix -->   | text()                                                        |
| DTD                   | <!DOCTYPE ...> | text(), notationDeclarations(), entityDeclarations()          |
| EntityReference       | &trade;        | name(), text()                                                |
| ProcessingInstruction | <?alert?       | processingInstructionTarget(), processingInstructionData()    |
| Invalid               | >&<!           | error(), errorString()                                        |
<br />
	- 例子:
{{{c++
        <doc>
            <quote>Einmal ist keinmal</quote>
        </doc>
}}}
	- 使用readNext() 每次可以产生一个新的token, 而后使用 getter 函数得到额外的信息.
{{{c++
        StartDocument
        StartElement (name() == "doc")
        StartElement (name() == "quote")
        Characters (text() == "Einmal ist keinmal")
        EndElement (name() == "quote")
        EndElement (name() == "doc")
        EndDocument
}}}
	- 在每个readNext()之后, 我们可以使用 isStartElement(), isCharacters(), 或类似函数进行测试, 或者使用state()函数
* 例子
	- 使用readFile()函数读取XML文件, 其进行递归下降
		- readBookindexElement() 分析 <bookindex>...</bookindex> 元素
		- readEntryElement() 分析 <entry>...</entry> 元素
		- readPageElement() 分析 <page>...</page>元素
		- skipUnknownElement() 跳过不认识的元素
	- QXmlStreamReader::setDevice() 设置该XML流的输入文本
		- reader.setDevice(&file);
	- 开始读取
		- reader.readNext();
		- reader.atEnd() --- 判断是否到尾部
	- 在循环中只有三种状态: 读到<bookindex> 启动tag, 其他启动tag, 其他的token.
	- QXmlStreamReader::raiseError() 报错误, 其到达XML文件尾部. 可调用error()或者QFile的errorString()查看错误信息.
	- reader.hasError() --- 判断是否有错误.
* QTreeWidget::invisibleRootItem() 是 QTreeWidget 的根 item.
* QXmlStreamReader.attributes() --- 得到当前 token 的属性.					  
* QXmlStreamReader::readElementText() 读取元素文本
* QXmlStreamReader::raiseError() 提出一个错误, 下次调用 atEnd() 时其返回真. 可以通过调用 error() 和在 QFile 上调用 errorString() 来查询错误.
	- raiseError() 函数让我们对底层的XML分析错误使用相同的错误报告机制, 即当 QXmlStreamReader 运行一个无效的XML或者有应用程序特定的错误时自动引发该错误.
* Q_ASSERT 用于提示错误
	- QXmlStreamReader 可以从任意QIODevice读取XML文件, 如QFile, QBuffer, QTcpSocket.
* 一个 QXmlStreamReader 可以采用任意 QIODevice 的输入, 包括 QFile, QBuffer, QProcess, QTcpSocket. 一些输入元也许不能够在分析器需要时提供其需要的数据. 例如, 由于网络的延迟, 它可能使用 QXmlStreamReader 在这样的网络环境; 关于这个主题的更多信息可见关于 QXmlStreamReader 的参考文档中的"Incremential Parsing".
* QXmlStreamReader 类属于 QtXml 库的一部分.
    
== 16.2 Reading XML with DOM ==
* DOM 是一个由W3C开发用于分析 XML 的标准API. Qt 提供了一个 non-validating DOM Level2 的实现用于读取, 操作, 和写入XML文档.
* DOM 表示一个 XML 文件为内存中的一棵树. 我们可以通过 DOM 树进行浏览, 我们可以修改该树并将其保存至硬盘内的XML文件.
	- 见文档:
{{{c++
        <doc>
            <quote>Scio me nihil scire</quote>
            <translation>I know that I know nothing</translation>
        </doc>
    DOM树
        Document
            |
            ---Element(doc)
                |
                ---Element(quote)
                |    |
                |    ---Text("Scio me nihil scire")
                ---Element(translation)
                    |
                    ---Text("I know that I know nothing")
}}}
	- 对DOM来说, Elment节点表示有相互对应封闭的tag, 在Qt中, 节点类型都有一个QDom前缀, QDomElement表示一个Element节点, QDomText表一个Text节点
	- 不同类型的节点可拥有不同类型的子节点,
		- 例如: Element节点可以包含其他Element, 以及 EntityReference, Text, CDATASection, ProcessingInstruction, 普通节点
	- 图16.3表示哪些节点可拥有哪种类型子节点, 灰色的表示不能拥有子节点.
* 例子
* QDomDocument::setContent(), QDomDocument::documentElement(), QDomElement
* QDomDocument::setContent() 函数自动打开设备(当设备未打开时). 其第二个参数设置为false表示禁止namespace的处理
* QDomDocument::documentElement() 得到单个 QDomElement 的孩子. 
* QDomElement::firstChild() 得到其第一个孩子. QDomNode::isNull() 是否空, QDomNode::toElement 转换其为一个 QDomElement, 而后调用它的 tagName() 得到该元素的 tag 名. 如果该节点不是 Element 类型, 则 toElement() 函数返回一个空的 QDomElement 对象, 以及一个空的 tag 名.
* QDomElement::attribute(), QDomElement::text() 得到该元素的属性, 文本.
    
== 16.3 Reading XML with SAX ==
* SAX 是一个公共的 domain de facto 标准 API 用于读取 XML 文档. Qt 的 SAX 类在 SAX2 Java 实现之后建模, 主要的不同就是命名匹配 Qt 的惯例. 和 DOM 比较, SAX 更底层且更快. 但 QXmlStreamReader 类提供了更像 Qt 的API且更快. 所以 SAX 分析器的主要用途是将使用 SAX API 的代码引入 Qt.
* Qt 提供一个基于SAX的无验证的XML分析器称之为 QXmlSimpleReader, 这个分析器可以识别 well-formed XML 且支持 XML namespaces. 当分析器经过文档时, 其调用注册处理类(registered handler classes)中的虚函数指出处理的事件(indicate parsing events).
* SAX分析器常用于将SAX API转至Qt. 如需更多的SAX信息, 见网页 http://www.saxproject.org/
	- Qt提供了类 QXmlSimpleReadere, 基于SAX的XML分析器
	- 假设分析一下文档:
{{{c++
        <doc>
            <quote>Gnothi seauton</quote>
        </doc>
}}}
	- 则分析器会调用以下分析事件处理函数
{{{c++
        startDocument()
        startElement("doc")
        startElement("quote")
        characters("Gnothi seauton")
        endElement("quote")
        endElement("doc")
        endDocument()
}}}
	- 这些处理函数都在QXmlContentHandler中声明. 这里为了简化, 我们略过了 startElement() 和 endElement() 的一些参数.
	- QXmlContentHandler 仅仅是许多处理类中的一个, 这些处理类可以连接至 QXmlSimpleReader.
		- 其他类有QXmlEntityResolver, QXmlDTDHandler, QXmlErrorHandler, QXmlDeclHandler, QXmlLexicalHandler
		- 这些类仅仅声明虚函数, 并给出不同类型分析事件的信息. 对于大多数程序来说, 仅需要 QXmlContentHandler 和 QXmlErrorHandler.
		- 这些类的层次可见图 16.4, 基类为 SaxHandler, 而后派生 QXmlDefaultHandler, 最后派生出上面众多处理类.
* 最主要的不同是使用 SAX API 和 QXmlStreamReader, SAX API 要求我们使用成员变量手动跟踪分析器的状态, 这一点在其他2个应用都不需要, 因为它们可以允许递归下降.
* 例子, 使用 QXmlSimpleReader 和 QXmlDefaultHandler 派生类处理.
	- 继承自 QXmlDefaultHandler, 重实现四个函数: startElement(), endElement(), characters(), fatalError(). 前三个函数在QXmlContentHandler中声明. 最后一个函数则在QXmlErrorHandler中声明.
	- 在readFile函数中
		- 创建一个QXmlInputSource 读取XML文件内容, 而后调用QXmlSimpleReader::parse分析该QXmlInputSource.
			- 并调用setContentHandler和setErrorHandler设置其处理函数, 本类中实现了这两个函数.
			- 本类仅重实现了来自 QXmlContentHandler 和 QXmlErrorHandler 类的函数, 如果我们要处理来自其他处理类的函数, 则我们需要调用对应的 setXxxHandler() 函数.
		- 在parse() 函数中, 我们传递了一个 QXmlInpuSource 对象, 这个类打开给定的文件, 读取它并提供了一个分析器用于读取文件的接口.
	- startElement() 函数在遇到一个新的开放 tag 时调用, 第三个参数为 tag 名, 第四个参数为属性列表, 忽略第一个和第二个参数, 其用于 XML 的 namespace 机制.
		- 该函数返回 true 表示继续分析这个文件, 如果我们想要将未知的 tags 报告为错误, 我们应当在这种情况中返回 false. 我们可能想要重实现来自 QXmlDefaultHandler 中的 errorString() 以返回合适的错误信息.
		- 当报告XML文档中的字符数据时调用 characters() 函数.
	- 当遇到一个关闭tag的时候会调用endElement()函数, 第三个参数为 tag 的名称.
	- 当分析XML文件发生失败时会调用fatalError函数
	- QXmlParseException::lineNumber(), QXmlParseException::columnNumber() --- 异常的行号和列号. QXmlParseException::message() --- 错误的文本.
        
== 16.4 Writing XML ==
* Qt 应用中三种生成 XML 文件的方法:
	- QXmlStreamWriter
	- 构建一个 DOM 树而后在其上调用 save()
	- 手动生成 XML 文件
* 使用QXmlStreamWriter类写入XML文本, 这个类会负责 escapint special 字符.
	- QXmlStreamWriter::setAutoFormatting() --- 可以让结果数据使用缩进来表示数据的递归结构.					  
	- QXmlStreamWriter::writeStartDocument() 用于写 XML的头行: <?xml version="1.0" encoding="UTF-8"?>
	- QXmlStreamWriter::writeStartElement()  用于生成新的tag. writeEndDocument() 则关闭该tag.
	- 对于每个顶层条目, 我们调用 writeIndexEntry() --- 自定义函数
		- QXmlStreamWriter::writeAttribute() 加入一个属性至刚被写入的 tag 上. QXmlStreamWriter::writeTextElement() 写入一个文本元素.
		- writeAttribute --- 属性
		- writeIndexEntry() --- 每个子条目
		- writeEndElement()  --- 结束该元素
* QDomDocument调用save()函数就可以保存XML文件. 默认为 UTF-8 格式, 如果想要其他的编码, 则在前面加上一个 <?xml?> 声明. 如下:
{{{
	<?xml version="1.0" encoding="ISO-8859-1"?>
}}} 
	- 接下来的代码演示如何做:
{{{c++
        const int Indent = 4;

        QDomDocument doc;
        ...
        QTextStream out(&file);
        QDomNode xmlNode = doc.createProcessingInstruction("xml",
                                     "version=\"1.0\" encoding=\"ISO-8859-1\"");
        doc.insertBefore(xmlNode, doc.firstChild());
        doc.save(out, Indent);
}}}
	- 对于 Qt 4.3, 另一种做法是在 QTextStream 使用 setCodec() 设置编码, 而后传递 QDomNode::EncodingFromTextStream 作为 save() 的第三个参数.
{{{c++
        QTextStream out(&file);
        out.setCodec("UTF-8");
        out << "<doc>\n"
            << "   <quote>" << Qt::escape(quoteText) << "</quote>\n"
            << "   <translation>" << Qt::escape(translationText)
            << "</translation>\n"
            << "</doc>\n";
}}}
* 手动生成最不注意的部分是文本中的 escape special 字符以及属性值.
	- 在文本和属性值中进行换码, Qt::escape() 用于  '<', '>', '&'.  详细情况见例子代码
	- 这里有一些代码利用了这点:
{{{c++
	QTextStream out(&file);
	out.setCodec("UTF-8");
	out << "<doc>\n"
    	<< "   <quote>" << Qt::escape(quoteText) << "</quote>\n"
    	<< "   <translation>" << Qt::escape(translationText)
    	<< "</translation>\n"
    	<< "</doc>\n";
}}}
* 另外如果必须正确的写 <?xml?> 声明和设置正确的编码, 我们必须继续 escape 我们写的文本. 如果我们使用属性, 我们必须在它们的的值中 escape 单引号或双引号. 使用 QXmlStreamWriter 更简单, 因为他们可以处理所有这些事情.


= Chapter 17 Providing Online Help =
* 大多数应用程序给用户在线帮助. 一些帮助很简短, 如 tooltips, 状态栏 tips, 以及 "What's This?"帮助. 对于许多页面的帮助, 你可以使用 QTextBrowser 作为一个简单地在线帮助浏览器, 或者你启动一个 Qt Assistant 或者从你的应用程序启动一个 HTML 浏览器.

== 17.1 Tooltips, Status Tips, and "What's This?" Help ==
* Tooltip 的主要用途是提供工具条按钮的文本描述.
* 使用 QWidget::setToolTip() 给任意的 widget 添加 tooltips.
{{{c++
	findButton->setToolTip(tr("Find next"));
}}}
* 给一个 QAction 设置一个 tooltip 可以将该 tooltip 添加至对应的菜单和工具条上. 在 action 上调用 setToolTip():
{{{c++
	newAction = new QAction(tr("&New"), this);
	newAction->setToolTip(tr("New document"));
}}}
* 如果我们不显式地设置 tooltip, QAction 将自动地使用 action 文本.
* 当鼠标在工具条按钮或菜单选项上方时, 在状态栏显示一个状态 tip, 使用 setStatusTip() 函数
{{{c++
	newAction->setStatusTip(tr("Create a new document"));
}}}
* 下面是一个使用"What's This?"文本的一个例子:
{{{c++
	dialog->setWhatsThis(tr("<img src=\":/images/icon.png\">"
	                        "&nbsp;The meaning of the Source field depends "
	                        "on the Type field:"
	                        "<ul>"
	                        "<li><b>Books</b> have a Publisher"
	                        "<li><b>Articles</b> have a Journal name with "
	                        "volume and issue number"
	                        "<li><b>Theses</b> have an Institution name "
	                        "and a Department name"
	                        "</ul>"));
}}}
* 我们可以使用 HTML tags 形成"What's This?"文本. Qt 支持的 tags 和属性见 http://doc.trolltech.com/4.3/richtext-html-subset.html.
* 当我们在一个 action 上设置"What's This?"文本时, 则在"What's This?"模式中用户点击菜单条目或工具条按钮或按下快捷键时将会显示文本. 当一个应用程序主窗口的用户界面组成部分提供"What's This?"文本时, 其通常在帮助菜单和一个对应的工具条按钮中提供一个 What's This?  选项. 这可以通过静态函数 QWhatsThis::createAction() 创建一个 What's This? 的 action , 而后添加其返回至一个帮助菜单和一个工具条. QWhatsThis 类同样也提供了静态函数以能够程序上进入和离开"What's This?"模式.

== 17.2 Using a Web Browser to Provide Online Help ==
* 实现更多的在线帮助, 可以提供HTML格式的帮助文本, 而后在应用程序页面上启动用户的网络浏览器.
* 包含一个 help browser 的应用程序通常在主窗口的帮助菜单中一个帮助条目(entry), 以及在每个对话框有一个帮助按钮.
* 本节中我们显示如何使用 QDesktopServices 类提供用于这些按钮的功能.
* 主窗口有一个 help() slot, 当用户按下 F1 或点击 Help|Help 菜单选项时调用.
{{{c++
	void MainWindow::help()
	{
	    QUrl url(directoryOf("doc").absoluteFilePath("index.html"));
	    url.setScheme("file");
	    QDesktopServices::openUrl(url);
	}
}}}
	- 这个例子我们假设我们应用程序的HTML帮助文件在"doc"子目录内, QDir::absoluteFilePath() 函数返回给定文件名的绝对地址.
	- QUrl::setScheme() 设置为"file, 表示在本地文件系统中查看.(file:///前缀)
	- QUrl::openUrl() 打开浏览器.
* QApplication::applicationDirPath() --- 获取应用程序目录路径
* QDir::dirName() --- 目录名称
* QDir::cdUp() --- 上一个目录.
* QDir::cd() --- 进入一个子目录.
{{{c++
	void EntryDialog::help()
	{
	    QUrl url(directoryOf("doc").absoluteFilePath("forms.html"));
	    url.setScheme("file");
	    url.setFragment("editing");
	    QDesktopServices::openUrl(url);
	}
}}} 
	- 上例中特定的页面有帮助文本用于一些不同forms, 每个都有一个 anchor references(例如, <a name="editing">), 可以表示每个form帮助文本开始的地方. 这样使用 setFragment() 以及该 anchor 作为参数, 则页面会滚动到该位置.

== 17.3 Using QTextBrowser as a Simple Help Engine ==
* 提供基于 QTextBrowser 类的帮助引擎.
* QTextBroswer 可以处理大量的 HTML tags.
* setAttribute(Qt::WA_GroupLeader); --- 可以让我们从模型对话框中弹出该窗口, 在请求帮助之后可以与应用程序中的其他窗口交互.
* 使用QTextBrowser::setSearchPaths() 提供了两个查找路径, 第一个则是文件系统中包含应用程序文档的路径, 第二个则为图像资源的位置. HTML 可以包含和平常方式一样文件系统中图像的关联, 还可以包含使用 :/ 开头的路径的图像资源的关联. 
* QTextBrowser::setSource() 其参数为文档文件的名称, 有个可选的 HTML anchor.
* QTextBrowser::documentTitle() 返回页面中 <title> tag 中的文本.
* 我们设置属性  Qt::WA_DeleteOnClose, 当关闭时会自动删除该窗口资源. 
* 则使用如下:
{{{c++
	void MainWindow::help()
	{
	    HelpBrowser::showPage("index.html");
	}
	
	void EntryDialog::help()
	{
	    HelpBrowser::showPage("forms.html#editing");
	}
}}} 
* 我们可以使用 Qt 的资源系统嵌入帮助文件和他们关联的图像至可执行文件中. 唯一的变化是添加每个我们想要嵌入的 entry 到应用程序的 .qrc 文件, 其使用资源路径(如, :/doc/forms.html#editing).

== 17.4 Using Qt Assistant for Powerful Online Help ==
* 使用 Qt 的 Assistant 主要优点是其支持索引和全文查找, 以及可以处理多个文档集用于多个应用. 
* Qt 应用和 Qt Assistant 之间的通讯是通过 QAssistantClient 类处理, 为了使用该类, 需要使用库 QtAssistant.
* QAssistantClient 构造函数接受一个路径字符串作为第一个参数, 其用于定位 Qt Assistant 可执行文件的位置. 传递一个空白路径, 表示 QAssistantClient 应当在 PATH 环境变量中查找可执行文件.
* QAssistantClient 有一个 showPage() 函数接受一个带可选HTML anchor的页面名称.
* 接下来的步骤是准备一个table of contents和一个用于文档的index. 这可以通过创建一个Qt 的 Assistant profile 和写一个提供关于文档信息的 .dcf 文件来完成. 
* 对于 Windows 应用程序, 其可能想要创建一个 Windows HTML Help 文件以及使用 Microsoft Internet Explorer 提供对它们的访问. 你可以使用 Qt 的 QProcess 类或者 ActiveQt 框架用于实现这个.

