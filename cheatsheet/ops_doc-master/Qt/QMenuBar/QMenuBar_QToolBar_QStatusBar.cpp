1. 菜单栏
2. 工具栏
3. 状态栏
4. 核心控件
5. 浮动窗口

1. 创建菜单栏
	#include <QMenubar>
    menuBar()->addMenu(menu);                                             QMainWindow
    QMenubar *mBar = new QMenuBar; ... mainLayout->setMenuBar(menuBar);   QDialog
2. 在菜单栏中添加菜单
	#include <QMenu>
	QMenu * pFile = mBar->addMenu("file");
	QMenu *pEdit = mBar->addMenu("edit");
    
    QMenu *fileMenu = new QMenu(tr("&File"), this); menuBar->addMenu(fileMenu); QMainWindow
    QMenu *menu = new QMenu(tr("&File"), this);     menuBar()->addMenu(menu);   QDialog
    
3. 在菜单中添加动作
	#include <QAction>
	QAction *pNew = pFile->addAction("new");
	QAction *pOpen = pFile->addAction("open");
    
    QAction *a = new QAction( newIcon, tr("&New"), this);  menu->addAction(a);  QMainWindow
    QAction *exitAction = fileMenu->addAction(tr("E&xit"));                     QDialog
4.	通过动作连接实际的操作
	connect(pNew,&QAction::triggered,
            [=](){
              ......//此处可以是该动作所引发的相关函数
              qDebug()<<"you triggered this action";
            });
5. 在窗口中添加工具栏
	//工具栏实际上是菜单栏的快捷方式
	#include <QToolBar>
	QToolBar *tBar = new QToolbar("toolbar");
	//工具栏中可以添加动作,可以添加按钮
	tBar->addAction(pNew);
		QPushButton *b = new QPushButton(this);
		b.setText("hello");
	tBar->addWidget(b);
6. 在窗口中添加状态栏
	#include <QStatusBar>
	#include <QLabel>
	QStatusBar *sBar = new QStatusBar(this);
	QLabel *label= new QLabel(this);
	label->setText("normal text file");
	sBar->addWidget(label);
	//或者可以直接是:
	sBar->addWidget(new QLabel("hello world",this));
	
	//从右往左添加控件,并且每次添加的控件都在窗口界面的最右端
	sBar->addPermanentWidget(new QLabel("hello world",this));
7. 在窗口中添加核心控件
	#include <QTextEdit>
	QTextEdit *tEdit = new QTextEdit(this);
	//设置为核心控件
	setCentralWidget(tEdit);
8. 在窗口中添加浮动窗口
	#include <QDockWidget>
	QDockWidget *dock = new QDockWidget(this);
	//添加浮动窗口
	addDockWidget(Qt::RightDockWidgetArea,dock);
	//在浮动窗口中添加控件
	QTextEdit tEdit1=new QTextEdit(this);
	dock->setWidget(tEdit1);


