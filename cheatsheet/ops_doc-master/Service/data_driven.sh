data(数据驱动编程的核心是用数据表示逻辑){
  数据压倒一切。
  如果选择了正确的数据结构并把一切组织的井井有条，正确的算法就不言自明。编程的核心是数据结构，而不是算法。
      数据是易变的，逻辑是稳定的。           # 可维护性
      相对于程序逻辑，人类更擅长于处理数据。 # 可读性
      数据比程序逻辑更容易驾驭，所以我们应该尽可能的将设计的复杂度从程序逻辑转移至数据。   # 可读性
      程序员束手无策，只有跳脱代码，直起腰，仔细思考数据才是最好的行动。表达式编程的精髓。 # 转变思路
      
      
  1. 所有的程序设计语言大概有3个源流：结构化编程；面向对象编程；数据驱动编程。
  
  2.1 数据驱动编程的本质是"参数化抽象"的思想，不同于OO的"规范化抽象"的思想。
  2.1 数据驱动编程中，数据不但表示了某个对象的状态，实际上还定义了程序的流程；OO看重的是封装，而数据驱动编程看重的是编写尽可能少的代码。
  
  3. 将变和不变的部分分离，策略和机制分离：数据和代码的分离，微语言和解释器的分离，被生成代码和代码生成器的分离
  
  4. 元编程分为静态元编程(编译时)和动态元编程(运行时)，静态元编程本质上是一种 代码生成技术或者编译器技术；动态元编程一般通过解释器(或虚拟机)加以实现。
  
  在数据驱动编程中数据不仅仅是对象的抽象，更重要的是它还可以去定义程序的控制流。

设计思路
  把程序逻辑和引用函数转换到数据结构的数据字段，使用字段控制程序逻辑，而不需新添逻辑代码。
  代码通过提供不同的数据集，程序逻辑根据数据控制程序状态改变：
  states:UP - DOWN - STOP - START
  1. 规则集合根据不同数据输入执行不同决策，输出不同的结果
  2. 根据特定输出触发的几个预定执行过程
应用范围
  1. 结构化流数据：日志文件，定界符分隔的值，电子邮件消息，电子邮件过滤
  2. 过滤
  3. 转化
  4. 聚集
  5. 调用其他程序
语言：
awk sed perl lua
}

data(){

"相较于其它方式，我一直热衷于推崇围绕数据设计代码，我想这也是Git能够如此成功的一大原因[…]在我看来，
区别程序员优劣的一大标准就在于他是否认为自己设计的代码还是数据结构更为重要。"
-- Linus Torvalds

"优秀的数据结构与简陋的代码组合远比反之的组合更好。"
-- Eric S. Raymond, The Cathedral and The Bazaar
}

data(1. 使用SQL生成SQL语句){
ORM方法论基于三个核心原则： 
  简单：以最基本的形式建模数据。
  传达性：数据库结构被任何人都能理解的语言文档化。 
  精确性：基于数据模型创建正确标准化了的结构。
}
data(2. 代码生成器){

}
chain(职责链模式){
事件模型就是典型的"职责链模式"(Chain-of-responsibility pattern)，看看职责链

}
  
2. 认识：
         从命令式编程范式，转向了声明式编程范式
         数据的表现形式是编程的根本

   好的代码总是将复杂的逻辑以分层的方式降低单个层次上的复杂度。复杂与简单有一个相互转化的过程。
   
   
table(表驱动编程的核心是索引,参数抽象,回调函数){
Control_table  # https://en.wikipedia.org/wiki/Control_table
Decision_table # https://en.wikipedia.org/wiki/Decision_table

# 表驱动法——实现
i. 提取共性，做到为每个元素做一样的事。把共性放到表中, 用查表法取代switch。 
ii. 提供支持函数，因为提取共性后会要求有为这些共性服务的函数。
   第1步是比较简单的，把第2步想透了才会提升使用表驱动法的层次。
# 表驱动法——意义
表驱动法，一方面简化代码实现，便于维护。(这里的简化强调地是上层实现逻辑的简化。) 
          二是提高代码的弹性，增减内容的成本低，甚至可以做到动态支持。

http://www.cnblogs.com/clover-toeic/p/3730362.html
1. 表驱动法(Table-Driven Approach):用查表的方法获取数据。此处的"表"通常为数组，但可视为数据库的一种体现。
2. 具体到编程方面，在数据不多时可用逻辑判断语句(if…else或switch…case)来获取值；
   但随着数据的增多，逻辑语句会越来越长，此时表驱动法的优势就开始显现。
3. 使用表驱动法时需要关注两个问题：一是如何查表，从表中读取正确的数据；二是表里存放什么，如数值或函数指针。
4. 数据驱动编程可以应用于：
    函数级设计，如本文示例。
    程序级设计，如用表驱动法实现状态机。
    系统级设计，如DSL
    
机制就是消息的处理逻辑，策略就是不同的消息处理

凡是能通过逻辑语句来选择的事务，都可以通过查表来选择.

需要注意的一些细节：
1，留心端点。
2，考虑用二分查找取代顺序查找。
3，考虑用索引访问来取代阶梯技术
}
table(直接查找){
    查表方式
        常用的查表方式有直接查找、索引查找和分段查找等。
1. 直接查找 : 即直接通过数组下标获取到数据
  如获取星期名称，逻辑判断语句如下：
# if(0 == ucDay){
#     pszDayName = "Sunday";
# }
# else if(1 == ucDay){
#     pszDayName = "Monday";
# }
# //... ...
# else if(6 == ucDay){
#     pszDayName = "Saturday";
# }
# 而实现同样的功能，可将这些数据存储到一个表里：
# CHAR *paNumChars[] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",  "Saturday"};
# CHAR *pszDayName = paNumChars[ucDay];
对于过于复杂和庞大的判断，可将数据存为文件，需要时加载文件初始化数组，从而在不修改程序的情况下调整里面的数值。
1.1 Redis.c(populateCommandTable)函数中：redisCommandTable，以及server.commands和server.orig_commands对象
1.2 Redis.c(initServerConfig)函数中：server.commands = dictCreate(&commandTableDictType,NULL)

1.3 字符统计
# INT32U aDigitCharNum[10] = {0}; /* 输入字符串中各数字字符出现的次数 */  
# INT32U dwStrLen = strlen(szDigits);
# for(; dwStrIdx < dwStrLen; dwStrIdx++)
# {
#     aDigitCharNum[szDigits[dwStrIdx] - '0']++;
# }
1.4 消息处理
# typedef struct{
#     OAM_LOG_OFF = (INT8U)0,
#     OAM_LOG_ON  = (INT8U)1
# }E_OAM_LOG_MODE;
# typedef FUNC_STATUS (*OamLogHandler)(VOID);
# typedef struct{
#     CHAR           *pszLogCls;    /* 打印级别 */
#     E_OAM_LOG_MODE eLogMode;      /* 打印模式 */
#     OamLogHandler  fnLogHandler;  /* 打印函数 */
# }T_OAM_LOG_MAP;
# 
# T_OAM_LOG_MAP gOamLogMap[] = {
#     {"all",         OAM_LOG_OFF,       noanylog},
#     {"oam",         OAM_LOG_OFF,       nologOam},
#     //... ...
#     {"version",     OAM_LOG_OFF,       nologVersion},
#     
#     {"all",         OAM_LOG_ON,        logall},
#     {"oam",         OAM_LOG_ON,        logOam},
#     //... ...
#     {"version",     OAM_LOG_ON,        logVersion}
# };
# INT32U gOamLogMapNum = sizeof(gOamLogMap) / sizeof(T_OAM_LOG_MAP);
# 
# VOID logExec(CHAR *pszName, INT8U ucSwitch)
# {
#     INT8U ucIdx = 0;
#     for(; ucIdx < gOamLogMapNum; ucIdx++)
#     {
#         if((ucSwitch == gOamLogMap[ucIdx].eLogMode) &&
#            (!strcasecmp(pszName, gOamLogMap[ucIdx].pszLogCls));
#         {
#             gOamLogMap[ucIdx].fnLogHandler();
#             return;
#         }
#     }
#     if(ucIdx == gOamLogMapNum)
#     {
#         printf("Unknown LogClass(%s) or LogMode(%d)!\n", pszName, ucSwitch);
#         return;
#     }
# }

}

table(索引查找){
  有时通过一次键值转换，依然无法把数据(如英文单词等)转为键值。此时可将转换的对应关系写到一个索引表里，即索引访问。
}

table(分段查找){
  通过确定数据所处的范围确定分类(下标)。有的数据可分成若干区间，即具有阶梯性，如分数等级。此时可将每个区间的上限
(或下限)存到一个表中，将对应的值存到另一表中，通过第一个表确定所处的区段，再由区段下标在第二个表里读取相应数值。注意要留意端点，可用二分法查找，另外可考虑通过索引方法来代替。
   #define MAX_GRADE_LEVEL (INT8U)5  2 DOUBLE aRangeLimit[MAX_GRADE_LEVEL] = {50.0, 60.0, 70.0, 80.0, 100.0};
#  CHAR *paGrades[MAX_GRADE_LEVEL] = {"Fail", "Pass", "Credit", "Distinction", "High Distinction"};
#  static CHAR* EvaluateGrade(DOUBLE dScore)
#  {
#      INT8U ucLevel = 0;
#      for(; ucLevel < MAX_GRADE_LEVEL; ucLevel++){
#          if(dScore < aRangeLimit[ucLevel])
#              return paGrades[ucLevel];
#      }
#      return paGrades[0];
#  }
#   typedef struct{
#       DOUBLE  aRangeLimit;
#   CHAR *pszGrade;
#   }T_GRADE_MAP;
#   T_GRADE_MAP gGradeMap[MAX_GRADE_LEVEL] = {
#   {50.0, "Fail"},
#   {60.0, "Pass"},
#   {70.0, "Credit"},
#   {80.0, "Distinction"},
#   {100.0, "High Distinction"}
#   };
#   static CHAR* EvaluateGrade(DOUBLE dScore)
#   {
#     INT8U ucLevel = 0;
#     for(; ucLevel < MAX_GRADE_LEVEL; ucLevel++)
#     {
#         if(dScore < gGradeMap[ucLevel].aRangeLimit)
#             return gGradeMap[ucLevel].pszGrade;
#     }
#     return gGradeMap[0].pszGrade;
#   }
}

table(有感于ucos_arm){
#  typedef struct  __EVENT_DRIVE
#  {
#      MODE_TYPE mod;//消息的发送模块
#      EVENT_TYPE event;//消息类型
#      STATUS_TYPE status;//自身状态
#      EVENT_FUN eventfun;//此状态下的处理函数指针
#  }EVENT_DRIVE;
#
#  EVENT_DRIVE eventdriver[] = //这就是一张表的定义，不一定是数据库中的表。也可以使自己定义的一个结构体数组。
#  {
#      {MODE_A, EVENT_a, STATUS_1, fun1}
#      {MODE_A, EVENT_a, STATUS_2, fun2}
#      {MODE_A, EVENT_a, STATUS_3, fun3}
#      {MODE_A, EVENT_b, STATUS_1, fun4}
#      {MODE_A, EVENT_b, STATUS_2, fun5}
#      
#      {MODE_B, EVENT_a, STATUS_1, fun6}
#      {MODE_B, EVENT_a, STATUS_2, fun7}
#      {MODE_B, EVENT_a, STATUS_3, fun8}
#      {MODE_B, EVENT_b, STATUS_1, fun9}
#      {MODE_B, EVENT_b, STATUS_2, fun10}
#  };
#  int driversize = sizeof(eventdriver) / sizeof(EVENT_DRIVE)//驱动表的大小
#  EVENT_FUN GetFunFromDriver(MODE_TYPE mod, EVENT_TYPE event, STATUS_TYPE status)//驱动表查找函数
#  {
#      int i = 0;
#      for (i = 0; i < driversize; i ++)
#      {
#          if ((eventdriver[i].mod == mod) && (eventdriver[i].event == event) && (eventdriver[i].status == status))
#          {
#              return eventdriver[i].eventfun;
#          }
#      }
#      return NULL;
#  }

}


event(事件驱动){

}

timed(时间驱动){

}
Metaprogramming(数据驱动编程，也叫元编程){
C "X Macros"
C++ Templates
bash shell
Python
}

data(Data_structures){
https://en.wikipedia.org/wiki/Book:Data_structures
}

object(){
    属性            此事件发生在何时...
    onabort         图像的加载被中断。
    onblur          元素失去焦点。
    onchange        域的内容被改变。
    onclick         当用户点击某个对象时调用的事件句柄。 
    ondblclick      当用户双击某个对象时调用的事件句柄。 
    onerror         在加载文档或图像时发生错误。
    onfocus         元素获得焦点。
    onkeydown       某个键盘按键被按下。
    onkeypress      某个键盘按键被按下并松开。
    onkeyup         某个键盘按键被松开。
    onload          一张页面或一幅图像完成加载。
    onmousedown     鼠标按钮被按下。                    
    onmousemove     鼠标被移动。
    onmouseout      鼠标从某元素移开。
    onmouseover     鼠标移到某元素之上。                
    onmouseup       鼠标按键被松开。                    
    onreset         重置按钮被点击。
    onresize        窗口或框架被重新调整大小。
    onselect        文本被选中。
    onsubmit        确认按钮被点击。
    onunload        用户退出页面。
    
    属性              描述
    altKey          返回当事件被触发时，"ALT" 是否被按下。
    button          返回当事件被触发时，哪个鼠标按钮被点击。
    clientX         返回当事件被触发时，鼠标指针的水平坐标。
    clientY         返回当事件被触发时，鼠标指针的垂直坐标。
    ctrlKey         返回当事件被触发时，"CTRL" 键是否被按下。
    metaKey         返回当事件被触发时，"meta" 键是否被按下。
    relatedTarget   返回与事件的目标节点相关的节点。
    screenX         返回当某个事件被触发时，鼠标指针的水平坐标。
    screenY         返回当某个事件被触发时，鼠标指针的垂直坐标。
    shiftKey        返回当事件被触发时，"SHIFT" 键是否被按下。
面向对象的核心是抽象操作。即将不同的对象抽象成相同的几个操作。
}

structures(){
Structured Programming (book) 
A Discipline of Programming (book) 
A Method of Programming (book) 
Predicate Calculus and Program Semantics (book) 
Selected Writings on Computing: A Personal Perspective (book)

}