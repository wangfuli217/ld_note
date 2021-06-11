
<?xml version="1.0" encoding="utf-8"?>
<catalog>
    <maxid>4</maxid>
    <login username="pytest" passwd='123456'>
        <caption>Python</caption>
        <item id="4">
            <caption>test</caption>
        </item>
    </login>
    <item id="2">
        <caption>Zope</caption>
    </item>
</catalog>

#1、获得标签属性
print("#1、获得标签属性")
import xml.dom.minidom
dom = xml.dom.minidom.parse("del.xml") #打开xml文档
root = dom.documentElement #得到xml文档
print("nodeName：",root.nodeName)  #
print("nodeValue：",root.nodeValue)
print("nodeType：",root.nodeType)
print("ELEMENT_NODE：",root.ELEMENT_NODE)

#2、获得子标签
print("#2、获得子标签")
bb = root.getElementsByTagName('maxid')
print(type(bb))
print(bb)
b = bb[0]
print(b.nodeName)
print(b.nodeValue)

#3、获取标签属性值
print("#3、获取标签属性值")
itemlist = root.getElementsByTagName('login')
item =itemlist[0]
print(item.getAttribute("username"))
print(item.getAttribute("passwd"))
itemlist = root.getElementsByTagName('item')
item = itemlist[0]           #通过在itemlist中的位置区分
print(item.getAttribute("id"))
item_1 = itemlist[1]        #通过在itemlist中的位置区分
print(item_1.getAttribute("id"))

#4、获得标签对之间的数据
print("#4、获得标签对之间的数据")
itemlist1 = root.getElementsByTagName('caption')
item1 = itemlist1[0]
print(item1.firstChild.data)
item2 = itemlist1[1]
print(item2.firstChild.data)

#5总结
1. 获得标签属性
[instance]
dom = minidom.parse(filename) # 加载读取XML文件
[instance]
root = dom.documentElement    #得到xml文档对象
    print "nodeName:", root.nodeName            # 每一个结点都有它的nodeName，nodeValue，nodeType属性
    print "nodeValue:", root.nodeValue          # nodeValue是结点的值，只对文本结点有效
    print "nodeType:", root.nodeType            # nodeType是结点的类型。
    print "ELEMENT_NODE:", root.ELEMENT_NODE    # catalog是ELEMENT_NODE类型
        'ATTRIBUTE_NODE'
        'CDATA_SECTION_NODE'
        'COMMENT_NODE'
        'DOCUMENT_FRAGMENT_NODE'
        'DOCUMENT_NODE'
        'DOCUMENT_TYPE_NODE'
        'ELEMENT_NODE'
        'ENTITY_NODE'
        'ENTITY_REFERENCE_NODE'
        'NOTATION_NODE'
        'PROCESSING_INSTRUCTION_NODE'
        'TEXT_NODE'
2. 获得子标签
[xml.dom.minicompat.NodeList]
itemlist = root.getElementsByTagName(TagName) # 获取XML节点对象集合
item = itemlist[0]
3. 获得标签属性值
item.getAttribute(AttributeName) # 获取XML节点属性值
4. 获得标签对之间的数据
node.childNodes  # 返回子节点列表。
node.childNodes[index].nodeValue # 获取XML节点值
node.firstChild # 访问第一个节点。等价于pagexml.childNodes[0]

