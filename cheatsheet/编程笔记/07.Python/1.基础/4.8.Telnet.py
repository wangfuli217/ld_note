telnet = telnetlib.Telnet()               | t = telnetlib.Telnet(h, port) 
telnet.open(HOST, self.port, timeout=30)  |                               
telnet.sock.gettimeout()                  |                               
telnet.sock.close()                       | t.close ()                    

tn.read_until("Password: ")
tn.write(self.password+'\n')



# 配置选项
Host = '192.168.1.254' # Telnet服务器IP
sername = 'root' # 登录用户名
password = '123456' # 登录密码

# 连接Telnet服务器
tn = telnetlib.Telnet(Host)

# 输入登录用户名
tn.read_until('login: ')
tn.write(username + '\n')

 # 输入登录密码
tn.read_until('Password: ')
tn.write(password + '\n')

# 登录完毕后，执行ls命令
tn.write('ls\n')
# tn.read_some()      在命令执行完毕之后获取命令执行后的返回内容。
# tn.read_until('#')  在命令执行完毕或者登陆之后，读取内容

# ls命令执行完毕后，终止Telnet连接（或输入exit退出）
tn.close() # tn.write('exit\n')
