EJB 3.0
Sun App/JBoss/Weblogic
-----------------------------------------------------------
Day1

1. What is EJB
   EJB(Enterprise JavaBean)是JavaEE应用的业务层技术标准, 以这项技术开发的组件叫做EJB组件，常常简称EJB
   EJB架构是一个用于开发和部署基于组件的分布式业务应用的组件架构。
   采用EJB架构编写的应用是可伸缩的、事务性的、多用户安全的。
   可以一次编写这些应用，然后部署到任何支持EJB规范的应用服务器平台上。

   特点(和JavaBean比较)：
    1)提供远程访问的能力
    2)可扩展、可插拔的能力
    3)必须在EJB服务器上运行, 可享受服务器提供的事务、安全等服务
      (Jboss, Weblogic, Websphere, Sun Application server)

名词解析：
   1.分布式计算：
       1)把大任务分成小块，分发给大家分别地做，再把每个人的计算结果汇总。
         特点：分解工作，减轻成员的负担，成员之间做到职责分明。
       2)充分利用网络上空闲的计算机的计算能力。
     分布式组件：
       1)分布对象技术是伴随网络而发展起来的一种面向对象的技术。
         以前的计算机系统多是单机系统，多个用户是通过联机终端来访问的，没有网络的概念。
         网络出现后，产生了C/S、B/S的计算服务模式。
       2)分布式对象技术主要使用了面向对象技术的封装性，组件可以分布在网络的任何位置。
         对外界来说，它所需关心的只是组件的界面(接口)，至于内部是如何实现的则无需考虑，
         远程客户通过方法调用来访问它。这是分布式对象技术和传统的面向对象技术的最大不同点。
   2.组件：可独立发布的二进制单元
   3.框架，即framework。其实就是某种应用的半成品，就是一组组件，供你选用完成你自己的系统；
         代表：Struts,Spring,Hibernate…
   4.中间件，是一种独立的系统软件或服务程序，分布式应用软件借助这种软件在不同的技术之间共享资源；
         代表：Weblogic,WebSphere,Sun App Server…
   5.容器：
     EJB的家。 离开容器，EJB就失去了它的生命和意义

   EJB分布式对象的基础
       JRMI(Java Remote Method Invocation) (远程方法调用)
           --- 使用远程消息交换协议JRMP(Java Remote Messaging Protocol) 进行通讯
       CORBA对象调用
           --- 使用IIOP(Internet Inter-ORB Protocal)


2. Why EJB
   简化大型分布式系统的开发过程。
     1)利用网络中多台计算机的计算能力，构建瘦客户端(简化分布式访问)
     2)使用EJB服务器提供的系统级的企业服务(事务、安全、对象池....)，开发人员需要写业务组件
     3)EJB组件具有热部署的能力(可插拔)
     4)可以扩展现有系统的JavaBean
   优点：可维护性、重用性、可扩展性、可插拔性
     1)缩短开发时间：  编程人员可将先行开发的部件装配到新的程序中，从而加速了新程序的开发
     2)降低集成费用：  在将组件集成为一个完整的方案时，不同开发商采用了一致的标准接口，减少了特殊的定制工作
     3)开发更具灵性：  只需简单调整全部应用的一些组件，即可为企业不同领域的应用提供特定的解决方案
     4)降低维护费用：  各组件的软件功能是相对独立的，在维护和升级一个组件时，不必变动整个应用。维护简便


3. When to use EJB
   少量的需要分布式技术支持的大型项目，比如：
   1)应付巨大的客户访问量     2)和已有的系统做集成

   EJB可以做什么？
    1)服务器端的业务层框架    2)遵循EJB规范的标准组件    3)分布式组件
    4)持久化数据支持          5)事务性支持               6)支持并发多用户安全

技术选择：
    表现层技术：Servlet, JSP     MVC框架：Struts,Tapestry,MyFaces...
    业务层组件：JavaBean         集成层： Spring,EJB
    持久层技术：JDBC             ORM框架：Hibernate,TopLink,OpenJPA,EJB JPA...
常见技术组合：
    Struts/MyFaces + EJB(JDBC)
      需要分布式技术的大型项目，大并发访问量，性能要求高
    Struts/MyFaces + Spring + Hibernate
      多数中小型项目

EJB 3.0
   1)会话Bean：对业务逻辑建模
     分类： 有状态，能分辨不同的客户；无状态，不能分辨不同的客户
   2)实体(Entity)
        POJO
   3)消息Bean
     支持异步通信。没有直接的客户端，由消息触发(驱动)


4. First EJB开发步骤：
   EJB组件开发：
    1)安装JBoss，并启动
      默认端口：8080；可以修改 %jboss_home%/server/default/deploy/jboss-web.deployer 的server.xml
      把 <Service name="jboss.web"> 的 <Connector port="8080" ... 改成想要的就行
    2)开发一个普通的Java组件
    3)classpath加上Java EE 5 Libraries(MyEclipse自带类库)
    4)加EJB的标注，声明为EJB组件
      IHello.java (接口标注：@Remote )
      HelloBean.java (无状态会话bean标注：@Stateless )
    5)编译，在 FirstEJB/bin 运行命令: jar cvf HelloEJB.jar .
    6)拷贝HelloEJB.jar到%jboss_home%/server/default/deploy目录下
      这是正常发布方法。需要启动%jboss_home%/bin/run.jar (win下用run.bat,linux用run.sh启动)
    7)确认组件已部署(控制台没有异常)

   EJB客户端开发：
    1)classpath加上jbossall-client.jar(这个包在 %jboss_home%/client/ 下)
      引入这个jar包之后才可以初始化上下文(context)
    2)引入IHello.class
    3)Client.java

5. JNDI(Java 命名和目录服务接口)
   JNDI为JavaEE平台提供了一个通过名字查找网络中一切对象的标准机制
   是一套为开发者提供通过名字方便查找用户、机器、网络、对象和服务的 Java API
   JNDI实现了EJB对象位置的透明性，客户端只要能访问JNDI服务，便可以调用EJB服务。
   1) 部署ejb的时候，容器将会把EJB对象绑定到命名服务
   2) 像JDBC可以访问不同的数据库，可以通过JNDI访问不同的JNDI服务
      a.设置上下文工厂
      b.设置JNDI服务提供者的url
   3) JNDI的API的使用
      初始化上下文(Context ctx = new InitialContext())
          --- 不同的应用服务器初始化上下文的工厂类是不同的，协议也可能不一样！！！查文档吧
      三种方式初始化上下文:
        a)设置系统属性(Test.java中)
          System.setProperty(Context.INITIAL_CONTEXT_FACTORY,
                org.jnp.interfaces.NamingContextFactory.class.getName());
          上句也可以这样写： System.setProperty("java.naming.factory.initial",
                "org.jnp.interfaces.NamingContextFactory");
          System.setProperty(Context.PROVIDER_URL, "localhost");
                //"localhost" 也可以写： jnp://127.0.0.1:1099
        b)通过命令行设置
        c)在类路径下添加jndi.properties  ---名字不能修改！！
         jboss中：
          java.naming.factory.initial=org.jnp.interfaces.NamingContextFactory
          java.naming.provider.url=jnp://localhost:1099
         Sun App Server 9.0 中：
          java.naming.factory.initial=com.sun.enterprise.naming.SerialInitContextFactory
          java.naming.provider.url=iiop://127.0.0.1:3700
   4) JNDI API(javax.naming.Context接口) 主要方法的使用
      void bind(String name, Object object);   //将名称绑定到对象。如果已经存在，则抛出异常。
      void rebind(String name, Object object); //将名称绑定到对象。如果存在，重写所有绑定。
      void rename(String oldName,String newName); //把某一个已经绑定的旧名称改新名字
      void unbind(String name); //取消指定对象的绑定。
      Object lookup(String name); //查找指定的对象。
      注意：这4个方法都 throws NamingException;
   5) JBoss下配置JNDI名称
      在jboss下配置bean的JNDI名可以采取三种方式：
      第一种：也是默认的,"beanname/remote"
      第二种：使用@RemoteBinding注释。(导入jboss-annotations-ejb3.jar)
             @RemoteBinding(jndiBinding="jndiName")  --- 这种方式不好，与JBoss耦合！！！
      第三种：使用jboss.xml文件，此文件要放在src\META-INF目录下。具体内容见下面：
<jboss>
   <enterprise-beans>
      <session>
         <ejb-name>BeanName</ejb-name>
         <jndi-name>jnidname</jndi-name>
      </session>
   </enterprise-beans>
</jboss>


6. 远程调用的原理
   1)使用Socket进行网络通信
   2)使用代理模式，使得调用服务器端的远程对象，看起来像调用本地对象一样
   3)客户端的代理叫做Stub(桩)
   4)服务端的Skeleton(框架)
   5)调用过程: Client -> Stub(远程接口) -> Skeleton -> EJB Object(也叫远程对象)

   RMI简介
    1)RMI(Remote Method Invocation，远程方法调用)是用Java在JDK1.1中实现的，它增强了开发分布式应用的能力。
    2)Java RMI 则支持存储于不同地址空间的程序级对象之间彼此进行通信，实现远程对象之间的无缝远程调用。
    3)RMI目前使用Java远程消息交换协议JRMP(Java Remote Messaging Protocol)进行通信。
    4)用Java RMI开发的应用系统可以部署在任何支持JRE(Java Run Environment，Java运行环境)的平台上。但由于JRMP是专为Java对象制定的，因此，RMI 对于用非Java语言开发的应用系统的支持不足。不能与用非Java语言书写的对象进行通信。

   RMI架构
    1) Stub/Skeleton层
       该层提供了客户程序和服务程序彼此交互的接口。
    2) 远程引用层(Remote Reference)
       中间层，负责处理远程对象引用的创建和管理。
    3) 传输协议(Transport Protocal)
       提供了数据协议，用以通过线路传输客户程序和远程对象间的请求和应答。

   编写RMI的程序
    1) 定义远程接口
       通过扩展 java.rmi.Remote 接口，并定义所需的业务方法实现
       远程方法必须声明抛出 java.rmi.RemoteException 异常；或者这异常的父类
       远程方法的参数和返回值必须是实现序列化接口的类(基本类型也可以)
    2) 定义远程接口的实现类
       即实现上一步所定义的接口，给出业务方法的具体实现逻辑。
    3) 编写运行 Skeleton 引导程序注册RMI服务 (定义协议，并等待客户端调用)
    4) 编写客户端 Stub；(遵守协议的端口、读取发送信息的方式；供调用)
       使用动态类加载机制(反射机制)
    5) 编写客户端Client，调用远程对象


7. Local接口和EJB组件的依赖注入
   1)本地接口: @Local
   2)EJB组件的依赖注入：@EJB(mappedName="EJB Name/remote")

  ejb客户端开发步骤:
    1)引入ejb远程接口(a方式.引入ejb工程， b.把远程接口直接Copy过来)
    2)引入jbossall-client.jar
    3)保证src目录下面有一个jndi.properties
    4)客户代码，如:Test.java

8. Remote 和 Local
    Local(默认方式)            Remote
    使用@Local标注             使用@Remote标注
    只能本地调用，远程不行        既可以本地调用，也可以远程调用
    避免网络交换过程             无法避免网络交换过程，性能差
    允许传递未序列化的参数        不允许传递未序列化的参数

    注意：要调用实现Local接口的sessionbean，客户端程序和EJB必须在同一JVM的服务器环境。
    远程客户端也可以通过 与EJB在同一JVM的代理去访问(如Stub/Skeleton；或者用一个@Remote的Bean间接调用)

-----------------------------------------------------------
Day2

1. EJB的Web客户
   在web项目中调用EJB
   web项目在tomcat部署:
     web项目中必须包含远程接口
     web项目必须导入jbossall-client.jar
   web项目在jboss部署: (在同一台服务器上部署)
     web项目: 不需要 远程接口和jbossall-client.jar(注意: 一个JBoss中不能出现两个相同的类)

2. EJB编程模型

3. EJB的分类(2.X分类)
   1)Session Bean(会话Bean)  (Stateless和Stateful)       --- 对业务逻辑建模
   2)Entity Bean(实体Bean,3.0使用JPA替代)  -- POJO        ---对领域模型建模
   3)Message Driven Bean(消息驱动Bean)                   --- 支持异步通讯，没有直接的客户端，由消息驱动

4.EJB的系统服务
   1)事务
   2)安全
   3)对象池


5. 部署描述符和标注
   早期版本使用配置文件开发EJB, EJB3.0使用Annotation简化开发
   1)开发阶段：开发人员使用Annotation开发
   2)部署阶段：部署人员使用部署描述符部署(将覆盖annotation配置)

   部署描述符:
    1) 标准部署描述符：ejb-jar.xml
       <ejb-jar version="3.0" xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
         http://java.sun.com/xml/ns/javaee/ejb-jar_3_0.xsd ">
       <enterprise-beans>
         <session>
            <ejb-name>BeanName</ejb-name>
            <remote>package.IBeanName</remote>
            <local>package.IBeanName</local>
            <ejb-class>package.IBeanImplements</ejb-class>
            <session-type>Stateless</session-type>
            <transaction-type>Container</transaction-type>
          </session>
        </enterprise-beans>
       </ejb-jar>
    2) 特定应用服务器部署描述符：
        JBoss:jboss.xml
        Weblogic:weblogic-ejb-jar.xml
        Sun:sun-ejb-jar.xml

    标注和部署描述符的区别：
        标注                      部署描述符
    简单便利，直观               复杂，容易出错
    分散管理，无法应付复杂应用     集中管理，可以应付较复杂应用
    EJB提供者和部署者不是同一人    适合于EJB提供者和部署者不是同一人的情况
    容易出错

    注意：标注与部署描述符同时使用，部署描述符的优先级更高，会覆盖标注！！！


6. Session Bean(会话Bean)
   业务组件: 由客户端程序调用的一段业务逻辑, 作用相当于Spring管理的服务组件。一个EJB组件在容器中可能包含多个实例。
   会话Bean：对业务逻辑建模：用程序模拟处理一件事情的流程和步骤

7. 会话Bean的分类：
   Stateless Sesssion Bean(无状态会话Bean，简称：SLSB)
    1)一次方法调用代表一次会话
    2)多次方法请求之间不保存状态 (只能调用方法，不能访问属性)
    3)Bean的对象实例可以被任何客户调用

   Stateful session Bean(有状态会话Bean，简称：SFSB)
    1)会话贯穿于多次方法调用之间
    2)多次方法请求之间保存状态
      SFSB像servlet中的Session对象，可以访问SFSB的属性，SFSB的属性值会自动保留，供下次访问
    3)只有一个客户能访问这个Bean的对象实例和它的状态


8. 无状态会话Bean的对象和并发服务
   1)实例数量是容器根据客户端数量，来创建的。创建以后不会销毁，容器销毁或删除此项目时才销毁
   2)不能区分不同的客户。由哪个实例响应客户端，是由容器决定的。按静态方法来使用。
   3)实例可共享，和客户stub是多对多。不能拥有实例变量，即使有，也不能暴露给客户
   4)生命周期：不存在 -> 就绪
   5)回调方法和Remove方法
   6)并发访问
     a.没有状态，因此也无需做并发处理
     b.串行共享
     c.对象池   --- 容器会初始化n个Bean对象应付成千上万的客户端的并发请求。
9. 无状态会话Bean的生命周期(状态图)
   1)不存在 -> 就绪
     过程: 1创建Bean实例 2依赖注入 3@PostConstrcut回调方法)
   2)就绪 -> 不存在
     过程: @PreDestroy回调方法
   3)回调方法@PostConstrcut和@PreDestroy，可以定义在Bean类中，也可以定义在单独的类中
     @PostConstrcut 进行初始化工作，比如获取一些不能用依赖注入获得的资源
     @PreDestroy 释放初始化时获得的资源
   4)独立的回调类
     @Interceptors(Callback.class)


10.有状态会话Bean的对象池和并发服务
   1)能区分不同的客户，可以记住客户信息
   2)跨越多个请求(方法调用)，维护会话状态(bean类的实例变量)
   3)Bean对象和stub一对一
   4)生命周期：不存在 -> 就绪 -> 钝化
     状态包括：
      成员变量是非transient类型的java基本类型或对象
      本地或者远程接口的EJB引用
      容器管理的资源
      JNDI命名上下文Context
   5)回调方法和Remove方法(初始化实例变量,获得或关掉外部资源等)
   6)多用户并发访问：
     a.容器考虑，开发人员无需处理并发
     b.钝化和激活过程
     c.容器的并发策略(annotaion和DD)
       需导包：jboss-annotation-ejb3.jar (这个包在 %jboss_home%/client/ 下)
     d.Bean编写的要求，必须具备序列化能力(serializable)
   7)占用更多资源：cpu(查找bean、激活、钝化)和内存(有多少个在线用户就有多少stateful bean)

    有状态会话Bean:
    1.一个Stub就是一个客户，lookup到Stub以后，保存在servlet的session中
    2.EJB重新部署之后，需要lookup一个新的Stub

    生命周期：不存在 -> 就绪 -> 钝化
    1.当客户端lookup时，Bean并不存在；直到客户端首次请求调用时，服务器才构造bean实例，并调用postConstruct方法进入就绪状态；然后客户端才可以正常调用
    2.如果客户端太久不用，服务器会调用prePassivate方法使bean钝化；当客户端再次请求调用时，又构造新实例，调用postActivate重新激活；然后客户端才正常调用
    3.客户端调用remove后，服务器端会调用preDestroy方法令bean不存在；此后不能再使用这个bean，如需再用要再次lookup


11. 示例：购物篮
    购物篮EJB组件
    包含状态：产品信息(产品，数量)
    业务功能：1添加产品 2生成订单

   数据源 模板的位置：  %jboss_home%/docs/examples/jca/
   数据源配置文件位置： %jboss_home%/server/default/deploy/mysql-ds.xml
   mysql驱动程序位置： %jboss_home%/server/default/lib/

   issue:
    无法访问数据库时，注意:
    1. 检查数据库驱动程序
    2. 检查mysql-ds.xml是否正确(url,username,password)；放到 %jboss_home%/server/default/deploy/
    3. 检查数据源是否部署成功，JNDI引用名称是否正确( 以 "java:/" 开始)



-----------------------------------------------------------
Day3
1. JPA(Java Persistence API)简介
   1)ORM(object relational mapping):  实现对象到关系数据库中的表的自动持久化(翻译)
     通过元数据描述对象于数据库间的映射。
   2)JPA, Sun提出的又一套Java持久化规范标准
   3)整合当前各种ORM框架和技术，为各种ORM框架提供统一编程接口
   4)只是一套接口，要求持久化提供商实现支持
   5)使用Annotation和XML描述对象和关系表的关系
   6)EJB和普通Java程序都可使用

2. JPA编程
   EntityManager接口
   J2SE环境下JPA 编程步骤：
    a.导入包: Java EE 5 Libraries(MyEclipse的类库，javaee.jar);
      数据库驱动包;  PP(持久化提供者)的包
    b.配置persistence.xml(名字固定)
      提供访问数据库的信息 和指定具体的PP(persistence provider)
    c.开发实体(注解或orm.xml)
      1)在POJO类上添加@Entity
      2)实体必须声明主键@Id，(可以使用@GeneratedValue配置主键产生的策略)
      3)默认情况下，实体类名和属性名等同于表的字段名(可用@Table/@Column 加上(name="new_name")另外起名)
      //4)实体能够包括业务方法(不建议这么做，会导致实体的职责不清)
    d.Session Bean(注入EntityManager)
    e.开发客户程序

3. JTA支持两种事务类型
    本地资源事务(RESOURCE_LOCAL)：使用JDBC驱动管理的本地事务。不需发布。
    Java事务API(JTA)：容器管理的事务。要使用JTA必须使用服务器的DataSource。

    JavaEE环境下
        容器管理的EntityManager(@PersistenceContext注入)必须使用JTA事务。
        应用程序管理的EntityManager可以使用本地资源事务,也可以使用JTA事务
    在JavaSE环境下，使用本地资源事务

   比较 Hibernate 与 JPA 的开发过程：
        Hibernate             jpa
     1.POJO(entity)        1.entity
     2.xxx.hbm.xml         2.Annotation(orm.xml)
     3.hibernate.cfg.xml   3.persistence.xml
     4.SessionFactory      4.EntityManagerFactory



-----------------------------------------------------------
Day4

4. EntityManager接口
    find(Class<T> entityClass, Object primaryKey):<T> T    //根据主键查找，没有符合条件记录，返回null
        Hibernate:get();
    getReference(Class<T> entityClass,Object primaryKey):<T>T //根据主键查找,没有符合条件记录,抛出异常
        Hibernate:load();                                  //EntityNotFoundException
    persist(Object entity):void        //将实体变成受管态，并持久化它，将在数据库中增加一条记录
        Hibernate:save();
    merge(T entity):T                  //合并一个实体到持久化上下文中，将更新数据库记录，并返回持久化对象
        Hibernate:merge();
    remove(Object entity):void         //删除一个实体，将删除数据库记录
    clear():void                       //清除持久化上下文，将导致托管态对象变成游离态对象
    contains(Object entity):boolean    //检查一个实体对象是否包在持久化上下文中
    close();                           //关闭持久化上下文
    flush();                           //对象同步到数据库，有两种同步方式
        FlushModeType.AUTO             //事务提交和执行查询时同步
        FlushModeType.COMMIT;          //只有事务提交时同步
        setFlushMode(FlushModeType flushMode)    //设置同步方式
    refresh();                         //数据库同步到对象
    getTransaction().begin();          //开启事务
    getTransaction().commit();         //提交事务，事务结束

5. 持久化上下文和实体的生命周期
   新建 -> 托管(受管) -> 脱管(游离) -> 删除
    1) 新建new：new Instance persist(); 新建一个实体对象，还未持久化，没有持久化标志
    2) 托管managed：数据库里和持久化上下文中都有 实体对象
    3) 游离detached：持久化上下文中没有，但是又具有持久化标志(oid)  可调用merge()，不能调用persist();
    4) 删除removed：hibernate没有(数据库中和持久化上下文中都有，但是通过remove()标志实体是被删除的)
   总结:
    1) 不调用persist, 而是调用merge持久保存entity对象
    2) 在事务当中(ejb默认一个方法是一个事务)或者持久化上下文中，先查询entity, 再进行操作
    3) 调用find方法, 不要调用getReference()

6. 持久化上下文类型
    容器管理的上下文
    @PersistenceContext(type=PersistenceContextType.TRANSACTION)
    1)事务范围的(默认方式)：
            事务结束时(一个方法默认为一个事务)，上下文被关闭
    @PersistenceContext(type=PersistenceContextType.EXTENDED)
    2)扩展范围的(多个事务)：
            上下文跨越多个事务(事务结束时，上下文并不关闭)
            *只有*有状态会话Bean适用，SFSB销毁时，上下文关闭
     应用程序管理的上下文，是扩展的上下文
    EntityManagerFactory emf;
    EntityManager em = emf.createEntityManager();

7. 实体回调
   1)注解方法
     @PrePersist    //insert into SQL执行之前调用
     @PostPersist   //insert into SQL执行之后调用
     @PreUpdate     //update SQL执行之前调用
     @PostUpdate    //update SQL执行之后调用
     @PreRemove     //delete SQL执行之前调用
     @PostRemove    //delete SQL执行之后调用
     @PostLoad      //加载实体之后，select SQL执行之后调用 (只有这个没有之前执行的)
   2)独立的回调类
     @EntityListeners(Callback.class)
     回调方法多一个Object 参数，如：
       Callback.java 里写：                     entity.java里写：
       @PreUpdate                              @PreUpdate
       public void preUpdate (Object obj);     public void preUpdate ();

8. JPA查询(JPQL)
    1)javax.persistence.Query接口
      Query query = em.createQuery("select 别名 from entity类 别名"); //也可写 "from entity类"
       List<entity类> list = query.getResultList();
       for(entity类 obj : list){System.out.println(obj.getOid() + " : " + obj.getName());}
    2)本地查询
      Query query = em.createNativeQuery("select * from 表名", entity类.class);
      List<entity类> list = query.getResultList();
      for(entity类 obj :list){System.out.println(obj.getOid() + " : " + obj.getName());}
    3)命名查询
      a)在Entity里添加标注
        @NamedQuery(name="命名1", query="select h from entity类 h where h.age>?2 and h.name like ?1")
        //上面 ?1 ?2 的数字决定参数下标。也可以只用 ? ，但代码得保证对应这语句的顺序。(h是 entity类 的别名)
        //query 语句也可写成："from entity类 where age>:age and name like :name"
        //冒号表示用名称代号代替之前的下标，来表示参数。这种方式更常用，不易出错
      b)查询代码
        Query query = em.createNamedQuery("命名1");
        query.setParameter(1, "%始%"); //如果query 语句用分号的，则query.setParameter("name", str);
        query.setParameter(2, 70);
        List<entity类> list = (List) query.getResultList();
        for (entity类 obj : list){
            System.out.println(obj.getOid() + " : " + obj.getName());}
    4)本地命名查询
      a)在Entity里添加标注
        @NamedNativeQuery(name="命名2", query="select * from 表名", resultClass=entity类.class)
      b)查询代码
        Query query = em.createNamedQuery("命名2");
        List<entity类> list = (List)query.getResultList();
        for (entity类 obj : list){System.out.println(obj.getOid() + " : " + obj.getName());}

   JPA(Java Persistence API)简介
     1)ORM(object relational mapping):
       实现对象到关系数据库中的表的自动持久化(翻译)，通过元数据描述对象于数据库间的映射。
     2)JPA, Sun提出的又一套Java持久化规范标准
     3)整合当前各种ORM框架和技术，为各种ORM框架提供统一编程接口
     4)使用Annotation和XML描述对象和关系表的关系
     5)只是一套接口，要求持久化提供商实现支持
     6)EJB和普通Java程序都可使用

   数据库库同步
     flush();
     FlushModeType.AUTO 和 FlushModeType.COMMIT;
     refresh();


9. O/R mapping metadata
    @Entity  //用于类名前。表明他是pojo类
    @Table(name="t_film") //用于类名。这个类对应的表名，可以不写
    @Column(name="filmName") //用于属性。表中的字段名，不写则跟属性名一样(大小写也一样)
    @Id  //用于属性。表明他是id；要求一定要有ID
    @GeneratedValue //用于id属性。指定需要框架自动产生主键

    //主键生成策略
    @GeneratedValue(strategy=GenerationType.AUTO, generator="generatorName")
        GenerationType.AUTO            //默认
        GenerationType.IDENTITY        //Mysql,Sql Server适用

        GenerationType.SEQUENCE        //Oracle
        @SequenceGenerator(name="generatorName", sequenceName="")
        //Oracle: create SEQUENCE SEQ_ID INCREMENT BY 1 START WITH 1)

        GenerationType.TABLE           //Mysql,Oracle 适用
        @TableGenerator( name="generatorName",  table="ID_GEN",  pkColumnName="entityName",
            valueColumnName="IdValue",  allocationSize=1 )

    //Annotation
    @Basic(optional=false) //属性可选
    @Transient             //瞬态属性；不会持久化到数据库
    @Lob                   //大字段类型属性
    @Embedded              //复合组件(属性)  @Enumerated的手误???

   复合主键和复合组件
    @IDClass(复合主键)
    @EmbeddedID(复合主键)
    @Embeddable
    @Embedded(复合组件)



-----------------------------------------------------------
Day5

10.继承映射策略
   1)每个类对应一个表
     @Inheritance(strategy=InheritanceType.JOINED) //用于父类，还需有@Entity
     优点: 符号面向对象；支持多态；没有数据冗余
     缺点: 表的数量过多，不方便维护；连接查询速度慢
   2)每个具体类对应一个表
     @MappedSuperclass   //用于父类，子类继承父类的id，而父类没有表
     @AttributeOverrides({
        @AttributeOverride(name="prepertyName1", column=@Column(name="fieldName1")),
        @AttributeOverride(name="prepertyName2", column=@Column(name="fieldName2"))  })
     优点：查询速度快
     缺点：数据定义存在冗余
   3)整个类层次结构对应一个表
     @Inheritance(strategy=InheritanceType.SINGLE_TABLE)
     @DiscriminatorColumn(name="discriminatorField")
     @DiscriminatorValue("discriminatorValue")
      优点：容易理解和维护；最快的查询数度
      缺点：最大的冗余


11.实体关联关系
    //多对一与一对多
    @ManyToOne  //主动，只有他不能放弃维护关系。加上mappedBy就编译不通过
      @JoinColumn(name="外键字段名") //指定外键；Many的一方不需另外建表，只需增加字段就可以维护关系
    //被动。写mappedBy后就不再另外建表维护OneToMany的关系(默认建One_Many表)
    @OneToMany(mappedBy = "", cascade={}, fetch=FetchTYPE.EAGER)
      @JoinTable(name="One_Many关系表名" //反映 One_Many 关系的一个表。不写则不建
        ,joinColumns={@JoinColumn(name="One_id1")} //这个关系表的主键字段，可以用复合主键(One端)
        ,inverseJoinColumns={@JoinColumn(name="Many_id")}) //这个关系表的成员的字段(Many端)

    //一对一
    @OneToOne   //主动
      @JoinColumn(name="外键字段名")
    @OneToOne(mappedBy="")     //任意一方加上mappedBy后，变被动；他不可以再维护关系了

    //多对多
    @ManyToMany //主动
      @JoinTable(name="innerTableName"
          , joinColumns={@JoinColumn(name="foreign_key")}
          , inverseJoinColumns={@JoinColumn(name="otherColumn")})
    @ManyToMany(mappedBy="")  //加上mappedBy后，变成 ManyToOne 的 One方

   三大要点:
    a.维护关系(没有mappedBy的默认都是维护关系(设置外键或者设置中间表记录))
      加上mappedBy后，他就不可以再维护关系了
    b.fetch //设置加载方式
      (FetchType.EAGER时, 查询主表记录,并查询从表纪录,两条SQL语句；对 One 的一方)
         对于基本属性，使用 fetch=FetchType.EAGER (通常配合二级缓存使用)，会提高效率(默认 EAGER)
      (FetchType.LAZY时, 只查询主表记录, 只有一条SQL语句；对 Many 的一方)
         对于集合属性，一般设置为 fetch=FecthcType.LAZY 加载；为了提高效率
    c.cascade
      对一边执行操作时，是否要对另一端也行操作(只能用于 One端，用于Many端时编译不通过)
      cascade={CascadeType.REMOVE, CascadeType.REFRESH, CascadeType.RERSIST,
           CascadeType.MERGE, CascadeType.ALL}  //级联操作，小心使用
      例如: persist()一个对象时(执行insert语句)，是否同时persist关联对象


12. EJBQL (又称 JPQL)
    类似HQL(Hibernate的SQL语句)，这是EJB的SQL语句，又称JAVA的SQL语句
    1)批量删除、更新(delete from Entity)，需要 em.clear();
    2)连接查询(关联对象之间使用 join fetch，只能给有关联的类使用)
      left join/inner join (select u from User u inner join u.dept)
      inner join/left join(select u from User u left join u.dept)
      只能给有关联的表作级联操作。(功能不如SQL，SQL可以给所有表作级联操作)
      inner join fetch/left join fetch (查出所有关联实体)
    3)group by 和 having 语句
    4)投影：(要求构造函数才可以根据投影返回对象)
      如：select u.userName from User ；查询之后返回对象数组
      select new User(u.userName) from User u ；返回实体对象(要求有对应的构造函数)
    5)子查询：只能在where子句中出现(功能不如SQL，SQL可任意子查询)


13. 并发访问
    乐观锁
    悲观锁(只有数据库的锁才是悲观锁)
    @Version //加在Entity类的版本属性里




The basic of JPA (II)
-----------------------------------------------------------
Day6 事务

1. 事务概念：
   1)事务产生的动机
     使用事务保证原子操作，避免应网络故障或机器故障，导致数据状态不一致，保证多用户并发访问数据库的问题
   2)事务过程的参与者:
     事务对象：包含事务的应用组件，如EJB组件
     事务管理器：负责管理应用组件的事务操作，如J2EE应用服务器
     资源：一个可供读写的永久性的存储库，如数据库
     资源管理器：负责管理资源，如一个数据库管理系统
   3)事务的ACID属性:
     原子性(Atomicity)
           事务中的数据库修改操作，要么全部成功，要么全部不成功。
     一致性(Consistency)
           事务执行之前，和事务结束之后，数据库都必须满足全部完整性要求。
     隔离性(Isolation)
           一个事务的处理不能影响另一个事务的处理。(有多个隔离级别)
     持久性(Durability)
           指一个事务一旦提交，它对数据库中数据的改变就应该是永久性的。以后其他操作或故障不对其有任何影响。

2. 分布式事务
   1)事务的类型：JDBC事务 和 JTA事务
   2)分布式事务和两阶段提交协议
     分布式事务：事务的参与者、支持事务的服务器、资源服务器以及事务管理器分别位于不同的布式系统的不同(机器)节点之上
     为了实现分布式事务需要使用两阶段提交协议。
   两阶段提交协议(后台实现)
     阶段一：开始向事务涉及到的全部资源发送提交前信息。各资源服务器进行“预提交”。
     阶段二：只在阶段一没有异常结束的时候才会发生

   数据源配置文件位置(固定)： %jboss_home%/server/default/deploy/ 目录放
     mysql-xa-ds.xml 以及 oracle-xa-ds.xml (为每个需要调用的数据库都配置)
   驱动： %jboss_home%/server/default/lib/ 目录下放 mysql 和 Oracle 的驱动

3. EJB事务
   1)Bean(EJB Object)管理事务(BMT)(编程性事务)
   2)容器管理事务(CMT)(声明式事务)
   3)客户端管理事务

4. Bean管理事务
   1)由EJB实现类显示调用事务代码(编程式事务)
     @TransactionManagement(TransactionManagementType.BEAN)
     @Resource(mappedName = "UserTransaction")
     UserTransaction userTx;
   2)优点：支持细粒度事务控制
   3)缺点：需要编写事务代码，业务逻辑代码和事务代码耦合在一起，不利于维护

5. 容器管理事务(默认)
   1)由容器为我们管理事务(声明式事务)
     @TransactionManagement(TransactionManagementType.CONTAINER)
   2)类级别声明和方法级别声明
     @TransactionAttribute(TransactionAttributeType.REQUIRED|TransactionAttributeType.REQUIRED)
   3)六种事务属性
     REQUIRED: 一定有事务(调用者有事务，加入；调用者没有事务，创建一个事务)
     REQUIRES_NEW: 总是创建新事务
     SUPPORTS：支持事务，和调用者一致
     MANDATORY：调用者，必须有事务(客户端没事务就抛出异常)
     NOT_SUPPORTED：挂起原事务(如果有), 运行本方法，恢复原事务
     NERVER: 调用者不允许有事务
   4)优点：解耦业务逻辑代码和事务代码
   5)缺点：对事务控制的最小粒度受限制(方法级)，不够灵活

6. 客户端管理事务
   1)由客户端负责事务管理(编程式事务)
     UserTransaction utx = (UserTransaction)ctx.lookup("UserTransaction");
   2)EJB本身必须是CMT事务，否则客户端事务无法远程传递到EJB
   3)优点：事务在客户端，对于网络等问题造成的问题能进行处理(其他事务在这种情况下不知道事务是否成功)
   4)缺点：跨越网络的长事务将导致严重的性能问题


-----------------------------------------------------------
part5 消息技术和消息驱动Bean
1. 什么是消息和消息技术
   广义来讲是程序或者计算机之间，进行通信的数据，有消息两种：同步消息和异步消息。
       消息中间件技术中的消息是狭义的消息，特指异步消息。
   消息技术拓扑图和消息技术作用
       1)异步通信(接收、存储、转发)：非阻塞
       2)不同应用系统集成：松耦合
       3)可靠性：重发
       4)多发送者同时发送和多接收者同时接收

2. 消息系统中重要概念
   消息中间件(Message-Oriented Middleware)：对信息进行管理/控制，提供异步传输能力，各系统之间信息传递的基本平台
   消息：MOM系统中基本的数据传输单元
        消息结构：消息头(目的地、发送人、优先级) 和 消息体(真正想发送的数据)
   消息目的和消息域(Domain，即消息处理类型)
        a.点对点:消息发送者发送的消息只能提供给一个消费者一次消费(类似手机短信)，目的地：队列(Queue)
        b.发布/订阅：消息发送者发送的一条消息可以提供多个消费者即时消费(类似广播)，目的地：主题(topic)

3. JMS(Java Message Servic)
   以前：不同的消息中间件服务器提供不同的编程接口，每次换一个中间件服务器必须学改服务器的API
   现在：统一编程接口，不同的JMS Provider不用学习不同的MOM API

4. JMS API编程模型
   //服务器配置
   1)连接工厂，获取连接
     %JBOSS_HOME%/server/default/deploy/jms/uil2-service.xml
     配置<attribute name="ConnectionFactoryJNDIRef">ConnectionFactory</attribute>
   2)目的地
     %JBOSS_HOME%/server/default/deploy/jms/jbossmq-destinations-service.xml
     配置队列目的地：
       <mbean code="org.jboss.mq.server.jmx.Queue"
          name="jboss.mq.destination:service=Queue,name=tarenaQueue"> //tarenaQueue是个自定义名字
          <depends optional-attribute-name="DestinationManager">
           jboss.mq:service=DestinationManager</depends>
       </mbean>
     配置主题目的地
       <mbean code="org.jboss.mq.server.jmx.Topic"
           name="jboss.mq.destination:service=Topic,name=tarenaTopic">
          <depends optional-attribute-name="DestinationManager">
           jboss.mq:service=DestinationManager</depends>
       </mbean>

   //发送消息
   1)获取连接工厂(服务器端需配置连接工厂)   //这一步之前已经学过(熟透了吧)
     System.setProperty(Context.INITIAL_CONTEXT_FACTORY,
     "org.jnp.interfaces.NamingContextFactory");
     System.setProperty(Context.PROVIDER_URL, "localhost");
     Context ctx = new InitialContext();
     ConnectionFactory cf = (ConnectionFactory)ctx.lookup("ConnectionFactory");//跟之前唯一的不同
   2)创建连接
     Connection conn = cf.createConnection();
   3)创建会话
     Session sess = con.createSession(false, Session.AUTO_ACKNOWLEDGE);
     //false:不使用事务；Session.AUTO_ACKNOWLEDGE：收到消息后，自动确认消息(有时会要求接收者确认收到消息)
   4)获取目的地(服务器端需配置目的地)
     Destination dest = (Destination)ctx.lookup("queue/tarenaQueue");
     //lookup是队列跟主题唯一的区别，主题用"topic/tarenaTopic"
   5)创建生产者(Message Producer)
     MessageProducer mp = sess.createProducer(dest);
   6)创建消息
     TextMessage msg = sess.createTextMessage("无语了...");
     msg.setStringProperty("sender", "发言者名字");//这句话，标识自己在发言，让人监听；没有监听者则免了
   7)发送消息
     mp.send(msg);
   8)关闭资源(一般都把前7步放到 try 代码块里，再 catch(JMSException)；而这第8步放到 finally 代码块里)
     try { mp.close(); } catch (JMSException e) {e.printStackTrace();}
     try {sess.close();} catch (JMSException e) {e.printStackTrace();}
     try {conn.close();} catch (JMSException e) {e.printStackTrace();}

   //接受消息 (前4步跟发送一样)
   1)获取连接工厂(服务器端需配置连接工厂)
   2)创建连接
   3)创建会话
   4)获取目的地(服务器端需配置目的地)
   5)创建消费者(Message Consumer)
     MessageConsumer mc = sess.createConsumer(dest);
   6)启动连接(Connection.close())
     conn.start();
   7)接受消息(recive()或者佣人MessageListener)
     Message msg = mc.receive(2000);
     // 2000是接收信息的时间(毫秒)，在这段时间内收不到就不收了；不写时间则一直等待
   8)处理消息
     if(msg instanceof TextMessage) System.out.println(((TextMessage)msg).getText());
     // Message 是 TextMessage 的父类
   9)关闭资源
     这一步跟发送消息的相同

   //ConnectionFactory的接口
     createConnection();
     createSession(boolean transacted, int acknowledge);
        transacted: JMS消息是否使用事务
        acknowledge:Session.AUTO_ACKNOWLEDGE    //收到消息时，自动确认消息
                    Session.Client_ACKNOWLEDGE  //到消息时，调用Message.acknowledge()确认消息
                    Session.DUPS_OK_ACKNOWLEDGE //延时确认消息，(批量确认消息，提高性能)
   //JMS消息结构
    消息头:消息的标识/路由信息    --系统设置的属性
    消息体：真正的消息内容        --程序设置
    标识属性:给消息的接收有一个过滤的关键字(可选)--程序设置
        message.setStringProperty("sender", "maxwell"); //设置发送者属性(属性名称也是任意的)


5. 消息驱动Bean
   容器收消息，收到后调用消息驱动Bean
     1)和Stateless SessionBean一样表示无状态的业务逻辑
     2)和SessionBean的区别，不由客户调用，由消息驱动，也没有返回值
     3)毒消息(由于一直不能确认收到消息，服务器不断的发送重复消息)
       解决方法: a.使用Bean管理的事务，不使用默认的CMT事务
                b.不要抛出系统异常，try{} catch{} 捕获异常
                b.JMX控制台设置重复次数: jboss.mq.destination

   继承 javax.jms.MessageListener 接口
   消息驱动Bean的生命周期
        不存在 -> 就绪
        @PostConstruct //当被监听的人第一次发信息时调用；其他人发信息不理会
        @PreDestroy    //当工程销毁或者关闭服务器时调用

   @MessageDriven(activationConfig = { //写在监听类前面
        @ActivationConfigProperty    //信息类型
          (propertyName = "destinationType", propertyValue = "javax.jms.Topic") //队列用"Queue"
        ,@ActivationConfigProperty(propertyName = "destination", propertyValue = "topic/tt")
        ,@ActivationConfigProperty    //指定只接收某个人的；不写这句则接收所有人
          (propertyName = "messageSelector", propertyValue = "sender='Lily'") })
        //接收 Queue 消息时，如果有接收者，则直接发给接受着，不会发给监听者


-----------------------------------------------------------
Day7  part6 标注，定时器和拦截器

1. 标注
   //常规标注：
    @Stateless(name="ejb name")
    @Stateful
    @MessageDriven
    @Remote({If1.class})   //如果这个类实现多个接口，可以只指定其中某个接口是远程接口；默认所有接口都是远程的
    @Local(会话Bean接口标注，1.标注远程接口, 2.列出远程接口)

   //依赖注入标注
    @Resoure(mappedName="JNDI name")
    @EJB(beanName="ejb name")
    @PersistenceContext(unitName="unit name")  //persistence.xml包含多个持久化单元，必须指定unitName

   //JPA标注
    参看文档

2. 拦截器
   拦截器中定义的方法能够在EJB方法调用时自动调用
   //四种拦截器:
    1)缺省拦截器    部署在 ejb-jar.xml 中；最外层拦截
    2)类拦截器      拦截方法写在另一个类，在Bean类名前加 @Interceptors(拦截器类.class)；对整个类的方法都有效
    3)方法拦截器    拦截方法写在另一个类，在需要拦截的方法前加 @Interceptors(拦截器类.class)；仅对这方法有效
    4)自我拦截器    拦截方法定义在Bean本身(一个Bean只能有一个自我拦截方法)

    @Interceptors(Class.clas)    //注册拦截类
    @ArrounInvoke                //拦截类中的拦截方法
    public Object someMethod(InvocationContext ic);        //返回值是Object

   //拦截器链：
    所有拦截器组成了一个拦截器链
        ic.proceed();            //调用一下个拦截方法处理
    调用顺序：
        缺省拦截器，类拦截器，方法拦截器，自我拦截器；同级别拦截器，按声明顺序调用


-----------------------------------------------------------
part7 安全管理
1. 保证安全的四个环节
   1)身份验证。  要求用户标识自己的身份，提供证明自己身份的依据，计算机系统对其进行鉴别
   2)授权。     一旦用户身份验证通过，系统给用户分配访问资源的权限
   3)访问控制。  比较用户具有的权限和访问资源所需的权限
   4)安全审计。  记录和分析历史操作事件及数据，查找系统漏洞和可以改进的地方。
     目的是保证系统安全，保护数据，防止有意或无意的人为错误，防范和发现计算机网络犯罪活动。

2. JAAS(Java Authentication and Authorization Services )(java验证与授权服务)
   专门处理 身份验证(authentication) 及 权限管控(authorization) 的标准服务
   1)常用接口：
     Subject (包含用户信息：Princial, Credential等)
     Principal      //身份，授权信息
     Credential     //密码

     LoginContext   //登录上下文，用来选择验证模块
          使用LoginContext对象来验证Subject对象。LoginContext从配置文件中加载配置信息，这些配置信息告诉LoginContext对象在登录时使用哪一个LoginModule对象。
          login() 进行登录操作。该方法激活了配置中制定的所有LoginModule对象。如果成功，它将创建一个经过了验证的Subject对象；否则抛出LoginException异常。
          getSubject() 返回经过验证的Subject对象
　　       logout() 注销Subject对象，删除与之相关的Principal对象和凭证
     LoginModule      //登录模块
     CallbackHandler  //用来和用户交互，要求用户输入用户名和密码


3. web安全验证
   //1 服务器端配置安全域
    %Jboss_home%/server/default/conf/login-config.xml
    1) 基于属性文件的安全域
    2) 基于数据库的安全域

   //2 WebRoot/WEB-INF/jboss-web.xml 选择安全域
    <?xml version="1.0" encoding="UTF-8"?>
    <jboss-web>
        <!-- java:/jaas/固定格式，后面的是login-config.xml中配置安全域名称 -->
        <security-domain>java:/jaas/websecurity_db</security-domain>
    </jboss-web>

   //3 WEB-INF/web.xml
    1)选择验证方法
      表单验证(名称要求，固定写法)
        表单name="j_security_check"
        用户输入框name="j_user"
        密码输入框name="j_password"
      Basic验证(弹出一个系统对话框)
    2)定义安全约束；限制访问资源的用户
      <security-constraint>
         <!-- 配置受保护的资源 -->
         <web-resource-collection>
            <web-resource-name>Director</web-resource-name>
            <url-pattern>/admin/＊</url-pattern> //定义可以访问的资源
            <http-method>POST</http-method>
            <http-method>GET</http-method>
         </web-resource-collection>
         <auth-constraint>
            <role-name>director</role-name>      //定义什么角色有效(可多个)
         </auth-constraint>
      </security-constraint>
    3)申明安全约束使用的角色
      <security-role> <role-name>director</role-name> </security-role>
      <security-role> <role-name>trainer</role-name>  </security-role>
      <security-role> <role-name>student</role-name>  </security-role>

   //4 基于属性的安全域，web项目的类路径提供用户和角色属性文件
    users.properties
    roles.properties
    备注：基于表单的验证方式不能直接访问login.html
   //5 基于数据库的安全域，配置数据库


   //编程式授权方式
    String role = request.isUserInRole();


4. EJB安全验证
   1)选择安全域
     (1)部署描述符jboss.xml(优先级高)
     (2)标注(jboss-annotations-ejb3.jar)@SecurityDoamin("domain")
   2)访问控制
     (1)RoleAllowed("role1","role2",)
        类级别
        方法级别(覆盖类级别设置)
     (2)PermitAll
        类级别(默认)
        方法级别(覆盖类级别设置)
     (3)DenyAll()
        只能在方法级别上使用
     (4)RunAs("other")
        用户可以被当作other角色访问资源
   3)客户端
     SecurityAssociation
       setPrincipal   (SimplePrincipal)
       setCredential   (String)
     这个帮助类会进行登陆验证，并返回一个Subject，此Subject对象会自动与ctx上下文自动关联




补充：定时器
特定时间执行的某项任务
	//1 单动定时器；只运行一次
	createTimer(Date expiration, String info)  //expiration 指定时间， info 任务的描述信息
	createTimer(int duration, String info)     //duration 指定多久之后执行任务

	//2 多动定时器
	createTimer(Date initialExpiration,intervalDuration,info) //intervalDuration:每隔多久执行一次
	createTimer(initialDuration, intervalDuration, info)

	cancel()		//取消任务
	@Timeout		//定时方法上标注


