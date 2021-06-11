ApacheBench(){

    网站性能压力测试是性能调优过程中必不可少的一环。只有让服务器处在高压情况下
才能真正体现出各种设置所暴露的问题。Apache中有个自带的，名为ab的程序，可以对
Apache或其它类型的服务器进行网站访问压力测试。

ApacheBench命令原理：

    ab命令会创建很多的并发访问线程，模拟多个访问者同时对某一URL地址进行访问。它的
测试目标是基于URL的，因此，既可以用来测试Apache的负载压力，也可以测试nginx、
lighthttp、tomcat、IIS等其它Web服务器的压力。

    ab命令对发出负载的计算机要求很低，既不会占用很高CPU，也不会占用很多内存，但却会
给目标服务器造成巨大的负载，其原理类似CC攻击。自己测试使用也须注意，否则一次上太多的
负载，可能造成目标服务器因资源耗完，严重时甚至导致死机。

格式：ab [options] [http://]hostname[:port]/path
参数说明：
-n requests Number of requests to perform
//在测试会话中所执行的请求个数（本次测试总共要访问页面的次数）。默认时，仅执行一个请求。
-c concurrency Number of multiple requests to make
//一次产生的请求个数（并发数）。默认是一次一个。
-t timelimit Seconds to max. wait for responses
//测试所进行的最大秒数。其内部隐含值是-n 50000。它可以使对服务器的测试限制在一个固定的总时间以内。默认时，没有时间限制。
-p postfile File containing data to POST
//包含了需要POST的数据的文件，文件格式如“p1=1&p2=2”.使用方法是 -p 111.txt 。 （配合-T）
-T content-type Content-type header for POSTing
//POST数据所使用的Content-type头信息，如 -T “application/x-www-form-urlencoded” 。 （配合-p）
-v verbosity How much troubleshooting info to print
//设置显示信息的详细程度 – 4或更大值会显示头信息， 3或更大值可以显示响应代码(404, 200等), 2或更大值可以显示警告和其他信息。 -V 显示版本号并退出。
-w Print out results in HTML tables
//以HTML表的格式输出结果。默认时，它是白色背景的两列宽度的一张表。
-i Use HEAD instead of GET
// 执行HEAD请求，而不是GET。
-x attributes String to insert as table attributes
-y attributes String to insert as tr attributes
-z attributes String to insert as td or th attributes
-C attribute Add cookie, eg. -C “c1=1234,c2=2,c3=3″ (repeatable)
//-C cookie-name=value 对请求附加一个Cookie:行。 其典型形式是name=value的一个参数对。此参数可以重复，用逗号分割。
提示：可以借助session实现原理传递 JSESSIONID参数， 实现保持会话的功能，如
-C ” c1=1234,c2=2,c3=3, JSESSIONID=FF056CD16DA9D71CB131C1D56F0319F8″ 。
-H attribute Add Arbitrary header line, eg. ‘Accept-Encoding: gzip’ Inserted after all normal header lines. (repeatable)
-A attribute Add Basic WWW Authentication, the attributes
are a colon separated username and password.
-P attribute Add Basic Proxy Authentication, the attributes
are a colon separated username and password.
//-P proxy-auth-username:password 对一个中转代理提供BASIC认证信任。用户名和密码由一个:隔开，并以base64编码形式发送。无论服务器是否需要(即, 是否发送了401认证需求代码)，此字符串都会被发送。
-X proxy:port Proxyserver and port number to use
-V Print version number and exit
-k Use HTTP KeepAlive feature
-d Do not show percentiles served table.
-S Do not show confidence estimators and warnings.
-g filename Output collected data to gnuplot format file.
-e filename Output CSV file with percentages served
-h Display usage information (this message)
//-attributes 设置属性的字符串. 缺陷程序中有各种静态声明的固定长度的缓冲区。另外，对命令行参数、服务器的响应头和其他外部输入的解析也很简单，这可能会有不良后果。它没有完整地实现 HTTP/1.x; 仅接受某些’预想’的响应格式。 strstr(3)的频繁使用可能会带来性能问题，即你可能是在测试ab而不是服务器的性能。

参数很多，一般我们用 -c 和 -n 参数就可以了。例如:

# ab -c 5000 -n 600 http://127.0.0.1/index.php
在Linux系统，一般安装好Apache后可以直接执行；
# ab -n 4000 -c 1000 http://www.ha97.com/

    This is ApacheBench, Version 2.3
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking 192.168.80.157 (be patient)
    Completed 400 requests
    Completed 800 requests
    Completed 1200 requests
    Completed 1600 requests
    Completed 2000 requests
    Completed 2400 requests
    Completed 2800 requests
    Completed 3200 requests
    Completed 3600 requests
    Completed 4000 requests
    Finished 4000 requests

    Server Software: Apache/2.2.15
    Server Hostname: 192.168.80.157
    Server Port: 80

    Document Path: /phpinfo.php
    #测试的页面
    Document Length: 50797 bytes
    #页面大小

    Concurrency Level: 1000
    #测试的并发数
    Time taken for tests: 11.846 seconds
    #整个测试持续的时间
    Complete requests: 4000
    #完成的请求数量
    Failed requests: 0
    #失败的请求数量
    Write errors: 0
    Total transferred: 204586997 bytes
    #整个过程中的网络传输量
    HTML transferred: 203479961 bytes
    #整个过程中的HTML内容传输量
    Requests per second: 337.67 [#/sec] (mean)
    #最重要的指标之一，相当于LR中的每秒事务数，后面括号中的mean表示这是一个平均值
    Time per request: 2961.449 [ms] (mean)
    #最重要的指标之二，相当于LR中的平均事务响应时间，后面括号中的mean表示这是一个平均值
    Time per request: 2.961 [ms] (mean, across all concurrent requests)
    #每个连接请求实际运行时间的平均值
    Transfer rate: 16866.07 [Kbytes/sec] received
    #平均每秒网络上的流量，可以帮助排除是否存在网络流量过大导致响应时间延长的问题
    Connection Times (ms)
    min mean[+/-sd] median max
    Connect: 0 483 1773.5 11 9052
    Processing: 2 556 1459.1 255 11763
    Waiting: 1 515 1459.8 220 11756
    Total: 139 1039 2296.6 275 11843
    #网络上消耗的时间的分解，各项数据的具体算法还不是很清楚

    Percentage of the requests served within a certain time (ms)
    50% 275
    66% 298
    75% 328
    80% 373
    90% 3260
    95% 9075
    98% 9267
    99% 11713
    100% 11843 (longest request)
    #整个场景中所有请求的响应情况。在场景中每个请求都有一个响应时间，其中
    # 50％的用户响应时间小于275毫秒，66％的用户响应时间小于298毫秒，最大的
    # 响应时间小于11843毫秒。对于并发请求，cpu实际上并不是同时处理的，而是
    # 按照每个请求获得的时间片逐个轮转处理的，所以基本上第一个Time per request
    # 时间约等于第二个Time per request时间乘以并发请求数。

    总结：在远程对web服务器进行压力测试，往往效果不理想（因为网络延时过大），
建议使用内网的另一台或者多台服务器通过内网进行测试，这样得出的数据，准确度会
高很多。如果只有单独的一台服务器，可以直接本地测试，比远程测试效果要准确。
}