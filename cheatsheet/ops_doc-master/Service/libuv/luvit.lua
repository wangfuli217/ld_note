libuv 凡是 handle 类型必须要调用 uv_close 关闭。不然会造成内存泄露。
lua 和 C 的交互都是通过堆栈操作来进行的，和汇编有点像，一开始很容易弄错参数位置，比较好的办法是使用 pcall，在崩溃的时候打印出 traceback 和 stackinfo。
在最外层 uv_loop 中调用 lua 的时候，必须以调用一个 lua 函数开始。不然弄错了参数个数就内存泄露了。lua 函数默认是有保护的，弄错了也没问题。
灵活的使用 lua 中的 userdata 可以搞很多有意思的事情。比如说某个底层 C 模块获取了一个很大的 buffer，交给另外一个底层 C 模块处理。可以把 C struct 包在 userdata 中在上层 lua 传来传去。相比之下 python 的 ctypes 比较臃肿复杂，功能简单而不灵活。而 ctypes 还算比较好的设计了，一般脚本语言根本就压根没有这样的概念，只是草草的给出动态库的接口就了事了，完全没有精心设计和考虑过。
lua_pushcclosure 是一个很不错的设计。可以把一个 C 函数和 lua 中的数个变量绑定起来作为闭包，传给 lua 调用。这点也是基本上秒杀其他脚本语言的设计，配合 userdata 使用能彻底解决了高层底层之间回调的各种纠葛。
lua 数组下标默认从 1 开始是有原因的。这样通过 table.maxn 就可以判断 table 是作为 dict 还是 array 了。这点 php 做得就不好。
uv_work 会自动创建线程池，默认 4 线程，因此不用担心效率问题。
uv_process 退出的时候，进程和管道不一定谁先关谁后关，注意处理。
lua_cjson 模块是目前最快的（官网评测）json 模块，经过分析它快的原因是，边 parse 边在 lua 的虚拟机里面生成各种结构。这也是别的脚本的第三方库不可能做到的操作。它有可能是脚本语言中最快的 json 模块。
http_parser 是比较快和轻量级的 http header parser，也是回调形式的库，很容易和 libuv 结合到一起，很容易就搞出一个 http client。
luvit 是一个不错的开源项目。

#lua的vm不是堆栈式的，虽然lua跟c交互数据通过堆栈来完成，但是lua的vm是典型的寄存器式vm；Jvm是堆栈式vm.