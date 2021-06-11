require "luasql.mysql"
--mysql = require "luasql.mysql" --写法2

--创建环境对象
env = luasql.mysql()
--env = mysql.mysql()  --写法2

--连接数据库
conn = env:connect("lua", "root", "******", "localhost", 3306)
--conn = env:connect(数据库名称, 账号, 密码, IP地址, 端口号)

--设置数据库的编码格式
conn:execute"SET NAMES UTF8"

--执行数据库操作
cur = conn:execute([[select * from userInfo]])

--此处的a指的是以附加的方式打开只写文件
row = cur:fetch({}, "a") 

--文件对象的创建,顺便将表信息存储在userInfo.txt文本中
file = io.open("userInfo.txt","w+");

while row do
    var = string.format("%d %s %d %s\n", row.id, row.name, row.sex, row.address)

    print(var)

    file:write(var)

    row = cur:fetch(row, "a")
end


file:close()  --关闭文件对象
conn:close()  --关闭数据库连接
env:close()   --关闭数据库环境