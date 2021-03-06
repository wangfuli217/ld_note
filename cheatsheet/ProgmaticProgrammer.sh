{EJB (Enterprise JavaBean sun的JavaEE服务器端组件模型，设计目标与核心应用是部署分布式应用程序)
CORBA (Common Object Request Broker Architecture,公共对象请求代理体系结构，通用对象请求代理体系结构)
AOP (Aspect Oriented Programming 面向切面编程) -- Spring
RMI (Remote Method Invocation，远程方法调用)
 }
1. 一切阅读都是误读。
2. 细想一下Bug列表中的问题，其中大多数问题正是由于不正确的假设，或者是想当然造成的。
3. 不同的人从不同的角度用不同的方式，阐述相同的道路。
4. 如果要成为一个好程序员，其实所需要的道理也多不了多少，只不过，当水平不够的时候，永远不能认识到哪些朴素道理的重要。
5. 经验这个东西，往往不能告诉我们什么一定对，但是可以告诉我们什么一定不对。
6. 能不能让正确的原则指导正确的行动本身，其实就是区分是否是高手的一个显著标志。
7. 频繁的高强度的外部刺激和自主的有意识的反复提醒是加速内化的两个重要方法。

8. 维护，调试才是成本。

学会：
1. 与软件腐烂做斗争
2. 避开重复知识的陷阱
3. 编写灵活、动态、可适应的代码
4. 防止考巧合编程
5. 通过合约、断言以及异常使你的代码"防弹"
6. 捕捉真正的需求
7. 无情而有效的测试
8. 让你的客户满意
9. 建立注重实效程序的团队，并且通过自动化使你的开发更严谨。


progmatic(编程)
{
编程是一种技艺。用最简单的话表述，编成可归结为让计算机做你(或者你的用户)想要做他做的事情。
}

8. 无论是工具，语言还是操作系统，能够存在的只是在某些特定情形下更为适宜的系统。
   你不应该局限于任何特定的技术，而是应该拥有足够广博的背景和经验基础，以让你能在特定情况下选择好的解决方案。
   你的背景源自对计算机科学的基本原理的理解，而你的经验来自广泛的实际项目。理论和实现的结合使你强大起来。
progmatic(注重实效的程序员的特征)
{
要成为注重实效的程序员，不仅要完成工作，而且要完成的漂亮。
注重实效的个体，大型的团队，是一个持续的过程

1. 早期的采纳者/快速的改编者 [具有技术和技巧上的直觉，喜欢试验各种事务]
2. 好奇                      [喜欢提问，收集小知识的林鼠]
3. 批判的思考者              [不会不首先抓住事实而搬照别人的说法]
4. 有现实感                  [设法理解你面临的每个问题的内在本质]
5. 多才多艺                  [尽力熟悉广泛的技术和环境，并努力工作，以与各种新发展并肩前行]
}


关心你的技艺  [care about you craft]
思考！你的工作 [Think! About your work]

我们，采集的只是石头，却必须时刻展望未来的大教堂  ---- 采石工人的信条

9. 每天为提炼你所拥有的技能而工作，为把新的工具增加到你的技能列表中而工作。

progmatic(注重实效的程序员的哲学)
{
    注重实效的程序员的特征是什么？我们觉得是他们处理问题、寻求解决方案时的态度、风格、哲学。
    他们能够越出直接的问题去思考，总是设法把问题放在更大的语境中，总是设法注意更大的图景。毕竟，没有这样的更大的语境，
你怎么能注重实效，你又怎么注重实效？你又怎能做出明智的妥协和有见识的决策？
    他们的成功的另一个关键是他们对他们所做的每件事情负责。因为负责，注重实效的程序员不会坐视他们的项目土崩瓦解。
他们尽力使项目保持整洁。

}
在所有弱点中，最大的弱点就是害怕暴露弱点  ---- J.B. Bossuet，Politics from Holy Writ, 1709

10. 我们可以为我们的能力自豪，但对于我们的缺点 -- 还有我们的无知和我们的错误 -- 我们必须诚实。

progmatic(责任){责任是你主动负担的东西
    你承诺确保某件事情正确完成，但你不一定能直接控制事情的每一个方面。除了尽你所能以外，你必须分析风险是否超出你的控制
对于不可能做的事情或者是风险太大的事情，你有权不去为之负责。你必须基于你自己的道德准则和判断来做出决定。
    如果你确实同意要为结果负责，你就应该切实负起责任。当你犯错误(就如同我们所有人都会犯错误一样)、或者是判断失误时，
诚实地承认它，并设法给出各种选择。
<不要责备别人或者别的东西，或是拼凑借口>
<要提供各种选择，而不是找借口。不要说明事情做不到；要说明能够做什么来挽回局面>
<不要害怕提出要求，也不要害怕承认你需要帮助>

选择 ?
  ① 说明重构的价值
　② 花时间建立原型
　③ 引入更好的测试
}
提供各种选择，不要找蹩脚的接口 [Provide Options, Do not Make Lame Excuses]
<要提供各种选择，而不是借口。不要说事情做不到；说明能够做什么。>

11. 当软件中的无序增长时，程序员称之为"软件腐烂"。
    促生软件腐烂的最重要的是开发项目时的心理。

不要容忍破窗户 [Do not Live with broken Windows]
破窗户:低劣的设计、错误的决策、或是糟糕的代码；发现一个就修一个。如果没有足够的时间进行适当的修理，就用木板把它钉住。
    按照同样的道理，如果你发现你所在团队和项目的代码十分漂亮 -- 编写整洁、设计良好、并且很优雅 -- 你就很可能会格外注意
不去把它弄脏，你也不会想成为第一个弄脏东西的人。

做变化的催化剂 [Be a Catalyst for Change]
<你不能强迫人们改变。相反，要向他们展示未来可能会怎样，并帮助他们参与对未来的创造。>
记住大图景 [Remember The Big Picture]
留心大图景。要持续不断地观察周围发生的事情，而不只是你自己在做的事情。
<不要太过专注于细节，以致忘了查看你周围正在发生什么。>

progmatic(足够好){
欲求更好，常把好事变遭    ---- 李尔王
时间、技术和急躁都在合谋反对我们。

    首先得确保软件可用性,至于亮点,特色,在可用以后才需要考虑.而且还得明确用户需
求(虽然这点始终被强调).大家都知道系统不可能做的完美,但是自己着手开发的时候总是
朝着尽可能完美的方向发展。

足够好的软件 -- 对你的用户、对未来的维护者、对你自己内心的安宁来说足够好。
             -- 并不意味着不整洁或制作糟糕的代码。
             -- 应该给客户以机会，让他们参与决定你所制作的东西何时足足够好。
12. 无视用户的需求，一味地给代码增加新特性，或是一次又一次润饰代码，这不是有职业素养的做法。
13. 你所制作的系统的范围和质量应该作为系统需求的一部分规定下来。

使质量成为需求问题 [Make Quality a Requirement Issue]
14. 如果你给用户某样东西，让他们及早使用，他们的反馈常常会把你引向更好的最终解决方案。
15. 如果你不懂得应何时止步，所有的辛苦劳作就会遭到毁坏。如果你一层又一层、细节复细节地叠加，常常会迷失在绘制之中。
    不要因为过度修饰和过于求精而损坏完好的程序。<他也许不完美，但不用担心：他不可能完美>
    
}

    
知识上投资总是能得到最好的回报  -- 本杰明.富兰克林
progmatic(知识资产和目标)
{
知识资产 -- [Knowledge Portfolious]
有时效的资产 -- [expiring asset]

1. 定期投资        习惯自身也和总量一样重要
2. 多元化          你知道的不同的事情越多，你就越有价值
3. 管理风险        
4. 低买高卖        在新兴的技术流程之前学习它可能就和找到被低估的股票一样困难，但所得到的就是和那样的股票带来的收益一样。
5. 重新评估和平衡  

定期为你的知识资产投资  [Invest Regularly in Your Knowledge Portfolios]
<让学习成为习惯>

[目标]
1. 每年至少学习一种新语言   不同语言以不同方式解决相同的问题。通过学习若干不同的方法，可以帮助你拓宽你的思维，并避免墨守成规。
2. 每季度阅读一本技术书籍   计算机是由人 -- 你在设法满足其需要的人 -- 使用的。
3. 也要阅读非技术书籍       
4. 上课                     
5. 参加本地用户组织         
6. 试验不同的环境           Windows -> Linux IDE -> Makefile
7. 跟上潮流                 
8 上网                      
}

progmatic(批判的思考)
{
批判地思考你读到和听到的。你需要确保你的资产中的知识是准确的，并且没有受到供应商或媒体炒作的影响。
警惕声称他们的信条提供了唯一答案的狂热者 -- 哪或许适用、或许不适用于你和你的项目。
}

批判地分析你读到的和听到的 [Critically Analyze What You Read and Hear]
<不要被供应商、媒体炒作、或教条左右。要依照你自己的看法和你的项目的情况去对信息进行分析。>

progmatic(交流)
{
1. 知道你想要说什么
   规划你想要说的东西。写出大纲。然后问你自己："这是否讲清了我要说的所有内容？"。提炼它，直到确实如此为止。
2. 了解你的听众[需求、兴趣、能力]
   WISDOM
   你想让他们学到什么？       What do you want them to learn ?
   他们对你讲什么感兴趣？     What is their interest in what you are got to say ?
   他们多富有经验？           How sophisticated are they ?
   他们想要多少细节？         How much detail do they want ?
   你想要让谁拥有这些信息？   Whow do you want to own the information ?
   你如何促使他们听你说话？   How can you motivate them to listen to you ?
3. 选择时机
4. 选择风格
5. 让文档美观：以美观的方式传递给你的听众。
   LaTex 和 troff
   任何一个厨师都会告诉你，你可以在厨房里忙碌几个小时，最后却会因为饭菜糟糕的外表而毁掉你的努力。
6. 让听众参与
7. 做倾听者
   如果你想要大家听你说话，你必须使用一种方法：听他们说话。即使你掌握着全部信息，即使那是一个正式会议。
    如果你不听他们说话，他们也不会听你说话。
8. 回复他人
    
}

你说什么和你怎么说同样重要 [It is Both What You Say and the Way You Say It]
<如果你不能有效地向他人传递你的了不起的想法，这些想法就毫无用处。>

16. 交流越有效，你就越有影响力。

progmatic(注重实效的途径)
{
我们都是在一个时间和资源有限的世界上工作。如果你善于估计出事情需要多长时间完成，你就能更好地在两者
都很匮乏的情况下生存下去(并让你的老板更高兴)。
}

progmatic(重复的危害 DRY)
{
不要重复你自己 [DRY Do not Repeat Yourself]
<DRY 系统中的每一项知识都必须具有单一、无歧义、权威的表示。>

重复是怎样发生的  
强加的重复        Imposed duplication           开发者觉得他们无可选择 -- 环境似乎要求重复
无意的重复        Inadvertent duplication       开发者没有意识到他们在重复信息
无耐性的重复      Impatient duplication         开发者偷懒，它们重复，因为那样似乎更容易
开发者之间的重复  Interdeveloper duplication    同一团队(或不同团队)的几个人重复同样的信息

1. 强加的重复
   1.1 信息的多种表示--过滤器和代码生成器； 
   1.2 代码中的文档：糟糕的代码才需要许多注释。
17. DRY法则告诉我们，要把低级的知识放在代码中，它属于那里；把注释保留给其他的高级说明。否则，我们就在重复知识。   
   而每一次改变都意味着既要改编代码，也要改变注释。注释将不可避免地变得过时，而不可信的注释完全比没有注释更糟糕。
   1.3 文档与代码：开发团队用程序方式、根据文档本身生成这些测试。   
   1.4 语言问题：
18. 应该用头文件记载接口问题，用实现文件记载代码的使用者无须了解的实际细节。

2. 无意的重复
   2.1 有时重复来自设计的错误。
3. 无耐性的重复
   3.1 无耐性的重复是一种容易检测和处理的重复形式，但那需要你就收训练，并愿意为避免以后的痛苦而预先花一些时间。

4. 开发者之间的重复
   在高层，可以通过清晰的设计、强有力的技术项目领导，以及在设计中进行得到了充分理解的责任划分，对这个问题加以处理。
19. 模块设计的所有服务都应能通过统一的表示法使用，该表示法不能泄露它们是通过存储、还是通过计算实现的。
   
让复用变得容易 [Make It Easy to Reuse]
<如果复用很容易，人们就会去复用。创造一个支持复用的环境。>
如果不容易，大家就不会去复用。
}

progmatic(正交性)
{
消除无关事务之间的影响 [Eliminate Effects Between Unrelated Things]
<设计自足、独立、并具有单一、良好定义的目的的组件。>

20. 我们想要设计自足(self-contained) 的组件： 独立，具有单一、良好定义的目的(Yourdom)和Constatine
    称之内聚(cohesion).
    如果组件是相互隔离的，你就知道能够改变其中之一，而不用担心其余组件。只要你不改变组件的外部接口，你就可以放心：
    你不会造成波及整个系统的问题。
[效果]
1. 提高生产率
   1.1 改动得以局部化，所以开发时间和测试时间得以降低
   1.2 正交的途径还能够促进复用
   1.3 如果你对正交的组件进行组合，生产率会有相当微妙的提高。
2. 降低风险    
   2.1 正交的途径能降低任何开发中固有的风险。
   2.2 有问题的代码区域被隔离开来
   2.3 所得系统更健壮。对特定区域做出小的改动与修正，你所导致的任何问题都将局限在该区域中。
   2.4 正交系统很可能能得到更好的测试，因为设计测试、并针对组件运行测试更容易。
   2.5 你不会与特定的供应商、产品、或是平台紧绑在一起。

[方式]
1. 项目团队
我们偏好是从使基础设施与应用分离开始，每个主要的基础设施组件(数据库、通信接口、中间层，等等)有自己的子团队。
20. 人数越多，团队的正交性就越差。   

2. 设计：分层的途径式设计正交系统的强大方式。
         MVC
21. 你的设计在多大程度上解除了与现实世界中的变化的耦合？

3.工具箱和库
22 在引入某个工具箱时(甚至是来自你们团队其他成员的库)，问问你自己，他是否迫使你对代码进行不必要的改动。
   RMI EJB AOP CORBA

4. 编码
   4.1 每次你编写代码，都有降低应用正交性的风险。
   4.2 让你的代码保持解耦。
       编写"羞怯"的代码 -- 也就是不会没有必要地向其他模块暴漏任何事情、也不依赖其他模块的实现模块。   
       解耦和得模忒耳法则:如果你改变对象的状态，让这个对象替你去做。这样你的代码就会保持与其他代码的实现的隔离，并增加你保持正交性的机会。
   4.3 避免使用全局变量
       当你的代码引用全局变量时，他都把自己与共享该数据的其他组件绑在了一起。即使你只想对全局变量数据进行读取。
       也可能回答来麻烦。
23. 一般而言，如果你把所需的任何语境(context)显式的传入模块，你的代码就会更容易理解和维护。在面向对象应用中，
语境常常作为参数传递给对象的构造器，换句话说，你可以创建含有语境的结构，并传递指向该结构的引用。
   4.4 避免编写相似的函数：
24. 养成不断地批判对待自己的代码的习惯。寻找任何重新进行组织、以改善其结构和正交性的机会。这个过程叫做重构(refactoring).

5. 测试
25. 我们建议让每个模块都拥有自己的、内建在代码中的单元测试，并让这些测试代码作为常规构建过程的一部分自动运行。

6. 文档
   对于真正正交的文档，你应该能显著地改变外观，而不用改变内容。
      
}

如果某个想法是你唯一的想法，再没有什么比这个更危险的事情了。  ---Emil-Auguste Chartier， Propos sur la religion

progmatic(可撤销性)
{
26. 要实现某种东西，总有不止一种方式，而且通常有不止一家供应商可以提供第三方产品。

不存在最终决策 [There Are No Final Decisions]
<没有决策是浇铸在石头上的。相反，要把每项决策都视为写在沙滩上的，并为变化作好计划。>

灵活的架构：
1. 不确定市场部门想怎么样部署系统？预先考虑这个问题，你可以支持单机、客户-服务器、或n层模型 --- 只需要改变配置文件。
2. 通常，你可以把第三方产品隐藏在定义良好的抽象接口后面，事实上，在我们做过的任何项目中，我们都总
   能够这么做。但假定你无法那么彻底地隔离它。如果你必须大量地某些语句分散在真个代码中怎么办？把该需求
   放入元数据，并且使用某种机制 --- aspect或perl -- 把必须的语句插入代码自身中。
   
}

<曳光弹能通过试验各种事物并检查他们离目标有多远来让你追踪目标。>
progmatic(yè曳光弹)
{
27. 曳光弹使用于新的项目。 <---> 经典的做法是把系统定死。制作大量文档，逐一列出每项需求、确定所有未知因素
                                 并限定环境。根据死的计算射击。预先进行一次大量计算，然后设计并期望集中目标。
                                 
用曳光弹找到目标 [User Tracer Bullets to Find the Target]
曳光代码并非用过就扔的代码：你编写它，是为了保留它。它含有任何一段产品代码都拥有的完整的错误检查、
结构、文档、以及自查。它只不过功能不全而已。但是，一旦你在系统的各组件间实现了端到端的连接，你就可以
检查你离目标还有多远，并在必要的情况下进行调整。一旦你完全瞄准，增加功能将是一件容易的事情。

28. 曳光开发与项目永远不会结束的理念是一致的：总有改动需要完成，总有功能需要增加。这是一个渐进的过程。

1. 用户能够及早看到能工作的东西
2. 开发者构建一个他们能在其中工作的结构。
29. 最令人畏缩的纸是什么也没有写的白纸。
3. 你有了一个集成平台
30. 你将每天进行集成(常常是一天进行多次)、而不是尝试进行大爆炸式的集成。
4. 你有了可用于演示的东西
5. 你将更能够感觉到工作进度。                                
}

<原型制作是一种学习经验。其价值并不在于所产生的代码，而在于所学到的经验教训。>
30. 原型制作视为第一发曳光弹发射之前进行的侦查和情报收集工作。
31. 原型 VS 曳光弹： 如果你发现自己处在不能放弃细节的环境中，就需要问自己，是否真的在构建原型。或许，曳光弹开发方式更适合这种情况。
    原型：你寻求的是了解系统怎么样结合成为一个整体，并推迟考虑细节
progmatic(原型和便签)
{
原型：可以用于试验危险或不确定的原件，而不用实际进行真实的制造。
       原型是设计就是为了回答一些问题。
原型制作是一种学习经验。其价值不在于所产生的代码，而在于所学到的经验教训。那么才是原型制作的要点所在。

原型寻求的是了解系统怎么样结合成为一个整体，并推迟考虑细节。

任何带有风险的事务。
1. 以前没有试过的事物。
2. 对于最终系统极端关键的事物。
3. 任何未被证明的、实验性的、或有疑问的事物。
4. 任何让你觉得不舒服的事物。
如： 架构
     已有系统中的新功能
     外部数据的结构或内容
     第三方工具或组件
     性能问题
     用于界面设计
     
为了学习而制作原型 [Prototype to Learn]

怎样使用原型：在构建原型时，你可以忽略哪些细节：
正确性、完整性、健壮性、风格。   ---- 你可以使用非常高级的语言实现原型。
不考虑性能：Perl Python Tcl
考虑界面的： Tcl/Tk Visual Basic Powerbuilder Delphi

[得到的解答]
1. 主要组件的责任是否得到了良好定义?是否适当?
2. 主要组件间的协作是否得到了良好定义?
3. 耦合是否得以最小化?
4. 你能否确定重复的潜在来源?
5. 接口定义和各项约束是否可接受?
6. 每个模块在执行过程中是否能访问到其所需要的数据?是否在需要时进行访问?
}

32. 计算机语言影响你思考问题的方式，以及你看待交流的方式。
    每种语言都含有一系列特性 -- 比如静态类型与动态类型、早期绑定与迟后绑定、继承模型(单、多或无)这样的时髦话语 -- 
    所有这些特性都在提示或遮蔽特定的解决方案。
    
progmatic(领域语言)
{
不同语言有不同的优势，关键在于扬长避短，合理运用，有时候组合起来事半功倍。
靠近问题领域编程 [Program Close to Problem domain]
<用你的用户的语言进行设计和编码。>

yacc && bison
javaCC
Python
}

BNF(Backus-Naur Form)
{
可用于递归地规定上下文无关(context-free)的文法，任何关于编译器构造或解析的好书都会详细(无遗漏的)涵盖BNF.
}

progmatic(数据语言和命令语言)
{
widget 窗口小部件
screen scraping 挂屏
maintenance programmer 维护程序员
}
33. 把高级命令语言直接嵌入你的应用是一种常见的做法，这样，它们就会在你的代码运行时执行。这显然是一种强大的能力；
    通过改变应用读取的脚本，你可以改变应用的行为，却完全不用编译。这可以显著地简化动态的应用领域中的维护工作。
    
估算，以避免发生意外 [Estimate to Avoid Supriess]
      所有的估算都以问题的模型为基础。
34. 较好的估算：去问已经做过这件事情的人。在你一头钻入建模之前，仔细在周围找找也曾处在类似情况下的人。
progmatic(估算 -- 场景 -- 精确地的把握)
{
1. 在某种情况下，所有的解答都是估算。
>> 多准确才足够准确[你使用的单位会对结果的解读造成影响]              准确度
     时长        报出估算的单位                                      
    1~15天       天                                                  
    3~8 周       周                                                  
    8~30周       月                                                  
    30+ 周       在给出估算前努力思考一下                            
    [要选择能反映你想要传达的精确度的单位。]                           
>> 估算来自哪里 ->[问题的模型] & [专家或同事相同或相似项目的经验]    经验
>> 理解提问内容 ->[建立对提问内容的理解]  需求内容的范围管理。       细化需求范围
>> 建立系统的模型->模型既可以是创造性的，又可是长期有用的。          性能
                 ->[可以是你的组织在开发过程中所用的步骤，以及系统的实现方式的非常粗略的图景]
>> 把模型分解为组件 -> 找到描述这些组件怎样交互的数学规则。          每个组件都有一些参数，会对整个模型带来什么造成影响。
>> 给每个参数指定值 -> 此时会引入一些错误。                          默认参数
>> 计算答案 -> 只有在最简单的情况下估算才有单一的答案。              关键路径，程序执行阻塞点
>> 追踪你的估算能力 -> [总估算 子估算]                               花一点时间对自己估算出错问题进行剖析
>> 估算项目进度 -> 增量开发(重复) [检查需求 分析风险 设计、实现、集成  向用户确认]

3. 把握问题域的范围。这需要养成在开始猜测之前先思考范围的习惯。
35. 建模把精确性引入了估算过程中，这是不可避免的，而且也是有益的。你是在用模型的简单性与精确性做交易。
    使花在模型上的努力加倍也许只能带来精确性的轻微提高。你的经验将告诉你何时停止提炼。

}

通过代码对进度表进行迭代 [Iterate the Schedule with the Code]
36.  延期不会受到管理部门的欢迎，在典型情况下，他们想要的是单一的、必须遵守的数字 -- 甚至是在项目开始之前。
     你必须帮助他们了解团队、团队的生产率、还有环境将决定进度，通过使其形式化，并把改进进度表作为每次迭代的一部分。
     你将给予他们你所能给予的最精确的进度估算。
37. 在被要求进行估算时说什么："我等会儿回答你".

progmatic(基本工具)
{
1. 如果你没有高超的调试技能，你就不可能成为了不起的程序员。
2. 持久地存储知识的最佳格式是纯文本。    ---- 纯文本并非意味着文本是无结构的：XML，SGML和HTML。
   纯文本给予了自己既能以手工方式，也能以程序方式操作知识的能力，实际上可以随意使用每一样工具。
   保证不过时， 杠杆作用， 更容易测试。
regression test --- 回归测试  
38. 事实上，在一种环境中，纯文本的优点比其所有的缺点都重要。 HTML文档。
}

用纯文本保存知识 [Keep Knowledge in Plain Text]
[缺点]
1. 与压缩的二进制格式相比，存储纯文本所需空间更多。
2. 要解释及处理纯文本文件，计算上的代价可能更昂贵。
[中间点]  --- passwd文件和shadow
用纯文本存储元数据可能是可以接受的。
如果担心数据暴露给系统的用户，可以进行加密。

GUI [what you see is what you get] [what you see is all you get]

利用命令shell的力量 [Use the Power of Command Shells]

39. 源码控制系统(或范围更宽泛的配置管理系统)追踪你在源码和文档中作出的每一项变动。
    源码控制系统SCCS。
    通过SCCS，在每次生成一个发布版本时，你可以在开发树中生成分支。
    你把bug修正加载分支中的代码上，并在主干上继续开发。因为bug修正也可能与主干有关，有些系统允许你把选定的来自分支的变动自动合并回主干中。
进步远非由变化组成，而取决于好记性，不能记住过去的人，背叛重复过去。

总是使用源码控制 [Always Use Source Code Control]

40. 调试就是解决问题，要据此发起进攻。
bug是你的过错
要修正问题，而不是发出指责 [Fix the Problem, Not the Blame]
把时间浪费在设法找出编译器能够为你找到的问题上没有意义！
要总是设法找出问题的根源，而不只是问题的特定表现。(修正bug的同时极有可能引入bug -- 重新测试 -- 自动化测试的优点)



DDD调试器有一些可视化能力，并且可以自由获取。有趣的是，DDD能与多种语言一起工作，包括Ada C C++ Java Perl以及Python。

41. 找到问题的原因的一种非常简单、却又特别有用的技术是向别人解释它。
     bug有可能存在于OS、编译器、或是第三方产品中---但这不应该是你的第一想法。
Select 没有问题 ["select" Is not Broken]
不要假设，要证明 [Do not Assume it, Prove It]

学习一种文本操纵语言 [Learn a Text Manipulation Language]
shell [awk | sed] Python Perl Tcl
编写能编写代码的代码 [Write Code That Writes Code]
代码模板。         vim语言模板
代码生成Makefile。 mmake
lex && yacc        代码生成

progmatic(注重实效的偏执)
{
你不可能写出完美的软件 [You Can not Write Perfect Software]
<软件不可能完美。保护你的代码和用户，使它（他）们免于能够预见的错误。>

按合约设计             [Design By Contract]   客户与供应者必须就权力和责任达成共识。
--- 对立面为考巧合编程 ---
<对在开始之前接受的东西要严格，而允诺返回的东西要尽可能少。记住。如果你的合约表明你将接受任何东西，并允诺返回整个世界，
那你就有大量代码要编写>

继承和多态是面向对象语言的基石，是合约可以真正闪耀的领域！
<子类必须要能通过基类的接口使用，而使用者无须知道其区别！>

与计算机系统打交道很困难，与人打交道更困难。
合约既规定了你的权利与责任，也规定了对方的权力和责任。以外，还有关于任何一方没有遵守合约的后果的约定。
DBC关注的是用文档记载(并约定)软件模块的权利和责任，以确保程序的正确性。
什么是正确的程序？不多不少，做它声明要做的事情的程序。
[方法]
前条件(precondition)。为了调用例程，必须为真的条件；例程的需求。在其前条件被违背时，例程绝不应被调用。传递好数据时调用者的责任
后条件(postcondition)。例程确保会做的事情，例程完成时事件的状态。例程有后条件这一事实意味着他会结束：不允许有无限循环。
类不变项(class invariant)。类确保从调用者的视觉来看，该条件总是真的。在例程的内部处理过程中，不变项不一定会保持，但在例程退出、
控制返回到调用者时，不变项必须为真。


早崩溃 [Crash Early]
<死程序造成的危害通常比有问题的程序要小的多。>

用断言避免不可能发生的事情 [Use Assertions to Prevent the Impossisble]
<断言验证你的各种假定。在一个不确定的世界里，用断言保护你的代码。>

检查每一个可能的错误 --- 特别是意料之外的错误 --- 是一种良好的实践。
异常：异常很少应作为程序的正常流程的一部分使用，异常应保留给以外事件。假定某个未被抓住的异常会终止你的程序，问问你自己：
"如果我移走所有的异常处理器，这些代码是否仍能运行？"如果答案是"否"，那么异常也许就正在被用在非异常的情形中。

将异常用于异常问题 [Use Exceptions for Exceptional Problems]
<异常可能会遭受经典的意大利面条式代码的所有可读性和可维护性问题的折磨。将异常保留给异常的事物。>
异常表示即时的、非局部的控制转移，这是一种级联的goto.

错误处理器是检测到错误时调用的例程。

要有始有终 [Finish What You Start]
<只要可能，分配某资源的例程或对象也应该负责解除其分配。>

嵌套的分配
1. 以与资源的次序相反的次序解除资源的分配。这样，如果一个资源含有对另一个资源的引用，你就不会造成资源被遗弃。
2. 在代码的不同地方分配同一组资源时，总是以相同的次序分配它们。这将降低发生死锁的可能性。
}


progmatic(弯曲，或折断)
{
将模块之间的耦合减至最少 [Minimize Coupling Between Modules]
<通过编写“羞怯的”代码并应用得墨忒耳法则来避免耦合。>


要配置，不要集成 [Configure, Don’t Integrate]
要将应用的各种技术选择实现为配置选项，而不是通过集成或工程方法实现。

将抽象放进代码，细节放进元数据  [Put Abstractions in Code, Details in Metadata]
为一般情况编程，将细节放在被编译的代码库之外。

分析工作流，以改善并发性 [Analyze Workflow to Improve Concurrency]
利用你的用户的工作流中的并发性。

40.用服务进行设计 [Design Using Services]
根据服务——独立的、在良好定义、一致的接口之后的并发对象——进行设计。

41.总是为并发进行设计 [Always Design for Concurrency]
容许并发，你将会设计出更整洁、具有更少假定的接口。

42.视图与模型分离 [Separate Views form Models]
要根据模型和视图设计你的应用，从而以低廉的代码获取灵活性。

43.用黑板协调工作流 [Use Blackboards to Coordinate Workflow]
用黑板协调完成不同的事实和因素，同时又使各参与方保持独立和隔离。

progmatic(当你编码时：不要靠巧合编程)
{
44.不要靠巧合编程 [Don’t Program by Coincidence]
只依靠可靠的事物。注意偶发的复杂性，不要把幸运的巧合与有目的的计划混为一谈。

传统智慧认为，项目一旦进入编码阶段，工作主要就是机械地把设计转换为可执行语句。我们认为
这种态度是很多程序丑陋、低效、结构糟糕、不可维护和完全错误的最大一个原因。

考巧合编程：代码也许能工作，但却没有特别的理由说明它们为何能工作。
            依靠运气和偶然的成功。
实现的偶然；语境的偶然；隐含的假定。

1. 总是意识到你再做什么。Fred让事情慢慢失去了控制，直到最后被煮熟。
2. 不要盲目地编程。试图构建你不完全理解的应用，或是使用不熟悉的技术，就是希望自己被巧合误导。
3. 按照计划行事，不管计划是在你的头脑中，在鸡尾酒餐巾的背面，还是在某个CASE工具生成的墙那么大的输出结果上。
4. 依靠可靠的事物。不要考巧合和假定。如果你无法说出各种特定情形的区别，就假定是最坏的。
5. 为你的假定建立文档。"按合约设计"
6. 不要只是测你的代码，还要测试你的假定。
7. 为你的工作划分优先级。把时间花在重要的方面；很有可能，它们是最难的部分。
8. 不要做历史的努力。不要让已有的代码支配将来的代码。"模块化设计"
}

progmatic(当你编码时：算法的速率)
{
45.估计你的算法的阶 [Estimate the Order of Your Algorithms]
在你编写代码之前，先大致估算事情需要多长时间
注重实效的程序员会设法既考虑理论问题，又考虑实践问题。

O()表示法并非只适用于时间；你可以用它表示算法使用的其他资源。
1. 简单循环   如果某个简单循环从1运行到n，那么算法很可能就是O(n).                                        顺序查找
穷举查找；找到数组中的最大值；生成校验和。
2. 嵌套循环   如果你需要在循环中嵌套另外的循环，那么你的算法就变成了O(m*n),这里的m和n是两个循环的界限。  冒泡排序
冒泡排序
3. 二分法     如果你的算法在每次循环时把事物集合一分为二，那么他很可能是对数型O(log(n)).                 二分查找
二分查找；遍历二叉树；检查机器中的第一个置位的位。
4. 分而治之   划分其输入，并独立地在两个部分上进行处理，然后再把结果组合起来的算法可能是O(nln(n)).       快速排序
快速排序
5. 组合       只要算法考虑事物的排序，其运行时间就有肯能失去控制。 阶乘。
旅行问题；把东西最优地包装进容器中；划分一组数、是每一组都有相同的总和。

46.测试你的估计 [Test your Estimates]
对算法的数学分析并不会告诉你每一件事情。在你的代码的目标环境中测定他的速度。

最好的并非总是最好的算法：程序复杂度和可维护性。
}

progmatic(当你编码时：重构)
{
47.早重构，常重构 [Refactor Early, Refactor Often]
就和你会在花园里除草、并重新布置一样，在需要时对代码进行重写、重做和重新架构。要铲除问题的根源。

代码需要演化；代码不是静态的事物。
重写，重做和重新架构代码合起来，成为重构。
1. 重复，你发现了对DRY原则的违反
2. 非正交的设计。你发现有些代码或设计可以变得更正交
3. 过时的知识。事情变了，需求转移了。你对问题的了解加深了。代码要跟上这些变化
4. 性能，为了改善性能。

    追踪需要重构的事物，如果你不能立刻重构某样东西，就一定要 把它列入计划。
确保受到影响的代码的使用者知道该代码计划要重构。以及这可能会怎么影响他们。
1. 不要试图在重构的同时增加功能。
2. 在开始重构之前，确保你拥有良好的测试。尽可能经常运行这些测试。
    这样，如果你的改动破坏了任何东西，你就能很快知道。
3. 采取短小、深思熟虑的步骤：把某个字段从一个类移往另一个，把两个类似的方法融合进超类中。    
}

progmatic(当你编码时：易于测试的代码)
{
48.为测试而设计 [Design to Test]
在你还没有编写代码时就还是思考测试问题。

单元测试 == 针对合约的测试。
代码是否符合合约，以及合约的含义是否与我们所认为的一样。
我们想要通过广泛的测试用例与边界条件，测试模块是否实现了它允诺的功能。

对于小型项目，你可以把模块的单元测试嵌入在模块自身里。
对于更大的项目，建议你把每个测试放进一个子目录里面。

1. 一些例子，说明怎么样使用你的模块的所有功能。
2. 用于构建回归测试，以验证未来对代码的任何改动是否正确的一种手段。

java代码文档中的main，Python代码文档中的_main_, C/C++中的__TEST__，Shell中的instance.


测试装备：
1. 用以指定设置与清理的标准途径
2. 用以选择个别或所有可用测试的方法。
3. 分析输出是否是预期结构的手段
4. 标准化的故障报告形式
5. 测试应该是可以组合的。

含有跟踪消息的日志文件就是这样一种机制。日志消息也应该正规、一致。

49.测试你的软件，否则你的用户就得测试 [Test Your Software, or Your Users Will]
无情地测试。不要让你的用户为你查找bug。

50.不要使用你不理解的向导代码 [Don’t Use Wizard Code You Don’t Understand]
向导代码可以生成大量代码。在你把它们合并进你的项目之前，确保你理解全部这些代码。

Microsoft VisualC++的wizard向导，会产生向导代码！


}






60.围绕功能，而不是工作职务进行组织 [Organize Around Functionality, Not Job Functions]
只有有用负责的开发者、以及强有力的项目管理时，这种途径才有效。

技术主管：要不断关注大图景，设法找出团队之间任何不必要的、可能降低总体正交性的交叉。 
行政主管：调度各团队所需的各种资源，监视并报告进展情况，并根据商业需求帮助确定各种优先级。

60.围绕功能组织团队 [Organize Teams Around Functionality]
不要把设计师与编码员分开，也不要把测试员与数据建模员分开。按照你构建代码的方式构建团队。

团队质量：在有些团队方法学中有质量官员---团队会把保证产品质量的责任委派给他。这显然是荒谬的：
质量只可能源于全体团队成员都做出自己的贡献。

让某人持续地检查范围的扩大、时间标度的缩减、新增特性、新环境---任何不在最初约定的东西。
对新需求进行持续的度量。团队无需拒绝无法控制的变化---你只需注意到它们正在发生。否则，你就会置身热手中。

创立品牌：能帮助团队作为整体与外界交流。

认为项目的各种活动---分析、设计、编码、测试---会孤立地发生，这是一个错误。

61.不要使用手工流程 [Don’t Use Manual Procedures]
Shell脚本或批文件会一次次地以同一顺序执行同样的指令。
工具构建员：制作makefile,shell脚本，编辑器模板、实用程序，等等！

误导人的信息比完全没有信息更要糟糕！

62.早测试，常测试，自动测试 [Test Early. Test Often. Test Automatically]
与呆在书架上的测试计划相比，每次构建时运行的测试要有效的多。
编一点，测一点。
事实上，好的项目拥有的测试代码可能比产品代码还要多。编写这些测试代码所花费的时间是值得的。
长远来看，他最后会便宜得多，而你实际上有希望制作出接近零缺陷的产品。

63.要通过全部测试，编码才算完成 [Coding didn’t Done Until All the Tests Run]
就是这样。

test(测试)
{
测试什么？单元测试，集成测试，验证和效验，资源耗尽、错误及恢复，性能测试。可用性测试。
1. 单元测试是对某个模块进行演练的代码。
2. 集成测试说明组成项目的主要子系统能工作，并且能很好地协同。
3. 验证和效验：程序可以执行。
4. 资源耗尽、错误及恢复：内存空间，磁盘空间，CPU带宽，挂钟时间，磁盘带宽，网络带宽，调色板，视频分辨率。
5. 性能测试 = 压力测试 = 负载测试
6. 可用性测试：由真正的用户、在真实的条件下进行的测试。
7. 回归测试：把当前测试的输出与先前的值进行比对。

测试数据：现实世界的数据和合成的数据。
现实世界的数据 == 典型的用户数据。
合成数据：你需要大量的数据；你需要能强调边界条件的数据；你需要能展现出特定的统计属性的数据。
}

64.通过“蓄意破坏”测试你的测试 [Use Saboteurs to Test Your Testing]
在单独的软件副本上故意引用bug，以检验测试能够抓住它们。

在你编写了一个测试、用以测试特定的bug时，要故意引发bug，并确定测试会发出提示。
这可以确保测试在bug真的出现时抓住他。


65.测试状态覆盖，而不是代码覆盖 [Test State Coverage, Not Code Coverage]
确定并测试重要的程序状态。只是测试代码行是不够的。

66.一个bug只抓一次 [Find Bugs Once]
一旦测试员找到一个bug，这应该是测试员最后一次找到它。此后自动测试应该对应其进行检查。


67.英语就是一种编程语言 [English is Just a Programming Language]
像你编写代码一样编写文档：遵守DIY原则、使用原数据、MVC、自动生成，等等。

68.把文档建在里面，不要拴在外面 [Build Documentation In, Don’t Bolt It On]
与代码分离的文档不太可能被修整和更新。

    在典型情况下，开发者不会太关注文档。在最好的情况下，它是一件倒霉的差事；在最坏的情况下，
他就会被当做低优先级的任务，希望管理部门会在项目结束时忘掉它！
    注重实效的程序员会把文档当做整个开发过程的完整组成部分加以接受。

注释：我们喜欢看到简单的模块级头注释、关于重要数据与类型声明的注释、以及每个类和每个方法所加的简单注释、
      用以描述函数的用法和任何不明了的事情。
匈牙利命名法： 匈牙利表示法在面向对象系统中绝对不合适。记住，你会 好几百次地阅读代码，但却只编写几次。
花时间拼写出connectionPool，而不要只用cp。
    
69. 温和地超出用户的期望 [Gently Exceed Your Users’ Expectations]
要理解你的用户的期望，然后给他们的东西要多那么一点。
让我想起：《咨询的奥秘》中的表述：让用户感觉到变化在10%以内。


progmatic(交流期望)
{
我们的角色不是控制用户的希望，而是要与他们一同工作，达成对开发过程和最终产品、以及他们尚未描述出来的期望的共同理解。

随着你对他们的需要的理解的发展，你会发现在他们的有些期望无法满足，或是他们的有些期望过于保守。
你的部分角色就是就此进行交流。与你的用户一同工作，以使他们正确地理解你将交付的产品。并且要在
整个开发过程中进行这样的交流。绝不要忘了你的应用要解决的商业问题。

1. 曳光弹
2. 原型与便签
}

progmatic(额外的一英里)
{
1. 气球式帮助或工具提示帮助
2. 快捷键
3. 作为用户手册的补充材料的快速参考指南
4. 彩色化
5. 日志文件分析器
6. 自动化安装
7. 用于检查系统完整性的工具
8. 运行系统的多个版本、以进行培训的能力
9. 为他们的机构定制的splash屏幕
}


70.在你的作品上签名 [Sign Your Work]
过去时代的手工艺人为能在他们的作品上签名而自豪。一夜应该如此。
}

progmatic(在项目开始之前)
{
51.不要搜集需求——挖掘它们 [Don’t Gather Requirements – Dig for Them]
51.1 需求很少存在于表面上。它们深深地埋藏在层层假定、误解和政治手段下面。
51.2 找出用户为何要做特定事情的原因，而不只是他们目前做这件事的方式，这很重要。
51.3 需求：要区分需求(目的)、政策(约束)和实现(形式)之间差别。
     目的是长久不变的；政策是短时间会变的；实现可以是多种形式的。
      需求不是架构。需求不是设计。需求也不是用户界面。需求是需要。
      
52.与用户一同工作，像用户一样思考 [Work with a User to Think Like a User]
要了解系统实际上将如何被使用，这是最好的方法。
避免：规定过度。
Cockburn(用户需求：用例模板)
{
A 特征信息
  目标及其语境
  范围
  级别
  前条件
  成功结束条件
  失败结束条件
  主要参与方
  触发
B 主要成功情境
C 扩展
E 变更
D 相关信息
   优先级
   履行目标
   频度
   上层用例
   下层用例
   主要参与方联系渠道
   协助参与方
   协助参与方联系渠道
F：进度表
G：未解决问题   
}

53.抽象比细节活得更长久 [Abstractions Live Longer than Details]
“投资”于抽象，而不是现实。抽象能在来自不同的现实和新技术的变化的“攻击”之下存活下去。
管理需求增长的关键是向项目出资人指出每项新特性对项目进度的影响。

54.使用项目词汇表 [Use a Project Glossary]
创建并维护项目中使用的专用术语和词汇的单一信息源。

Linux常用词汇与术语大全
55.不要在盒子外面思考——要找到盒子 [Don’t Think Outside the Box – Find the Box]
在遇到不可能解决的问题时，要确定真正的约束。问问你自己：“它必须以这种方式完成吗？它真的必须完成吗？”
很多时候，当你设法回答这些问题时，你会有让自己吃惊的发现。很多时候，对需求的重新诠释能让整个问题完全消失。
你需要的只是真正的约束、令人误解的约束、还有区分它们的智慧。


56.等你准备好在开始 [Start When You’re Ready]
你的一生都在积累经验。不要忽视反复出现的疑虑。

是良好的判断还是拖延？无法确定的时候，开始构建原型吧？厌恶，标明自己有意拖延：有些基本的前提错了，缺乏良好的判断。

57.对有些事情“做”胜于“描述” [Some Things are Better Done than Described]
不要掉进规范的旋涡——在某个时刻，你需要开始编码。
代码规范、开发规范、测试规范。

    作为注重实效的程序员，你应该倾向于把需求收集、设计、以及实现视为同一个过程---交付高质量的系统---的不同方面。
不要信任这样的环境：收集需求、编写规范、然后开始编码，所有这些步骤都是孤立进行的。相反，要设法采用无缝的方法：
规范和实现不过是同一个过程---设法捕捉和编撰需求---的不同方面。每一步都应该直接流入下一步，没有人为制造的界限。
你将会发现，健康的开发过程鼓励把来自实现与测试的意见反馈到规范中。

规范 -> 适中 (构建原型，曳光弹开发)

58.不要做形式方法的奴隶 [Don’t Be a Slave to Formal Methods]
我喜欢形式技术和方法，我相信，盲目把某项技术放进你的开发实践和能力的语境中，不要盲目地采用它。
形式方法(CASE工具，瀑布开发，螺旋模型，Jackson、ER图、Booch云，OMT，Objectory及Coad/Yourdon)的缺点：
1. 大多数形式方法结合图和某些说明文字来捕捉需求。
2. 形式方法似乎鼓励专门化
3. 我们喜欢编写有适应能力的动态系统，使用元数据让我们在运行时改变应用的特征。

绝不要低估采用新工具和新方法的代价。
不要变成方法学的奴隶！

59.昂贵的工具不一定能制作出更好的设计 [Costly Tools Don’t produce Better Designs]
小心供应商的炒作，行业教条、以及价格标签的诱惑。要根据工具的价值判断它们。
}
progmatic(怎样维持正交性)
{
设计独立、良好定义的组建。
使你的代码保持解藕
避免使用全局数据
重构相似的函数
}

progmatic(应制作原型的事物)
{
构架
已有系统的新功能
外部数据的结构或内容
第三方工具或组建
性能问题
用户界面设计
}


progmatic(架构问题)
{
责任是否得到了良好定义？
写作是否得到了良好定义？
耦合是否得以最小化？
你能否确定潜在的重复？
接口定义和各项约束是否可以接受？
模块能否在需要时访问所需数据？
}

progmatic(调试检查清单)
{
正在报告的问题是底层bug的直接结果，还是只是症状？
Bug真的在编译器里？在OS里?或者是在你的代码里？
如果你向同事详细解释这个问题，你会说什么？
如果可以代码通过了单元测试，测试是否足够完整？如果你用该数据单元测试，会发生什么？
造成这个bug的条件是否存在于系统的其他任何地方？
}


progmatic(函数的得墨忒耳法则)
{
某个对象的方法应该值调用属于以下情形的方法：
它自身
传入的任何参数
它创建的对象
组件对象
}

progmatic(怎样深思熟虑地编程)
{
总是意识到你在做什么
不要盲目地编程
按照计划行事
依靠可靠的事物
为你的假定建立文档
不要只是测试你的代码，还要测试你的假定
为你的工作划分优先级
不要做历史的奴隶
}

progmatic(何时进行重构)
{
你发现了对DRY原则的违反
你发现事物可以更为正交
你的知识扩展了
需求演变了
你需要改善性能
}

progmatic(劈开戈尔迪斯结)
{
在解决不可能解决的问题时，问问自己：
有更容易的方法吗？
我是在解决正确的问题吗？
这件事情为什么是一个问题？
是什么使它如此难以解决？
它必须以这种方式完成吗？
它真的必须完成吗？
}

progmatic(测试的各个方面)
{
单元测试
集成测试
验证和校验
资源耗尽、错误及恢复
性能测试
可用性测试
对测试自身进行测试
}

关于个人的修炼

1、保持技术直觉，喜爱尝试并接受新事物
2、保持好奇心，喜欢提问
3、批判的思考者，不要盲从
4、要理解问题的内在本质
5、熟悉广泛的技术并了解你所处的时代和环境
6、说什么和怎么说同样重要
7、不要重复自己
8、关心你掌握的技术
9、思考你从事的工作
10、提供多种解决方案，不要找借口
11、充满热情，影响别人
12、关注全局，做好细节
13、定期为你的知识资产投资，保持学习的习惯
14、等你准备好再开始
15、在你的作品上签名

关于项目研发和管理的修炼

1、当你发现糟糕的设计时，马上修正它们
2、让用户参与确定项目真正的需求
3、让复用变的容易
4、消除无关事物之间的影响
5、不存在最终决策
6、为了学习制作原型（类似在造车之前会做一个1:1的模型车）
7、学习估算工作量
8、用好一种编辑器（专精一种绘画软件）
9、解决问题，而不是指责
10、不要假定，要证明
11、你不可能写出完美的软件（没有完美的画）
12、为并发进行设计
13、像用户一样思考
14、围绕功能组建团队
15、一个bug只抓一次
16、温和的超出用户期望 
