把读程序编译成两个不同版本：
阻塞读版本:br
以及非阻塞读版本nbr
把写程序编译成两个四个版本：
非阻塞且请求写的字节数大于PIPE_BUF版本：nbwg
非阻塞且请求写的字节数不大于PIPE_BUF版本：版本nbw
阻塞且请求写的字节数大于PIPE_BUF版本：bwg
阻塞且请求写的字节数不大于PIPE_BUF版本：版本bw
下面将使用br、nbr、w代替相应程序中的阻塞读、非阻塞读
验证阻塞写操作：
当请求写入的数据量大于PIPE_BUF时的非原子性：
nbr 1000
bwg
当请求写入的数据量不大于PIPE_BUF时的原子性：
nbr 1000
bw
验证非阻塞写操作：
当请求写入的数据量大于PIPE_BUF时的非原子性：
nbr 1000
nbwg
请求写入的数据量不大于PIPE_BUF时的原子性：
nbr 1000
nbw
不管写打开的阻塞标志是否设置，在请求写入的字节数大于4096时，都不保证写入的原子性。但二者有本质区别：
对于阻塞写来说，写操作在写满FIFO的空闲区域后，会一直等待，直到写完所有数据为止，请求写入的数据最终都会写入FIFO；
而非阻塞写则在写满FIFO的空闲区域后，就返回(实际写入的字节数)，所以有些数据最终不能够写入。