



范例：

/***************************** 产生一个Excel檔 ********************************/
/*
 当Agenda系统要和外界系统作沟通的时候，可以利用Java所提供的Runtime对象来达成。也就是当用户想要去呼叫某一系统起来时(如Word、Excel…等)，就可以使用此一对象。不过当被呼叫起来的系统不再被程序使用时，请记的要进行资源回收的动作，以防止资源一直被占用而无法释放。以下的范例先将Table组件的数据值输出成以“，”为区隔的字符串档案之功能写成一个Function，以模块化整个Script结构。接着再产生一个Excel文件并呼叫Excel应用程序。
*/

// 将 table资料转成以“,”隔开的csv檔 
function fn_toexcel(f_row,f_col) {
    var str   = "";
    var s_1 = "";
    for (i = 0;i <= f_row;i++) {
        for (j = 0;j <= f_col; j++) {
            s_1 = table.getValueAt(i,j) + ",";
            str   = str + s_1;
        }
        filetext.println(str);
        str = "";
    }
}
var s_dir = "c:\\report\\monthly\\月报表.csv"; //档案位置
var filetext1 = new Packages.java.io.FileWriter(s_dir,false); //开档
var filetext   = new Packages.java.io.PrintWriter(filetext1);
var table = Form.getComponent("table1");
//表头
var s_1 =  Form.getValue("查询年份");
var s_2 =  Form.getValue("查询月份");
var str  = "查询月份:" + s_1 +"年" + s_2 + "月";
filetext.println(str);
//取资料 
var str  = "产品名称,客户批号,进货日期,投入日期,备注" ;
filetext.println(str);
//表身 
fn_toexcel((table.getRowCount()-1),27);
filetext1.close();
//启动 
var rt = java.lang.Runtime.getRuntime();
var str2 = "start "+ s_dir;
rt.exec(str2);
/***************************** 产生Excel檔 结束 ********************************/



范例：使用常数的方式、取出目前Task的状态 
var Task =  Form.getCurrentTask(); 
var mID=Task.getRealExecutor(); 
java.lang.System.out.println("Task.TASK_STATE_READY="+ Task.TASK_STATE_READY); 
var tasklist = Client.getTaskOfMember(mID,Constant.TASK_STATE_READY); 
Form.setValue("TASK_STATE_READY",tasklist.toString()); 
var tasklist = Client.getTaskOfMember(mID,Constant.TASK_STATE_RUNNING);
Form.setValue("TASK_STATE_RUNNING",tasklist.toString()); 
var tasklist = Client.getTaskOfMember(mID, Constant.TASK_STATE_SUSPENDED); 
Form.setValue("TASK_STATE_SUSPENDED",tasklist.toString()); 
var tasklist = Client.getTaskOfMember(mID,Constant.TASK_STATE_COMPLETE); 
Form.setValue("TASK_STATE_COMPLETE",tasklist.toString());



范例：FormAPI：setComplete(于okAction控管窗体是否允许进行完成送出)
if ((iSubDays==0) && (iSubHour==0) && (iSubMinu==0)) {
    dlg.showMessageDialog(Form,"请假时数为0，请重新输入!");
    Form.setComplete(false);
} else {
    Form.setComplete(true);
}


范例：ClientAPI：设定/读取/移除一个Client Site区域对象 
//在 postAction 中抓取一些数据, 存下来供其他组件的Action来使用,如此避免每次都要重抓一次 
{state1: 
    var myTaskList = Client.getTaskOfMember("MEMxxxxxxx", Constant.TASK_STATE_ALL);
    // 将此数据存到 Client 数据 
    Client.setLocalObject("myTaskList1",myTaskList); 
    var data = Client.SQLloadValue("SELECT .... FROM ......");
    // 将此数据存到 Client 数据 
    Client.setLocalObject("dataXX",data);
}  
//某个 button 的 Action 
{ 
    // 取回原先存的数据 
    var list = Client.getLocalObject("myTaskList1");
    if(list != null) {
    //do something
    }
    // 取回原先存的数据 
    var data = Client.get("dataXX");
    if(data != null) {
        //do something 
    }
}


范例： ClientAPI：Client site to do "completeTask" 
※因为Form.closeForm()会有去update State，因此撰写顺序非常重要，否则Task会有残留的工作现象。 
if (Client != null) { 
    var t = Form.getCurrentTask(); 
    if (Client.checkTaskComplete(t)) { 
        Form.closeForm(); 
        Client.setArtInsExitState(t.getArtInstance());                   
        Client.completeTask(t); 
    } 
} 


范例：ClientAPI：检查用户输入密码的正确性 
var dlg = new Packages.javax.swing.JOptionPane(); 
var LoginID    = Form.getValue("账号"); 
var Password = Form.getValue("密码"); 
dlg.showMessageDialog(Form,'checkPassword='+ Client.checkPassword(LoginID,Password)); 


范例： ClientAPI：for Form create(建立窗体) 
a. JPanel createForm(String artID, String artInsID) 
var panel = Client.createForm("ART00000000000","Ans000000000603"); 
if (panel != null) { 
    var dlg = new Packages.javax.swing.JDialog(); 
    dlg.getContentPane().add(panel); 
    dlg.setSize(panel.getSize()); 
    dlg.setVisible(true); 
}

b. JPanel createForm(String artInsID) 
var dlg = new Packages.javax.swing.JOptionPane(); 
var panel = Client.createForm("Ans000000000603"); 
if (panel == null) { 
    dlg.showMessageDialog(Form,"查无此窗体"); 
}


/***************************** ClientAPI：寄送E-mail ********************************/
// 目前的Task资料 
var task = Form.getCurrentTask();
// 目前的用户数据 
var myMemberData = Client.getCurrentMember();
// 前一步骤的使用者名字 
var frontUserName = task.getFrontUser();
// 前一步骤的用户数据 
var memberData = Client.getMember(frontUserName);
if(memberData != null) {

    // 产生新的内部讯息数据 
    var msg = new Packages.pe.pase.PASEMessage();
    msg.setSendID(myMemberData.getID());        // 传送者ID 
    msg.setSendName(myMemberData.getName());    // 传送者名字 
    msg.setRecID(memberData.getID());           // 收信者ID 
    msg.setRecName(memberData.getName());       // 收信者名字 
    msg.setTitle("工作回复通知");               // 讯息主旨 
    //取得窗体夹文件 
    var msgForm = new Packages.pe.pase.MsgAttachFormData (Form.getArtInstance().getID(),task.getID()); 
    var vc = new java.util.Vector(); 
    vc.add(msgForm); 
    msg.setAttachList(vc); 
    // 讯息内容 
    var content = memberData.getName() + " 启动了「"  + task.getName() + "」工作。"; 
    msg.setMsg(content); 
    msg.setTime(java.lang.System.currentTimeMillis()); // 讯息产生时间 
    Client.sendPASEMessage(msg); 

    // 寄发 信件到该员工 e-mail 
    var from = myMemberData.getEmail();  // 信件来源 e-mail 
    var to = memberData.getEmail();      // 信件目的地 e-mail 
    var subject = "工作回复通知";          // 信件主旨 
    // 信件内容 
    var data = memberData.getName() + " 启动了「" + task.getName() + "」工作。" 
    // 传送e-mail给该员工 
    Client.sendMail(from,to,subject,data); 
} 
/***************************** 寄送E-mail 结束 ********************************/



范例：ServerAPI：寄送E-mail的做法 
var from = "abc@flowring.com"; 
var toMember = Server.getMember(MyTask.getMemberID()); 
var to = toMember.getEmail(); 
var title = "mail Title "; 
var data = "mail Content"; 
Server.sendMail(from,to,title,data); 


范例：ServerAPI：Server Site 自动执行时,改变文件状态的作法 
var PastStateID  = "AST01211255679951671";  //自动审核通过 的状态代码   可由 PDE 得知.
var falseStateID = "AST01221255681777281";  //自动不审核通过 的状态代码 可由 PDE 得知.
var ati = MyTask.getArtInstance();
var holiday = java.lang.Integer.parseInt( ati.getAppValue("Holiday") );
var totalDay = java.lang.Integer.parseInt( ati.getAppValue("TotalDay") );
if ( totalDay > holiday ) {
    Server.setArtInsState(ati,falseStateID);
}
else {
    Server.setArtInsState(ati,PastStateID);
}



范例：ClientAPI：可改变文件状态 
Client.setArtInsState(PASEartInstance artInstance, String stateID);


范例：Server Site：取出会签的意见内容 
var csInstance = MyTask.getCSInstance(); 
var note  = csInstance.getNote(); 
MyTask.getArtInstance().setAppValue("会签意见",note);


范例：Client Site：取出会签的意见内容 
var task = Form.getCurrentTask(); 
var csInstance =task.getCSInstance(); 
var note  = csInstance.getNote(); 
Form.setValue("会签意见",note); 



范例：Server API:
/* announceOnlineClient(), 于流程执行时传送讯息到Client端目前此API支持三种方式 
      0：在Client显示一个对话盒 
      1：在Client端的执行窗口上显示一段文字 
      2：让Client端的PC喇叭发出声音 
注意，这些通知讯息只有在该Client on line时才会显示。
*/
var clientMsg1 = new Packages.pe.pase.ClientMessage(0); // 对话盒
var param1 = new Packages.java.util.HashMap(); 
param1.put("title","===== test title ====");      //对话盒的标题 
param1.put("content","some message for you");     //对话盒的内容 
clientMsg1.setParam(param1); 
var clientMsg2 = new Packages.pe.pase.ClientMessage(1); // 显示文字 
var param2 = new Packages.java.lang.String("dump this message on screen");  //文字内容 
clientMsg2.setParam(param2); 
var clientMsg3 = new Packages.pe.pase.ClientMessage(2); // 发出声音 
var param3 = new Packages.java.lang.Integer(10);  // 次数 
clientMsg3.setParam(param3); 
Server.announceOnlineClient("yschen",clientMsg1);  // 送出第一个讯息 
Server.announceOnlineClient("yschen",clientMsg2);  // 送出第二个讯息 
Server.announceOnlineClient("yschen",clientMsg3);  // 送出第三个讯息 




/***************************** 设定定时执行及解除定时执行 ********************************
Server API：
注意事项: 
1.在server端控制 
2.命令为以一长字符串输入，如下例之command写法，和一般的script写法同，但原为"处改为\"，原为\n改为\\n。 
3.不论执行过否的命令行，在SERVER没有重新启动的情形下不会被移除，要自行移除。 
//根据窗体上客户类别下不同的时间控制， 
//于时间到时将本node上的数据通知前一node的user 
//但本node的user需要在填入数据后按暂停才能将现有的资料传回上一node  */

var refList=MyTask.getRefArtifactList(); 
var refArtInstance=refList.get(0); 
var cusRank = refArtInstance.getAppValue("客户类别"); 
var initiator = refArtInstance.getAppValue("受理人"); 
//time control, set different timer according to different types of customer 
//script to be executed at the specified time 
//get data from Artifact 010416 
var command = "var refList = MyTask.getRefArtifactList();"; 
command += "var refArtInstance = refList.get(0);"; 
command += "var date = refArtInstance.getAppValue(\"日期\");"; 
command += "var time = refArtInstance.getAppValue(\"时间\");"; 
command += "var cusRank = refArtInstance.getAppValue(\"客户类别\");"; 
command += "var cusName = refArtInstance.getAppValue(\"客户名称\");"; 
command += "var site = refArtInstance.getAppValue(\"障碍地点A\");"; 
command += "var cscMemberName = refArtInstance.getAppValue(\"受理人\");"; 
command += "var artInstance = MyTask.getArtInstance();"; 
command += "var handleRecord = artInstance.getAppValue(\"处理记录\");"; 
command += "var text = date +\" \"+ time
        + \"送出之障碍申告单尚未完成请注意!\\n\\n客户名称 : \" 
        + cusName + \"\\n客户类别 : \" + cusRank  
        + \"\\n障碍地点 : \" + site + \"\\n处理情形 : \" +handleRecord;";
command += "java.lang.System.out.println(text);"; 
//send Message to online user 
command += "var clientMsg1 = new Packages.pe.pase.ClientMessage(0);"; 
command += "var param1 = new Packages.java.util.HashMap();"; 
command += "param1.put(\"title\",\"!!!WARNING!!!\");"; 
command += "param1.put(\"content\",text);"; 
command += "clientMsg1.setParam(param1);"; 
command += "var clientMsg3 = new Packages.pe.pase.ClientMessage(2);"; 
command += "var param3 = new Packages.java.lang.Integer(5);"; 
command += "clientMsg3.setParam(param3);"; 
command += "Server.announceOnlineClient(cscMemberName,clientMsg1);"; 
command += "Server.announceOnlineClient(cscMemberName,clientMsg3);"; 
if (cusRank == "A"){ 
    var date = new Packages.pase.agenda.MyDate(); 
    var now = date.getCurrentDate("Y/M/D/H/m"); 
    var ann = date.addMin(now,1); 
    var taskID = MyTask.getID(); 
    for (var i=0;i<10;i++){ 
        var ann = date.addMin(ann,1); 
        //setTimeControl 
        Server.createCronScript(ann, command, taskID); 
    }
}
/***************************** 设定定时执行及解除定时执行 结束 ********************************/



范例：ClientAPI：createProcess相关用法 
//createProcess传回TaskID 
var taskID = Client.createProcess(userId,flowId,args);   
//getTask传回Task Object 
var task = Client.getTask(taskID);
//getTaskState传回TaskState 
var taskState = task.getTaskState();
if (taskState == Constant.TASK_STATE_READY){ 
    Packages.javax.swing.JOptionDialog().showMessageDialog(Form, "taskState is READY!!");
}


范例：ClientAPI：createProcessByRandom(String pID, HashMap arg) 
//配置参数数据结构 
var hashTable = new java.util.HashMap();
//由窗体读取参数数据 
var name = Form.getValue("姓名");
//将数据放入HashTable 
hashTable.put("姓名",name); 
//随机选取启动流程的人员 
var taskID = Client.createProcessByRandom("PRO0006972270347090",hashTable);


范例：Server, Client API： getManagerRole(String id) 
//首先寻找主要职务之Manager, 如无设定则任易选取一种职务之Manager. 
var mr = getManagerRole("MEM00000");
//寻找此职务之Manager. 如输入之职务"ROL00000"本身为主管，则寻找其主管。 
var mr = getManagerRole("ROL00000");
//寻找此部门之主管。 
var mr = getManagerRole("DEP00000");
//寻找此公司之最高主管。 
var mr = getManagerRole("company");



范例：AttachFile组件 
var attachFileCmp = Form.getComponent("AttachFile1");
attachFileCmp.setProperty("attach",false); // 关掉 attach 功能 
attachFileCmp.setProperty("uploadAll",true);// 上传档案 


范例：AttachFile组件properties : "FileList", "FileCount" 
var attachFileCmp1 = Form.getComponent("夹档1");
var attachFileCmp2 = Form.getComponent("夹档2");
//取得所有档案 
var filelist = attachFileCmp1.getProperty("FileList");
//配置文件案给另一AttachFile组件 
attachFileCmp2.setProperty("FileList",filelist);
//加入档案给另一AttachFile组件 
attachFileCmp2.setProperty("AppendFileList",filelist);
//取得档案数 
var count = attachFileCmp1.getProperty("FileCount") 


范例：改变Label组件的文字颜色 
var lab=Form.getComponent("Label4");
lab.setForeground(Packages.java.awt.Color.blue); //文字颜色改成蓝色 


范例：Table组件，改变table标题的作法 
//改table标题的用法 
var spane = Form.getComponent("Table1");
var table = spane.getViewport().getView();
//此行为取出第一行的标题0,1,2....为第几行 
var str = table.getColumnModel().getColumn(0).getHeaderValue();
//此行为改第一行的标题0,1,2...为第几行 
table.getColumnModel().getColumn(0).setHeaderValue("西瓜");
spane.repaint();


范例：Table组件，加入comboBox的作法 
//改table某column的editor用法 
//可以在没有设定editor为combobox情形下改为combobox 
var table = Form.getComponent("Table1").getViewport().getView();
var combo = new Packages.javax.swing.JComboBox();
combo.addItem("主机");
combo.addItem("屏幕");
combo.addItem("键盘");
var editor = new Packages.javax.swing.DefaultCellEditor(combo);
//此行为改第一行的editor,0,1,2...为第几行 
table.getColumnModel().getColumn(0).setCellEditor(editor);


范例：Table组件，加入自定义的Vector，并放进Table.string column的作法 
var vc1 = new java.util.Vector();
vc1.add("计算机主机");
vc1.add("计算机屏幕");
vc1.add("键盘");
vc1.add("鼠标");
var tb=Form.getComponent("Table1");
tb.newRow();
tb.setValueAt("采购单一",0,"String");
tb.setValueAt(10,0,"Integer");
tb.setValueAt(false,0,"Boolean");
tb.setValueAt(vc1,0,"JComboBox");


范例：Table组件：每列计算加总的作法 
var sum = 0;
var price = 0;
var table = Form.getComponent("table1");
if (table.getRowCount() > 1) { 
    for(var i=0;i<table.getRowCount()-1;i++) { 
        if ((table.getValueAt(i,"金额") != "")) { 
            price = java.lang.Double.parseDouble(table.getValueAt(i,"金额"));
            sum = sum + price;
        }
    } 
}


范例：Table组件：隐藏或还原被隐藏域的作法 
目前Table隐藏域，仅提供暂时性的隐藏，亦即当窗体关闭再开启又会恢复全貌的字段数。 
var dlg = new Packages.javax.swing.JOptionPane();
var table = Form.getComponent("Table");// 取得 MyTable 对象 
table.setColHiding("字段三");         // 隐藏"字段三" 
var strArr = table.getColHidingByName();// 取出被隐藏的域名 
dlg.showMessageDialog(Form,strArr);
table.resetColHiding();   // 取消所有隐藏的效果 


范例：Table组件：formula使用方法 
Table组件提供formula编辑器，使用规则为 SQL语法 + @{域名} 
@{域名} :表示数据条件会依用户在所指定字段的内容值而取出对应的查询结果。 
//依所输入的"员工编号"此字段的数据值，取出对应的员工姓名(Name)。 
SELECT Name FROM Mem_GenInf WHERE ID = @{员工编号} 


范例：BarCode组件：设定BarCode Value的内容值 
var cBarCode = Form.getComponent("BarCode1");
cBarCode.setProperty("code","9999");


范例：ComboBox组件：放入两个ITEM以上的作法 
//一般的写法,只能将一组ITEM的数据放入ComboBox 
var adder = new Packages.pase.agenda.MyComboBoxAdder(Client);
var comp = Form.getComponent("ComboBox1");
adder.addItems(comp,"Name","select Distinct Name from Rol_GenInf");
//多笔的处理后放入 
var combo = Form.getComponent("ComboBox1");  
combo.removeAllItems();             //先清掉ComboBox中原有资料 
var str = "select Distinct Name,ID from Rol_GenInf"; //取出两组数据 
var t7 = Client.SQLloadValue(str);
for (var i=0;i<t7.size();i++) { 
    var ht = t7.get(i);
    var aa = ht.get("Name");
    var bb = ht.get("ID");
    if (aa.length() > 0 ) {             
        // cc=aa+bb中,如aa是null,会出现错误(但bb是null则不会), 故要挡aa是null的情形 
        var cc = aa + bb;   
        // 可直接用addItem放入 
        combo.addItem(cc);           
    } else {  
    // aa是null,则直接放入bb 
    combo.addItem(bb); 
    } 
} 


范例：使用 SQL 语法 
//Select 
var SQLText="SELECT Name FROM Mem_GenInf WHERE ID = \"MEM000001\"";
var DataSet = Client.SQLloadValue(SQLText);
if (DataSet.size()>0) { 
    var sRecord = DataSet.get(0);
    var sName = sRecord.get("Name");
    Form.setValue("姓名",sName);
} 
//Insert 
var SQLText = " insert IDTEMP (ID) VALUES ('456')  ";
Client.SQLinsertValue(SQLText);
//Update 
var iTotal=1000;
var t_qty =20;
var SQLText = " UPDATE ART961723240490_Ins SET ITEM23 = "+iTotal+ " WHERE  ITEM23 = '+t_qty;
Client.SQLupdateValue(SQLText); 
//Delete 
var SQLText = " delete from Task  ";
Client.SQLdeleteValue(SQLText); 


范例：Script 撰写 Function 的作法： 
// function checknull(s) 
function checknull(s) { 
    if ( s == null ) { s = "";}
    return s  
} 
// main  
var ht1 =new java.util.HashMap();
var sNum = Form.getValue("赠品需求单号码");
sNum = checknull(sNum);
ht1.put("赠品需求单号码",sNum);


范例：显示询问的对话盒 
var yesnoDlg = new Packages.javax.swing.JOptionPane();
var n = yesnoDlg.showConfirmDialog(Form,"无批号,是否结案?","结案","1");
if (n == 0) {  //表示Yes 
    .... 
}


范例：设定Button Enable/Disable 
var tfObject = Form.getComponent("Button1");
tfObject.setEnabled(false);    // (1) false:表示Disable  (2)true :表示Enable 


范例：透过程序启动 Button、RadioButton、CheckBox 内程序 
var bt = Form.getComponent("Button1");
bt.doClick();
var rb = Form.getComponent("RadioButton1");
rb.doClick();
var cb = Form.getComponent("CheckBox1");
cb.doClick();


范例：取得文件编号 
var Task = Form.getCurrentTask();
var alnstance = Task.getArtInstance();
var No=alnstance.getMyID();
Form.setValue("文件编号",No);


范例：取得公司组织架构下成员姓名并放置窗体下拉式选单Combobox中 
var adder = new Packages.pase.agenda.MyComboBoxAdder(Client);
var comp1 = Form.getComponent("代理人");
adder.addItems(comp1,"UserName","select UserName from Mem_GenInf");



范例：取出员工相关信息的作法 
取出员工相关信息(使用前题:没有被设定代理人) 
// Get login User MyID,Name 
var cMember = Client.getCurrentMember();
Form.setValue("申请者员工编号",cMember.getMyID());
Form.setValue("申请者",cMember.getName());
// Get Role DATA ON CURRENTLY 
var mdr = cMember.getMemberDR(Task.getRoleID());
if(mdr != null) { 
    Form.setValue("申请者职称",mdr.getRoleName());
    Form.setValue("申请者职称编号",mdr.getRoleID());
    Form.setValue("申请者单位",mdr.getDepartmentName());
    Form.setValue("申请者单位代号",mdr.getDepartmentID());
} else { 
    Form.setValue("申请者职称","Unknown");
    Form.setValue("申请者职称编号","Unknown");
    Form.setValue("申请者单位","Unknown");
    Form.setValue("申请者单位代号","Unknown");
} 
取出当时Task执行者的信息 
// Default login User Name to set asking for person 
var Task =  Form.getCurrentTask();
var mID=Task.getRealExecutor(); //Task实际执行者 
var cMember = Client.getMemberByID(mID);
// Get Role,Department  
var mdr = cMember.getMemberDR(Task.getRoleID());
if(mdr != null) { 
    Form.setValue("职称",mdr.getRoleName());
    Form.setValue("单位",mdr.getDepartmentName());
} else { 
    Form.setValue("职称","Unknown");
    Form.setValue("单位","Unknown");
}

取出员工新方式(有无设定代理人，都可以正常被取出) 
// Get login User MyID,Name 
var Task =  Form.getCurrentTask();
var mID=Task.getRealExecutor(); //Task实际执行者 
var cMember = Client.getMemberByID(mID);
Form.setValue("员工编号",cMember.getMyID());
Form.setValue("姓名",cMember.getName());
// Get Department Name & Role Name 
var Str = java.lang.String(cMember.getRoleList().get(0));
var iStr=Str.indexOf("-");
var sDepName = java.lang.String(Str.substring(0,(iStr-1))).trim();
var sRoleName = java.lang.String(Str.substring((iStr+1),Str.length())).trim();
Form.setValue("单位",sDepName);
Form.setValue("职称",sRoleName);



范例：将Task 一次送给许多人 
若希望将下列的流程A分派给同一个职务的所有人执行 
流程A：START -> 1 -> 2 -> 3 -> END 
先设计另一个流程B，于B中获得所要分派人的名单，再使用createProcess 来启动多个流程A 
流程B：START -> 1 -> END 
其中1 设定为自动执行的流程，并在其【职务设定】->【执行动作】中撰写所需的Script 
// 取得所要分派的职务 
var role = Server.getRole("ROL0002982310491040");
if( role != null) { 
    // 取出此职务下的所有职员 
    var memberlist = role.getMemberList();
    for (var i=0;i<memberlist.size();i++) { 
        var mID = memberlist.get(i);
        var args = new Packages.java.util.HashMap();
        // 呼叫 createProcess, 启动流程A 
        Server.createProcess(mID,"PRO0018982766454101",args);
    } 
} 
写好后，只要用户起动流程B，就可以一次启动多个流程A，将工作分派给同一个职务下的每个人。 


范例：取出参考文件的内容数据 
//取出参考文件"请料单"的域值 
var task = Form.getCurrentTask();                               
var refList = task.getRefArtifactList();
if (refList.size() >0) { 
    // 取出第一份参考文件 
    var aInstance = refList.get(0);
    // 取出参考文件中"请料单号"字段的内容值 
    var str = aInstance.getAppValue("请料单号");
    // 将取出的资料设定到目前正在作用的窗体上 
    Form.setValue("已请料单号",str);
    //取出参考文件中Table组件的内容值 
    var Ins_tb = aInstance.getAppDataMap();
    // 原本参考文件Table组件命名为T3 
    var tb = Ins_tb.get("T3");
    if (tb.size() > 0) { 
        var table = Form.getComponent("T1");
        for (var i=0;i<tb.size();i++) { 
            var ht = tb.get(i);
            var row = table.newRow() - 1;
            table.setValueAt(ht.get("ITEM1"),row,"序号");
            table.setValueAt(ht.get("ITEM2"),row,"料号");
            table.setValueAt(ht.get("ITEM3"),row,"原料名称");
            table.setValueAt(ht.get("ITEM4"),row,"单位");
            table.setValueAt(ht.get("ITEM5"),row,"申请数量");
        }
    }
}



范例：检查目前Task是否来自代理他人工作的作法 
var dlg = new Packages.javax.swing.JOptionPane();
var tsk = Form.getCurrentTask();
var memID = tsk.getMemberID();
var realID = tsk.getRealExecutor();
if (memID.equals(realID)) { 
    dlg.showMessageDialog(Form,"没有代理任何人工作");
} else { 
    var mr = Client.getMemberByID(memID);
    dlg.showMessageDialog(Form,"代理:"+mr.getName());
} 


范例：将Vector的值放入List Object的使用方法 
var sSql = " select Name from Art_GenInf";
var RecordSet = Client.SQLloadValue(sSql);
var vc1 = new java.util.Vector();
if (RecordSet.size() > 0 ) { 
    for (i=0;i < RecordSet.size() ;i++) { 
        vc1.add(RecordSet.get(i).get("Name"));
    } 
} 
var list = (Packages.javax.swing.JList) 
(Form.getComponent("List1").getViewport().getView());
list.setListData(vc1);


范例：Array的使用方法 
var table = Form.getComponent("Table1");
var rCount = table.getRowCount(); 
// 加入此两行 
var cCom = new Array(rCount);
var cNam = new Array(rCount);
for(var i=0; i<rCount; i++) { 
    cCom[i] = table.getValueAt(i,"制令");
    cNam[i] = table.getValueAt(i,"客户");
    var Ustr = "update ART0015979544766775_Ins set ITEM35='"+cCom[i]+ "' where ITEM141='"+cNam[i]+"'";
    Client.SQLupdateValue(Ustr);
} 


范例：Server:会签流程前置动作 
//在分派会签成员阶段，系统会先执行此段Script。 
//此段Script的目的在新增一个参与会签成员。 
{CSANNEX: 
    var mem = new Array(3);
    mem[0] = "MEM0050991632102697";
    var member = Server.getMemberByID(mem[0]);
    mem[1] = member.getMainRoleID();
    var memDR = member.getMemberDR(mem[1]);
    mem[2] = memDR.getDepartmentID();
    MyTask.addAuditMember(mem);
} 
//会签在加签阶段，系统会先执行此段Script。 
//此段Script的目的在将所有的参与会签成员的名字、职务、与部门放进会签单内。 
{CSAUDIT: 
    var str = new java.lang.String();
    var auditList = MyTask.getAuditList();
    for(var i = 0;i < auditList.size();i++) { 
        var mem = auditList.get(i);
        str += ("\nMem == " + Server.getMemberByID(mem[0]).getName());
        str += (" ;Role == " + Server.getRole(mem[1]).getName());
        if(mem[2] == "company")  
            str += (" ;Dep == " + Server.getCompany().getName());
        else 
            str += (" ;Dep == " + Server.getDepartment(mem[2]).getName());
    } 
    MyTask.getCSInstance().setNote(str);
} 


范例：Server:会签流程后置动作 
//当会签在分派成员阶段的工作结束之后，系统会去执行此段Script。 
//此段Script的目的在将分派成员阶段设定完毕的参与会签成员在多加一个人员。 
{CSANNEX: 
    var mem = new Array(3);
    mem[0] = "MEM0050991632102697";
    var member = Server.getMemberByID(mem[0]);
    mem[1] = member.getMainRoleID();
    var memDR = member.getMemberDR(mem[1]);
    mem[2] = memDR.getDepartmentID();
    MyTask.addAuditMember(mem);
} 
//当会签在加签阶段工作完成后，系统会去执行此段Script。 
//此段Script的目的在将所有的参与会签成员的名字、职务、与部门列在会签意见之后。 
{CSAUDIT: 
    var str = MyTask.getCSInstance().getNote();
    var auditList = MyTask.getAuditList();
    for(var i = 0;i < auditList.size();i++) { 
        var mem = auditList.get(i);
        str += ("\nMem == " + Server.getMemberByID(mem[0]).getName());
        str += (" ;Role == " + Server.getRole(mem[1]).getName());
        if(mem[2] == "company")  
            str += (" ;Dep == " + Server.getCompany().getName());
        else 
            str += (" ;Dep == " + Server.getDepartment(mem[2]).getName());
    } 
    MyTask.getCSInstance().setNote(str);
}



范例：【分派动作】
//将此一工作的执行者更改为原本执行者的主管
{
    var managerRole = Server.getManagerRole(MyTask.getRoleID());
    var memberList = managerRole.getMemberList();
    MyTask.setRealExecutor(memberList.get(0));
    MyTask.setMemberID(memberList.get(0));
    MyTask.setRoleID(managerRole.getID());
    Server.updateTask(MyTask);
}


范例：【从数据库直接读取基本数据】
{ 
    //读取使用者名字、LoginID、EMail、说明 
    var memID = Client.getCurrentMember().getID();
    var memLoadStr = "select UserName, LoginID, EMail, Synopsis from "
        + "Mem_GenInf where MemID = '"+memID+"'";
    var memResult = Client.SQLloadValue(memLoadStr);
    var memData = memResult.get(0);
    var str = "[利用数据库取得数据]\n姓名："+memData.get("UserName")
        + "\nEMail："+memData.get("EMail")+"\nID："+memID
        + "\nLoginID："+memData.get("LoginID")
        + "\nSynopsis："+memData.get("Synopsis")+"\n";
//读取职务名称以及部门ID 
    var roleLoadStr = "select a.Name, a.DepID from Rol_GenInf a, Rol_Mem b "
        + "where b.MemID = '"+memID+"' AND b.RolID = a.RolID";
    var roleResult = Client.SQLloadValue(roleLoadStr);
    var depID = roleResult.get(0).get("DepID");
    //读取部门名称 
    var depLoadStr = "select Name from Dep_GenInf where DepID='"+depID+"'";
    var depResult = Client.SQLloadValue(depLoadStr);
    str = str + "部门："+depResult.get(0).get("Name")
        + "\n职称："+roleResult.get(0).get("Name")+"\n";
    //读取目前时间 
    var today = new Packages.pase.agenda.MyDate();
    var now = today.getCurrentDate("Y/M/D H:m");
    str += now;
    //将数据显示在电子表单上 
    Form.setValue("board", str);
}


范例：【防呆】 
防呆指的就是在电子表单里一些该填的数据没有填的话，系统就会做出一些预防措施以避免流程发生错误。
所有组件的防呆检查动作几乎都一样，就是一一去检查各组件里的字段是否该填的没填，接着再做出一些预防措施。
一般的防呆动作都是在送出窗体时才做，因此通常都是写在LayerPane的okAction方法里面。
范例中是使用Table组件，一检查到有字段未填时，系统就会显示出一个窗口并且阻止流程完成送出。
{初始化: 
    //检查Table中的字段是否有留白 
    ////Table中的最后一行通常都是空白的，且如果Table只有一行数据的话， 
 ////有可能没有最后的空白行，所以在检查时需分开检查。 
    var CheckValue = "";
    var table = Form.getComponent("Table1");
    if (table.getRowCount() == 1) { 
        if (table.getValueAt(0,"项目名称") == "") { 
            CheckValue = "项目名称";
        } else if (table.getValueAt(0,"单价") == "") { 
            CheckValue = "单价";
        } else if (table.getValueAt(0,"数量") == "") { 
            CheckValue = "数量";
        } else if (table.getValueAt(0,"总价") == "") { 
            CheckValue = "总价";
        }
    } else { 
        for(var i=0;i<table.getRowCount()-1;i++) {
            if (table.getValueAt(i,"项目名称") == "") { 
                CheckValue = "项目名称";
                break;
            } else if (table.getValueAt(i,"单价") == "") { 
                CheckValue = "单价";
                break;
            } else if (table.getValueAt(i,"数量") == "") { 
                CheckValue = "数量";
                break;
            } else if (table.getValueAt(i,"总价") == "") { 
                CheckValue = "总价";
                break;
            }     
        } 
    } 
 
    if(CheckValue != "") { //Table字段有留白 
        //显示出警告对话框 
        Packages.javax.swing.JOptionPane.showMessageDialog( 
Client.getClientMainFrame(), CheckValue+"字段未填写！",    
"工作未完成", Packages.javax.swing.JOptionPane.ERROR_MESSAGE);
        //阻止流程完成送出 
        Form.setComplete(false);
    } else {    //Table字段没有留白 
        //流程完成并送出 
        Form.setComplete(true);
    } 
}



范例：【多重流程、电子邮件与夹文件带至新流程】 
多重流程指的是一对多流程的分发。此范例内有用到两个流程，流程A及流程B，流程A是由部门主管所执行的，当执行完毕之后会将流程A的电子表单里面的内容传到流程B的电子表单里面，如果流程A中有夹文件，则此夹档亦会一起传送到流程B，接着将流程B分派给部门内除了主管之外的所有人去执行，并且会寄封电子邮件通知所有成员尽速完成工作。
流程A的流程为：STARTStep1END。分派流程B到部门其他成员、传送电子表单内容以及寄送电子邮件的程序代码是写在流程A电子表单中LayerPane的postAction方法里。
{State1: 
    //将流程A电子表单数据读取出来放进HashMap里 
    var args = new Packages.java.util.HashMap();
    args.put("title", Form.getValue("标题"));
    //将流程A电子表单的附加文件读取出来放进HashMap里 
    args.put("file", Form.getComponent("附加檔").getProperty("FileList"));
    //读取部门成员 
    var dep = Client.getDepartment("DEP00031011150625115");
    var roleList = dep.getRoleList();
    for(var i = 0;i < roleList.size();i++) { 
        var roleID = roleList.get(i);
        //如果职务为主管，则不再进行以下的动作 
        if(roleID == "ROL00061011150634569") continue;
        var role = Client.getRole(roleID);
        var memList = role.getMemberList();
        //将流程B分派给部门内部其他成员 
        for(var j = 0;j < memList.size();j++) { 
            var memID = memList.get(j);
            //分派流程B，内存流程A电子表单数据的HashMap为参数传给流程B 
            Client.createProcess(memID, "PRO00571011930907386", args);   
            //寄封电子邮件通知成员尽快完成流程B 
            //电子邮件的出处 
var from = "guest@test.com";    
//电子邮件的目的地 
var to = Client.getMember(memID).getEmail();    
//电子邮件的主题 
            var subject = "工作通知";    
            //电子邮件的内容 
            var text = "Dear All:\n        请尽快完成流程B\nManager";    
            Client.sendMail(from, to, subject, text);
        } 
    }
} 
 流程B的流程为：STARTStep1Step2END。由于流程B已经被一一
的分派给所需执行此流程的成员，因此在流程B中只需将流程A所传过来的
电子表单数据读取出来，此段程序代码写在流程B电子表单中LayerPane的
preAction方法里。程序代码如下。 
{ALL: 
    //读取流程A在建构流程B时所传的HashMap参数    
    var task = Form.getCurrentTask();   
    var parentID = task.getParentID();   
    var globals = Client.getGlobals(parentID);   
    if (globals != null) {    
        //读取传过来的数据 
    var title = globals.get("title");
        Form.setValue("title", title);
        //读取流程B的附加文件的数据 
        var attachFileCmp = Form.getComponent("附加檔");
        //设定附加文件的属性 
        attachFileCmp.setProperty("delete", false);
        //读取流程A传过来的附加文件的数据 
        var fileList = globals.get("file");
        if(fileList != null) { 
            //将流程A附加文件内的档案存到流程B附加文件内 
            attachFileCmp.setProperty("AppendFileList", fileList);
        } 
    }    
}



范例：【会签】 
会签流程中有三个状态，此范例就分别针对这三种状态做不同的事情。程序代码是写在LayerPane的preAction方法里面。
{ALL: 
    var tsk = Form.getCurrentTask();
    //csannex;指派会签人员分派成员 
    if(tsk.getTaskType().equals("csannex")) { 
        //范例中的此部份只在提醒指派会签人员要进行分派成员的动作 
        Form.setValue("board", "请分派参与会签成员。");
    } 
    //csaudit;参与会签成员正在进行会签动作 
    if(tsk.getTaskType().equals("csaudit")) { 
        //范例中的此部份会将参与会签成员的名单列在窗体上 
        var list = tsk.getAuditList();
        var listStr = "指派会签人员所分派的参与会签成员名单如下。";
        for(var i = 0;i < list.size();i++) { 
            var data = list.get(i);
            //参与会签成员 
            var memberName = Client.getMemberByID(data[0]);
            //参与会签成员所担任的职务 
            var roleName = Client.getRole(data[1]);
            //参与会签成员所在的部门 
            var depName = Client.getDepartment(data[2]);
            listStr = listStr +"\n"+depName+"/"+roleName+"/"+memberName;
        } 
        Form.setValue("board", listStr);
    } 
    //csreview;审查者检视会签内容 
    if(tsk.getTaskType().equals("csreview")) { 
        var content = "会签意见汇整如下。";
        //读取汇整之后的会签内容 
        content = content + "\n" + tsk.getCSInstance().getNote();
        Form.setValue("board", content);
    } 
} 


范例：【参考文件】 
此范例的目的在将参考文件里的内容传到作用文件里。程序代码是写在作用文件中LayerPane的preAction方法里面，将其列在下方。
{初始化: 
    var task=Form.getCurrentTask();
    //取得所有的参考文件，在refList这个Vector里面的对象都是PASEartInstance 
    var refList=task.getRefArtifactList();
    if (refList.size() > 0) { 
        var aInstance=refList.get(0);
        //将列在第一份的参考文件的内容传到作用文件上 
        Form.setValue("board",aInstance.getAppValue("board"));
    } 
}


