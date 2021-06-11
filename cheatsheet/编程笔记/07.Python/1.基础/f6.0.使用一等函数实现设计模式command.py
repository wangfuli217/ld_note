"命令"设计模式也可以通过把函数作为参数传递而简化。
"命令"模式的目的是解耦调用操作的对象（调用者）和提供实现的对象（接收者）。
Gamma等人说过："命令模式是回调机制的面向对象替代品。"问题是，我们需要回调机制的面向对象替代品吗？有时确实需要，但并非始终需要。


MacroCommand的各个实例都在内部存储着命令列表
class MacroCommand: 
    """一个执行一组命令的命令""" 
 
    def __init__(self, commands): 
        self.commands = list(commands) # 使用commands参数构建一个列表，这样能确保参数是可迭代对象，还能在各个 
                                       # MacroCommand实例中保存各个命令引用的副本。
    def __call__(self): 
        for command in self.commands: # 调用MacroCommand实例时，self.commands 中的各个命令依序执行。 
            command()

过多强调设计模式的结果，而没有细说过程。
对接口编程，而不是对实现编程
优先使用对象组合，而不是类继承。