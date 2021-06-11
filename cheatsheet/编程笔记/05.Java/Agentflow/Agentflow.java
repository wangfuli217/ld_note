
1.Agentflow 的安装：
    1) 须先安装有JVM，如JDK/JRE
       下载地址：http://java.sun.com/downloads/
       设置环境变量：如果是Win2000，xp使用鼠标右击“我的电脑”->属性->高级->环境变量
              系统变量->新建->变量名：JAVA_HOME 变量值：c:\j2sdk1.4.1
              系统变量->新建->变量名：CLASSPATH 变量值：.;%JAVA_HOME%\lib
              系统变量->编辑->变量名：Path 在变量值的最前面加上：%JAVA_HOME%\bin;
              (CLASSPATH中有一英文句号“.”后跟一个分号，表示当前路径的意思。三个缺一不可)
    2) 安装 JSP contanner 如tomcat5,需要bin目录下有startup.bat的
    3) 安装 Workflow Engine (又称PASE)
    4) 安装流程设置环境 (又称PDE)  在ProcessDesigner目录下
    5) 安装 Agenda
    6) 安装 WebAgenda
       将 WebAgenda.war 复制到 tomcat的webapps目录下
       修改 WebAgenda 的环境：在 comcat目录\webapps\WebAgenda\WEB-INF\agenda-config.xml
       修改内容：
              <?xml version="1.0" encoding="UTF-8"?>
              <Server>
                <PaseServer>
                  <IP>localhost</IP>
                  <PORT>1099</PORT>
                  <FIREWALL>false</FIREWALL>
                  <FIREWALLIP>localhost</FIREWALLIP>
                  <FIREWALLPORT>1099</FIREWALLPORT>
                </PaseServer>
       另一种修改方式：用浏览器修改
       先 run PASE，再 run tomcat 。
       登录 http://127.0.0.1:8080/WebAgenda/setconfig.do 修改

  默认用户名：administrator，密码：adm



2.Agentflow 概述
  利用Agentflow来开发并执行一个流程，其运作过程大致分两个阶段：
  1) 设计流程
     可利用流程设计师(ProcessDesigner)来设计流程，包括：
     建立组织架构，建立新专案，设定须签核的文件，设计电子表单。并通过流程引擎执行。
  2) 执行流程
     利用系统提供的使用者界面(Agentflow Enterprise Process Portall)
     使用者可以查看手上哪些工作待处理，查询工作进度，填写文件表单...

  Agentflow的系统包含了：
  1) 流程设计师(Process Designer)            建立电子流程
  2) 组织设计师(Organization Designer)       建立公司的组织架构
  3) 电子表单设计师(e-form Designer)         设计电子表单，方便传递、可与流程结合。
  4) 流程引擎(Workflow Engine)               沟通者。包含：流程服务器(process server)，对象服务器(object server)等
  5) 流程入口网站模组(AEPP)                  通过浏览器执行，能在任何地方处理工作流程。
  6) 流程管理师(Administrator)               对作业流程(process)的管理



3.组织设计师入门：
  先从“组织设计师”开始
  1) 启动 安装目录下的 PDE目录的server.bat 或开始菜单栏的“PDE Server 2.2”
     设置好默认数据库。(不建议使用MySQL，它没法建立art_state表 ,后期会出问题)
       由于Agentflow必须要有专属的数据库，因此用户必须先于数据库系统中建立一个Agentflow专用的数据库名称。
       不建议让Agentflow和用户现有的系统共享同一个数据库，可能会发生因系统表格共享而发生重大冲突。
     这个服务器需先在菜单栏“系统资料设定”-“安装系统表格”，然后才可启动。
     以下的设计阶段都需要启动“PDE_Server”然后才可以操作，像 org、Process_Designer 等
  2) 启动 同一目录的client.bat 或开始菜单栏的“Process Designer 2.2”
     设置好默认数据库。数据库填写跟上面一样。
  3) 通过“流程设计师”的界面点击“组织设计师”进入
     也可直接双击同目录下的“org.bat”进入
  默认用户名: administrator, 密码: adm
  参考：组织设计师(Organization Designer)使用手册
  4) 项目发布时,需先启动“PASE_server”，然后启动tomcat,里面的WebAgenda才可以访问。

4.组织设计师简介
  流程的各个步骤必定有其负责执行的人员或角色，因此在建置一个公司内部工作流程时必须先建立一个该公司的组织结构。
  组织结构中描述人员及角色的关系，当工作流程建置完成后便会依据组织结构所描述的关系来进行工作的传送和管理。
  Agentflow所提供的「组织设计师」，可让您透过图形化接口轻易地完成公司组织架构的建置。

  组织上下关系逻辑：
  1) 公司节点下只能是：部门节点或职务节点
  2) 部门节点下只能是：部门节点或职务节点
  3) 职务节点下只能是：部门节点或职务节点或职员节点
  4) 职员节点下不能有任何节点。
  5) 一个职员可以分配到多个职务节点上。
     系统允许职员同名，以“编号”来区别。

  组织图建立后，可存储到数据库或者生成“.org”文件来保存。
  下次也可从数据库或本地文件上读取出来。



5.流程设计师(Process Designer)简介
  工作流程主要包含了人、事、物三个主要因素，分别是参与的人员、待处理的事物以及操作的窗体。
  使用「流程设计师」的目的在于设计流程，因此「流程设计师」扮演的角色为：
    1) 设计流程
       每一个项目流程(Process)包含多个流程节点(SubProcess)及文件(Artifact)
       而流程的设定，主要是在设定各流程节点间的关系、文件窗体以及流程节点的开启及结束条件。
       每一条联结线只供一个联结状态使用，用多少状态需传递则需多少条线。
         例如，有三种状态指向一个节点，而这节点在不改变任何状态时指向结束，则需三条结束线。
    2) 设定文件
       流程节点的开启或结束条件，是以文件的状态来决定。
       以请假流程为例，请假单一份文件就有许多状态，如「未填写」、「填写中」、「已填写」…等。
       于流程节点中，系统将依照文件处理的情形，适时的改变文件的状态，进而影响流程的走向。
    3) 专案职务
       给每一个流程节点设定流程的负责人员。
       除了可以针对基本的公司组织架构做职务设定外，也可依据特殊需要选取某个人员，担任项目中的职务。
    4) 生成 jsp 页面
       可以用 Process_Designer 的“文件设定”的“JSP表单产生器”，将生产的文件放到 WebAgenda 项目的 artform 目录下。
       生产的文件放在安装目录的“PDE”目录下，一个名为“ART表单编号”的目录即是,这目录名如：“ART00041256086357046”
    5) 自己编辑 jsp 页面
       可以直接在 WebAgenda 项目的 artform 目录下，创建一个名为“ART表单编号”的目录，里面一个名为“ART表单编号.jsp”的文件里面写页面
       而原本需要用“e-form设计师”画的页面，现在只需要在“e-form设计师”里面拖出所需要的元件即可，排版和 js 留给 jsp 页面来做。

6.流程设计多样性
    1) 线性式流程
       「线性式流程」是一般常用的工作流程模式。没有特殊的流程需求，单纯的将每个阶段串接起来。
       这类流程虽然简单，但却是其他任何复杂流程模式的基础。
    2) 条件式流程
       「条件式流程」利用条件判断来控制流程。
       如，程序设计人员可以依据窗体上特定字段的数值，决定流程的流向。
    3) 扇状式流程
       「扇状式流程」是条件式流程的延伸。碰到必须同时启动两条(或多条)路径时使用。
       利用文件状态的设计，可以同时指定两个(或多个)相同的文件状态，达到同时启动多条路径的目的。
       注意，Agentflow本身并不支持多个终端节点，也就是所有分支必须会合于一个终端节点，否则会发生流程无法连续的状况。
    4) 阶层式流程
       「阶层式流程设计」允许用户在同一个工作流程(Workflow)中，将某个程序(Process)切为多个子程序(Sub-Process)。
       例如在【请购】流程中，包含申请、核准、采购、验收、付款、取件等步骤；而【采购】步骤比较复杂。
       所以在【请购】流程中将【采购】视为单一流程，并将其切割为子流程。
       这种设计的目的，在于降低在设计及维护复杂流程时的难度，设计人员可在同一画面上操作适当数量的程序。
    5) 呼叫流程
       「呼叫旧有流程」允许用户在设计流程时，重复使用已经设计好的工作流程。
       ※ 注意事项：
       1. 当某一个被呼叫的工作流程被修改时，系统在执行「呼叫旧有流程」的功能时，会寻找最新版本的工作流程。
       2. 呼叫某个工作流程时，可以依据此项工作流程最后的状态决定流程走向。
       3. 每一个流程都有「启动者」，代表实际启动此流程的人，而被呼叫的流程的「启动者」由系统依据设定自动产生。
    6) 会签功能
       「会签」功能允许多个用户同时针对一份工作发表意见，使用者将意见写在会签单上，并由系统自动将意见作整合。
       「会签」功能整合几个步骤：【决定会签人员】、【加签】、【签核】、【汇整】。
       第一个步骤是在流程设计时，决定参予会签人员的名单，并设定加签选项；
       若加签选项被启动，则在流程进入签核阶段之前，拥有加签权力的人可以增删参予会签人员的名单；
       之后在【签核】阶段，所有参予人员可以在会签单上写入意见；
       这些意见会被整合在同一张会签单上，其中包含人名以及其所提供的意见
       在所有【签核】阶段后执行的程序中，用户都可以看到这些意见。
    7) 加会签功能
       「加会签」功能与「会签」功能很类似，差别在于「加会签」可以动态的决定是否要执行「加会签」功能。
       也就是说「加会签」功能在流程设计时只需做些设定而不需要另外制作一相关流程。
       「加会签」功能主要分为【启动加会签】、【执行加会或加签工作】、【观看加会签结果】三步骤。
       第一步骤是执行流程时临时要加会签，可设定加会签种类与参与成员,完成工作后系统会按设定将工作交付给参与成员。
       第二步骤为参与成员可以在加会工作上填写加会意见，在加签工作上做签核的动作。
       第三步骤为执行加会签工作返回点或是加签工作驳回点的使用者可以观看整个加会签工作汇整起来的结果与意见。
       「加会签」功能里的种类分为：分会、串会、与串签。
       分会即是将工作同时交付给所有的参与成员，等到所有参与成员都将意见填写完毕之后，即将意见汇整给返回点﹔
       串会为将工作按照参与成员的顺序一一的交付下去，等到最后一位参与成员的意见填写完毕后，即将意见汇整给返回点﹔
       串签为将工作按照参与成员的顺序一一的交付下去。如果核准，则交付给下一位，到最后一位，则将结果汇整并将工作交付给返回点﹔如果驳回，即将工作交付给驳回点去执行。

7.专案
    项目【作者】的重要性
        作者对项目有着不可获缺的重要性，由于流程设计师是多人操作(multi-user)的环境，因此安全性是必须加以考虑的。
        一个项目只能由该作者进行读写，对其他的人都是只读的，其他人不能修改这个项目。

8.操作
    1) 建立新项目
       “专案资讯”里右键建立。设置专案属性。
       专案建立后，可存储到数据库或者生成“.prj”文件来保存。下次可从数据库或本地文件上读取出来。
    2) 建立流程资讯
       “流程设计”标签，对着专案右键“加入新流程”
       建立流程节点：对着流程右键“加入新流程”，就生成新节点。还可给流程节点加节点。
    3) 文件设定
       进入“文件设定”标签。对着专案右键“加入新java文件”，设置文件属性。
    4) 设计电子表单
       开启「电子表单设计师(e-form)」，对着刚才建立的文件右键“e-form设计师”
       绘制电子表单 ...... 存储
    5) 文件状态
       通过设置文件状态以决定流程走向。
       设置文件状态的条件。
    6) 设置文件属性
       提供表单的权限控制。避免无意或是蓄意地更改别人所填写的字段数据。
       点选【文档属性状态】中的【文档属性Enable编辑器】
       根据文件状态来设定各字段可否填写，"打勾"表示这个字段在这个状态可以填写。
    7) 编写script
       Agentflow Script 类似于 JavaScript
       Agentflow Script请参阅「Agentflow系统开发手册」以及「API手册」。
       在“电子表单设计师”的组件事件(属性右边)里编辑。
    8) 设置各流程的运作状态
       职务设定，设定流程的执行者及相关信息。
       完成条件设定(主流程不需要)
       制作工作流程图
    9) 编辑版本咨询，选择“载入执行”与“启动时间”
       不执行这步，则 Agenda 启动项目中不出现此流程。



9.工作管理员(Agenda)
    须先启动安装目录下的“PASE\server.bat”或开始菜单的“Flow Engine 2.2”，填好设置后启动。
    启动安装目录下的“\Agenda\client.bat”或者开始菜单的“Agenda 2.2”
    用公司的几个成员登录，测试流程效果。


10.数据库
    1) 建表
       在流程设计师(Process Designer)的文件设定里，每建一个文件，agentflow即在数据库里新建一张相应的表
       表名为文件编号+"_INS"，如：“ART00001256624823546_INS”
       表的字段都是“ITEM”+数字，如：“ITEM2”；只有文件单号字段为“INSID”
       获取文件单号的方法：
           窗体端：var task = Form.getCurrentTask();    var 文件单号 = task.getArtInstance().getMyID();
       每启动一个流程，其作用的文件所对应的数据库表会新增一笔数据。
       也可另外建立：
         var art = Client.createArtInstance(XJXDTable0);   //创建询价明细档
         art.setAppValue("Discuss", Discuss);  //传送数据
         art.setAppValue("SendSign", SendSign);
         Client.updateArtInstance(art);
         var XJXDID =  = art.getID();    //文件编号(INSID)
       查看窗体：Client.createFormExt(artInsID, "", false, false, false, false); //artInsID是窗体号
    2) 各表格说明
       Mem_GenInf     保存组织结构信息 的人员组织
       Rol_GenInf     保存组织结构信息 的职务组织
       Dep_GenInf     保存组织结构信息 的部门组织
       Pro_GenInf     保存专案下的 各流程信息
       Art_GenInf     文件信息
       Art_State      文件状态信息




Agentflow Script
/********************************************************/
语法和Java Script相似，而差别则在于提供的API不一样。
Java Script是一种网页语言，目的是增添网页的特色用，而Agentflow Script则具有更好的应用程序开发能力。

关键词(keywords)：
    abstract      boolean   break       byte            case
    catch         char      class       constrotected   continue
    default       double    else        extends         false
    final         finally   float       function        for
    goto          int       interface   if              in
    implements    import    instanceof  long            new
    native        null      ackage      private         public
    return        short     static      super           switch
    synchronized  throw     throws      transient       true
    try           void      var         with            while
    this          do


数据型态
    Agentflow Script认可的数据型态有以下四种
    数据型态     中文名称     例子
    number       数值         3或是4.56…等
    String       字符串       "Hello"、"Yes!!! "…等
    boolean      布尔值       true 或是 false
    null         空值         即以null表示，但不可以Null或是NULL表示
    Object       对象


申明变量
    使用 var 关键字。注：不能用其他关键字申明，如 String, int 等。
    在Agentflow Script变量宣告，无须指定数据型态，在script实际执行时，会因应需要而自动转换数据型态。
    例如：var internetaddress
    也可一次宣告多个变量： var I, j, k ;
    用"＝"来指定变数的初始值，例如：
    var internetaddress="name@company.com";
    var i=0.09, j=fales, k ;  k=0;
    var a = [0, 1, 2]; //array with 3 elements，数组跟java, java Script有不同
    var a = []; //array with zero elements
    var a; //a variable
    var a = java.lang.Object; //a java native variable


变量范围
    局部变量：在一个函式内宣告的变量便属于局部变量，当函式被呼叫时变量才有作用，函式结束后变量也跟着除去。
    整体变量：在所有函式外面宣告变量，这个变量便是整体变量，所有的函式及程序的任何部份都可以使用这个变量和它的值．


运算符
    单元操作数:    ，     ++     --     !(非)     ~(反相)    []    ()    =
    四则操作数:    +      -      *      /     %     +=     -=     *=     /=     %=
    逻辑操作数:    ||     &&
    位操作数:    |      ^      &      >>     <<     >>=     <<=     &=     ^=     |=
    关系操作数:    ==     !=     <      >      <=     >=
    三元操作数:    ?:     如：(exp1)?(exp2):(exp3)

循环
    while:         while (exp){  ...; }
    do-while:      do{ ...; }(exp)
    for:           for (var i=0; i < sum; i++) { ...; }

if条件式
    if(exp1){...;} else if(exp1){...;} else{...;}

switch条件式
    switch(sum){
        case 1:  price = 100; break;
        case 2:  price = 200; break;
        case 3:  price = 300; break;
        case 4:  price = 400; break;
        default: price = 0;
    }


申明函式
    function add(x,y,z) {
        return x + y + z;
    }

   调用函数，只要撰写正确的函数名称，及个数正确的参数即可，例如
   var sum = add(1,2,3);

例外处理： try {  throw e;  } catch (e) { ... } finally { ... }



Agentflow程序撰写分为两大类--Client端程序及Server端程序

一、Client端说明
    Client端执行的script，是在电子表单设计师撰写的。
   1. 窗体组件提供的方法
      以下列举电子表单设计师中窗体组件与方法的对应表
      方法/对象    action    item    ValueChanged  change  editingStopped
      TextField      ◎
      CheckBox       ◎
      Button         ◎       ◎                     ◎
      RadioButton    ◎                              ◎
      ComboBox       ◎       ◎
      List           ◎       ◎
      Table                               ◎                    ◎

      LayerPane  特有的方法：preAction postAction  okAction  openFormAction closeFormAction
      执行顺序分别为 preAction -> openFormAction -> okAction -> closeFormAction -> postAction

   2. 方法解释
      方法名称            解释
      preAction          开启窗体时执行，主要是设定表单域默认值，可以依据窗体不同的状态给予不同的执行行为。
      postAction         填写窗体后按完成键时执行，可以依据窗体不同的状态给予不同的执行行为。
      ok Action          编辑窗体按完成键时执行，主要用来检查字段数据是否符合结束条件。
      openFormAction     开启窗体时执行。不过执行的次数不止一次，暂停后重新开启也会执行。
      closeFormAction    关闭窗体时执行。不过执行的次数不止一次，暂停或是完成工作都会执行。
      action             在TextField中按"enter"后执行，在其他的表单对象中则是"click"(点击)后执行。
      Item               若在对象中点选的数据改变，就会执行其中的script。
      value changed      若在对象中点选该行的数据改变，就会执行其中的script。
      editing stopped    在Table对象某一cell编辑结束后，就会执行其中的script。
      change             若对象的状态改变，就会执行其中的script。

      注意：为了防止用户第一次打开时关闭页面而不保存；建议preAction的内容全部改写在openFormAction

   3. Layerpane组件之方法的特殊性
      Layerpane组件拥有流程状态区隔卷标，可以分隔这些方法在流程的各个阶段所欲执行的的程序。
      区隔卷标，即是流程中所设定的文件状态的名称。

/************** 例 1 面板(Layerpane) 的openFormAction ***********************/
{初始化:
    var task    =  Form.getCurrentTask();
    var mID     =  task.getRealExecutor();     //发送表单者的员工ID
    var member  =  Client.getMemberByID(mID);  //发送表单者的名字
    Form.setValue("Name",member.getName());    //填写表单的“Name”栏位
    var sRoleID    =  task.getRoleID();        //发送表单者的部门ID
    var sRoleName  =  Client.getRole(sRoleID).getName(); //部门名称
    Form.setValue("Post",sRoleName);
    var sDepID     =  task.getDepartmentID();  //职务ID
    var sDepName   =  Client.getDepartment(sDepID).getName(); //职务名称
    Form.setValue("Department",sDepName);
}

//表单在“主管同意”状态时
{主管同意:
    var manager = Form.getValue("主管姓名");
    …
}

//“ALL”是系统内定的特殊标识符
// 表示在任何状态下，一律先执行ALL里的Script，然后再执行对应状态的Script。
{ALL:
    ...
}
/*************************** 例 1 结束 ************************************/



二、Server端说明
    1. 主要的撰写环境就是在流程规划师
     * 【菜单栏】-【设定】:
        -【PASE服务器启动动作】:当PASE服务器启动的时候触发。
        实际上PASE服务器启动时会先将所有PASE服务器所提供的服务都启动之后，才执行此Script。
        提供此一动作的主要目的是让系统管理员可以在启动PASE服务器之后亦顺便启动需自行加入的服务。
        -【PASE服务器关闭动作】:当PASE服务器关闭的时触发。
        实际上PASE服务器关闭时会先执行此一Script，执行完毕后才关闭PASE服务器所提供的所有服务及释放所占用的资源。
        提供此一动作的主要目的是让系统管理员可以在关闭PASE服务器时释放系统管理员自行加入的服务或是资源。
        -【PASE服务器组织异动动作】:当透过PASE服务器异动组织时, 撰写在PASE服务器组织异动动作里的函式便会被呼叫
        当return的值不为true时，代表该动作失败，此时PASE 服务器会执行Rollback数据库，也就是不会执行该项异动。
     * 【流程设计】-【执行动作设定】：提供流程的前置动作(preAction)、执行动作(Action)及后置动作(postAction)、
        分派动作(dispatchAction)，可以用script分别控制流程在Server端执行前、中、后及分派的行为。
     * 【流程设计】-【时间控制】：提供流程工作完成期限的设定，在时间控制中，除了可以利用接口设定提醒跟催促外，
        也可以利用script自定义工作逾时的动作，譬如在超过期限时，在绩效考核数据中加入记录。
     * 【会签设计】-【执行动作设定】：提供会签流程的前置动作(preAction)、后置动作(postAction)、分派动作(dispatchAction)
        可以用script控制会签流程在Server端执行前、后以及分派工作给使用者的行为。执行时机与用途都与一般流程相同。
        其不同点在于会签流程里分有三个阶段，分别为分派阶段(csannex)、加签阶段(csaudit)、与汇整阶段(csreview)
        因此可以针对不同的阶段撰写不同的Script，其方式有点类似文件状态。

        【会签的执行动作设定】样式如下：
         {ALL:
          ……
         }
         {CSANNEX:
          ……
         }
         {CSAUDIT:
          ……
         }
        “ALL”、“CSANNEX”、与“CSAUDIT”是系统内定的特殊标识符。
        “ALL”表示在任何状态下，系统一律先执行。“CSANNEX”表示当会签流程执行到分派阶段时执行。
        “CSAUDIT”表示当会签流程执行到加签阶段时执行。


    2. Script执行路径
       主要分为二种路径，一为用户开启窗体，二为系统自动执行。如下图：

              server端：
                                                自动执行
       Task产生 ----> 前置动作 ---> 分派动作  /  Action   ------------------------> 后置动作 ---> Task结束
                                       ↓                                                ↑
                                       ↓ (非自动执行)                                   |
              client端：         使用者开启表单                                          |(表单关闭)
                                       └--> pre --> open --> Form --> ok --> close --> post
                                           Action   Action   Action   Action  Action   Action

       1) 不为自动执行的Task的流程走向：
          执行顺序为 Task产生 -> 前置动作 -> 分派动作 -> Client端的执行 -> 后置动作 -> Task结束。
          Step1：当Task被启动时，系统则立即向后端数据库进行撷取相关的时间控制、文件内容、执行人员及代理人设定等信息。
          Step2：执行PDE前置动作。再将执行的结果储存起来。并检查PDE是否自动执行，以决定下个步骤走向。
          Step3：接着系统会执行PDE分派动作内所撰写的Script。执行完毕之后即将工作分派给执行者。
          Step4：因为不是自动执行，则表示系统会进行分派处理人的工作并将执行的焦点整个移转到Client端的窗体上。
          Client端开启并处理窗体，最后当用户按下“完成”键时，系统会去改变文件状态，并进行CompleteTask的动作。

       2) 系统自动执行：
          若在流程设计师中设定流程为系统自动执行，表示此流程不经由人为启动，一切行为皆在Server端自动处理。
          执行顺序为: Task产生 -> 前置动作 -> 自动Action -> 后置动作 -> Task结束
          Step1：当Task被启动时，立即向后端数据库撷取相关的时间控制、文件内容、执行人员及代理人设定等信息。
          Step2：执行PDE前置动作。并检查PDE自动执行的选项是否被勾选，以决定下个步骤应采自动执行或非自动执行。
          Step3：因为没有执行者，不需分派动作，所以，系统会执行自动执行框的Script，并按其指定改变文件状态。
          Step4：储存刚才系统执行Task的数据，并移除时间控制上执行的设定及更正Task执行状态为“已完成”。
          Step5：最后系统会去执行后置动作的Script，并完成及储存执行结果。

       在自动执行里需注意的有两点：
          一为只要有人启动此一流程，系统就会自动执行，就因为都是系统执行的，所以在下一关所看到的送出者皆为System，而不是启动此一系统的人，因此在撰写Script时需注意，如果利用MyTask.getMemberID()或是MyTask.getRealExecutor()所得到的都是System而不是去点选激活的那个使用者。
          另一需注意的一点是，在Script的最后都必须指定此窗体的下一状态为何或是直接将这一项工作关闭，否则系统会不知道这一项工作是否完成而造成流程无法执行。
          可以利用 Server.setArtInsState(PASEArtInstance art, String stateID)来指定窗体的下一状态
          或是利用 MyTask.setTaskState(MyTask.TASK_STATE_COMPLETE)将工作关闭。


三、Agentflow Script内建的物件
    对象类别         对象名称(参数)  Client端   Server端      说明
    Host Object        Server                     ◎
    Host Object        MyTask                     ◎       继承于 Task，API可参考它的。提供取得正在执行工作的相关信息
    应用程序界面对象   Client          ◎                  与Flow Engine沟通的管道，存取流程的定义或是数据等
    应用程序界面对象   Form            ◎                  与窗体沟通的机制， 例如设定窗体中某些组件的值，或取出内容
    应用程序界面对象   String          ◎         ◎       字符串对象
    应用程序界面对象   Math            ◎         ◎       数学运算对象
    应用程序界面对象   MyDate          ◎         ◎       日期对象
    应用程序界面对象   MyComboBoxAdder ◎                  协助下拉式选单(ComboBox(Client))对象抓取数据的对象
    窗体对象           Table           ◎                  数据库的数据表对象
    组织数据对象       Company         ◎         ◎       公司的数据对象
    组织数据对象       Department      ◎         ◎       部门的数据对象
    组织数据对象       Role            ◎         ◎       职务的数据对象
    组织数据对象       MemberRecord    ◎         ◎       用户的数据对象
    流程数据对象       PASEartInstance ◎         ◎       一个窗体的实例(instance)数据对象
    流程数据对象       Task            ◎         ◎       一件工作的数据对象

    Host Object 范例：
    // 在server端,抓取参考文件中refProjectID字段内的数据, 并将其值放入目前作用文件中的actProjectID字段内。
    var ati=MyTask.getArtInstance();
    var refArtSet=MyTask.getRefArtifactList();
    if (refArtSet.size()>0) {
        var refArt=refArtSet.get(0);  //取得第一份参考文件
        var sProjectID=refArt.getAppValue("refProjectID");
        ati.setAppValue("actProjectID",sProjectID);
    }

    // 于PDE时间控制-使用者自定义撰写发送E-mail给目前的使用者
    var fromEmail = "abc@flowring.com";
    var toMember = Server.getMember(MyTask.getMemberID());
    var toEmail = toMember.getEmail();    // get E-mail address
    // set E-mail title & content
    var title  = "mail Title ";
    var data = "mail Content";
    // send E-mail
    Server.sendMail(fromEmail,toEmail,title,data);

四、应用程序编程接口(API)物件
    1. Client物件
       此对象提供与Flow Engine沟通的机制，存取流程定义、公司组织成员信息、数据库数据等
       1) 公司组织信息(Organization Definition Retrieve)
          回传值/对象        函式(数据型态 参数)                 说明
          Company          getCompany()                       得到公司对象
          Department       getDepartment(String dID)          根据部门ID取得部门对象
          Role             getRole(String rID)                根据职务ID取得职务对象
          MemberRecord     getCurrentMember()                 取得登入系统者的用户对象
          MemberRecord     getMemberByID(String mID)          根据memberID取得用户对象，memberID为系统自动产生的个人ID
          MemberRecord     getMemberByName(String mLoginID)   根据使用者登入账号取得用户对象
          MemberRecord     getMemberByCName(String mName)     根据用户姓名取得用户对象
          MemberRecord     getMember(String id)               根据使用者的个人工号或是登入账号或是姓名取得用户对象

          取得公司及用户信息
          var Company = Client.getCompany();      // 取得公司对象
          var companyName = Company.getName();    // 取得公司名称
          var Member = Client.getCurrentMember(); // 取得当前的使用者
          var memberName = Member.getName();      // 取得使用者名字
          var memberID = Member.getID();          // 取得使用者的ID
          var memberSys = Member.getSynopsis();   // 取得使用者的描述
          var member = Client.getMember("FR012");           // 取得公司编号为"FR012"的职员
          var member = Client.getMemberByID("MEM001");      // 取得系统编号为"MEM001"的使用者
          var member = Client.getMemberByName("william");   // 取得登录账号为"william"的使用者
          var member = Client.getMemberByCName ("王小明");  // 取得姓名为"王小明"的使用者

       2) SQL指令
          利用SQL语言，对数据库进行新增、删除、更新、查询等动作;
          且另提供了一特殊语法--ArtSQLloadValue(…)，利用表单域为条件进行查询工作。
          回传值/对象       函式(数据型态 参数)          说明
          Vector         SQLloadValue(String sql)       SQL命令: 查询
          boolean        SQLinsertValue(String sql)     SQL命令: 新增
          boolean        SQLupdateValue(String sql)     SQL命令: 更新
          boolean        SQLdeleteValue(String sql)     SQL命令: 删除
          Vector         ArtSQLloadValue(String sql)    SQL命令：整合窗体的名称及字段，做为SQL查询的命令

          agentflow表 查询所有员工的名字，语句：
          sql = "SELECT USERNAME FROM MEM_GENINF WHERE MEMID != 'Administrator'";

          用SQL指令，取得关连式数据库中某一 table 的字段
          例如：到Table「tb_Customer」中，抓取资料，条件为Customer_Name为"Xina"
          var name = "Xina";
          var str = "select Customer_ID from tb_Customer where Customer_Name = '" + name + "'";
          var RecordSet = Client.SQLloadValue(str);     // RecordSet即为一Vector物件
          // 若查询的数据存在，则RecordSet.size()大于0
          if ( RecordSet.size() > 0 ) {
              var Record = RecordSet.get(0); //若有数笔记录，取第一笔
              var ID = Record.get("Customer_ID"); //取得该笔记录的字段「Customer_ID」数据
          }

          用SQL指令，依条件更改数据库中某一 table 的字段植
          例如：更改Table「tb_Customer」的字段Customer_Name为"Xina"，条件为Customer_ID为"001"
          var name = "Xina";
          var str = "update tb_Customer set Customer_Name = '" + name + "' where Customer_ID = '001'";
          Client.SQLupdateValue(str);

          特殊的SQL指令，依窗体名称及域名为条件查询
          例如：依据窗体的名称--请假单，及窗体内一域名--请假人为条件，用 SQL语句到数据库抓取请假天数
          var name = "Xina";
          var str = "select 请假天数 from 请假单 where 请假人 = '" + name + "'";
          var RecordSet = Client.ArtSQLloadValue(str);
          //若取得的资料存在，则RecordSet.size()大于0
          if ( RecordSet.size() > 0 ) {
              var Record = RecordSet.get(0); //若有数笔记录，取第一笔 (jsp时，用 Map 接收)
              var day = Record.get("请假天数"); //取得该笔记录的字段「请假天数」数据
          }

       3) 执行工作信息(Runtime data Retrieve)
          取得流程执行时所产生的工作(Task)相关信息
          回传值/对象      函式(数据型态 参数)
           Vector      getTaskOfMember(String 个人系统ID, int 工作状态)    // 取得Agenda中的工作

        (1) 第一个参数：个人成员的系统ID，获取方法如以下范例
            var member = Client.getCurrentMember();
            var mid = member.getID();
        (2) 第二个参数：为工作的属性条件。以下列表的系统常数即代表这些属性
            工作状态      说明          系统常数
            ready       工作准备中     Constant.TASK_STATE_READY
            complete    工作完成       Constant.TASK_STATE_COMPLETE
            running     工作正在进行   Constant.TASK_STATE_RUNNING
            suspended   工作暂停       Constant.TASK_STATE_SUSPENDED
            all         所有的工作     Constant.TASK_STATE_ALL
        (3) 回传值：为查询结果的工作集合
            例如：取得目前「我的工作」"准备中"的工作
            var member = Client.getCurrentMember();
            var mid = member.getID();
            var TaskSet = Client.getTaskOfMember(mid, Constant.TASK_STATE_READY);
            //若取得的工作数大于0
            if (TaskSet.size() > 0) {
                 //以工作数为循环次数
                 for(var i=0;i<TaskSet.size();i++){
                    //取得当笔的工作对象
                    var Task = TaskSet.get(i);
                    //取得工作名称
                    var name = Task.getName();
                 }
            }

       4) 流程控制(Flow Control)
          以script控制流程的开启及结束
          回传值/对象     函式(数据型态 参数)                          说明
          String       createProcess(String ProID, HashMap data)    启动ID为ProID的流程，data用来传送数据至启动的流程中
          HashMap      completeTask(Task t)                         将一工作设定完成，参数即为一工作对象

          //开启的流程参数ProID，该ID为一根流程(root process)的ID，在流程设计师的流程设计的流程信息设定中得到ID(流程编号)
          //工作对象(Task)可利用getTaskOfMember(…)取得。

          例如：在请购单的postAction中开启采购流程，并在采购流程preAction接收数据
          在请购单中按完成后，即通知系统开启一采购流程，并传送数据至采购流程：

/*************************** 流程控制 例1 ************************************/
/***** 请购单的postAction *****/
{主管已审核:
    var data = new java.util.HashMap();
    //将取得的数据放入HashMap对象中，利用put(key, value)放入
    data.put("单价",10);
    data.put("数量",2000);
    data.put("总价",20000);

    //以下即利用createProcess启动流程，并传送变量至该流程
    var tid = Client.createProcess("PRO000000000001",data);
}

/***** 采购单的preAction *****/
{初始化
    //以下3行程序即去抓取传来的"data"参数，ght变数即为传来的data参数，亦即一HashMap物件
    var task = Form.getCurrentTask();
    var s_parentid = task.getParentID();
    var ght = Client.getGlobals(s_parentid);  //ght，即为请购单的data变数
    if (ght != null) {
        //利用方法get(key)，来取得相对应的value
        var price = ght.get("单价");   // price = 10
        var amount = ght.get("数量");  // amount = 2000
        var sum = ght.get("总价");     // sum = 20000
    }
}
/*************************** 流程控制 例1 结束 ************************************/


          将「我的工作」中工作名称为"请假单审核"、工作状态为"ready"，以script设定完成工作
            var member = Client.getCurrentMember();
            var mid = member.getID();
            var TaskSet = Client.getTaskOfMember(mid,Constant.TASK_STATE_READY);
            if (TaskSet.size() > 0) {
                for(var i=0;i<TaskSet.size();i++) {
                    var Task = TaskSet.get(i);
                    var name = Task.getName();
                    //若工作名称为"请假单审核"，则将工作完成
                    if (name == "请假单审核")
                        Client.completeTask(Task);
                    }
            }

       5) 行事历(schedule)
          用以检查日期是否属于工作日等信息
          回传值/对象     函式(数据型态 参数)           说明
          boolean       isHoliday(String date)         检查 date 是否为假日.
          boolean       isRestSat(String date)         检查 date 是否为周休二日
          boolean       isHalfHoliday(String date)     检查 date 是否为半个工作日

          例如：检查2002/12/30是否为假日(该日为非周休二日的假期，当时是星期一)
          var date = "2002/12/30";
          var bl1 = Client.isHoliday(date);     // bl1 = false
          var bl2 = Client.isRestat(date);      // bl2 = false
          var bl3 = Client.isHalfHoliday(date); // bl3 = true

       6) 窗体实例数据(artifact instance data)
          取得窗体实例的数据，亦即正在执行或是历史窗体的数据
          回传值/对象     函式(数据型态 参数)                             说明
          Jpanel        createForm(String artID, String artInsID)     在窗体中开启一窗口，内容为一窗体的实例
          //参数artID为欲开启的窗体ID，可以在流程设计师的【文件设定】的【文件信息设定】中得到
          //参数artInsID为该窗体某一实例(Instance)的ID

          在采购单中要查询一张请购单，即在采购单中开启一请购单
          var artID = "ART00000000001"; // artID为请购单ID
          /* 以下SQL是取出请购单之单价栏为100的所有历史窗体的Instance ID，假设在数据库中储存请购单历史窗体
             的Table name为ART00000000001_Ins，储存单价的field name为ITEM10  */
          var sql_str = "select InsID from ART00000000001_Ins where ITEM10 = 100";
          var RecordSet = Client.SQLloadValue(sql_str);
          if (RecordSet.size() > 0) {
              var Record = RecordSet.get(0); //取出第一笔记录
              var artInsID = Record.get("InsID"); //取出该笔记录的Instance ID
              var panel = Client.createForm(artID, artInsID);
              //以下四行script即开启一张请购单，并加入scrollbar
              var sPane = new Packages.javax.swing.JScrollPane(panel);
              var dlg = new Packages.javax.swing.JDialog();
              dlg.getContentPane().add(sPane);
              dlg.setSize(panel.getSize());
              dlg.setVisible(true);
          }

    2. Form物件
       Form对象提供与窗体沟通的机制，可以针对目前开启的窗体，进行域值设定，或是取出字段内容做运用。
       1) 完整属性及方法
          回传值/对象            函式(数据型态 参数)                     说明
          Task                   getCurrentTask()                      取得目前操作中的Task对象
          Void                   doPreAction()                         重新执行preAction的Script
          Object(JComponent)     getComponent(String cmp)              在操作的窗体中，根据域名取得该字段对象
          String                 getValue(String cmp)                  根据窗体的域名，取得域值
          Void                   setValue(String cmp,String value)     根据窗体的域名，设定域值
          Int                    getIntValue(String cmp)               根据窗体的域名，取得域值，并转成整数
          Void                   setIntValue(String cmp,int value)     根据窗体的域名，设定字段整数值
          void                   setComplete(boolean bComplete)        设置窗体可否完成，默认为 true

    3. String物件
       1) 完整属性及方法
          回传值/对象   函式(数据型态 参数)             说明
          int         length()                       字符串长度
          char        charAt(int i)                  字符串在i索引的字符
          boolean     equals(String s)               比较和字符串s是否完全相同
          Int         indexOf(String s)              从头开始搜寻字符串s，找到即回传该字符串所在的索引
          int         lastIndexOf(String s)          从尾开始搜寻字符串s，找到即回传该字符串所在的索引
          String      substring(int start)           回传一个截取目前的字符串中以start索引开始到最后的所有字符的子字符串
          String      substring(int start,int end)   回传一个截取目前的字符串中以start索引开始到end索引中的所有字符的子字符串
          String      toLowerCase()                  将字符串传回全部大写字母
          String      toUpperCase()                  将字符串传回全部小写字母

    4. Math对象(数学运算对象)
       以下之 4type，表示{int, float, double, long}
       1) 完整属性及方法
          回传值/对象   函式(数据型态 参数)        说明
          4type         abs(4type i)              取i的绝对值
          4type         max(4type i, 4type j)     回传i、j的较大值
          4type         min(4type i, 4type j)     回传i、j的较小值
          double        pow(double i, double j)   回传i的j次方
          long、int     round(4type i)            将i四舍五入回传
          double        random()                 回传介于0与1之间的随机数
          double        sqrt(double i)            回传i的平方根
          double        ceil(double i)            回传大于或等于i的最小整数
          double        sin(double i)             回传i的正弦函数值
          double        cos(double i)             回传i的余弦函数值
          double        tan(double i)             回传i的正切函数值
          double        atan(double i)            回传i的反正切函数值
          double        acos(double i)            回传i的反余弦函数值
          double        asin(double i)            回传i的反正弦函数值

          //疑问：没有Math.floor(i) ?  ceil(i)回传类型为double ?

    5. MyDate物件
       日期物件; MyDate对象不同于String对象或是Math对象，不能直接使用，在使用前需先宣告，宣告方式如下：
       var mydate = new Packages.pase.agenda.MyDate();  //宣告后的mydate即为MyDate对象。
       1) 完整属性及方法
          回传值/对象  函式(数据型态 参数)                         说明
          String  getCurrentDate()                               回传当前的公元日期yyyy/mm/dd
          String  getCurrentDate(String date, String symbol)     回传当前的公元日期(date以YMDHmS代表时间，symbol是分隔符)
          String  getCurrentDate(String date)                    回传当前的公元日期(date以YMDHmS代表时间，且分隔符写在里面)
          Date    ConverToDate(int year,int month, int day)      将参数年、月、日合并转成Date对象
          Date    ConverToDate(String date)                      将参数日期(字符串)转成Date对象
          int     getSubtractDay(String thedate)                 回传日期参数与目前日期的相差日数
          int     getSubtractDay(String startday, String endday) 回传两个日期参数的相差日数
          int     getSubtractDay(Date thedate)                   回传日期参数与目前日期的相差日数
          int     getSubtractDay(Date startday, Date endday)     回传两个日期参数的相差日数
          int     getSubtractSecond(String start_Date,String end_Date)     回传两个日期参数的相差秒数
          String  add(String date,int day)                       将date日期加上day天数，回传加后的日期
          int     getROCYear()         回传当前的民国年份
          String  getROCDate()         回传当前的民国日期
          int     getCurrentYear()     回传当前的公元年份
          int     getCurrentMonth()    回传当前的月份
          int     getCurrentDay()      回传当前的日数
          int     getCurrentHour()     回传当前的时数
          int     getCurrentMinute()   回传当前的分
          int     getWeekOfMonth()     回传当前是这个月的第几周
          int     getDayOfWeek()       回传今天星期几
          int     getDayOfYear()       回传今天是一年的第几天
          int     getHourOfDay()       回传现在是一天的第几个小时

          说明：getCurrentDate(String date, String symbol)、getCurrentDate(String date) 中
          参数date为代码符号，共有YMDHmS六种，分别代表年月日时分秒
          参数symbol代表时间之间的统一分隔符

       2) MyDate对象使用范例
          var Ob_date = new Packages.pase.agenda.MyDate();
          //取得当前的时间
          var ls_date0 = Ob_date.getCurrentDate();             // 回传如："2002/11/22"
          var ls_date1 = Ob_date.getCurrentDate("YMDH", "-");  // 回传如："2000-09-18-06"
          var ls_date2 = Ob_date.getCurrentDate("Y/M/D H:m");  // 回传如："2000/11/22 16:04"
          //取得两个日期的相差时间
          var num = Ob_date.getSubtractDay("2000/02/10", "2000/02/28"); //num == 19
          //日期的加减运算
          var date3 = Ob_date.add("2000/02/10", 3);  //date3 == "2000/02/13"
          var date4 = Ob_date.add("2000/02/10", -3); //date4 == "2000/02/07"

    6. MyComboBoxAdder物件
       动态加入数据于下拉式选单中。
       MyComboBoxAdder对象与MyDate对象相同，不能直接使用，在使用前需先宣告，宣告方式如下：
       var adder = new Packages.pase.agenda.MyComboBoxAdder(Client); //宣告后的adder即为MyComboBoxAdder对象。
       1) 完整属性及方法
          回传值/对象     函式(数据型态 参数)                                说明
          void     addItems(JComboBox combo, String itemName, String sql)  根据SQL语句将itemName放入combo中
          void     addItems(JComboBox combo, int i, int j)       将i到j的数值放入combo的ComboBox组件中
          void     addItems(JComboBox combo, int i)              从1到i的数值放入combo的ComboBox组件中

       2) MyComboBoxAdder对象使用范例
          var adder = new Packages.pase.agenda.MyComboBoxAdder(Client);
          //将数据库中table「Member」的字段「Name」依条件将符合的数据抓出，并放入下拉式选单"ComboBox1"中
          var combo = Form.getComponent("ComboBox1");  //将窗体中的ComboBox1对象取出
          //根据SQL command将符合条件的「Name」资料放入ComboBox1中
          adder.addItems(combo, "Name", "select Name from Member where ID like 'FR%' ");
          将数字10到31放入下拉式选单"ComboBox1"中
          //将窗体中的ComboBox2对象取出
          var combo = Form.getComponent("ComboBox2");
          adder.addItems(combo,10,31)
          combo.insertItemAt("", 0); //第一栏增加一个空


五、 窗体对象
     在窗体中显示出来的每一个字段或是说明，都是在电子表单设计师中绘制的，对电子表单设计师来说都是窗体对象，每个对象都有自己的属性及方法，可以利用Form对象将每个窗体对象取出进行设定，使用方式如下
     var JComponent = Form.getComponent(对象名称);

     table物件: 数据库的数据表对象，就是在窗体中以Grid模式呈现的对象
     1. 回传值/对象  函式(数据型态 参数)                  说明
        Vector      getRowList()                       回传整个Table的资料
        HashMap     getRowData(int row)                回传该row的所有数据
        void        setRowList(Vector rowList)         将rowList的数据放入Table中
        void        clear()                            将Table资料清除
        String      getValueAt(int row, String colName)    根据参数指定，回传该cell的值
        String      getValueAt(int row, int col)       根据参数指定，回传该cell的值
        int         getSelectedRow()                   回传目前光标停留的row位置
        int         getSelectedColumn()                回传目前光标停留的column位置
        int         getRowCount()                      回传Table目前的row总数
        int         newRow()                           新增一笔row，并回传该row的位置
        void        setValueAt(Object value,int row, String colName)     根据参数指定，设定该cell的值为参数value
        void        setValueAt(Object value,int row, int col)            根据参数指定，设定该cell的值为参数value
        void        setColHiding(String[] hideCols)    隐藏hideCols所记录的各个字段，参数是各个域名组成的数组
        void        setColHiding(String colName)       隐藏某一个字段，参数是该域名
        String[]    getColHidingByName()               用于查询有哪些字段正处于隐藏状态，传回值为域名的字符串数组
        void        resetColHiding()                   用于还原Table所有隐藏域为显示状态

     2. table对象使用范例
      1) table对象数据存取
        例如：若窗体中有一table对象--"Table1"，要将第1笔记录的字段"姓"及字段"名"字符串相加后，放入字段"全名"中
        var table = Form.getComponent("Table1"); // 将窗体中的Table1对象取出
        var surname = table.getValueAt(0,"姓");  // 将第1笔记录的"姓"栏中的数据取出
        var name = table.getValueAt(0,"名");     // 将第1笔记录的"名"栏中的数据取出
        var full_name = surname + name;
        table.setValueAt(full_name, 0 , "全名"); //将全名放入第1笔记录的"全名"栏中
      2) 在table对象中加入一笔新的记录
        var table = Form.getComponent("Table1"); // 将窗体中的Table1对象取出
        var row = table.newRow(); // 在table中新增一笔空白记录
        row = row - 1; // 由于行数是从0开始，所以在处理时须将实际行数减1
        table.setValueAt(200,row,"单价"); // 将200放入"单价"栏中
        table.setValueAt(5,row,"数量"); // 将5放入"数量"栏中
      3) 在table对象的字段「序号」中，按顺序为每笔记录加上流水号
        var table = Form.getComponent("Table1"); // 将窗体中的Table1对象取出
        var rowCount = table.getRowCount(); // 抓出table目前的记录笔数
        for(var i=0;i<rowCount;i++) {  // 用循环为每笔记录加序号的流水号
             table.setValueAt(i+1,i,"序号");
        }
      4) 将table对象的全部数据取出，并放入另一个相同格式的table对象中(两个table的格式必须完全相同)
        var table1 = Form.getComponent("Table1"); // 将窗体中的Table1对象取出
        var rowList = table1.getRowList(); // 抓出Table1目前的所有记录
        var table2 = Form.getComponent("Table2"); // 将窗体中的Table2对象取出
        table2.setRowList(rowList); // 将table1的所有记录放入table2中
      5) 隐藏table对象中的字段「密码」
        var table = Form.getComponent("Table1"); // 将窗体中的Table1对象取出
        var column = "密码";
        table.setColHiding(column); //将「密码」字段隐藏

六、 组织数据对象
     组织数据对象即是与公司组织架构相关的对象，包含公司、部门、职务、成员等四类。
    1. Company物件：公司的数据对象。
       要取得Company对象，必须透过Client对象，如：var company = Client.getCompany();

       回传值/对象 函式(数据型态 参数)      说明
       String      getName()               取得公司名称
       Vector      getDepartmentList()     取得公司所有部门清单
       Vector      getRoleList()           取得公司所有的职务清单

    2. Department物件：部门的数据对象。
       要取得Dempartment对象，必须透过Client对象，并给予参数--部门系统代码，如：
       var department = Client.getDepartment("DEP00001"); //department即为部门的数据对象

       回传值/对象 函式(数据型态 参数)      说明
       String      getID()                 取得部门编号
       String      getName()               取得部门名称
       String      getSynopsis()           取得部门描述
       String      getManagerID()          取得部门主管职务编号
       String      getParentID()           取得上层部门编号
       String      getResponsibility()     取得部门负责事务说明数据
       Vector      getSubDepartmentList()  取得部门下直属子部门清单
       Vector      getRoleList()           取得部门下直属职务清单

    3. Role物件：职务的数据对象。
       要取得Role对象，必须透过Client对象，并给予参数-职务系统代码，使用方式如下：
       var Role = Client.getRole("Rol00001"); //Role即为职务的数据对象

       回传值/对象 函式(数据型态 参数)      说明
       String      getID()                 取得职务编号
       String      getName()               取得职务名称
       String      getDepartmentID()       取得职务所属部门编号
       String      getSynopsis()           取得职务描述
       Vector      getMemberList()         取得职务所属员工编号清单
       Vector      getRoleList()           取得职务管辖下直属的子职务清单
       Vector      getSubDepartmentList()  取得职务管辖下直属的子部门清单

    4. MemberRecord物件：用户的数据对象。
       要取得MemberRecord对象，必须透过Client对象，如：
       var member = Client.getCurrentMember();    // 取得当前用户的数据对象
       var member = Client.getMember("FR012");    // 取得公司编号为"FR012"的职员的数据对象
       var member = Client.getMemberByID("MEM001");   // 取得系统编号为"MEM001"的用户的数据对象
       var member = Client.getMemberByName("william");   // 取得账号为"william"的用户的数据对象
       var member = Client.getMemberByCName ("王小明");   // 取得姓名为"王小明"的用户的数据对象

       回传值/对象 函式(数据型态 参数)      说明
       String      getID()                 取得使用者编号
       String      getName()               取得使用者名称
       String      getLoginID()            取得使用者登录账号
       String      getPassword()           取得用户登录密码
       String      getEmail()              取得用户E-mail数据
       String      getPhone()              取得用户电话数据
       String      getSynopsis()           取得使用者描述
       Vector      getRoleList()           取得用户所扮演的职务清单
       Vector      getPrjRoleList()        取得用户参与的项目职务清单

七、 流程数据对象
     用以取得某个工作(Task)或是流程执行的窗体实例数据。
    1. Task物件
       回传值/对象      函式(数据型态 参数)        说明
       String           getID()                 取得工作编号
       String           getName()               取得工作编号
       String           getParentID()           取得上层工作编号
       String           getMemberID()           取得执行此工作的员工编号
       String           getProcessID()          取得此工作所属流程编号
       String           getRoleID()             取得执行此工作的职务编号
       String           getSynopsis()           取得工作描述
       String           getTaskState()          取得工作目前状态//如:running
       String           getTaskType()           取得工作类型数据
       long             getStartTime()          取得工作起始时间
       long             getEndTime()            取得工作结束时间
       long             getDuration()           取得工作执行期限
       PASEartInstance  getArtInstance()        取得此工作操作的窗体数据
       Vector           getRefArtifactList()    取得此工作参考的窗体列表，为PASEartInstance对象的集合
       Vector           getExtCondList()        取得此工作结束条件清单
       String           getStartTimeString()    取得工作起始时间(字符串数据)
       String           getTaskNote()           取得工作备忘录资料
       boolean          setKeyWord(String str)  设定工作开始时的工作主题

    2. PASEartInstance物件
       一个窗体的实例(instance)对象，亦即正在执行或是历史窗体的对象
       回传值/对象      函式(数据型态 参数)        说明
       String           getID()                   取得窗体实例编号
       String           getMyID()                 取得窗体实例流水号
       String           getName()                 取得窗体名称
       String           getTaskNote()             取得窗体编号
       PASEartState     getArtState()             取得窗体实例目前状态
       String           getAppValue(String key)   取得窗体实例中某个字段数据
       HashMap          getAppDataMap()           取得窗体实例的所有字段数据

    3. 流程数据对象使用范例
       var task = Form.getCurrentTask();   // 先取得目前的Task对象
       var mbrID = task.getMemberID();     //取得执行此工作的员工编号
       var aInstance = task.getArtInstance();   // 从task对象取得目前的窗体实例对象aInstance
       // 若窗体中有一字段「姓名」，即可以getAppValue(域名)取得字段数据
       var name = aInstance.getAppValue("姓名");
       var price = aInstance.getAppValue("金额");
       var state = aInstance.getArtState().getName(); //回传如："初始化"

       取得窗体流水号
       /* 在流程设计师的【文件设定】的【文件信息设定】中，可以设定窗体流水号的编码原则，
          在每张窗体开启时即给予唯一的流水号，但系统无法自动将流水号放入窗体中，须透过script写入 */
       var task = Form.getCurrentTask();
       var aInstance = task.getArtInstance();
       var formID = aInstance.getMyID();   //回传经过设定的编码原则产生之流水号
       Form.setValue("流水号",formID);

       取得参考窗体的窗体数据
       在流程设计时，若在同一个流程中有二种以上的窗体，较晚执行的窗体即可在「执行时机」中设定参考窗体，将参考窗体设定为较先执行的窗体，而透过script，即可在窗体中取得参考窗体的数据。
       以下为范例说明，假设一流程由请购人填写请购单，经主管审核后即交由采购填写采购单，若希望采购单的数据可以从请购单而来，可以在采购单的 preAction初始化中撰写以下script
       {初始化：
           var task = Form.getCurrentTask();
           // 取得参考窗体的对象集合refArtSet，为一Vector对象，若在执行时机仅设定请购单，则Vector对象仅存一笔数据
           var refArtSet = task.getRefArtifactList();
           if (refArtSet.size() > 0){
               var refArt = refArtSet.get(0);     // 取得请购单对象
               var price = refArt.get("金额");    // 取得请购单中字段「金额」的数据
               var amount = refArt.get("数量");   // 取得请购单中字段「数量」的数据
               Form.setValue("金额",price);
               Form.setValue("数量",amount);
           }
       }


八、 Java与Agentflow Script的整合
     对Agentflow Engine而言，在直译Script时，不仅可以执行Agentflow Script的对象，亦同样支持Java的类别
     令Agentflow开发系统的领域变得更加宽广。

  1. 内嵌JDK(Java Develop Kit)物件
     若要在Agentflow编辑环境中使用JDK的对象，只要指定完整路径即可，简单范例如下：
     var integer = java.lang.Integer.parseInt(string);

     例如：显示对话盒(dialog box)
     var message = "这是一个测试对话盒!!!";
     var dlg = new javax.swing.JOptionPane();     // 产生一个对话盒
     dlg.showMessageDialog(Form, message);        // 开启一对话盒并显示讯息

  2. 内嵌自定义对象(自己制作Java类别)
     只要以Java实作(编译)后的class，直接放在Agentflow Pase安装目录下的ext目录即可。
     c:\>…\Agentflow\pase\ext
     引用时，必须使用Packages对象将class引入如：  var demo = new Packages.ext.Demo_obj();

     例如：将数字转成中文大写
     var num = 1234;
     var numToChi = new Packages.ext.NumToChi(num);
     var ChiNum = numToChi.getChiNum();
     Form.setValue("中文大写",ChiNum);





九、应用 JSP


 范例：
/***************************** 启动流程后获得其内容 ********************************/
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%-- //引入套件 --%>
<%@ page session="true" %>
<%@ page import="java.sql.*,java.util.*" %>

<%@ page import="si.*" %>
<%@ page import="si.wfinterface.*" %>
<%@ page import="pe.pase.*" %>

<%@ page import="com.everunion.services.WFCIService, org.apache.commons.beanutils.BeanUtils" %>
<%@ page import="com.everunion.flow.order.*"%>
<%@ page import="com.everunion.util.*,com.everunion.flow.order.Comm"%>
<%@ page import="com.everunion.flow.quotation.IS8N" %>

<%
//清除cache
response.setContentType("text/html;charset=UTF-8");
  //如果是需要回传的Ajax，则写response.setContentType("text/xml);
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
%>

<%!
/**
 * 取得关卡别
 * @param processID 名称
 * @return int 关卡别
 */
public int computeStepNo(String processID)
{
    if ( "PRO00011257319114890".compareTo(processID) == 0 ) return 1; //填写请假单
    if ( "PRO00021257319208765".compareTo(processID) == 0 ) return 2; //代理人签核
    if ( "PRO00031257334256625".compareTo(processID) == 0 ) return 3; //单位主管审核
    if ( "PRO00041257334258734".compareTo(processID) == 0 ) return 4; //一级主管审核
    if ( "PRO00051257334439531".compareTo(processID) == 0 ) return 5; //人事承办签核
    if ( "PRO00061257337437937".compareTo(processID) == 0 ) return 6; //人事二组组长签核
    if ( "PRO00071257337440000".compareTo(processID) == 0 ) return 7; //人事主任签核
    if ( "PRO00081257339613765".compareTo(processID) == 0 ) return 8; //校长签核
    if ( "PRO00091257339616031".compareTo(processID) == 0 ) return 9; //会事务组审核
    if ( "PRO00101257339618218".compareTo(processID) == 0 ) return 10; //会三组审核
    if ( "PRO00111257340818906".compareTo(processID) == 0 ) return 11; //人事承办最终核定
    return 0;
}
%>
<%
IS8N is8n = new IS8N (request, "com.everunion.resource.flow.order.order_fillForm");
//数据库链接
Connection conn = null;
try
{
    //任务ID
    String taskID = "";
    if ( request.getParameter("TaskID") != null )
         taskID = com.flowring.encode.UtilGlobals.Base64Decoding(request.getParameter("TaskID"));

    WFCI wfci = WFCIService.getWFCI();

    //任务对象
    Task task = null;
    task = wfci.getTask( taskID );
    if ( task == null )
    {
        throw new Exception("无此纪录: task is null!!");
    }

    String taskName = "";
    //根ID
    String rootId = "";
    String InsID = "";
    HashMap hm = new HashMap();

    //窗体状态名称
    String stateName = ""; // = task.getArtInstance().getArtState().getName();
    //窗体状态编号
    String stateID = "";
    //目前关卡id
    String processID = "";
    String realExecutor =(String)session.getAttribute("cName");
        // realExecutor = task.getRealExecutor(); //取得每一关人员的编号
    //当前用户
    MemberRecord member = null;
    String loginName = session.getAttribute("account");
    String memberID = "";
    //数据集
    Vector subStaff = new Vector();

    //取得当前用户
    if ( session.getAttribute("CurrentMember") != null )
        member = (MemberRecord) session.getAttribute("CurrentMember");
    else
    {
        //取得MemberRecord
        member = wfci.getMemberByName(loginName);
        if ( member != null )
            session.setAttribute("CurrentMember", member);   //设置CurrentMember
        else return;
    }

    //取得id
    memberID = member.getID();
    //取得数据集
    if ( session.getAttribute("subStaff")!= null )
        subStaff = (Vector)session.getAttribute("subStaff");
    else
        subStaff = wfci.getSubMemListOfMember(memberID);


    //登录账号与真正执行者不同
    if ( !session.getAttribute("account").equals(member.getLoginID()) )
    {
         %>   <jsp:forward page="../taskDisabled.jsp" />    <%
    }
    //是否完成
    if ( "complete".compareTo(task.getTaskState()) == 0 )
    {
        //跳转
        %>  <jsp:forward page="../taskExist.jsp" />   <%
    }
    //没完成
    else
    {
        //启动
        wfci.startTask( task );
        //目前关卡id
        processID = task.getProcessID();
        //取得流程节点名称
        taskName = task.getName();
        rootId = task.getRootID();
        stepNo = computeStepNo(taskName);
        InsID = task.getInstanceID();
        hm = task.getArtInstance().getAppDataMap();
        artInstance = task.getArtInstance();
    }
%>
<%= task.getTaskState() %><br>

<%
// 以下代码是遍历 hashMap、session 和 request ；仅为方便调试

//遍历 hashMap
out.println("hashMap:<br>");
Iterator  it  =  hm.keySet().iterator();
while(it.hasNext())
{
    Object  key  =it.next();
    Object  value  =hm.get(key);
    out.println( key + " = " + value + "<br>" );
}

//遍历session
out.println("<br><br><br>session:<br>");
Enumeration e = session.getAttributeNames();
while( e.hasMoreElements() )
{
    String key = (String)e.nextElement();
    out.println( key + " = " + session.getAttribute(key) + "<br>" );
}

//遍历request
out.println("<br><br><br>request:<br>");
e = request.getParameterNames();
while( e.hasMoreElements() )
{
    String key = (String)e.nextElement();
    out.println( key + " = " + request.getParameter(key) + "<br>" );
}
%>

<%   //呼叫 WCPI 组件，可写下面这句，也可用 useBean
// com.flowring.struts.webapp.User user = (com.flowring.struts.webapp.User)session.getAttribute("user");
%>
<jsp:useBean id="user" scope="session" type="com.flowring.struts.webapp.User"/>

MemberID:<%=user.getMemberId()%><br> <%-- 印出使用者编号 --%>
User Name:<%=user.getCName()%><br> <%-- 印出使用者名称 --%>
Role:<%=user.getRoleName()%><br>   <%-- 印出使用者角色名称 --%>
Dep:<%=user.getDepName()%><br>    <%-- 印出使用者部门名称 --%>


员工号：<%= member.getMyID() %>

<%
}
catch ( Exception e )
{
    //打印
    e.printStackTrace();
    String[] path = this.getClass().toString().split("\\.");
    System.out.println(path[path.length-1] + " error:\r\n" + e);
}
finally
{
    DBConnect.freeConn(conn);
}
%>
/***************************** 启动流程后获得其内容 结束 ********************************/


/***************************** 流送出其内容 ********************************/
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--引入套件--%>
<%@ page session="true" %>
<%@ page import="java.sql.*,java.util.*" %>

<%@ page import="si.*" %>
<%@ page import="si.wfinterface.*" %>
<%@ page import="pe.pase.*" %>

<%@ page import="com.everunion.services.WFCIService, org.apache.commons.beanutils.BeanUtils" %>
<%@ page import="com.everunion.flow.order.*"%>
<%@ page import="com.everunion.util.*,com.everunion.flow.order.Comm"%>
<%@ page import="com.everunion.flow.quotation.IS8N" %>

<%!
/**
 * 当传来的 str 在 request 里为null时，传回""
 * @param request   HttpServletRequest
 * @param name   需要获取的页面上的name
 * @param init 默认值，如果页面上没有那个name的值，则传回此值
 * @return 获取的页面上的name，页面上没有则传回init
 */
public String getParameter(HttpServletRequest request, String name, String init)
{
    if ( request.getParameter(name) == null ) return init;
    String re = request.getParameter(name);
    if ( "".compareTo(re) == 0 ) return init;
    if ( "NULL".compareTo(re.toUpperCase()) == 0 )  return init;
    return re;
}
%>

<%
try
{
    //关卡别
    int stepNo = 0;
        stepNo = Integer.parseInt(getParameter(request,"stepNo","0"));

    //任务ID
    String taskID = "";
    if ( request.getParameter("TaskID") != null )
           taskID = request.getParameter("TaskID");

    WFCI wfci = null;
         wfci = WFCIService.getWFCI();
    //任务对象
    Task task = null;
         task = wfci.getTask( taskID );
    PASEartInstance artInstance = null;

    if ( task != null )
    {
        artInstance = task.getArtInstance();
        if( stepNo == 1 )
        {
            String Giveup = getParameter(request, "Giveup", "");
            if ( "true".compareTo(Giveup) != 0 )
            {
                String deputyLoginID = getParameter(request, "deputy", ""); //先获取deputy的loginID
                MemberRecord m = wfci.getMemberByName(deputyLoginID);
                artInstance.setAppValue( "deputyID", m.getMyID() );
            }
        }
        //把窗体送来的所有内容都更新过去。
        Enumeration e =  request.getParameterNames();
        while( e.hasMoreElements() )
        {
            String key = (String) e.nextElement();
            if( "timeStamp".compareTo(key)==0 || "TaskID".compareTo(key)==0
             || "stepNo".compareTo(key)==0 ) continue;
            String value= getParameter(request,key,""); // request.getParameter(key);
            artInstance.setAppValue( key, value );
        }
        wfci.updateArtInstance(artInstance);
        wfci.completeTask(task);
    }

}
catch ( Exception e )
{
    e.printStackTrace();
    System.out.println("_Ajax.jsp error" + e);
}
%>
/***************************** 流送出其内容 结束 ********************************/



范例：
获取主管、最高领导
//普通职员
String memberID = "MEM00300455304127";
MemberRecord member = wfci.getMember(memberID);
//获取主管
String managerDeparment = wfci.getManager(memberID)[0];
String managerRole = wfci.getManager(memberID)[1];
String managerID = wfci.getManager(memberID)[2];
//获取最高领导  有时出不来？？？
Role Result_company = wfci.getManagerRole("company");
Vector v = Result_company.getMemberList();
String headID = (String) v.elementAt(0);
out.println("最高领导："+wfci.getMember(headID).getName()+"<br>" );



/***************************** 遍历全公司 ********************************/
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--引入套件--%>
<%@ page session="true" %>
<%@ page import="java.sql.*,java.util.*" %>

<%@ page import="si.*" %>
<%@ page import="si.wfinterface.*" %>
<%@ page import="pe.pase.*" %>

<%@ page import="com.everunion.services.WFCIService, org.apache.commons.beanutils.BeanUtils" %>
<%@ page import="com.everunion.flow.order.*"%>
<%@ page import="com.everunion.util.*,com.everunion.flow.order.Comm"%>
<%@ page import="com.everunion.flow.quotation.IS8N" %>
<%!

/**
 * 遍历部门、职务下的所有子元素
 * 由于部门和职务的遍历方法很类似，故整合在一起
 * @param wfci
 * @param vector   保存Department、Role的ID集合
 * @param parentID 此节点的ID
 * @param number   第几层子元素
 * @return String  页面显示的内容
 */
public String getChild(WFCI wfci, Vector vector, String parentID, int number)
{
    StringBuffer child = new StringBuffer("");
    for(int index=0; index < vector.size(); index++)
    {
        String childID = (String) vector.elementAt(index);
        Object childElement = null;
        Vector roleVector   = null;
        Vector depVector    = null;
        String getParentID  = "";
        String tree_img     = "";
        String childName    = "";
        //如果是职务
        if ( wfci.getRole(childID) instanceof Role )
        {
            Role roleChild = wfci.getRole(childID);
            getParentID    = roleChild.getParentID();
            childName      = roleChild.getName();
            childElement   = roleChild;
            roleVector     = roleChild.getSubRoleList();
            depVector      = roleChild.getSubDepartmentList();
            tree_img       = "<IMG SRC='./image/tree_role.gif' ALT='职务'>";
        }
        //如果是部门
        else if ( wfci.getDepartment(childID) instanceof Department )
        {
            Department depChild = wfci.getDepartment(childID);
            getParentID         = depChild.getParentID();
            childName           = depChild.getName();
            roleVector          = depChild.getRoleList();
            depVector           = depChild.getSubDepartmentList();
            tree_img            = "<IMG SRC='./image/tree_department.gif' ALT='部门' >";
        }
        else
        {
            return "";
        }
        if( parentID.compareTo(getParentID) != 0 ) continue;
        child.append(addSpace(number));
        child.append("<span onClick=\"viewChild('"+childID+"')\">");
        child.append("<IMG id='img_" + childID + "' src='./image/closeView.gif'>" + tree_img);
        child.append(childName+"</span><br/>\r\n");
        child.append("<div id='"+childID+"' style='display:none'>");
        //如果是职务，则还需遍历它的直属员工。部门下不能有直属员工
        if( childElement instanceof Role )
        {
            child.append(getChildMember(wfci, (Role)childElement, number + 1));
        }
        child.append(getChild(wfci, roleVector, childID, number + 1));
        child.append(getChild(wfci, depVector, childID, number + 1));
        child.append("</div>");
    }
    return child.toString();
}

/**
 * 遍历此职务下的直属员工
 * @param wfci
 * @param role   需遍历的职务
 * @param number 第几层子元素
 * @return String 页面显示的内容
 */
public String getChildMember(WFCI wfci, Role role, int number)
{
    StringBuffer members = new StringBuffer("");
    //获取此 role 职务下的所有员工(包括非直属)，还没有获取职务下的直属员工的方法
    Vector memberIDs = role.getMemberList();
    for(int index=0; index < memberIDs.size(); index++)
    {
        String memberID = (String) memberIDs.elementAt(index);
        MemberRecord member = wfci.getMember(memberID);
        //获取此员工的所有职务
        Vector memberRoles = member.getRoleList();
        for(int i=0; i < memberRoles.size(); i++)
        {
            memberDR mDR = (memberDR) memberRoles.elementAt(i);
            //如果不是 role 的直属职务，则跳过
            if( role.getID().compareTo(mDR.getRoleID()) != 0 ) continue;
            members.append(addSpace(number));
            members.append("<IMG SRC='image/tree_member.gif' ALT='职员'>");
            members.append("<a HREF='#' onClick=\"set('" + member.getIdentityID());
            members.append("', '" + member.getName() +"', '" + mDR.getRoleName());
            members.append("', '" + mDR.getDepartmentName() +"', '" + member.getLoginID() +"')\">" );
            members.append(member.getName()+"</a><br/>\r\n");
        }
    }
    return members.toString();
}

/**
 * 增加空格，以表明层次
 * @param number 第几层子元素
 * @return String 页面显示的内容
 */
public String addSpace(int number)
{
    StringBuffer space = new StringBuffer("");
    for(int j=0; j < number; j++)
    {
        space.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }
    return space.toString();
}

%><%

try
{
    WFCI wfci = WFCIService.getWFCI();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
 <HEAD>
  <TITLE> New Document </TITLE>
  <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <script type="text/javascript">
    function viewChild(dataID)
    {
        var data = document.getElementById(dataID);
        var method = data.getAttribute("kk"); //kk是个随意起的名称
        var dataImg = document.getElementById("img_"+dataID);
        if( "block"===method )
        {
            data.style.cssText = "display:none";
            dataImg.setAttribute("src","image/closeView.gif");
            data.setAttribute("kk", "none");
        }
        // 此节点下没内容时
        else if( "" === data.innerHTML || data.innerHTML === null )
        {
            dataImg.setAttribute("src","image/none.gif");
        }
        // method=="none" 以及 method ==null 时
        else
        {
            data.style.cssText = "display:block";
            dataImg.setAttribute("src","image/openView.gif");
            data.setAttribute("kk", "block");
        }
    }
  </script>
 </HEAD>

 <BODY>
<%
    Company com = wfci.getCompany();
    out.println("<IMG SRC='./image/tree_company.gif' ALT='公司' >");
    out.println(com.getName()+"<br>");

    //遍历company
    //先遍历company下的职务
    Vector roles = wfci.getAllRoleIDOfCompany();
    out.println(getChild(wfci, roles, com.getID(), 1));

    //再遍历company下的部门
    Vector deparments = wfci.getAllDepIDOfCompany();
    out.println(getChild(wfci, deparments, com.getID(), 1));

    //显示未任职人员
    Vector members = wfci.getAllMember();
    out.print(addSpace(1));
    out.print("<span onClick=\"viewChild('noRoleMem')\">");
    out.print("<IMG id='img_noRoleMem' src='./image/move_right.gif'>");
    out.print("<IMG SRC='./image/norole.gif' ALT='未任职'>未任职</span><br/>\r\n");
    out.print("<div id='noRoleMem' style='display:none'>");
    for(int index=0; index < members.size(); index++)
    {
        MemberRecord member = (MemberRecord) members.elementAt(index);
        //获取此员工的主职务
        String memberRole = member.getMainRoleID();
        //如果此员工没有主职务，则说明他是未任职人员。只对未任职人员作如下显示
        if ( "".compareTo(memberRole) != 0 && memberRole != null ) continue;
        out.print(addSpace(2));
        out.print("<IMG SRC='image/tree_member.gif' ALT='职员'>");
        out.print(member.getName() + "<br/>\r\n");
    }
%>
 </BODY>
</HTML>
<%
}
catch ( Exception e )
{
    //打印
    e.printStackTrace();
    String[] path = this.getClass().toString().split("\\.");
    System.out.println(path[path.length-1] + " error:\r\n" + e);
}
%>
/***************************** 遍历全公司 结束 ********************************/





























