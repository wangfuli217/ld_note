
猴子补丁(Monkey patching)
=============================
我们现在来到 gevent 的死角了. 在此之前，我已经避免提到猴子补丁(monkey patching) 以尝试使 gevent 这个强大的协程模型变得生动有趣，但现在到了讨论猴子补丁的黑色艺术 的时候了。
你之前可能注意到我们提到了 monkey.patch_socket() 这个命令，这个 纯粹副作用命令是用来改变标准 socket 库的。

# 示例
    import socket
    print(socket.socket) # <class 'socket._socketobject'>

    print("After monkey patch")
    from gevent import monkey
    monkey.patch_socket()
    print(socket.socket) # <class 'gevent.socket.socket'>

    import select
    print(select.select) # <built-in function select>
    monkey.patch_select()
    print("After monkey patch")
    print(select.select) # <function select at 0x01BD85F0>


Python 的运行环境允许我们在运行时修改大部分的对象，包括模块，类甚至函数。
这是个一般说来令人惊奇的坏主意，因为它创造了“隐式的副作用”，如果出现问题 它很多时候是极难调试的。
虽然如此，在极端情况下当一个库需要修改 Python 本身 的基础行为的时候，猴子补丁就派上用场了。
在这种情况下，gevent 能够 修改标准库里面大部分的阻塞式系统调用，包括 socket 、 ssl 、 threading 和 select 等模块，而变为协作式运行。

例如，Redis的python绑定一般使用常规的 tcp socket 来与 redis-server 实例通信。
通过简单地调用 gevent.monkey.patch_all() ，可以使得redis的绑定协作式的调度 请求，与 gevent 栈的其它部分一起工作。

这让我们可以将一般不能与 gevent 共同工作的库结合起来，而不用写哪怕一行代码。 虽然猴子补丁仍然是邪恶的(evil)，但在这种情况下它是“有用的邪恶(useful evil)”。

# 注：如果先执行了 gevent.monkey.patch_all()
# 后面再 import 进来的 socket, threading 等都会是已经被修改过了的
