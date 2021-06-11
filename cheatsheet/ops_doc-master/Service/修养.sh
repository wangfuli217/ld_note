
hold (主流程序员的自我修养)
{


工作也有一段时间了，无论是亲身实践还是观察他人，或多或少能意识到怎么样才是一个『好』的工程师。本文是我的一点思考。

在美国的时候，教授常常跟我说，engineering 和 engineer 在大家看来是特别神圣的词，因为这意味着他们做的事情和他们本身，都是为了解决问题而存在的。而在开源运动风风火火的今天，写代码其实只是工程师应该具备的能力的一小部分。还有很多代码之外的东西，需要去学习和实践。

调试是最基本的技能之一，IDE 是如此强大，搞得很多人以为调试就是设个断点或者输出一下值，但其实并不是这样的，或者说，这不是问题的核心。那么问题的核心是什么？

掌控

通过断点或输出来分离代码确定错误点，然后进行修复。这里一定要弄清楚是因为程序员的无心之失导致的错误，还是因为系统设计的模糊性导致的实现不一致。前者只牵一发，后者要动全身。而对于需要 7x24 运行的服务来说，对于服务质量的掌控，很多时候是通过日志实现的。日志这个是个大话题，通过汇总线上的各类数据，可以确定重点代码进行重点优化，尤其是在计算资源或者带宽资源吃紧的时候，从数据出发才是有的放矢。一般来说需要注意两个地方，一是 IO，二是资源共享。

IO 部分的优化通常是要么是利用缓存，尽量一次多做一点事情，要么是减少数据的传输量，不过这个无形之中增加了设计的复杂度，具体使用的时候需要权衡。资源共享部分涉及某种确定资源使用的机制，比方说锁或者信号量之类的，这部分本身就是很难的，比较好的办法是设计时就尽量隔离，不要过分依赖于资源共享。

另一个增加掌控的方法是写文档，文档可以看作是在时间尺度上的掌控，因为认真写文档的代码，即使过几年再看，也很容易跟上当时的思路，否则就容易迷失在茫茫跳转中。而面对糟糕的代码，文档其实也是很好的重构工具，尤其是在测试紧缺的情况下，通过文字辅助理解可能是最为保险的选择。

关于团队其实是另一个话题，不过说到底原则其实很简单：把自己手头上的事情用心做好，并以此带动同事，成为值得信任的人，才有可能赢得信任。今天看女排赛后采访，听郎平说了两个词『承担』和『包容』，的的确确是成为顶梁柱所必备的素质。

工程师应该把时间花在关键问题上，无聊且机械化的事情，哪怕第一次可能会比较麻烦，必须要交给机器来做。所谓关键问题，就是那些能真正创造价值，或者能让创造价值的过程更好的问题。更重要的是，要让提供资源的人能够意识到解决这些问题的价值。

不过话说回来，掌控也需要一个度，也要容忍一定的黑盒，总不能啥都重新发明一次轮子吧。所谓『掌控』，不是啥都亲力亲为，最后累得死去活来还不一定能达到效果，而是找到关键点，用最少的成本来达到自己想要的效果。

没错，我说的就是《永恒的终结》。观测师和程序员其实挺像的，而我也一定会像小说中那样，愿意为自己珍惜的东西，拼尽一切。

}

    