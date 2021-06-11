
day1
什么是Spring？
    开源、轻量级

Spring 特征：
    1.B/S 和 C/S，使用资源小
    2.对象间的关系松，高内聚，低耦合
      IOC --- Inverse of control 
         使得业务组件都处在框架的管理之下
         框架可以管理组件的创建和依赖关系
         框架可以提供可以配置的服务
    3.通过AOP技术将业务与非业务分离
      AOP --- Aspect Oreinted Programming
      在不修改组件的前提下，为组件提供扩展的服务
    4.Spring容器管理整个JavaBean生命周期
      简化对j2ee技术的使用
    5.与Hibernate、Struts一样是个框架
      (类集合) (框架提供) 
    6.Spring是一个全方位的框架
      SpringMVC 类似 Struts

Spring框架在多层开发中位于那一层？或哪几层？
    框架简化开发过程，提供公共服务和便利的工具
    1.业务逻辑层 (Ioc *AoP) 最擅长的一层
    2.表现层    (SpringMVC Web B/S都有) 
    3.数据持久层 (SpringDAO ORM) 

什么是IoC：
    1.IOC --- Inverse of control (控制反转) 
       A主动创建B的实例：正向控制
      过去：拉模型
           组件决定自己依赖的对象的创建 
           接口没有在松散耦合中起到太大作用
      IOC：推模型，也叫做依赖注入
           采用工厂模式管理应用组件的创建，管理组件的依赖关系 
           用接口表达组件间的依赖
      依赖注入的方式
        1)构造方法注入
        2)set 方法注入
    2.Spring IoC 容器先创建B的实例，再把B的实例注入A中
    3.执行过程：
      1)执行 BeanFactory 或 ApplicationContext 时，解析 xml 文件
      2)通过反射，执行 JavaBean 的空参构造方法，创建实例
      3)调用 JavaBean 的 set方法，将xml的信息注入到这 JavaBean 实例
        或者执行满参构造方法创建实例，同时注入 xml 的信息

spring 框架的7个组成部分
    1.BeanFactory -- (低级容器，接口)使用工厂模式实例化组件，装配组件
       XmlBeanFactory(实现类) 
    2.ApplicationContext (高级容器，接口)--- bean factory 增加事件发布，增加了国际化，资源访问等的支持
       ClassPathXmlApplicationContext(实现类) 
    3.aop --  提供一种基于声明方式的AOP
    4.dao 支持--简化jdbc，声明的事务
    5.orm 支持-- 简化使用 Hibernate ,toplink 等持久化框架，方便的事务管理
    6.web 支持-- 在 web 应用中使用 spring 框架的相关支持，协调表现层和业务层的关系
    7.web mvc--- 独立的 web mvc 框架

    spring 是全方位的框架
    spring 的组成部分相对独立，可选择的使用

作业：
    用户注册页面
    要求： Servlet + Spring + JDBC + MySQL
         1.判断用户名是否已注册(保证用户名唯一性) 
         2.采用B/S架构，使用IoC功能，完成JavaBean的注入。
           在JavaBean不要使用 new 方式创建对象。
         3.连接数据库时的 driver ，配置在 xml 文件中。








day2
二、控制反转(inverse of control IOC ) 
    2、Bean 工厂(BeanFactory)的功能和配置
        ClassPathResource
            在类路径下查找资源
            另有 FileSystemResource
        XmlBeanFactory 
            读取 xml 文件中的配置信息
            生产bean
            解决bean 依赖
    
    * Bean 的创建
        spring 可调用bean的构造方法，或通过工厂方法生产 bean 对象

    1.利用 bean 的构造方法创建bean
        无参的构造方法
            <bean id="refName" class="foopak.FooClass">
               <property name="username" value="root"/>
               <property name="password" value="123"/>
            </bean>
        有参的构造方法，需指明构造方法的参数列表，通过：
            <bean id="refName" class="foopak.FooClass">
                <construct-arg><value>arg0</value></construct-arg>
                <construct-arg><value>arg1</value></construct-arg>
            </bean>
            表明调用了两个参数的构造方法

    2.通过工厂方法获得 bean 对象
        bean 没有公共的构造方法，需通过工厂类或工厂实例来创建
        分为静态工厂和实例工厂方法两种情况
        静态工厂方法:
            class 指明工厂类，factory-method 指明工厂方法
            如： Connection con=DriverManager.getConnection(url,user,pwd);
            对应的配置：
                <bean id="con" class="java.sql.DriverManager" factory-method="getConnection">
                    <construct-arg><value>jdbc:mysql://localhost/test</value></construct-arg>
                    <construct-arg><value>zhangsan</value></construct-arg>
                    <construct-arg><value>pwd</value></construct-arg>
                </bean>
                工厂方法参数和构造方法参数设置的形式相同
            
             实例工厂方法：    
                要先创建工厂实例，然后再由工厂实例创建产品
                如： Statement stmt = con.createStatement();
                        con 对象是工厂
                        stmt 对象是产品
                配置为：
                 <bean id="con" class="java.sql.DriverManager" factory-method="getConnection">
                       ……
                 </bean>
                 <bean id="stmt" factory-bean="con" factory-method="createStatement"/>
    
    单例 bean
        bean 工厂生产bean 缺省都是单例的
        scope 属性
            scope="singleton|prototype|request|session"
        后两者用于web应用中    
         

    通过注入解决bean的依赖

        1 依赖注入的两种方式
            1) set 注入
                <property name="xxxYy">
                    ……
                </property>
               相当于 setXxxYy(val);
            2) 构造方法注入
                <construtor-arg>……</construtor-arg>
          spring 直接利用了 bean 的 set 或 构造方法
          避免了使用接口注入的侵入性
          
        2 依赖的目标类型分成三种形式：
            1) 基本类型+String  
                <value>data</value>
               类型自动转化
            2) 对其他bean 的引用  
                <ref bean="target"/>
            3) 集合类型
                list
                props
                set
                map
        
        3 让spring 自动装配bean，解决依赖
            autowire 属性指明自动装配的依据： 
                    byName--- id=property
                    byType--- 属性的类型=当前工厂中bean的类型        
                    constructor--构造方法参数的类型=当前工厂中bean的类型
                    autodetect-- constructor ---> byType
            autowire-candidate 属性
                指明是否作为 autowire 的候选对象
                解决多个候选对象的冲突
                    true --- 
                    false --- 
        4 让容器检测 bean 所有的依赖是否都已经满足
            某个 bean 需要设置好所有属性
            防止遗漏装配，在运行后出现莫名奇妙的情况
            dependency-check 属性指明应检查的目标类型
                simple -- 基本类型+字符串+集合
                objects --- 对其他bean的依赖
                all 
                none -- 默认值

    管理 Bean 生命周期
        生命周期
            构造
            set
            回调初始化方法
            getBean 返回
        回调方法：
            两个属性指明
                init-method 
                destroy-method 
            或实现两个接口：
                InitiallizingBean
                DisposableBean
            
    重用 bean 定义
        parent -- 继承 bean 定义
                    bean 之间不一定有继承关系
        abstract --- 只作为模板，不可以被实例化
    
    补充：
        name
            id=""
            name="/myBean"
            name="a b c"
            
        延迟加载bean
            bean 的加载时机
                预先加载
                    构造 bean 工厂时实例化所有bean
                延迟加载
                    getBean 时构造
                    先构造依赖的bean

                BeanFactory 总是延迟加载的
                ApplicationContext 
                    BeanFactory 的扩展
                    预先加载 单例 bean
                    lazy-init (true|false)

    3、ApplicationContext
     BeanFactory 的扩展，为应用提供国际化和事件框架的支持

    1)I18N(国际化)
    ApplicationContext 可以读取国际化的消息文件
        getMessage();
    
    实施：
        1)注册消息源
        <bean id="messageSource" 
            class="ResourceBundelMessageSource">
            <property name="basename">
                <value>MessageResource</value>
            </property>
        </bean>    
        bean 的id 必须是"messageSource"
        2)读取消息
        ApplicationContext 的方法：
            getMessage(String key,String[] args,Locale l);
                key - 消息的key
                args- 插入到消息中的参数
                l - 区域
                    Locale 语言和区域代码的封装对象
                        locale=new Local("zh","CN");
                            local=Locale.getDefault();
    思考：工厂管理的组件怎样使用获得国际化消息
    
    注意：因为AppicationContext包含了BeanFactory所有的功能，所以优先选择 ApplicationContext 

    2)事件框架
    提供了一个观察者模式的框架,快速实现组件间的事件通知
    
    实施：    
        1 所有想得到通知的对象都实现ApplicationListener
        2 事件源发出事件:applicationContext.publishEvent(event);
    自定义事件类
        什么时候需要？
            被观察者在需要传输数据给观察者时
        怎么做？
            自定义事件类 extends ApplicationEvent
















day3
三、面向切面编程(Aspect oriented Programming) 
    1、代理模式
    定义
        1 A , B 实现了相同的接口，接口要求方法 m
        2 用户调用A的m，A又调用B的m
         
    解决什么问题(什么时候考虑使用代理模式)
        1 扩展功能，而不修改现有的类 
        2 职责具有清晰的划分
        
    怎么用    
        Actale--接口 方法 act
        Actor---实现
        Test --- 客户
        Broker--实现，Actor 的代理
    
    采用代理实现日志
        IFoo
            doA,doB,doC
        Foo
        
        Test -- Test
        FooLogProxy        
                
    
    注意思考：日志代理的弊端
        相同的代码散落在每一个方法中

    
    2、使用动态代理解决
        下面方法可以直接为接口 Foo 产生代理实例：
            Foo proxy = (Foo) Proxy.newProxyInstance(
                    Foo.class.getClassLoader(),
                    new Class[] 
            { Foo.class },
            handler);
             对 proxy 调用接口定义的方法，都会被分发给:
                handler.invoke()
             handler 是实现InvocationHandler 接口的实例
             这样就把对多个方法的调用集中起来了
             handler.invoke()然后再分发请求到目标方法

         实施:
            1) 实现 InvocationHandler 接口
            2)产生代理

    3、Spring 的AOP 采用动态代理实现
    一些别扭的概念：
    切面：当前关注的一个代码的流程，其中可能调用了多个类的多个方法。
    连接点：一个代码流程中的某个步骤，也就是这个代码流程中对某个方法的调用。
    通知(Advice)：对于某个方法(连接点)，进行拦截的拦截规则。
    切入点：对于某个方法(连接点)，是否被拦截的判断(过滤)规则。
    目标对象：某个连接点所在的对象。
    AOP代理：目标对象的代理。

    代理的生成：ProxyFactoryBean(org.springframework.aop.framework.ProxyFactoryBean)
        工厂类，生产代理
        区别于 BeanFactory
    InvocationHandler 的行为 : Advice

    实施：
    1) 创建拦截器类，封装代理行为
        implements MethodInterceptor        
    2) 使用 ProxyFactoryBean 产生代理        
        属性：
            target 目标对象e
            proxyInterfaces 代理的接口
            interceptorNames 代理要干什么

    补充：Advice / Interceptor
        除了 MethodInterceptor,还有多种接口可供选择
        决定拦截方法的时机
            方法前拦截  MethodBeforeAdvice
            方法后拦截    AfterReturningAdvice                
            方法抛出异常后拦截 ThrowsAdvice                
            围绕方法拦截 MethodInterceptor
            
    MethodInterceptor 通用

    Pointcut 
        切点，相当于过滤器，缩小拦截的方法的范围
        
    
    概要：
        缩小接口或类的范围
        缩小方法的范围

    实施
    1) implements Pointcut 
        定制过滤规则
        ClassFilter
            站在接口或类的级别上缩小范围
        MethodMatcher
            站在方法的级别上所有范围
            isRuntime() 
                return true ,意味着要对参数的值做判断，会调用有三个参数的matchs方法
    2) 把 pointcut 和 advice 组合成一个 advisor 对象
         advisor = pointcut + advice
         使用 DefaultPointcutAdvisor(org.springframework.aop.support.DefaultPointcutAdvisor) 构造 advisor 对象
    3) 然后把 advisor 添加到 interceptorNames 中


    使用 Spring 提供的Advisor实现
    1)NameMetchMethodPointcutAdvisor()
    1)RegexpMethodPointcutAdvisor()

    思考：使用 ProxyFactoryBean 创建代理的缺点？？
        1)每个target都要声明ProxyFactoryBean真麻烦!!!
        2)能不能以自动匹配的形式创建代理
        可以!!!使用自动代理创建器
    
    BeanNameAutoProxyCreator(org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator)
        为指定的 bean 自动创建代理
        属性：
            beanNames
            interceptorNames
    DefaultAdvisorAutoProxyCreator(org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator)
        根据 Advisor 创建代理













day4
四、使用AOP管理事务

    帐户管理
        Account
        IAccountDao
            long open(String name,double init);
            withdraw(long id,double amount);
            deposit(long id,double amount);
            List<Account> findByName(String name)        
        JdbcAccountDao
        applicationContex.xml 
            提供数据源，注入给DAO

    实践经验：
        Dao 中定义的方法是持久化单元操作，
        一个事务可能有若干个单元操作构成，
        所以事务逻辑不应该出现在Dao中。
        通常事务逻辑应用在业务层(service层)

    采用 AOP 管理事务
        JdbcTransactionManager implements MethodInterceptor
        
        问题：
            1)事务管理器与Dao 都操作同一个连接对象
            2)同时，要保证在每个线程都操作不同的连接对象
        解决方法：采用ThreadLocal 管理连接对象

    创建模板类
        管理资源(连接对象)的获取释放
        执行SQL
        JDBCTemplate
            update(String sql,Object[] args);
            List<Map> query(String sql);    

    结论：事务管理棘手
         资源的管理棘手


五、对Jdbc的支持
    1.提供了JdbcTemplate 简化编程
    2.提供了声明的事务管理(与编程的事务管理)
        不再把事务逻辑硬编码在程序中，而是在配置文件中定义事务边界
    3.把所有checkedException ---> uncheckedException
        SQLException--->DataAccessException


    应用步骤：
        Account

        IAccountDao
            long open(String name,double amount);
            void deposit(long id,double amount);
            void withdraw(long id,double amount);
            List<Account> findByName(String name);

        JdbcAccountDao    extends JdbcDaoSupport
            继承了两个方法：
                setDataSource(DataSource ds)
                getJdbcTemplate()        

        Test

        applicationContext.xml 
            datasource(org.springframework.jdbc.datasource.DriverManagerDataSource)
                driverClassName
                url
                username
                password
            dao
            transactionManager(org.springframework.jdbc.datasource.DataSourceTransactionManager)
                dataSource
            transactionProxy(org.springframework.transaction.interceptor.TransactionProxyFactoryBean)
                target
                transactionManager
                transactionAttributes

    事务的传播属性,七种                    
        调用者：调用当前方法的方法
        当前方法：声明事务属性的方法

    PROPAGATION_REQUIRED:如果存在一个事务，则支持当前事务。
                 如果没有事务则开启一个新的事务。

    PROPAGATION_SUPPORTS: 如果存在一个事务，支持当前事务。
                  如果没有事务，则非事务的执行。

    PROPAGATION_MANDATORY: 如果已经存在一个事务，支持当前事务。
                   如果没有一个活动的事务，则抛出异常。 

    PROPAGATION_REQUIRES_NEW: 总是开启一个新的事务。
                      如果一个事务已经存在，则将这个存在的事务挂起。

    PROPAGATION_NOT_SUPPORTED: 总是非事务地执行，并挂起任何存在的事务。  

    PROPAGATION_NEVER: 总是非事务地执行，如果存在一个活动事务，则抛出异常       

    PROPAGATION_NESTED: 如果一个活动的事务存在，则运行在一个嵌套的事务中. 
                如果没有活动事务, 则按TransactionDefinition.PROPAGATION_REQUIRED 属性执行 
        
    JdbcTemplate                 
        JdbcTemplate 的API
            更新
            查询

        如果使用Spring 提供的事务管理器 ， 你必须使用 Template        


六、Spring对 Hibernate 的支持
    1) HibernateTemplate
    2) 提供声明的事务管理
    3) LocalSessionFactoryBean(org.springframework.orm.hibernate3.LocalSessionFactoryBean) 
        dataSource

应用的步骤(与JDBC有三点不同)    
    
    1)HibernateAccountDao extends HibernateDaoSupport 
        setSessionFactory()
        getHibernateTemplate()
    
    2)事务管理器使用 HibernateTransactionManager(org.springframework.orm.hibernate3.HibernateTransactionManager)

    3)使用 LocalSessionFactoryBean 获得SessionFactory





1.SpringDAO,SpringORM给持久层带来的好处：
  省去try catch代码，事务、异常自动处理
2.访问数据源的两种方法(b/s,c/s)：
  dataSource:
     JDBC Driver          JNDI
7.事务的五个属性：
  传播性、只读、










day5

Struts1.x流程：
 B(浏览器)---->ActionServlet-->RequestProcessor-->Action-->JavaBean-->DB
        request                       ↓      <--       <--       <--
                                struts-config.xml   


七、在web 应用中使用Spring
    概述：
        Spring 提供监听器，在应用部署时构造ApplicationContext
        ApplicationContext 对象会被绑定在 servlet context 中
        Spring 提供了API获得servlet context 中的ApplicationContext        

   实施步骤：
    实现一个web应用，区分 mvc 。

    然后，使用spring 管理model ：
    1) 配置监听器加载上下文
        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/applicationContext.xml</param-value>
        </context-param>
        <listener>
            <listener-class>
            org.springframework.web.context.ContextLoaderListener
            </listener-class>
        </listener>
    2) 在Servlet中获得上下文
        WebApplicationContext context=
            WebApplicationContextUtils
            .getWebApplicationContext(this.getServletContext());
    
-------------------------

八、对Struts 的支持
        辅助 Action 获得 model 对象
          两种选择：    
            Action 不受Spring 管理
                Spring为Action 获得 applicationContext 提供支持 
            Action 受 Spring 管理，
                容器为Action注入依赖的 model 对象
                使用Spring 的RequestProcessor 或 Action 代理实现


    与Struts 集成的两种选择：
    1 spring 不管理Action
        那只需要关注 Action 怎样获得上下文,两种方式可选择
        1) 仍然通过 WebApplicationContextUtils 获得
            WebApplicationContextUtils.getWebApplicationContext(
                        this.getServlet().getServletContext());
        2)XxAction extends ActionSupport
                继承了一个方法 ：getWebApplicationContext            
            令外可选择 :
                DispatchActionSuport 
                LookupDispatchActionSupport
                MappingDispatchActionSupport

       优点：结构清楚简单,容易理解

    2 让 Spring 管理 Action
        把 Action 做为 bean 配置
        这样就可以注入Action 依赖的 model 对象了

        实现机制，有两种：
            改变 RequestProcessor 创建 Action的行为 
                改由上下文中获得 action
                原理：覆盖 processActionCreate
        
            所有请求都给一个特殊的Action，
                此 Action execute 方法由上下文中获得 action 
                然后把处理行为委托给action 
                    return action.execute() 
                    
        
        Spring 给我们提供了这两种机制的实现
    
      实施：
        1) 把 Action 作为bean 配置,注入其依赖的model组件
            applicationContext.xml :
                <bean name="/actionpath" class="action class">
                    <property name="foo">
                        <ref bean="foo"/>
                    </property>
                </bean>
          struts-config.xml :
                <action name="/actionpath" type="action class"/>
                type 无效
                即，等价于：
                <action name="/actionpath" />    
        2) 选择 RequestProcessor 或者 Action ，
            使其委托请求给 spring 管理的bean

            A)使用DelegatingRequestProcessor
                <controller processorClass=
                "org.springframework.web.struts.DelegatingRequestProcessor"/>
            B)使用 Action 的代理 DelegatingActionProxy
                 <action path="/actionpath" 
                    type="org.springframework.web.struts.DelegatingActionProxy"/>




Spring Security(安全) 
比较JAAS与SpringSecurity
    JAAS              SpringSecurity
  与具体的 web容器有关   与具体web容器无关(技术：IOC/AOP) 








推荐书籍(学完这课程之后再看)：
Spring2.x(2.0/2.5)实例指南
Spring2企业级开发(图灵出版社) 

