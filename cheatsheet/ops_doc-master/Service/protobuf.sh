主要用于“数据存储、传输协议格式”等场合。
1. 性能好/效率高
    先说时间开销：XML 格式化（序列化）的开销倒还好；但是 XML 解析（反序列化）的开销就不敢恭维啦。
俺之前经常碰到一些时间性能很敏感的场合，由于不堪忍受 XML 解析的速度，弃之如敝履。
    再来看空间开销：熟悉 XML 语法的同学应该知道，XML 格式为了有较好的可读性，引入了一些冗余的文本信息。
所以空间开销也不是太好（不过这点缺点，俺不常碰到）。
2. 代码生成机制
除了性能好，“代码生成机制”是主要吸引俺的地方。
如果使用 protobuf 实现，首先要写一个 proto 文件（不妨叫 Order.proto），在该文件中添加一个名为 Order 的 message 结构，用来描述通讯协议中的结构化数据。该文件的内容大致如下：
message Order
{
    required int32 time = 1;
    required int32 userid = 2;
    required float price = 3;
    optional string desc = 4;
}

　　然后，使用 protobuf 内置的编译器【编译】该proto。由于本例子的模块是 C++，你可以通过 protobuf 编译器的命令行参数（看“这里”），指定它生成 C++ 语言的“订单包装类”。（一般来说，一个 message 结构会生成一个包装类）
　　然后你使用类似下面的代码来序列化/解析该订单包装类：

发送方代码示例
Order order;
order.set_time(XXXX);
order.set_userid(123);
order.set_price(100.0f);
order.set_desc("a test order");

string sOrder;
order.SerailzeToString(&sOrder);
// 然后调用某种 socket 通讯库把序列化之后的字符串发送出去
// ......

接收方代码示例
string sOrder;
// 先通过网络通讯库接收到数据，存放到某字符串 sOrder
// ......

Order order;
if(order.ParseFromString(sOrder))  // 解析该字符串
{
#    cout << "userid:" << order.userid() << endl
#         << "desc:" << order.desc() << endl;
}
else
{
#   cerr << "parse error!" << endl;
}
万一将来需求发生变更，要求给订单再增加一个“状态”的属性，那只需要在 Order.proto 文件中增加一行代码。对于发送方（模块 A），只要增加一行设置状态的代码；对于接收方（模块 B）只要增加一行读取状态的代码。哇塞，简直太轻松了！
　　另外，如果通讯双方使用不同的编程语言来实现，使用这种机制可以有效确保两边的模块对于协议的处理是一致的。
　　顺便跑题一下。
　　从某种意义上讲，可以把 proto 文件看成是描述通讯协议的规格说明书（或者叫接口规范）。这种伎俩其实老早就有了，搞过微软的 COM 编程或者接触过 CORBA 的同学，应该都能从中看到 IDL 的影子。它们的思想是相通滴。

3. 支持“向后兼容”和“向前兼容”
    当你维护一个很庞大的分布式系统时，由于你无法【同时】升级【所有】模块，为了保证在升级过程中，整个系统不受影响
（继续运转），就需要尽量保证通讯协议的“向后兼容”或“向前兼容”。
4. 支持多种编程语言
    俺开博以来点评的几个开源项目（比如“Sqlite”、“cURL”），都是支持【多种编程语言】滴，这次的 protobuf 也不
 例外。在 Google 官方发布的源代码中包含了 C++、Java、Python 三种语言（正好也是俺最常用的三种，真爽）。如果你
 平时用的就是这三种语言之一，那就好办了。

 protobuf 有啥缺陷？
 ◇应用不够广
 ◇二进制格式导致可读性差
 ◇缺乏自描述
 ★为什么俺会选用 protobuf？