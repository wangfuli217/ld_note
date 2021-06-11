
软件开发的分层思想：
    三层架构：
                           数据表现层     业务逻辑层      数据持久层
        SUN的桌面应用        Swing AWT    普通Java类     JDBC
        SUN的WEB基本应用     JSP          普通Servlet    JDBC
        SUN的WEB高级应用     JSF          SessionBean   Persistence 
        WEB国内流行开源      Struts       Spring         Hibernate


一、 对象持久化的理论
    1.对象持久化：内存中的对象转存到外部持久设备上，在需要的时候还可以恢复。
    2.对象持久化的原因(目标)：
      物理： 1) 内存不能持久，需要在硬盘上持久保存 //(物理上，物理的都不是根本原因) 
            2) 内存容量有限，需要在容量更大的硬盘上保存 
      应用： 3) 共享(Internet的本质：信息的收集、整理、发布) //最重要的原因
            4) 检索(大规模) //也很重要
            5) 管理(备份、安全) 
    3.怎样进行对象持久化？(仅从JAVA方面讲) 
      物理： 1) 对象序列化
            2) DB技术(JDBC 数据库) 
    4.怎样利用数据库做对象持久化？
            1) JDBC 
               优点：功能完备、理论上效率高
               缺点：复杂(难)、代码量大、面向R(过程；二维表关系) 
            2) EJB 仅讲Entity Bean
               优点：封装JDBC
               缺点：更复杂的API、重量级(侵入式)、功能不完备、难共享
                    缺点的后果：开发周期长、测试困难、面向过程
               以上是 2.0之前的版本，但 3.0跟Hibernate基本一样
            3) ORM 轻量级框架(Hibernate) 
               现阶段最佳的持久化工具：文档齐全、服务很好、工业标准、大量应用、易学
               优点：封装JBDC、简单的API、轻量级(只做持久化)(用类库)、PO(持久对象)->POJO(纯JAVA)、开源
               缺点：不够JDBC灵活
    5.结论：
      1)对象持久化是必须的
      2)必须使用DB来实现
      3)Hibernate必须的(现阶段最佳选择) 
          开源工具的通常问题：1.文档不全；2.服务不全；3.标准化不够
          而Hibernate避免了所有这些问题 

二、 ORM和Hibernate的相关知识(理解)
    1) ORM:Object Relational Mapping
       对象-关系映射实现了面向对象世界中对象到关系数据库中的表的自动的(和透明的)持久化，
       使用元数据(meta data)描述对象与数据库间的映射。
    2) Hibernate是非常优秀、成熟的O/R Mapping框架。它提供了强大的对象和关系数据库映射以及查询功能。

    规范：
        1.一个映射文件对应一个持久类(一一对应) 
        2.映射文件的名字和它所描述的持久类的名字保持一致
        3.映射文件应该与它所描述的类在同一包中
    po -> (pojo) 
       -> oid(唯一，中性) 
       -> getters/setters
       -> 构造方法


三、Hibernate核心API(理解)
    Configuration类:
        Configuration对象用于配置和启动Hibernate。Hibernate应用通过Configuration实例来指定对象-关系映射文
        件的位置或者动态配置Hibernate的属性，然后创建SessionFactory实例。
    SessionFactory接口：
        一个SessionFactory实例对应一个数据存储源。应用从SessionFactory中获取Session实例。
        1)它是线程安全的，这意味着它的一个实例能够被应用的多个线程共享。
        2)它是重量级的，这意味着不能随意创建或者销毁，一个数据库只对应一个SessionFactory。
          通常构建SessionFactory是在某对象Bean的静态初始化代码块中进行。
          如果应用只是访问一个数据库，只需创建一个SessionFactory实例，并且在应用初始化的时候创建该实例。
          如果应用有同时访问多个数据库，则需为每个数据库创建一个单独的SessionFactory。
    Session接口：
        是Hibernate应用最广泛的接口。它提供了和持久化相关的操作，如添加，删除，更改，加载和查询对象。
        1)它是线程不安全的，因此在设计软件架构时，应尽量避免多个线程共享一个Session实例。
        2)Session实例是轻量级的，这意味着在程序可以经常创建和销毁Session对象，
          例如为每个客户请求分配单独的Session实例。
          原则：一个线程一个Session；一个事务一个Session。
    Transaction接口：
        是Hibernate的事务处理接口，它对底层的事务接口进行封装。
    Query和Criteria接口：
        这两个是Hibernate的查询接口，用于向数据库查询对象，以及控制执行查询的过程。
        Query实例包装了一个HQL查询语句。
        Criteria接口完全封装了基于字符串形式的查询语句，比Query接口更面向对象。Criteria更擅长于执行动态查询。
        补充：find方法也提供数据查询功能，但只是执行一些简单的HQL查询语句的快捷方式(已过时)，远没有Query接口强大！


四、Hibernate开发步骤:(重点：必须掌握) 
   开始：(设置环境变量和配置) 
         在myeclipse里导入Hibernate的文件包(包括各数据库的驱动和其他的jar包，对版本敏感，注意各版本的兼容) 
         按hibernate规范编写名字为hibernate.cfg.xml文件(默认放在工程文件夹下) 
   步骤一：设计和建立数据库表
        可以用Hibernate直接生成映射表。
        Oracle里建表： create table t_ad (oid number(15) primary key,
                      ACTNO varchar(20) not null unique,BALANCE number(20));
   步骤二：持久化类的设计
     POJO----
     POJO 在Hibernate 语义中理解为数据库表所对应的Domain Object。(此类中只含有属性、构造方法、get/set方法) 
     这里的POJO就是所谓的“Plain Ordinary Java Object”，字面上来讲就是无格式普通Java 对象，
     简单的可以理解为一个不包含逻辑代码的值对象(Value Object 简称VO)。

   步骤三：持久化类和关系数据库的映射
     编写*.hbm.xml文件
     ---该文件配置持久化类和数据库表之间的映射关系
     <class name=“POJO的类全路径”  table=“对应的库表名”     //这两项一定要配置，其它的都可以不配置
			discriminator-value=“discriminator_value”   //区分不同子类的值，多态时使用。默认与类名一样
			dynamic-update=“true | false” //是否动态更新SQL。false:每次都更新所有属性;true:只更新修改的
			dynamic-insert=“true | false” //是否动态插入SQL。false:每次都插入所有属性;true:只插入非空的
			select-before-update=“true | false” //是否在update前查询对象是否被修改过，修改过才update
			polymorphism=“implicit | explicit”  //设置多态是显性（explicit）的还是隐性（implicit）的
			where=“查询时使用的SQL的条件子句”   //查询时使用的SQL的条件子句
			lazy=“true | false” //设置延迟加载策略
	 />
     一个实体对应一个xml文件，组件用id，非组件用property。
     *.hbm.xml文件样板：
        <?xml version="1.0" encoding="utf-8" ?>
        <!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
            "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
        <hibernate-mapping package="com.tarena.ebank.biz.entity"><!--package指文件所在的包名 -->
           <class name="Account" table="student"><!-- name:POJO类的名; table数据库里对应的表名-->
              <id name="oid" column="OID"><!-- OID:(唯一，中性)表自动生成的(需要另外添加hilo表) -->
                 <generator class="hilo">
                    <param name="table">t_hi</param>
                    <param name="column">hi</param>
              </generator></id>
			  <!-- column:指数据库表里的字段名称， name:bean类里的成员名称 -->
              <property name="actNo" type="Int32" column="ACTNO" unique="true" not-null="true"/>
              <property name="bal" type="String" column="BALANCE" not-null="true"/>
           </class>
        </hibernate-mapping>

   步骤四：Hibernate配置文件
     hibernate.cfg.xml或hibernate.properties
     1.需要配置那些信息：持久化映射，方言，特性，登陆信息
         多数使用默认的设置。
         A、dialect：方言，就是拼驱动程序和SQL语句。每种数据库对应一种方言。其实就是指定了用那一种数据库。
            Oracle数据库方言：org.hibernate.dialect.OracleDialect
            MySql数据库方言：org.hibernate.dialect.MySQLDialect
         B、Object Persistence：对象持久化。把内存中的数据保存到一个永久的介质中，比如说数据库。
         C、ORM：对象关系映射，是一个自动的过程
         注：持久对象与临时对象最大的区别是有没有数据库id标识。
    2.hibernate.cfg.xml的样板：
      <?xml version='1.0' encoding='UTF-8'?>
      <!DOCTYPE hibernate-configuration PUBLIC
          "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
          "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
      <hibernate-configuration>
      <session-factory>
            <!-- 数据库连接配置 -->
        <property name="connection.url">jdbc:mysql://localhost:3306/test</property>
        <property name="connection.driver_class">com.mysql.jdbc.Driver</property>
        <property name="connection.username">root</property>
        <property name="connection.password">password</property>
            <!-- 自动建表语句：create覆盖旧表，update自动更新，none不理会 -->
        <property name="hbm2ddl.auto">update</property> 
            <!-- 是否在控制台上打印SQL(Hibernate把语句转化为SQL语句)，默认false-->
        <property name="show_sql">true</property>
            <!-- 缓存策略，数据量不大可不写  -->
        <property name="cache.provider_class">org.hibernate.cache.EhCacheProvider</property>
        <property name="cache.use_query_cache">false</property>
        <property name="cache.use_second_level_cache">false</property>
            <!-- 不同数据库使用的SQL选择 -->
        <property name="dialect">org.hibernate.dialect.MySQLDialect</property>
        <property name="myeclipse.connection.profile">mysql</property>
            <!-- 连接池配置，练习时不写，使用默认的 -->
        <property name="connection.pool_size">1</property>
            <!--决定是采用thread或jta或自定义的方式来产生session，练习时不写，使用默认的  -->
        <property name="current_session_context_class">thread</property>
            <!-- *.hbm.xml文件路径，各关联表要一同写上 -->
        <mapping resource="many_to_one/vo/Customer.hbm.xml" />
        <mapping resource="com/tarena/ebank/biz/entity/Order.hbm.xml" />
      </session-factory>
      </hibernate-configuration>
<%
    步骤五：使用Hibernate API
        //读取Hibernate.cfg.xml配置文件，并读到内存中为后续操作作准备
        Configuration config = new Configuration().configure();
        //SessionFactory缓存了生成的SQL语句和Hibernate在运行时使用的映射元数据。
        SessionFactory sessionFactory = config.buildSessionFactory();
        //Session是持久层操作的基础，相当于JDBC中的Connection。
        Session session = sessionFactory.openSession();

        try{  //为保持事务的原子性，必须捕捉异常。所有事务都放在这一代码块里。
            //操作事务时(增、删、改)必须显式的调用Transaction(默认：autoCommit=false)。
            Transaction tx = session.beginTransaction();
            for(int i=0; i<=1000; i++){
              Student stu = new Student(...);
              session.save(stu);//set value to stu
              //批量更新：为防止内存不足，分成每20个一批发送过去。 如果不是大批量更新，则不需要这样
              if(i%20==0){session.flush();session.clear();}
            }
			//默认时，会自动flush：查询之前、提交时。
			tx.commit();//提交事务，Hibernate不喜欢抛异常，如有需要，自己捕捉。

            //查询方法。如果有必要，也可以用事务(调用Transaction) 
            String hql = "from Student s where s.stuNo like ? and s.Sal > ?";//Student是类而不是表
            List list = session.createQuery(hql)
                               .setString(0, "a00_").setDouble(1, 3000.0)//设置HQL的第一二个问号取值
                               .list();//Hibernate里面，没有返回值的都默认返回List
            StringBuffer sb = new StringBuffer();
            for(Student st :(List<Student>)list){//(List<Student>)强制类型转换
              sb.append(st.getOid()+"  "+st.getName()+"\n");//拿到Student类里的属性
            }
			System.out.print(sb.toString());//直接打印sb也可以，它也是调用toString，但这样写效率更高
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();//如果事务不成功，则rollback
        } finally {
            session.close();//注意关闭顺序，session先关，Factory最后关(因为它可以启动多个session) 
            sessionFactory.close();//关闭SessionFactory，虽然这里没看到它，但在HbnUtil里开启了。
        }
%>

五、 Hibernate主键策略(上面的步骤三的一部分) 
    <id><generator class=“主键策略” /></id> 
    主键：在关系数据库中，主键用来标识记录并保证每条记录的唯一性(一般可保证全数据库唯一)。必须满足以下条件：
        1)不允许为空。
        2)不允许主键值重复。
        3)主键值不允许改变。
    1.自然主键：以有业务含义的字段为主键，称为自然主键。
        优点：不用额外的字段。
        缺点：当业务需求发生变化时，必须修改数据类型，修改表的主键，增加了维护数据库的难度。
    2.代理主键：增加一个额外的没有任何业务含义的一般被命名为ID的字段作为主键。
        缺点：增加了额外字段，占用部分存储空间。
        优点：提高了数据库设计的灵活性。
    Hibernate用对象标识(OID)来区分对象:
        Student stu = (Student)session.load(Student.class,101); //这代码加载了OID为101的Student对象
    Hibernate推荐使用代理主键，因此Hibernate的OID与代理主键对应，一般采用整数型，包括：short、int、long。

    1、主键生成策略： (Hibernate支持多种主键生成策略) 
    generator节点中class属性的值：
      1) assigned：assigned：由用户自定义ID，无需Hibernate或数据库参与。
         是<generator>元素没有指定时的默认生成策略。
           <id name="id" column="id"><generator class="assigned"/></id>
      2) hilo：通过hi/lo(高/低位)算法生成主键，需要另外建表保存主键生成的历史状态(这表只需要一个列和高位初始值)。
         hi/lo算法产生的标识只在一个特定的DB中是唯一的。所有数据库都可用。
         如果同一个数据库里多张表都需要用；可以建多张主键表，也可以共用同一字段，但最好是用同一张主键表的不同字段。
           <id name="id" column="id"><generator class="hilo">
               <param name="table">high_val</param><!--指定高位取值的表-->
               <param name="column">nextval</param> <!--指定高位取值的列-->
               <param name="max_lo">5</param><!--指定低位最大值，当取到最大值是会再取一个高位值再运算-->
           </generator></id>
      3) sequence：采用数据库提供的Sequence机制。
         Oracle,DB2等数据库都提供序列发生器生成主键，Hibernate也提供支持。
           <id name="id" column="id"><generator class="sequence">
               <param name="sequence">序列名</param>
           </generator></id>
      4) seqhilo：功能同hilo，只是自动建表保存高位值。主键生成的历史状态保存在Sequence中。
         只能用于Oracle等支持Sequence的数据库。
           <id name="id" column="id"><generator class="hilo">
               <param name="sequence">high_val_seq</param> <param name="max_lo">5</param>
           </generator></id>
      5) increment：主键按数值顺序递增。
         作用类型：long,short,int
         使用场景：在没有其他进程同时往同一张表插数据时使用，在cluster下不能使用
      6) indentity：采用数据库提供的主键生成机制。特点：递增。(Oracle不支持) 
         通常是对DB2,Mysql, MS Sql Server, Sybase, Hypersonic SQL(HSQL)内置的标识字段提供支持。
         返回类型：long,short, int  
           <id name="id" column="id"><generator class="identity"/></id>
         注：使用MySql递增序列需要在数据库建表时对主健指定为auto_increment属性。用Hibernate建表则不需要写。
           (oid int primary key auto_increment) 
      7) native：由Hibernate根据底层数据库自行判断采用indentity, hilo或sequence中的一种。
         是最通用的实现，跨数据库时使用。Default.sequence为hibernate_sequence
           <id name="id" column="id"><generator class="native"/></id>
      8) foreign：由其他表的某字段作为主键，通常与<one-to-one>联合使用；共享主健(主键与外键)，两id值一样。
           <id name="id" column="id" type="integer"> <generator class="foreign">
               <param name="property">car</param>
           </generator></id>
      9) UUID：
         uuid.hex：由Hibernate基于128位唯一值产生算法生成十六进制数(长度为32的字符串---使用了IP地址)。
         uuid.string：与uuid.hex一样，但是生成16位未编码的字符串，在PostgreSQL等数据库中会出错。
         特点：全球唯一；ID是字符串。
      10)select：通过DB触发器(trigger)选择一些唯一主键的行，返回主键值来分配主键
      11)sequence-identity：特别的序列发生策略，使用DB序列来生成值，通常与JDBC3的getGenneratedKeys一起用，
         使得在执行insert时就返回生成的值。Oracle 10g(支持JDK1.4)驱动支持这一策略。

    2、复合主键策略
       步骤一：创建数据库表，设定联合主键约束
       步骤二：编写主持久化类以及主键类；编写主键类时，必须满足以下要求：
          1)实现Serializable接口
          2)覆盖equals和hashCode方法
          3)属性必须包含主键的所有字段
       步骤三：编写*.hbm.xml配置文件
          <composite-id name="dogId" class="composite.vo.DogId">
            <key-property name="name" type="string"><column name="d_name"/></key-property>
            <key-property name="nick" type="string"><column name="d_nick"/></key-property>
          </composite-id>


六、 Hibernate的查询方案(应该熟悉各种查询的使用方法)
    1、利用Session接口提供的load方法或者get方法
    2、Hibernate提供的主要查询方法
       1)Criteria Query(条件查询)的步骤：
         (1)通过Session来创建条件查询对象Criteria
            Criteria criteria = session.createCriteria(Course.class);
         (2)构建条件---创建查询条件对象Criterion
            Criterion criterion1 = Property.forName("id").ge(39);//通过Property来创建
            Criterion criterion2 = Restrictions.le("cycle", 5); //通过Restrictions来创建
         (3)查询对象关联条件
            criteria.add(criterion1);
         (4)执行条件查询
            List<Course> courses = criteria.list();
       2)HQL(Hibernate Qurey Language)
         特点： 语法上与SQL类似； 完全面向对象的查询； 支持继承、多态、关联
         (1) FROM子句
             例如：查询所有的学生实例
             Query query=session.createQuery("from Student"); query.list();
         (2) SELECT子句
             选择哪些对象和属性返回到结果集
          A、SELECT语句后可以跟多个任意类型的属性，返回结果保存在Object类型的数组中
             //A、B、C、都是查询学生的姓名和年龄
             Query query=session.createQuery("select stu.name,stu.age from Student as stu");
             List<Object[]> os=query.list();//返回的Object数组中有两个元素，第一个是姓名，第二个是年龄
          B、SELECT语句后可以跟多个任意类型的属性，返回结果也可以保存在List中
             Query query=session.createQuery
               ("select new List(stu.name,stu.age) from Student as stu");
             List<List> lists=query.list();
          C、SELECT语句后可以跟多个任意类型的属性，返回结果也可以是一个类型安全的POJO对象
             Query query=session.createQuery
               ("select new Student(stu.name,stu.age) from Student as stu");
             List<Student> stuList=query.list();//注意：Student类必须有Student(String,int)的构造方法
          D、SELECT子句中可以使用聚集函数、数学操作符、连接
             支持的聚集函数：avg、sum、min、max、count ….
         (3) WHERE子句，限制返回结果集的范围
         (4) ORDER BY子句，对返回结果集进行排序
       3)Native SQL(原生SQL,原始SQL查询)
         可移植性差：资源层如果采用了不同的数据库产品，需要修改代码---非不得已，不推荐使用
         步骤一：调用Session接口上的createSQLQuery(String sql)方法,返回SQLQuery
         步骤二：在SQLQuery对象上调用addEntity(Class pojoClass) //设置查询返回的实体
           例如：SQLQuery query =session.createSQLQuery(“select * from student limit 2,10”)
                query.addEntity(Student.class);
                List<Student> stuList=query.list();
         在数据量很大时，采用 HQL 会自动创建对象，消耗大量内存和时间，效率低下。故使用原始SQL,回到 JDBC 操作
           SessionFactory sessionFactory = getHibernateTemplate().getSessionFactory();   
           Session session = sessionFactory.openSession();
           Transaction tx = session.beginTransaction();
		    //取到 Connection, 就可以直接使用 JDBC 啦
           Connection conn = session.connection();
           PreparedStatement stmt = conn.prepareStatement( SQL );
           stmt.executeUpdate();
           tx.commit();



七、 Hibernate对象的状态
    实体对象的三种状态：
    1) 暂态(瞬时态)(Transient)---实体在内存中的自由存在，它与数据库的记录无关。
        po在DB中无记录(无副本)，po和session无关(手工管理同步) 
        如：Customer customer = new Customer(); customer.setName("eric");
        这里的customer对象与数据库中的数据没有任何关联
    2) 持久态(Persistent)---实体对象处于Hibernate框架的管理中。
        po在DB中有记录，和session有关(session自动管理同步) 
    3)游离态(脱管态)(Detached)
        处于Persistent状态的实体对象，其对应的Session实例关闭之后，那么，此对象处于Detached状态。
        po在DB中有记录，和session无关(手工管理同步) 
      无名态：po处于游离态时被垃圾回收了。没有正本，只有DB中的副本。
      po处于暂态时被垃圾回收了，则死亡。(唯一可以死亡的状态) 

    实质上，这三个状态是：持久对象的正副本与同步的关系
    原则：尽量使用持久态。
    三态的转换：
        暂态--->持久态
            A.调用Session接口上的get()、load()方法
            B.调用Session接口上的save()、saveOrUpdate()方法
        持久态--->暂态
            delete();
        游离态--->持久态
            update()、saveOrUpdate()、lock();
            (lock不建议用，危险；肯定没变化时用，有则用updata) 
        持久态--->游离态
            evict()、close()、clear() 
            (一般用evict，只关闭一个实体的连接；close关闭整个连接，动作太大) 


八、 映射(重点掌握和理解，注意配置的细节)
    关联关系：A有可能使用B，则AB之间有关联关系(Java里指A有B的引用)。
            双边关系、传递性、方向性、名称、角色(权限)、数量(1:1；1:m；n:m)、关联强度
    委托：整体跟部分之间是同一类型。    代理：整体跟部分之间不是同一类型。
    A. 单一实体映射：最简单、基本映射(最重要)；任何其他映射种类的基础。
       原则：1.类->表；一个类对应一个表。
            2.属性->字段：普通属性、Oid；一个属性对应一个字段。
    B. 实体关系映射：
       a.关联关系映射：(最难、量最多) 
           1.基数关系映射：
             一对一(one to one) (共享主键、唯一外键) 
             一对多(one to many) (1:m) 作级联，删one后连着删many
             多对一(many to one) (m:1) 不作级联，删many中一个，不删one
             多对多(many to many)(n:m = 1:n + m:1) 
           2.组件关系映射：(一个类作为另一个类的零件，从属于另一个类，没有自己的XML) 
             单一组件关系映射
             集合组件关系映射
       b.继承关系映射：(最普遍。两个类有继承关系，在本质上他们就是一对一关系。共享主健。) 
           有三种映射方案：
           1.一个类一个表(效率很低；最后考虑使用，一般是数据量较大和父子类重复字段不多的时候用) 
             只有当子类中的属性过多时才考虑每个类建一个表的策略。
           2.一个实体一个表(多表查询效率低，不考虑多态时用) 
             不考虑多态时，最好是用只针对具体类建表，而考虑多态时尽量使用所有类建一个表
           3.所有类一个表(查询效率最高，结构简单；字段数不超过100个时使用，首选) 

       c.集合映射(值类型) 
           Set   不重复、无顺序
           List  可重复、有顺序
           Map   
           Bag   可重复、无顺序(bag本身也是list实现的) 
    双向关联(Bidirectional associations)(相当于两个单向关联)  
    单向关联(Unidirectional associations) 

    "一"方的配置：
    <!-- 表明以Set集合来存放关联的对象，集合的属性名为orders；一个"customer"可以有多个"order" -->
    <!-- inverse="true"表示将主控权交给order，由order对象来维护关联关系，
         也就是说order对象中的关联属性customer的值的改变会反映到数据库中 -->
    <set name="orders" cascade="save-update" inverse="true">
        <!-- 表明数据库的orders表通过外键customer_id参照customer表 -->
        <key column="customer_id"/>    
        <!-- 指明Set集合存放的关联对象的类型 -->
        <one-to-many class="many_to_one.vo.Order"/>
    </set>

    "多"方的配置：
    <many-to-one 
        name="customer" 
        class="many_to_one.vo.Customer" 
        column="customer_id"
        not-null="true"
        cascade="save-update"
        />

    cascade属性：设定级联操作(插入、修改、删除)。
    cascad属性值                 描述
    -------------------------------------------------------------------------
    none                 保存、更新或删除当前对象时，忽略其他关联对象，默认属性值
    save-update          通过Session的save()、update()以及saveOrUpdate()方法来保持、更新当前对象时级联
                         所有关联的新建对象，并且级联更新所有有关联的游离对象
    delete               当通过Session的delete()方法来删除当前对象时，级联删除所有关联对象
    all                  包含所有的save-update以及delete行为
    delete-orphan        删除所有和当前对象解除关联关系的对象
    all-delete-orphan    包含all与delete-orphan的动作

    inverse属性：表示是否将当前属性的值的变化反映到数据库中去。
            false --- 表示反映到数据库中
            true ---表示不反映到数据库中
    Set的lazy属性：
       A.不设置lazy值，默认true    现象：查询Customer时，不会主动查询关联表Orders(SQL语句)
       B.设置lazy=false          现象：出现查询Orders表的SQL语句

    3、多对多
        默认情况下，由两方共同维护关联关系。也就是两个对象关联属性的值的改变都会反映到数据库中。


九、 Hibernate控制的事务
	事务保证原子操作的不可分，也就是操作的同时成功或同时失败。
	hibernate的事务隔离级别和JDBC中大致相同。
		设置时要在hibernate.cfg.xml配置
		<property name="hibernate.connection.isolation">4</property>
		1： 读未提交的数据(Read uncommitted isolation) 脏读
		2： 读已提交的数据(Read committed isolation)   不可重复读
		4： 可重复读级别(Repeatable read isolation)    幻读
		8： 可串行化级别(Serializable isolation) 
	hibernate的锁(悲观锁，乐观锁)
	  1.悲观锁是由数据库本身所实现的，会对数据库中的数据进行锁定，也就是锁行。(更新期间不许其他人更改) 
		LockMode.UPGRADE,修改锁，在get()方法中加上这个设置作为第三个参数。
		LockMode.NONE 无锁机制
		LockMode.READ 读取锁
		LockMode.WRITE 写入锁，不能在程序中直接使用
		还可以使用Session.lock()  Query.setLockMode()  Criteria.setLockMode()方法来设置锁，
		检测版本号，一旦版本号被改动则报异常。
	  2.乐观锁，也就是通过对记录加上某些信息来解决并发访问的问题。(认为更新期间不会有其他更改) 
		版本检查；要在其表中多加上一列表示版本信息，会在读取时读到这个版本号，并在修改之后更新这个版本号；
		更新瞬间加锁，并且只有版本号相同才会予以更新，如果版本号不同，就会抛出例外。
		<version name="version" column="version" type="integer" />





























