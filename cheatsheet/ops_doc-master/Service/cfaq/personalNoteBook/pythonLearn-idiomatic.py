
1.compare: if 1 < i  < 3

2.倒置if/else:
  num = 10  if str == 'a' else 20  

3.for else: 

 for i in range(5):
        if i==3:
            break   跳过else逻辑
 else:
     print('error') 只有for完整遍历才执行else逻辑，else里面一般是异常逻辑
     
4. dict查找key
  dict.get(key, None) 如果key不存在返回None

5.动态生成元素(推导):   
  eg: dict = {num: num*2  for num in list if num  > 1}
  eg2:  s= "Name1=Value1;Name2=Value2;Name3=Value3"  ,   d = dict(item.split("=") for item in s.split(";"))  

6. 设置dict 默认值，只运行1次:
  dict.setdefault(k, v)

7.copy list:
copy_list = list[::] or copy_list= list[:]

8.格式化输出
str = "welcome to {here}".format(here='github')  输出: 'welcome to github'

9.swap:   a,b = b,a

10.带下标的遍历list
for i,v in enumerate(list) 如果不用enumerate只能拿到value

11.字符串连接: ''.join(list)

12.打开关闭文件: 
  with open('file') as f:
    for line in f:
      print(line)

13.unpack tuple:  
i,j,k = tuple  is better than: i = t[0],j=t[1],k=t[2]

14.多用decorator来提取common代码，抽离个性化代码
   @decorator
   def myfunc:
