Monkey patch就是在运行时对已有的代码进行修改，达到hot patch的目的。Eventlet中大量使用了该技巧，以替换标准库中的组件，比如socket。首先来看一下最简单的monkey patch的实现。


