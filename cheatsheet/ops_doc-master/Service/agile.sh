
https://www.cnblogs.com/timxgb/p/4091012.html
https://blog.csdn.net/libing403/article/details/72904713

软件开发一直处于动态、不断变化的环境中。所以软件开发过程无法预知,充满风险,具有挑战性。即开发软件不是个确定的,线性的过程。

越早发现问题，就越容易修复问题。
小步规划、小步前进、小步修正，只要持续这个循环过程，就能积小步以至千里。
为了节省项目的时间而走愚蠢的捷径是会付出巨大代价的。
敏捷依赖人，而不是依赖项目的甘特图和里程表。

你若不想做，会找到一个借口。你若想做，会找到一个方法

    最大的问题在于只有很少的团队真正在使用敏捷方法开发。很多团队采用了几种"敏捷"的方法，并从中得到一些益处，
但是这和真正的敏捷实践相差甚远。有一个很危险的误解，有人认为"遵从敏捷方法"或者"做敏捷"是和真正的敏捷是一样的事儿。
事实远非如此。
Practices(实践论){
"敏捷开发" 方法论 -> "敏捷开发" 实践论
  过程符合标准并不意味结果正确的。敏捷团队重结果胜过重过程。
  
1. 敏捷开发是在一个高度协作的环境中，不断地使用反馈进行自我调整和完善。
   一个把以人为本、团队合作、快速响应变化和可工作的软件为宗旨的开发方法。

敏捷开发的要求：
   敏捷要求团队中的每一个人(包括与团队合作的人)都具备职业精神，并积极地期望项目能够
获得成功。敏捷不要求所有人都是有经验的专业人员，但必须具有专业的工作态度 -- 每个人都希望
最大可能做好自己的工作。 -> 旷工、偷懒、怠工 (不包括迟到和早退: 专业的工作态度)

敏捷：不会在项目结束的时候才开始测试；
      不会在月底才进行一次系统集成
      不会在一开始编码的时候就停止收集需求和反馈

敏捷开发的平衡艺术
2. 敏捷的目的是快速适应变化：需求变化，人员变化，意想不到的设计失败；如果项目需求
   明确，人员稳定，多数框架成熟，瀑布模型也许更好。
}

a. 关注团队工作情景，态度即情景
Practices(态度决定一切:做事){ 指责不能修复bug : blame does not fix bugs
出了问题，大家的重点是做事。你应该把重点放在解决问题上，而不是在指责犯错者上面纠缠。
指责不会修复bug。把矛头对准问题的解决方法，而不是人，这是真正有用处的正面效应。

切身感受
  1. 勇于承认自己不知道的答案，这会让人感觉放心。
  2. 一个重大的错误应该被当作是一次学习而不是指责他人的机会。
  3. 团队成员们在一起工作，应互相帮助，而不是互相指责。

平衡的艺术
  1. "这不是我的错",这句话不对."这就是你的错",这句话更不对.
  2. 如果你没有犯过任何错误,就说明你可能没有努力去工作.
  3. 开发者和质量工程师(QA)争论某个问题是系统本身的缺陷还是系统增强功能导致的,通常没有多大的意义.与其如此,不如赶紧去修复它.
  4. 如果一个团队成员误解了一个需求、一个API调用,或者最近一次会议做的决策,那么,也许就以为这团队的其他成员也有相同的误解.
     要确保整个团队尽快消除误解.
  5. 如果一个团队成员的行为一再伤害了团队,则他表现得很不职业.那么他就不是在帮助团队向解决问题的方向前进.这种情况下,我们必须
      要求他离开这个团队.(不需要解雇他,但是他不能继续留在这个项目中.同时也要意识到,频繁的人员变动对整个团队的平衡也很危险)
}
Practices(态度决定一切:欲速则不达){
一次又一次的快速修复，每一次都不探究问题的根源，久而久之就形成了一个危险的沼泽地，最终会吞噬整个项目的生命。
不要坠入快速的简单修复之中.要投入时间和精力保持代码的整洁、敞亮。

平衡的艺术
  1. 你必须要理解一块代码是如何工作的,但是不一定需要成为一位专家.只要你能使用它进行有效的工作就足够了,不需要把它当作毕业生事业.
  2. 如果有一位团队成员宣布,有一块代码其他人都很难看懂,这就意味着任何人(包括原作者)都很难维护它.请让它变得简单些.
  3. 不要急于修复一段没能真正理解的代码.这种+1/-1的病症始于无形,但是很快就会让代码一团糟.要解决真正的问题,不要治标不治本.
  4. 所有的大型系统都非常复杂,因此没有一个人能完全明白所有的代码.除了深入了解你正在开发的那部分代码之外,你还需要从更高的层面来
     了解大部分代码的功能,这样就可以理解系统各个功能块之间都是如何交互的.
}
Practices(态度决定一切:对事不对人){
  1. 否定个人能力。
  2. 指出明显的缺点，并否定其观点。
  3. 询问你的队友，并提出你的顾虑。
  
  你不需要很出色才能起步，但是你必须起步才能变得出色。 ---- 虚心接受别人的批评
  能欣赏自己并不接受的想法，表明你的头脑足够有学识。   ---- 亚里斯多德
  
  设定最终期限: 没有最好的答案，只有更适合的方案。设定期限能够帮你在为难的时候果断做出决策，让工作可以继续进行。
  逆向思维    : 先是积极地看到他的正面，然后再努力地从反面去认识他。目的是要找出优点最多缺点最少的那个方案
  设立仲裁人  : 仲裁人的责任就是确保每个人都有发言的机会，并维持会议的正常进行。仲裁人可以防止明星员工操作会议，并及时打断假大空式发言。
  支持已经做出决定: 我们的目标是让项目成功满足用户需求。 客户并不关心是谁的注意----他们关心的是，这个软件是否可以工作，并且是否符合他们的期望。结果最重要。

平衡的艺术
  1. 经历贡献自己的好想法，如果你的想法没有被采纳也无需生气。不要因为只是想体现自己的想法而对拟定的好思路画蛇添足。
  2. 脱离实际的反观点会使争论变味。若对一个想法有成见，你很容易提出一堆不太可能发生或者不太实际的情形去批驳它。
     这时，清先扪心自问：类似问题以前发生过吗？是否经常发生？
  3. 也就是说，像这样说是不够的：我们不能采用这个方案，因为数据库厂商可能会倒闭。或者：用户绝对不会接受那个方案。你必须要评判
     那些场景发生的可能性有多大。想要支持或者反驳一个观点，有时候你必须先做一个原型或者调查出它有多少的同意者或者反对者。
  4. 只有更好，没有最好。尽管"最佳实践"这个术语到处在用，但实际上不存在"最佳"，只有在某个特定条件下更好的实践、
  5. 不带个人情绪并不是要盲目地接受所有的观点。用合适的词和理由去解释为什么你不赞同这个观点或方案，并提出明确的问题。
}

Practices(态度决定一切:排除万难，奋勇前进){
  复制代码是不负责的表现，因为复制，增加了维护成本
  重用代码是负责的表现，因为重用减少了维护成本
  需求明确，代码模块化可测试是重写(重构)的基础

平衡的艺术
  1. 如果你说天快要塌下来了，但其他团队成员都不赞同。反思一下，也许你是正确的，但你没有解释清楚自己的理由。
  2. 如果你说天快要塌下来了，但其他团队成员都不赞同。认真考虑一下，他们也许是对的。
  3. 如果设计或代码中出现了奇怪的问题，花时间去理解为什么代码会是这样的。
     如果你找到了解决的办法，但代码仍然另人费解，唯一的解决办法就是重构代码，让他可读性更强。
     如果你没有马上理解那段代码，不要轻易的否定和重写他们。那不是勇气，而是鲁莽。
  4. 当你勇敢站出来提问时，如果收到了缺乏背景知识的抉择者的抵制，你需要用他们能够听懂的话语表达。"更清晰的代码"是无法打动生意人的。
     节约资金、获取更好的投资回报，避免诉讼以及增加用户利益，会让论点更具说服力。
  5. 如果你在压力下要对代码质量做出妥协，你可以指出，作为一名开发者，你没有职权毁坏公司的资产(所有的代码)。
}

b. 保持学习是个人和团队实现成长和稳定的基石
Practices(学无止境:跟踪变化){
  即使你已经在正确的轨道上，但如果只是停止不前，也仍然会被淘汰出局。
  唯有变化是永恒的。
  
  迭代和增量式学习: 
  了解最新行情:
  参加本地的用户组活动：
  参加研讨会议:
  如饥似渴的阅读：
  
  你需要一直处于学习状态。哪怕最后你用不上这门技术，你学到的每样东西都在告诉你一些其他方向的知识和建议，所以没有任何学习是白费的。
  
平衡的技术
1. 许多新想法从末变得羽翼丰满，成为有用的技术。即使是大型，热门和资金充裕的项目，也会有同样的下场。你要正确把握资金投入的精力。
2. 你不可能精通每一项技术，没有必要去做这样的尝试。只要你在某些方面成为专家，就能使用同样的方法，很容易地成为新领域的专家。
3. 你要明白为什么需要这项新技术 ---- 它视图解决什么样的问题？它可以被用在什么地方？
4. 避免在一时冲动的情况下，只是因为想学习而将应用切换到新的技术，框架或者开发语言。在做决策之前，你必须评估新技术的优势。
   开发一个小的原型系统，是对付技术狂热者的一剂良药。
}
Practices(学无止境:对团队投资){
午餐会议；主持讲座
平衡的艺术
1. 读书小组逐章一起阅读一本书，会非常有用，但是要选好书。《7天用设计模式和UML精通》也许不会是一本好书。
2. 不是所有的讲座都能引人入胜，有些甚至显得很不合时宜。不管怎么样，都要未雨绸缪；诺亚在建造方舟的时候，可并没有开始下雨，谁能料到后来洪水泛滥呢？
3. 尽量让讲座走入团队中。如果午餐会议在礼堂中进行，有餐饮公司供饭，还要使用幻灯片，那么就会减少大家接触和讨论的机会。
4. 坚持有计划有规律地举行讲座。持续、小步前进才是敏捷。稀少、间隔时间长的马拉松式会议非敏捷也。
5. 如果一些团队成员因为吃午饭而缺席，用美食引诱他们。
6. 不要局限于纯技术的图书和主题，相关的非技术主题(项目估算、沟通技巧等)也会对团队有帮助。
7. 午餐会议不是设计会议。总之，你赢专注讨论那些与应用相关的一般主题。具体的设计问题，最好是留到设计会议中去解决。
}
Practices(学无止境:懂得丢失){
切身感受
    新技术会让人感到有一点恐惧。你确实需要学习很多东西。已有的技能和习惯为你打下很好的基础，但不能依赖它们。
平衡的艺术
    沉舟侧畔千帆过，病树前头万木春。要果断丢弃旧习惯，一味遵循过时的旧习惯会危害你的职业生涯。
    不是完全忘记旧的习惯，而是只在使用适当的技术时才使用它。
    对于所使用的语言，要总结熟悉的语言特性，并且比较这些特性在新语言或新版本中有什么不同。
}
Practices(学无止境:打破砂锅问到底){
为什么呀？不停的问为什么。不能只满足于别人告诉你的表面现象，要不停地提问知道你明白问题的根源。
平衡的艺术
  你可能会跑题，问了一些与主题无关的问题。就好比是，如果汽车启动了，你问是不是轮胎出了问题，就是没有任何帮助的。问"为什么"，但是要问道点子上。
  当你问"为什么"的时候，也许你会被反问："为什么你问这个问题？"在提问之前，想好你提问的理由，这会有助于你问出恰当的问题。
  "这个，我不知道"是一个好的起点，应该由此进行更进一步的调查。而不是在此戛然结束。
}
Practices(学无止境:把握开发节奏){

}
Practices(时间盒){

}

c. 避免软件开发过程中风险 -> 交付用户想要的软件
Practices(交付用户想要的软件:让客户决定){
  没有任何计划在遇敌后还能继续执行。我们的敌人不是客户，不是用户，不是队友，也不是管理者。真正的敌人是变化。
  软件开发如战争，形势的变化快速而又剧烈。固守昨天的计划而无视环境的变化会带来灾难。你不可能"战胜"变化
   ---- 无论它是设计、架构还是你对需求的理解。
   
   如何让设计指导而不是操纵开发。
   固定的价格就意味着背叛承诺。

平衡的艺术
  1. 记录客户做出的决定，并注明原因。好记性不如烂笔头。可以使用工程师的工作日记或日志、Wiki、邮件记录或者问题跟踪数据库。
但是也要注意，你选择的记录方法不能太笨重或者太繁琐。
  2. 不要用低级别和没有价值的问题打扰繁忙的业务人员。如果问题对他们的业务没有影响，就应该是没有价值的。
  3. 不要随意假设低级别的问题不会影响他们的业务。如果能影响他们的业务，就是有价值的问题。
  4. 如果业务负责人回答"我不知道"，这也是一个称心如意的答案。也许是他们还没有想到那么远，也许是他们只有看到运行的实物
才能评估出结果。尽你所能为他们提供建议，实现代码的时候也要考虑可能出现的变化。
}
Practices(交付用户想要的软件:让设计指导而不是操纵开发){
  严格的需求-设计-代码-测试开发流程源于理想化的瀑布式开发方法。
  设计可以分为两层：战略和战术，前期的设计属于战略，通常只有在没有深入理解需求的时候需要这样的设计。
更确切地说，它应该只描述总体战略不应深入到具体的细节。
  战略级别的设计不应该具体说明程序方法、参数、字段和对象交互精确顺序的细节。那应该留到战术设计阶段，它应该
在项目开发的时候再具体展开。
  良好战略设计应该扮演地图的角色，指引你向正确的方向前进。任何设计仅是一个起跑点：它就像你的代码一样，在项目的生命周期中，
会不停地进一步发展和提炼。
  战略级别的设计:如何设计类的职责，CRC(类-职责-协作)卡片的设计方法就是用来做这个事情的，每个类按照下面的术语描述。
1. 类名。
2. 职责：它应该做什么？
3. 协作者：要完成工作它要与其他什么对象一起工作？

切身感受
    好的设计应该是正确的，而不是精确的。也就是说，它描述的一切必须是正确的，不应该涉及不确定或者可能会发生变化的细节。
它是目标，不是具体的处方。

平衡的艺术
  "不要在前期做大量的设计"并不是说不要设计。只是说在没有经过真正的代码验证之前，不要陷入太多的设计任务。当对设计一无所知的时候，
投入编码也是意见危险的事。如果深入编码只是为了学习或创造原型，只要你随后能把这些代码扔掉，那也是一个不错的办法。
  即使初始的设计到后面不再管用，你仍需设计：设计行为是无价的。正如美国总统艾森豪威尔所说："计划是没有价值的，但计划的过程是必不可少的。"
在设计过程中学习是有价值的，但设计本身也许没有太大的用处。
  白板、草图、便利贴都是非常好的设计工具。复杂的建模工具只会让你分散精力，而不是启发你的工作。
}
Practices(交付用户想要的软件:合理地使用技术){
1. 这个技术框架真能解决这个问题吗？
2. 你将会被它拴住吗？
3. 维护成本是多少？会不会随着时间的推移，它的维护成本会非常昂贵？

你的代码写得越少，需要维护的东西就越少。
切身感受
    新技术就应该像是新的工具，可以帮助你更好地工作，它自己不应该成为你的工作。
平衡的艺术
  或许在项目中真正评估技术方案还为时太早。那就好。如果你在做系统原型并要演示给客户看，或许一个简单的散列表就可以代替数据库了。
如果你还没有足够的经验，不要急于决定用什么技术。
  每一门技术都会有优点和缺点，无论它是开源的还是商业产品、框架、工具或者语言，一定要清楚它的利弊。
  不要开发那些你容易下载到的东西。虽然有时需要从最基础开发所有你需要的东西，但那是相当危险和昂贵的。
}
Practices(交付用户想要的软件:保持可以发布){
1. 为数据库的表结构、外部文件，甚至引用它的API提供版本支持，这样所有相关变化都可以进行测试。
2. 你也可以在版本控制系统中添加一个分支，专门处理这个问题。
平衡的艺术
  有时候，做一些大地改动后，你无法花费太多的时间和精力去保证系统一直可以发布。如果总共需要一个月的时间才能保证它一周内可以发布，
那就算了。但这只应该是例外，不能养成习惯。
  如果你不得不让系统长期不可以发布，那就做一个(代码和框架的)分支版本，你可以继续进行自己的实验，如果不行，还可以撤销，从头再来。
千万不能让系统既不可以发布，又不可以撤销。
}
Practices(交付用户想要的软件:提早集成,频繁集成){
1. 在产品开发过程中,集成是一个主要的风险区域,让你的子系统不停的增长,不去做系统集成,就等于把自己置于越来越大的风险中.
2. 提早集成.频繁集成.代码集成是主要的风险来源.要想规避这个风险.只有提早集成.持续而有规律地进行集成.
3. 如果你真正做对了.集成就不再会是一个繁重的任务.它只是编写代码周期中的一部分.集成时产生的问题.都会是小问题并且容易解决.
平衡的艺术
  成功的集成就意味着所有的单元测试不停地通过.正如医学院界希波克拉底的誓言:首先,不要造成伤害.
  通常,每天要和同队其他成员以前集成代码好几次,比如平均每天5~10次,甚至更多.但如果你每次修改一行代码就集成一次,
那效用肯定会缩水.如果你发现自己的大部分时间都在集成,而不是写代码,那你一定是集成得过于频繁.
  如果你集成得不够频繁(比如,你一天集成一次,一周一次,甚至更糟),也许就会发现整天在解决代码集成带来的问题.
而不是在专心写代码.如果你集成的问题很大.那一定是做得不够频繁.
  对那些原型和实验代码,也许你想要独立开发,而不要想在集成上浪费时间.但是不能独立开发太长的时间.一旦你有了经验.就要快速地开始集成.
}
Practices(交付用户想要的软件:提早实现自动化部署){
1. 这些工作都应该是无形的。系统的安装或者部署应该简单，可靠及可重复。一切都很自然。
2. 确保他们能提前告诉你运行的软件版本，避免出现混乱。

平衡的艺术
    1. 一般产品在安装的时候，都需要有相应的软，硬件的环境。比如，Java或Ruby的某个版本，外部数据库或者操作系统。
这些环境的不同很可能会导致很多技术支持的电话。所以检查这些依赖关系，也是安装过程的一部分。
    2. 在没有询问并征的用户的同意之前，安装程序绝对不能删除用户的数据。
    3. 部署一个紧急修复的bug应该很简单，特别是在生产服务器的环境中。你知道这会发生，而且你不想在压力之下，在凌晨3点半，你还在手工部署系统。
    4. 用户应该可以安全并且完整的卸载安装程序，特别是在质量保证人员的机器环境中。
    5. 如果维护安装脚本变得很困难，那很可能是一个早期的警告，预示着 ---- 很高的维护成本(或者不好的设计决策)
    6. 如果你打算把持续部署系统和产品CD或者DVD刻录机连接到一起，你就可以自动的为每个构建制作出一个完整且有标签的光盘。
任何人想要最新的构建，只要从架子上拿最上面的一张光盘安装即可。
}
Practices(维护项目术语表){
    不一致的术语是导致需求误解的一个主要原因。企业喜欢用看似普通浅显的词语来表达非常具体、深刻的意义。
    在项目的开发过程中，从术语表中为程序结构 ---- 类、方法、模型、变量等选择合适的名字，并且要检查和确保这些定义
一直符合用户的期望。
}
Practices(问题跟踪){
    随着项目的进展，你会得到很多反馈 --- 修正、建议、变更要求、功能增强、bug修复等。
要住的信息很多。随机的邮件和潦草的告示贴是无法应付的。所以要有一个跟踪系统记录所有这些
日志，可能是用Web界面的系统。 <软件项目成功之道>
}

Practices(交付用户想要的软件:使用演示获得频繁反馈){
1. 作为人类，不管是什么事情，我们都能越做越好，不过是以缓慢而逐步的方式。
2. 清晰可见的开发。在开发的时候，要保持应有可见(而且客户心中也要了解)。每隔一周或者两周，邀请所有的客户，给他们演示最新完成的功能，
积极获得他们的反馈。
3. 演示是用来让客户提出反馈，有助于驾驭项目的方向。

    当你第一次试图用这种方法和客户一起工作的时候，也许他们被这么多的发布吓到了。所以，要让他们知道，这些都是内部的发布(演示)，
是为了他们自己的利益，不需要发布给全部的最终用户。
    一些客户，也许会觉得没有时间应付每天、每周甚至一个月一次会议，那么就定一个月。
    一些客户的联络人的全职工作就是参加演示会议。他们巴不得每隔1个小时就有一次演示和反馈。你会发现这么频繁的会议很难应付，
而且还要开发代码让他们看。缩减次数，只有在你做完一些东西可以给他们演示的时候，大家才碰面。定性的时候，不应该拿来演示，
那只能让人生气。可以及早说明期望的功能：让客户知道，他们看到的是一个正在开发中的应用，而不是一个最终已经完成的产品。
}
Practices(交付用户想要的软件:使用短迭代，增量发布){
1. 迭代开发是，在小且重复的周期里，你完成各种开发任务：分析、设计、实现、测试和获得反馈，所以叫做迭代。
2. 软件开发不是精细的制造业，而是创新活动。规划几年之后客户才能真正使用的项目注定是行不通的。
平衡的艺术
    关于迭代时间长短一直是一个有争议的问题。Andy曾经遇到这样一位客户：他们坚持认为迭代就是4周的时间，因为这是他们学到的。
但他们的团队却因为这样的步伐而垂死挣扎，因为他们无法在开发新的代码的同时又要维护很多已经完成了的代码。解决方案是，
在每4周的迭代中间安排一周的维护任务。没有规定说迭代必须要紧挨着下一个迭代。
    如果每个迭代的时间都不够用，要么是任务太大，要么是迭代的时间太长了。用户的需要、技术和我们对需求的理解，都会随着时间
的推移而变化，在项目发布的时候，需要清楚地反映出这些变化。如果你发现自己工作时还带有过时的观点和陈腐的想法，那么很可能你
等待太长时间做调整了。
    增量的发布必须是可用的，并且能为用户提供价值。你怎么知道用户会觉得有价值呢？这当然要去问用户。
}
Practices(交付用户想要的软件:固定的价格就意味着背叛承诺){
1. 固定的价格就是保证要背叛承诺： A  fiaed  price  guarantees a  broken promise

}

Project(软件项目成功之道){ 西方经典的方法论：基础设施（工具）+技术和过程（方法）。
基础设施（版本控制->自动化构建-> 测试框架->持续集成+跟踪列表），
技术（任务清单+技术领导人+每日例会+代码审查+变更通知） ，
过程（曳光弹），常见问题与解决方案。
}
Management(项目管理修炼之道){ https://www.jianshu.com/p/6e9de3d1de2b
了解和尊重项目相关的工作人员。33 人
首先，要写下客户的期望——从客户的角度来看，项目的驱动因素是什么［Rot98］。这个列表中应该包括：客户想要什么（功能集合），他们期望何时收到交付物（发布时间），可交付物的质量如何（缺陷等级）［Gra92］。12 人
项目经理负责管理风险和资源11 人
理想状况下，关键驱动因素应该只有一个，约束应该只有一个，而浮动因素可以有四个。11 人
产品：项目产生的一系列可交付物。10 人
项目：一个独特的任务或是系统化的流程，其目的是创建新的产品或服务，产品和服务交付完成标志着项目的结束。项目都有风险，并且受制于有限的资源。9 人
风险管理是项目管理的重心，这一点是我多年项目管理工作的心得。8 人
项目经理：负责向团队清晰说明完成的含义，并带领团队完成项目的人。完成，是指产品符合组织对这个产品的要求，也能满足客户使用这个产品的需要。8 人
规划和日程安排是两种不同的活动。规划是指制订带有发布条件的项目计划，而日程安排则是对工作项目的有序描述。7 人
□项目要怎么样才算成功？□为什么想得到这样的结果？□这种解决方案对你来说价值何在？□这个系统要解决什么样的问题？□这个系统可能会造成什么样的问题？6 
}

