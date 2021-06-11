
一、常用函数:
  getFitValue({TABLE;字段}, 长度 int) -- 缩短字符來显示:如果字符超过长度(参数2 int)则后面的省略
  Previous({TABLE;字段}), Next({TABLE;字段}) -- 上一笔 下一笔资料,位於 Functions -> Print State
  sum({TABLE;字段}), Average({TABLE;字段}) -- 求和,求平均; 位於 Functions -> Summary

  字符拼接,用“&”符号; Switch 用法
  //货品名称 改成只显示:  款号, 颜色 颜色编码,尺寸
  {ev_product.no} & "," & {ev_product.colorname} & {ev_product.color} & "," &
  Switch (
      left(right({ev_product.id}, 7),2)="00", "XXS",
      left(right({ev_product.id}, 7),2)="01", "XS",
      left(right({ev_product.id}, 7),2)="03", "S",
      left(right({ev_product.id}, 7),2)="05", "M",
      left(right({ev_product.id}, 7),2)="07", "L",
      left(right({ev_product.id}, 7),2)="09", "XL",
      left(right({ev_product.id}, 7),2)="11", "2L",
      left(right({ev_product.id}, 7),2)="13", "3L",
      left(right({ev_product.id}, 7),2)="15", "4L",
      left(right({ev_product.id}, 7),2)="17", "5L",
      left(right({ev_product.id}, 7),2)="19", "6L",
      left(right({ev_product.id}, 7),2)="21", "7L",
      True, "尺寸错误"
  )

1.判断下一笔资料和这一笔是否相同
  Previous ({TABLE;字段}) = ({TABLE;字段})

  其中，Previous() 表示上一笔资料； 而直接写的 ({TABLE;字段})表示这一笔资料的字段
  对着显示栏位右键 -> Format Field... -> Commom -> Suppress If Duplicated (勾上，就不会再显示重复的资料)
  如果需要按条件判断资料是否重复，就得在刚才那个“Suppress If Duplicated”，勾上，再去它右边写公式，公式如上面的


2.数据库查询條件
  把下面的这段写到一个变量里面(Formula Fields)，然后在“Report”->“Select Expert”里面加入这条件
  @条件名 -> “Formula:” -> 填入：“ if {@条件名} then true else false ”

  if ( {ev_trade.tradedate} >= {?Begindate}  and  {ev_trade.tradedate} <={?Enddate}
   -- 可以不输入参数的，用下面這句
   and ({?Cusid} = '' or {ev_trade.partner} = {?Cusid})
   -- 必須輸入参数的用下面這句
   and {ev_trade.type} = {?Type}
  ) then true else false

  表达式不能用大括号，所以写起来比较难看
  比较运算符，要使用 and or not ，而不能使用 && || !

  like 语句的匹配符用“*”代替“%”作任意匹配符,用“?”代替“_”单个匹配符; 如:
  if ( {?Id}="" or {ev_product.id} like "*" + Replace({?Id}, " ", "*") + "*" ) then true else false
  上面语句的 {?Id} 是前后模糊匹配，而且中间的空格也作为模糊匹配任意字符。
  另外，使用 like 时，传过来的参数里面的“*”和“?”具有匹配作用，比如{?Id}的内容是“*22*55*”里面的星号具有匹配作用。


3.自定义数据库查询语句
  菜单栏 -> Database -> Database Expert ... -> Create new Connection -> ODBC(RDO) -> 选数据库 -> Add Command
  双击“Add Command”可以编写自定义的数据库SQL,同时这SQL查出来的资料也跟类的资料一样使用
  -- SQL需要的参数在右边输入框可定义,同样使用“{?参数名}”的形式传入
  如果参数是字符型参数，请手动加上'' 号。 比如 where sm.session_id = '{?input_sm_id}'


4.表关联
  菜单栏 -> Database -> Database Expert ... -> Create new Connection -> ODBC(RDO) -> 选数据库 -> 选择所需数据表
  接下来是这些数据表的关联关系,在“Links”标签页可见到,默认是字段名相同的做内关联(inner join)
  点它的连线,再选“Link Options...”即可修改连接方式;(快捷键：o)
  如果要用不同的字段作关联,如“OpenAccount”字段关联到另一张表的“id”字段,鼠标点着“OpenAccount”字段拖到“id”字段即可

