
漂亮的打印出JSON
    JSON是一种非常好的数据序列化的形式，被如今的各种API和web service大量的使用。
    使用python内置的 json 处理，可以使JSON串具有一定的可读性，但当遇到大型数据时，它表现成一个很长的、连续的一行时，人的肉眼就很难观看了。

    为了能让JSON数据表现的更友好，我们可以使用indent参数来输出漂亮的JSON。
    当在控制台交互式编程或做日志时，这尤其有用：

    import json

    data = {"status": "OK", "count": 2, "results": [{"age": 27, "name": "Oz", "lactose_intolerant": True}, {"age": 29, "name": "Joe", "lactose_intolerant": False}]}
    print(json.dumps(data))  # No indention, 打印:{"status": "OK", "count": 2, "results": [{"age": 27, "name": "Oz", "lactose_intolerant": true}, {"age": 29, "name": "Joe", "lactose_intolerant": false}]}

    print(json.dumps(data, indent=2))
    # With indention, 打印如下:
    '''
    {
      "status": "OK",
      "count": 2,
      "results": [
        {
          "age": 27,
          "name": "Oz",
          "lactose_intolerant": true
        },
        {
          "age": 29,
          "name": "Joe",
          "lactose_intolerant": false
        }
      ]
    }
    '''

    print(json.dumps(data, separators=(',',':')))  # 输出时去掉分隔符的空格, 打印如下:
    #{"status":"OK","count":2,"results":[{"age":27,"name":"Oz","lactose_intolerant":true},{"age":29,"name":"Joe","lactose_intolerant":false}]}

    同样，使用内置的pprint模块，也可以让其它任何东西打印输出的更漂亮。
    参考： http://docs.python.org/2/library/pprint.html



字符串 转成 json
    import json
    json_input = '{ "one": 1, "two": { "list": [ {"item":"A"},{"item":"B"} ] } }'
    try:
        decoded = json.loads(json_input)
        # pretty printing of json-formatted string
        print json.dumps(decoded, sort_keys=True, indent=2)
        print "JSON parsing example: ", decoded['one']
        print "Complex JSON parsing example: ", decoded['two']['list'][1]['item']
    except (ValueError, KeyError, TypeError):
        print "JSON format error"

        
encoding：把一个Python对象编码转换成Json字符串
decoding：把Json格式字符串解码转换成Python对象

对于简单数据类型（string、unicode、int、float、list、tuple、dict），可以直接处理。
import json
 
obj = [[1,2,3],123,123.123,'abc',{'key1':(1,2,3),'key2':(4,5,6)}]
encodedjson = json.dumps(obj)
print repr(obj)
print encodedjson

运行结果为
[[1, 2, 3], 123, 123.123, 'abc', {'key2': (4, 5, 6), 'key1': (1, 2, 3)}] 
[[1, 2, 3], 123, 123.123, "abc", {"key2": [4, 5, 6], "key1": [1, 2, 3]}]
在json的编码过程中，会存在从python原始类型向json类型的转化过程，具体的转化对照如下： revertjson


对于encode，我们使用dump()方法，对于decode，我们使用loads()方法
decodejson = json.loads(encodedjson)
print type(decodejson)
print decodejson[4]['key1']
print decodejson
输出为：
<type 'list'> 
[1, 2, 3]
[[1, 2, 3], 123, 123.123, u'abc', {u'key2': [4, 5, 6], u'key1': [1, 2, 3]}]
loads方法返回了原始的对象，但是仍然发生了一些数据类型的转化。比如，上例中‘abc’转化为了unicode类型。
从json到python的类型转化对照如下： jsonrevert

json.dumps方法提供了很多好用的参数可供选择，比较常用的有sort_keys（对dict对象进行排序，我们知道默认dict是无序存放的），separators，indent等参数。
排序功能使得存储的数据更加有利于观察，也使得对json输出的对象进行比较，例如：

sort_keys
    data1 = {'b':789,'c':456,'a':123}
    data2 = {'a':123,'b':789,'c':456}
    d1 = json.dumps(data1,sort_keys=True)
    d2 = json.dumps(data2)
    d3 = json.dumps(data2,sort_keys=True)
    print d1
    print d2
    print d3
    print d1==d2
    print d1==d3
    
    输出：
    {"a": 123, "b": 789, "c": 456} 
    {"a": 123, "c": 456, "b": 789} 
    {"a": 123, "b": 789, "c": 456} 
    False 
    True

indent参数是缩进的意思，它可以使得数据存储的格式变得更加优雅
    data1 = {'b':789,'c':456,'a':123}
    d1 = json.dumps(data1,sort_keys=True,indent=4)
    print d1
    输出：
    { 
        "a": 123, 
        "b": 789, 
        "c": 456 
    }

separator
    输出的数据被格式化之后，变得可读性更强，但是却是通过增加一些冗余的空白格来进行填充的。
    json主要是作为一种数据通信的格式存在的，而网络通信是很在乎数据的大小的，无用的空格会
    占据很多通信带宽，所以适当时候也要对数据进行压缩。separator参数可以起到这样的作用，
    该参数传递是一个元组，包含分割对象的字符串
    
    print 'DATA:', repr(data)
    print 'repr(data)             :', len(repr(data))
    print 'dumps(data)            :', len(json.dumps(data))
    print 'dumps(data, indent=2)  :', len(json.dumps(data, indent=4))
    print 'dumps(data, separators):', len(json.dumps(data, separators=(',',':')))

    # 输出：
    DATA: {'a': 123, 'c': 456, 'b': 789} 
    repr(data)             : 30 
    dumps(data)            : 30 
    dumps(data, indent=2)  : 46 
    print 'DATA:', repr(data)
    print 'repr(data)             :', len(repr(data))
    print 'dumps(data)            :', len(json.dumps(data))
    print 'dumps(data, indent=2)  :', len(json.dumps(data, indent=4))
    print 'dumps(data, separators):', len(json.dumps(data, separators=(',',':')))

    # 输出：
    DATA: {'a': 123, 'c': 456, 'b': 789} 
    repr(data)             : 30 
    dumps(data)            : 30 
    dumps(data, indent=2)  : 46 

处理自己的数据
    首先，我们定义一个类Person

    class Person(object):
        def __init__(self,name,age):
            self.name = name
            self.age = age
        def __repr__(self):
            return 'Person Object name : %s , age : %d' % (self.name,self.age)
    if __name__  == '__main__':
        p = Person('Peter',22)
        print p

如果直接通过json.dumps方法对Person的实例进行处理的话，会报错，因为json无法支持这样的自动转化。
通过上面所提到的json和python的类型转化对照表，可以发现，object类型是和dict相关联的，所以我们
需要把我们自定义的类型转化为dict，然后再进行处理。这里，有两种方法可以使用

第一种方法：自己写转换函数
import Person 
import json 

p = Person.Person('Peter',22) 
    def object2dict(obj): 
    #convert object to a dict 
    d = {} 
    d['__class__'] = obj.__class__.__name__ 
    d['__module__'] = obj.__module__ 
    d.update(obj.__dict__) 
    return d 
def dict2object(d): 
    #convert dict to object 
    if'__class__' in d: 
        class_name = d.pop('__class__') 
        module_name = d.pop('__module__') 
        module = __import__(module_name) 
        class_ = getattr(module,class_name) 
        args = dict((key.encode('ascii'), value) for key, value in d.items()) #get args 
        inst = class_(**args) #create new instance 
    else: 
        inst = d 
        return inst 
        
d = object2dict(p) 
print d #{'age': 22, '__module__': 'Person', '__class__': 'Person', 'name': 'Peter'} 

o = dict2object(d) 
print type(o),o #<class 'Person.Person'> Person Object name : Peter , age : 22 

dump = json.dumps(p,default=object2dict) 
print dump 
#{"age": 22, "__module__": "Person", "__class__": "Person", "name": "Peter"} 

load = json.loads(dump,object_hook = dict2object) 
print load 
#Person Object name : Peter , age : 22

第二种：继承JSONEncoder和JSONDecoder类，覆写相关方法
JSONEncoder类负责编码，主要是通过其default函数进行转化，我们可以override该方法。同理对于JSONDecoder。

import Person 
import json

p = Person.Person('Peter',22)

class MyEncoder(json.JSONEncoder): 
    def default(self,obj): #convert object to a dict 
        d = {} 
        d['__class__'] = obj.__class__.__name__ 
        d['__module__'] = obj.__module__ 
        d.update(obj.__dict__) 
        return d
        
class MyDecoder(json.JSONDecoder): 
    def __init__(self): 
        json.JSONDecoder.__init__(self,object_hook=self.dict2object) 
    def dict2object(self,d): 
    #convert dict to object 
        if'__class__' in d: 
            class_name = d.pop('__class__') 
            module_name = d.pop('__module__') 
            module = __import__(module_name) 
            class_ = getattr(module,class_name) 
            args = dict((key.encode('ascii'), value) for key, value in d.items()) #get args 
            inst = class_(**args) #create new instance else: inst = d return inst
        else: 
            inst = d 
            return inst

d = MyEncoder().encode(p) 
o = MyDecoder().decode(d) 
print d 
print type(o), o