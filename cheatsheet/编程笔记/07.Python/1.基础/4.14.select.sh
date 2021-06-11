select()方法接收并监控3个通信列表， 
第1个是所有的输入的data,就是指外部发过来的数据，
第2个是监控和接收所有要发出去的data(outgoing data),
第3个监控错误信息，接下来我们需要创建2个列表来包含输入和输出信息来传给select().
readable , writable , exceptional = select.select(inputs, outputs, inputs, timeout)

inputs = [ server ]
outputs = [ ]
while inputs:
    readable, writable, exceptional = select.select(inputs, outputs, inputs)
    for s in readable:
        if s is server:
            pass # ...
        else:
            pass # ...
            
            data = s.recv(1024) 
            if data:
                pass # ...
            else:
                pass # ...
                
    for s in writable:
    
    for s in exceptional:
            
# http://www.cnblogs.com/wspblog/p/5960879.html
