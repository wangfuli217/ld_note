selenium  自动化测试工具

config <type> ["<name>"]     # Section
    option <name> "<value>"  # Option
---------------------------------------------------
config system
    option conloglevel '8'
    option cronloglevel '8'
    option hostname Openwrt
    option timezone
config timeserver ntp
    list server 0.openwrt.pool.ntp.org
    list server 1.openwrt.pool.ntp.org
    list server 2.openwrt.pool.ntp.org
    option enabled 1
    option enable_server 0
---------------------------------------------------

thinking(所见即所得){
0. cbi将配置文件映射成 Map 对象，
1. cbi将配置文件中的各种节区类型 映射 成Web页面各种类型
   节区类型 可以 映射 成TypedSection，也可以 映射 成NamedSection，且这两种节区有相同和不同的选项，选项用来管理数据和控制htm
   1.1 当配置文件中只有一个type，且type没有name时，只能使用TypedSection
   1.2 当配置文件中有多个type，且type有name时，TypedSection常用于选项显示；NamedSection常用于"Section"选项编辑
   1.3 当配置文件中有多个type，且type没有name时，使用TypedSection的filter函数可以显式指定显示的"Section"，还有depends和validate
   1.4 SimpleSection可以使用template的方式显示non-UCI类型的数据表，对于数据集用Table显式，对于单条数据常用TextValue处理。
2. cbi将配置文件中的各种名称 映射 成Web页面标题和描述，将名称对应的值通过cfgvalue，formvalue和write函数显示到页面，从页面获取，保存到配置文件中
   2.1 cbi中多数类型都有Title和Description字段，主要是Node基类构建时设定的，更深层次是为了业务可描述而设计的。Template这个特殊类没有
   2.2 Map: Title 映射成 配置文件名称，Description为对Map的进一步描述
   2.3 [Typed|Named]Section： Title 映射成 配置文件中Section的<name>，Description为对Section的进一步描述
   2.4 Value: Title 映射成 配置文件中Option的<name>，Description为对Option的进一步描述
3. cbi将配置文件中的名称的value 映射 成Web页面的编辑、选择、使能/非使能、多选的描述
   enabled      <-> Flag              选择使能|非使能；可以通过Button方式显示，只要重构render函数即可，见startup.lua
   hostname     <-> Value             可以编辑的字符串和数字类型, 不可编辑的字符串 .readonly选项或者枚举值 value函数
   conloglevel  <-> ListValue         下拉菜单 1|2|3|4|5|6|7|8
   XXX          <-> MultiValue        多个选择 Sun&Mon&Tue&Wed&Thu&Fri&Sat
   list server  <-> DynamicList       list选项 ntpserver 服务器地址列表
   ------------     ------------------------------------------------------
   non-UCI
   DummyValue                         与Value功能类似， 处理非/etc/config下配置文件相关的功能；
   Button                             按钮功能
   TextValue                          多行编辑，常用于对文件进行编辑
4. cbi是POST类型的http协议交互类型，将 Web页面的显示在 render函数中实现，将 Web页面的处理在parse函数中实现
   4.1 Map类型在原有header.htm和footer.htm基础上，嵌套了view/cbi/header.htm和view/cbi/footer.htm。view/cbi/header.htm中有POST标签
   4.2 SimpleForm类型的simpleform.htm模板中有POST标识
   4.3 POST类型仍有很多子类型，当前多为(multipart/form-data)类型的提交方式，一次可以提交多个字段数据，
   application/x-www-form-urlencoded,multipart/form-data,application/json,text/xml,enctype,contentType
   4.4 http.lua用于缓存未处理的数据和已处理的数据。protocol用于对 application/x-www-form-urlencoded,multipart/form-data等类型接收数据进行处理
   4.5 其中http.lua提供的formvalue()用于获取指定id的页面数据，formvaluetable用于获取id前缀相同的多个数据集。
5. cbi中每种类型对应 一种 HTML 片断。Template类型使自己可以 重设计 HTML片断。
   5.1 SimpleSection和Template两种类型多会使用htm模板重载原有模板
   5.2 TypedSection的tsection.htm模板为行显示方式，而tblsection.htm为列显示方式。
   5.3 (themes/)header.htm[(cbi/)header.htm[map[section[value...]...]...](cbi/)footer.htm](themes/)footer.htm Map类型CBI格式
   最外层是主题类型header.htm和footer.htm。次外层是cbi类型header.htm和footer.htm。里层就是多个Map类型。 常为单个Map实例
   Map类型通过cbi使用return map,map的方式在header.htm和footer.htm之间叠加；
   section类型通过for循环方式嵌在Map类型中；value类型通过for循环方式嵌在section类型中。
   5.4 (themes/)header.htm[SimpleForm[Table[dummyvalue...]...]...](themes/)footer.htm  SimpleForm方式展示为cbi类型数据。
   最外层是主题类型header.htm和footer.htm。里层就是多个SimpleForm类型。 常为单个SimpleForm实例。
   所以，多个Map类型实例只有一个行 (Save&Apply, Save, Reset) 而多个SimpleForm实例有多个(Submit, Reset)
   Map和SimpleForm之间存在差异，具体参考simpleform.htm
                                                                                     skip                          增加忽略按钮
   Save&Apply ：将页面数据保存到后台文件系统; 并通知与相关文件关联的进程进行重新启动 hideapplybtn=false&&autoapply 显示
   Save       ：将页面数据保存到后台文件系统;                                        hidesavebtn=false             显示
   Reset      ：恢复到修改前的状态                                                   hideresetbtn=false            显示
   Submit     ：提交已修改的的数据
6. cbi 使用节点属性定制模板和控制数据处理，cbi通过重载函数实现特殊功能。
   节点属性：一种用于控制模板的页面显示(被用在render函数中)，一种用于控制后台的数据处理(被用在parse函数中)；
   节点函数：一种用于实现模板的页面显示(被用在render函数中)，一种用于实现后台的数据处理(被用在parse函数中)；
   6.1 TypedSection的addremove,anonymous,extedit属性。Value的rmempty,datatype,placeholder,default属性
   6.2 TypedSection的filter,validate,cfgsetions,render函数。 value的cfgvalue,write,validate函数
   6.3 Map的flow,parsechain,pageaction,messages属性。SimpleForm的pageaction,dorender,message,submit,reset属性。
   6.4 Map的parse,validate函数，SimpleForm的parse,validate函数
7. 阅读cbi.lua时感到的疑惑: 
   7.1 Node类是一个基类，一个抽象类。抽象类给人一种不知所以然的感觉，没有任何一个可见的东西与之对应
   而它的一些属性和方法也不知道实现哪些功能，感觉就是做些接口抽象和数据结构抽象。
   7.2 当看到Map, SimpleForm, AbstractSection, AbstractValue的时候，在函数逻辑内有回调基类的render函数等，
   有将逻辑且回到Node函数中，这种来回切换使思路中断，造成的不连续，降低了可阅读性。AbstractSection与其子类之间，
   AbstractValue与其子类之间存在类似的问题。
   7.3 面向对象的覆盖功能和重用功能，使得编程的时候，简单看实现类不能理解完实现类提供的所用功能，因为有些功能隐藏在父类中。
   同时父类抽象一个接口，在接口内叠加子类此接口要实现的功能，造成逻辑叠加(if,switch分支增加)，既造成阅读上困惑又提高了阅读难度
}

thinking(我思故我在){
1. 面向对象编程 本质上 是面向数据编程：面向数据编程核心是 基于关键字 的数据索引；基于关键字 的数据关联模型 -- 数据结构。

2. 面向对象编程 设计上 是按照分层分类原则设计，
   2.1 分层：底层完成关联结构、共同数据、共同操作的实现，尽量抽象共同业务而不实现。高层完成扩展数据、抽象共同业务、特殊操作重载实现。
   2.2 分类：底层实现类型关系；高层实现类型业务功能。底层为一元类型；高层多实现类型。

3. 回调函数、表驱动(数据驱动)、分层分类、流程分段抽象是程序设计的基本原则。
  3.1 数据驱动和流程分段抽象 是核心，是在对业务的深层次理解基础上完成的，是程序设计的艺术所在。
    流程分段抽象:
    a. 从cgi-bin/luci调用开始，然后luci/cgi/sgi.lua，最后在luci/dispatcher.lua中完成数据处理
    b. cbi.lua内Node类型的children用于构建一棵树，Node的parse解析Web输入数据，Node的render输出Web显示
}

class
  |                                           s = m:section(NamedSection, x['.name'], "switch",    动态显示 foreach
Node |--AbstractSection-|--NamedSection       s = m:section(NamedSection, arg[1], "redirect", "")  section编辑
     |                  |--TypedSection       s = Map:section(TypedSection, "_dummy", "")          虚设显示，重载cfgsections
     |                  |--SimpleSection      SimpleForm:section(SimpleSection, nil, "")           虚设显示，重载AbstractValue的cfgvalue和write
     |                  |--Table              SimpleForm:section(Table,                            显示表结构数据：动态的(当前进程状态)， 静态数据(启动任务配置)
     |                  
     |--AbstractValue --|--Value              编辑框()
     |                  |--DummyValue         虚设编辑框，重载cfgvalue
     |                  |--Flag               "1"和"0" 二元制
     |                  |--ListValue          select下拉菜单
     |                  |--DynamicList        动态增加，对应uci的list
     |                  |--MultiValue         多选，一次可以选择多个选项
     |                     |----StaticList    选中 不选中，与Flag类似
     |                  |--TextValue          多行编辑框
     |                  |--Button             按钮
     |                  |--FileUpload         未使用
     |                  |--FileBrowser        未使用
     |--Template          SimpleForm:append(Template)
     |--Map               UCI
     |--Compound          未使用
     |--Delegator         未使用
     |--SimpleForm        non-UCI
     |       |---- Form   未使用
     |--Page              未使用

-------------------|------------------|--------------|-------- |---------------|-------------------|-------------|----|
Node               | AbstractSection  |AbstractValue |Template |Map            |  Compound         | SimpleForm  |Page|
-------------------|------------------|--------------|-------- |---------------|-------------------|-------------|----|
  prepare          |                  | prepare      |         |               |                   |             |    |
  append           |                  |              |         |               |                   |             |    |
  parse            |                  | parse        | parse   | parse         | parse             | parse       |    |
  render           |                  | render       | render  | render        |                   | field       |    |
  render_children  |                  |              |         |               |                   |             |    |
                   | tab              | depends      |         | formvalue     | populate_delegator|             |    |
                   | has_tabs         | deplist2json |         | formvaluetable|                   |             |    |
                   | option           | cbid         |         | get_scheme    |                   |             |    |
                   | taboption        | formcreated  |         | submitstate   |                   |             |    |
                   | render_tab       | formvalue    |         | chain         |                   |             |    |
                   | parse_optionals  | additional   |         | state_handler |                   |             |    |
                   | add_dynamic      | mandatory    |         | section       |                   |             |    |
                   | parse_dynamic    | add_error    |         | add           |                   |             |    |
                   | push_events      |              |         | set           |                   | set         |    |
                   | cfgvalue         | cfgvalue     |         | del           |                   | del         |    |
                   | remove           | remove       |         | get           |                   | get         |    |
                   | create           | write        |         |               |                   | get_scheme  |    |
                   |                  | validate     |         |               |                   |             |    |
-------------------|------------------|--------------|-------- |---------------|-------------------|-------------|----|
                                                                                                                
----------------|--------------|----------------|----------------|
AbstractSection | NamedSection |   TypedSection |   Table        |
----------------|--------------|----------------|----------------|
prepare         | prepare      |   prepare      |                |
append          |              |                |                |
parse           | parse        |   parse        |   parse        |
render          |              |                |                |
render_children |              |                |                |
tab             |              |                |                |
has_tabs        |              |                |                |
option          |              |                |                |
taboption       |              |                |                |
render_tab      |              |                |                |
parse_optionals |              |                |                |
add_dynamic     |              |                |                |
parse_dynamic   |              |                |                |
push_events     |              |                |                |
cfgvalue        |              |                |                |
remove          |              |                |                |
create          |              |                |                |
                |              |   cfgsections  |    cfgsections |
                |              |   depends      |                |
                |              |   checkscope   |                |
                |              |                |    update      |
----------------|--------------|----------------|----------------|
                                                     
----------------|------------ | ------------|-----------|------------|--------------|
AbstractValue   | Value       |  DummyValue |  Flag     | ListValue  |  MultiValue  |
----------------|------------ | ------------|-----------|------------|--------------|
prepare         |             |             |           |            |              |
append          |             |             |           |            |              |
parse           | parse       |  parse      |  parse    |            |              |
render          |             |             |           |            |  render      |
render_children |             |             |           |            |              |
depends         |             |             |           |            |              |
deplist2json    |             |             |           |            |              |
cbid            |             |             |           |            |              |
formcreated     |             |             |           |            |              |
formvalue       |             |             |           |            |              |
additional      |             |             |           |            |              |
mandatory       |             |             |           |            |              |
add_error       |             |             |           |            |              |
cfgvalue        |             |   cfgvalue  |  cfgvalue |            |              |
remove          |             |             |           |            |              |
write           |             |             |           |            |              |
validate        |             |             |  validate | validate   |  validate    |
                | reset_values|             |           |reset_values| reset_values |
                | value       |             |           | value      |              |
                |             |             |           |            |   valuelist  |
----------------|------------ | ------------|-----------|------------|--------------|

Macro(){
FORM_NODATA  =  0    not "cbi.submit"  # 确定接收数据是否为提交数据
FORM_PROCEED =  0
FORM_VALID   =  1    children 都正常处理 
FORM_DONE    =  1    "cbi.cancel"
FORM_INVALID = -1
FORM_CHANGED =  2
FORM_SKIP    =  4    "cbi.skip"

AUTO = true

CREATE_PREFIX = "cbi.cts."
REMOVE_PREFIX = "cbi.rts."
RESORT_PREFIX = "cbi.sts."
FEXIST_PREFIX = "cbi.cbe."
}                                                                            
Node(没有template的抽象){ 分离过程，抽象接口；构造数据结构，抽象数据管理接口
1. 函数
lua -l luci.cbi -e 'for k,v in pairs(luci.cbi.Node) do print(k,'\t',v) end'

-- hook 回调函数 详细见 hook 节
Node._run_hook(self, hook) -- 执行名字为hook的钩子函数
-- 输入为一个字符串：即一个函数名; 函数参数为(self)
-- 该hook钩子函数，需要在类创建的时候构建；
Node._run_hooks(self, ...) -- 执行名字为... (可变参数:动态多个名字)的回调钩子函数
-- 输入为多个字符串：即多个函数名; 函数参数为(self)
-- 该hook钩子函数，需要在类创建的时候构建；

-- self.children 关联子类
Node.append(self, obj)   -- 将对象添加到self.children中。
Node.prepare(self, ...)  -- 递归遍历调用Node.prepare
Node.parse(self, ...)    -- 递归遍历调用Node.parse

-- self.template Web显示模板
Node.render(self, scope)         -- 导出自身的模板到Web页面
                                 -- scope是一个k-v的映射表，用于给self.template对应的模板传递参数
                                 -- 重载render可以控制页面显示
-- self.template + self.children 递归显示
Node.render_children(self, ...)  -- 导出所有子节点的模板

2. 字段
self.children = {}                    -- 子节点 -- 树形结构关联节点
self.title = title or ""              -- 标题
self.description = description or ""  -- 描述
self.template = "cbi/node"            -- 模板
}

Template(Node 参数化template字段){ 在cbi(SimpleForm)实例上附加htm模板
1. 函数
Template.render(self)            -- 相比Node的render函数，没有scope参数
-- Template简化了Node的render函数
Template.parse(self, readinput)  -- 相比Node的parse函数，增添了readinput参数；
-- Node依赖实例化子类；Template实现parse函数

2. 字段
self.template = template

3. 实例 
3.1 ipkg.lua = SimpleForm包含Template(Web页面的tab形式) tab1 = package.htm; tab2 = ipkg.lua

# CBI对象的template
DummyValue.template =                   构建新嵌入块
TypedSection.template  = "cbi/tblsection"
# CBI类型Template
SimpleForm:append(Template("admin_system/ipkg"))         添加view  (luci\luci\view\admin_system\ipkg.htm)
SimpleForm:append(Template("admin_system/backupfiles"))  添加view  (luci\luci\view\admin_system\backupfiles.htm)
# luci对象template
luci.template.render("admin_system/reboot", {reboot=reboot})
}

Map(Node){
1. 函数
Map.get(self, section, option)        -- 获取指定section的option的值
Map.del(self, section, option)        -- 删除指定section的option选项
Map.set(self, section, option, value) -- 设置指定section的option的值为value
Map.add(self, sectiontype)            -- 添加指定类型的

-- 字符串   页面响应数据
-- false    没有从页面返回 readinput = false
-- nil      页面没有数据
Map.formvalue(self, key)
-- table    空表: 页面没有数据；页面有数据
-- false    没有从页面返回 readinput = false
Map.formvaluetable(self, key)

2. 字段
   FORM_SKIP：cbi.skip按钮被按，不对数据进行任何处理
   FORM_NODATA：                submit按钮没有被按
   FORM_INVALID：               数据没有被保存
   FORM_VALID：                 告知handle函数，内容正常
   FORM_CHANGED: formvalue不等于uci value，且已经修改
   FORM_PROCEED：form执行了create或者remove等操作
   
apply_needed:当CBI中存在在XHR的时候，在执行异步请求的时候，执行apply_needed=true
                                                           Map.parse() 和 dispatcher._cbi()
self.config = config            -- 关联配置文件
self.parsechain = {self.config} -- 可以关联多个配置文件
self.template = "cbi/map"       -- 模板
self.apply_on_parse = nil       -- 
self.readinput = true           -- 
self.proceed = false            -- 
self.flow = {}                  -- 

3. htm扩展字段
skip: If true ADD the skip button.
autoapply: if true (and hideapplybtn not true) HIDE submit button.
hideapplybtn: if true (and autoapply not true) HIDE submit button.
hidesavebtn: If true HIDE the save button
hideresetbtn: if true HIDE the reset button.

m.message = ""  # 在Web页面输出提示信息
}

SimpleForm(Node:non-UCI){
ipkg.lua          SimpleForm(TextValue)+SimpleForm(TextValue)+SimpleForm(TextValue)                         form调用
startup.lua       SimpleForm(section(Table)+DummyValue... +Button)+SimpleForm(TextValue)                    form调用
Processes.lua     SimpleForm(section(Table)+DummyValue... +Button)                                          cbi调用
backupfiles.lua   SimpleForm(SimpleSection(Button+TextValue))  SimpleForm(SimpleSection(Button+DummyValue)) form调用
crontab.lua       SimpleForm(TextValue)

processes.lua ： 整体用于数据显示，整体不进行数据处理
1. SimpleForm.reset = false SimpleForm.submit = false模式，使得SimpleForm不提供reset按钮和submit按钮
2. SimpleForm实现方式使用cbi的方式调用，由于SimpleForm对象中没有pageaction变量，使得cbi/footer.htm中没有按钮


SimpleForm + Table + DummyValue + Button -> 启动状态管理，进程管理，ipkg包管理
SimpleForm + TextValue -> 脚本文件

SimpleForm(TextValue) 既可以在t.write函数中完成提交处理；也可以在f.handle中完成提交处理



1. 字段
self.config = config
self.data = data or {}
self.template = "cbi/simpleform"
self.dorender = true   -- 保证输出SimpleForm内容
self.pageaction = false
self.readinput = true

# 默认情况下SimpleForm有reset和submit两个按钮
m.reset = false    -- SimpleForm不显示reset按钮
m.submit = false   -- SimpleForm不显示submit按钮

# 可以提供的按钮：默认按钮是submit和reset
type="button" value="<%:Back to Overview%>"  -- redirect
type="submit" name="cbi.skip"                -- self.flow and self.flow.skip
type="submit" value="self.submit"            -- self.submit ~= false
type="reset" value="self.reset"              -- self.reset ~= false
type="submit" name="cbi.cancel"              -- self.cancel ~= false and self.on_cancel

2. 函数
SimpleForm.formvalue = Map.formvalue
SimpleForm.formvaluetable = Map.formvaluetable
SimpleForm.parse(self, readinput, ...) 见parse
SimpleForm.render(self, ...)           见render
SimpleForm.submitstate(self)           返回"cbi.submit"按钮返回的值

SimpleForm.section(self, class, ...)   创建指定类型Section，并添加给自身
如: s = m:section(Table, inits)    见startup.lua

field(self, class, ...)                在默认section或者Simplesection中创建value
如:t = f:field(TextValue, "lines") 见ipkg.lua

# SimpleForm可以通过data关联一个Table
set(self, section, option, value)
del(self, section, option)
get(self, section, option)

总结
-- 关联绑定
1. 关联 Table 见 startup.lua              s = m:section(Table, inits) 其中inits是个表结构
2. 关联 SimpleSection 见 backupfiles.lua  m:section(SimpleSection, nil, translate( 其中 section为nil
3. 关联 TextArea 见 crontab.lua           t = f:field(TextValue, "crons")
}                                            

Map_vs_SimpleForm(){
Map_vs
1. Maps 常常使用cbi类型的调用，cbi调用会在header.htm footer.htm的基础上嵌入view/cbi/header.htm footer.htm
header.htm中暗藏：
<form method="post" name="cbi" 
action="/cgi-bin/luci/admin/status/processes"  -- 定义了当表单被提交时数据被送往何处
enctype="multipart/form-data" 
onreset="return cbi_validate_reset(this)"                                                  -- cbi.js
onsubmit="return cbi_validate_form(this, 'Some fields are invalid, cannot save values!')"> -- cbi.js
<input type="hidden" name="token" value="a8f698d075b0e3ff030f2828cff14f49" />   -- token值
<input type="hidden" name="cbi.submit" value="1" />                             -- cbi.submit值
<input type="submit" value="Save" class="hidden" />                             -- submit触发的javascript处理
2. footer.htm中暗藏：
pageaction  -- 控制下面所有按钮
  redirect -- 实现未用到
  flow.skip                                cbi.skip   Skip          -- 后台直接退出，不进行任何处理
  not flow.hidesavebtn                                Save          -- 不存在错误就进行数据存储  self.uci:save(config) 保存到临时文件
  not flow.hideresetbtn                               Reset         -- 浏览器重新请求页面
  not autoapply and not flow.hideapplybtn  cbi.apply  Save & Apply  -- self.uci:commit(config)  将数据提交到/etc/config/配置文件中
                                                                    -- self.uci:apply(self.parsechain) 调用/sbin/luci-reload
                                                                    luci-reload 根据/etc/config/ucitrack配置文件重新启动对应服务
cbi("adblock/overview_tab", {hideresetbtn=true, hidesavebtn=true})
cbi("ntpc/ntpcmini", {autoapply=true})

SimpleForm_vs
1. SimpleForm常常使用form类型的调用，form调用直接使用系统提供的header.htm footer.htm
2. simpleform.htm 中有
  self.embedded                               Form.embedded = true 说明在simpleform中为nil
  self.title
  self.description
  self.message
  self.errmessage                             -- 实现未用到
  redirect                                    -- 实现未用到
  self.flow and self.flow.skip                -- 实现未用到
  self.submit ~= false                        -- type="submit" value="Submit"
  self.reset ~= false                         -- type="reset" value="Reset"
  self.cancel ~= false and self.on_cancel     -- on_cancel() 函数 wifi部分
}
AbstractSection(Node){
self.sectiontype = sectiontype -- 节类型(NamedSection和TypedSection)
self.map = map                 -- 配置文件关联Map实例
self.config = map.config       -- 配置文件的名称

self.optionals = {}
self.defaults = {}
self.fields = {}
    
self.tag_error = {}
self.tag_invalid = {}
self.tag_deperror = {}
self.changed = false


self.optional = true    -- self.options 见：ucisection.htm
self.addremove = false  -- 通过页面增加删除section
self.dynamic = true     -- 页面有Section输出之外的option的时候，动态增加该option到/etc/config/配置文件中

2. 函数
parse_dynamic(self, section) 在parse函数中被调用
}
TypedSection(Node->AbstractSection){
self.template = "cbi/tsection"
self.deps = {}          -- depends函数收集的依赖option项
self.anonymous = false  -- 匿名的，即不显示section的title和description

s.extedit   = ds.build_url("admin", "network", "firewall", "zones", "%s") -- 编辑
s.addremove = true                                                        -- 添加删除属性
self.anonymous = true                                                     -- 不显示section的title和description
function s.create(self)                                                   -- 添加实现
    local z = fw:new_zone()
    if z then
        luci.http.redirect(
            ds.build_url("admin", "network", "firewall", "zones", z.sid)
        )
    end
end

function s.remove(self, section)                                          -- 删除实现
    return fw:del_zone(section)
end

# 两种都具有过滤功能
1. s:depends("proto", "static")  -- 根据section中指定option中 key-value 的值是否满足，判断是否予以显示
   depends(self, option, value)
2. s.filter(self, section)       -- 根据section中指定section的 name 的值是否满足，判断是否予以显示
   s:filter(section)             
3. validate(self, section)       -- 根据section中options之间的依赖关系，以及option值是否有效，判断是否予以显示
   s.validate(self, sectionid)
  上述depends、filter、validate函数返回决定是否予以显示；返回nil就不予显示，返回section名字予以显示。
  depends函数用以调用，filter和validate函数予以重载

TypedSection.cfgsections(self)  # 返回所有与此类型匹配的sections名字

s = m:section(TypedSection, "_dummy", "")                        # 修改用户密码
TypedSection.cfgsections()
Map.parse(map)

s2 = m2:section(TypedSection, "_dummy", translate("SSH-Keys"),   # 修改SSH-Keys
TypedSection.cfgsections()
}
NamedSection(Node->AbstractSection){
self.addremove = false
self.template = "cbi/nsection"
self.section = section
}
Table(Node->AbstractSection){
1. Table + DummyValue
Table(self, form, data, ...)                    -- data <-> non_system_mounts; key到value的映射表
m:section(Table, non_system_mounts, translate("Mounted file systems"))  -- 依赖于Map的Section类型
fs = v:option(DummyValue, "fs", translate("Filesystem")) -- non_system_mounts.value.fs   对应的值


datasource.formvalue = Map.formvalue             -- 页面值
datasource.formvaluetable = Map.formvaluetable   -- 页面表值
datasource.readinput = true                      -- 

s = m:section(Table, inits)                                      inits对应section
i = s:option(DummyValue, "index", translate("Start priority"))   "index"对应option
datasource.get(self, section, option)   -- data[section][option] 对应section以及option对应的值
datasource.submitstate(self)            -- "cbi.submit"的值
datasource.del(...)                     -- 返回true
datasource.get_scheme()                 -- 返回nil 

Table.cfgsections(self)  # 返回所有与此类型匹配的sections名字
}

AbstractValue(Node){
depends(self, field, value) -- 当field等于value的时候，显示该选项
1. s:option(Value, "netmask", "Netmask"):depends("proto", "static")  -- option与option间显示与否的依赖关系

2. cbid(self, section) -- 可以返回此选项的唯一id，可以用于 s.formvalue(cbid) 的输入参数

3. formvalue(self, section) -- 返回Web页面内FORM内的值，函数可以被重构 -> self.map:formvalue(self:cbid(section))
   cfgvalue(self, section) --
差别：
   formvalue 函数从web页面的FORM获取指定的字段；
   cfgvalue可从Web页面的FORM中；也可以从/etc/config/配置文件；还可以从table类型的value."name"中来。
   cfgvalue支持类型转换，当前只能转换成string和table类型

   forcewrite 选项保证：页面是否对其值进行修改，都会将该值保存到/etc/config/配置文件中
                        lua程序后台都会调用wirte函数回写数据到/etc/config/配置文件中
   
4. additional(self, value) -- self.optional = value
5. mandatory(self, value) -- self.rmempty = not value
差别： 此处optional和rmempty意义相同，即该值为空的时候，不在配置文件中显示

self.optional -- 该选项没有配置的时候，通过页面可以动态增加该选项          -- 页面提示功能
                 核心在于：页面通过Add按钮提示用户可以配置该项，也可以不配置此选项。 
self.rmempty  -- 页面将该选项设置为空的时候，可以删除在配置文件的配置项     -- 配置文件内是否需要配置功能

self.default     -- 如果配置文件不存在，配置该值作为默认值 -- 该默认值与程序默认值一致
self.placeholder -- 用于提示Value类型的配置值，该选项常常与optional = true 一起使用
                 -- 描述文本区域预期值的简短提示。

self.rmempty   = true
self.optional  = false
}

DummyValue(Node->AbstractValue){ 强调展示，疏于输入
1. 属性
href   属性 : 超链接
rawhtml属性 : html解析属性
value  值   = self:cfgvalue(section) or self.default or ""

2. 模板
self.template = "cbi/dvalue"
self.value = nil

<% include( valueheader or "cbi/full_valueheader" ) %>
<%+cbi/valueheader%>
dvalue.htm
<% include( valueheader or "cbi/full_valuefooter" ) %>
<%+cbi/valuefooter%>
3. 实例说明
3.1. o.template = "admin_system/clock_status"  见 system.lua 中，修改显示template
设置template进行显示替换
3.2 startup.lua 与Table一起使用，option("index" 或 "name") 表示table中特定的key
i = s:option(DummyValue, "index", translate("Start priority"))
n = s:option(DummyValue, "name", translate("Initscript"))
3.3 forwards.lua 与Section一起使用，在一个字段中显示多个字段信息
match = s:option(DummyValue, "match", translate("Match"))
dest = s:option(DummyValue, "dest", translate("Forward to")
实例3.2 调用过程
DummyValue.cfgvalue(self, section)
  AbstractValue.cfgvalue(self, section)
    self.map:get(section, self.option)
      function datasource.get(self, section, option)
        return tself.data[section] and tself.data[section][option]

4. 函数说明
DummyValue.cfgvalue(self, section)
1. self.value 为函数    -- 函数返回值
2. self.value 为非nil   -- 返回当前值
3. self.value 为nil     -- section.value."name"
}

Button(Node->AbstractValue){  可以html input submit进行关键字搜索
Button是"submit"类型。 
self.template  = "cbi/button"
self.inputstyle = nil
self.rmempty = true

self.inputstyle = remove | find | save | reload | reset | apply | textarea 
该值控制位于luci/view/cbi/button.htm中的 css选项

render(self, section, scope) -- 绘制Button  用于显示
write(self, section)         -- 点击被调用  处理点击

btn = s:option(Button, "_btn", translate("Click this to run a script")) 
function btn.write() 
    luci.sys.call("/usr/bin/script.sh") 
end

总结
1. function o.render(self, section) 重构该函数，
设置title, inputtitle, inputstyle配置button的标题，内容和样式。对于二元状态，一种状态对应一种标题，内容和样式
1.1 o.render 绑定 Table 的属性，此时可通过 inits[section].enabled ( table[key].value ) 的方式获得当前状态
1.2 o.render 通过 luci.sys.init.enabled("keepalived") 的方式，获得特定启动任务的启动状态
1.3 o.render 通过 self.map:get(section, "enabled") ~= "0"  获得配置文件的状态信息
2. function o.write(self, section, value) 重构该函数
通过value与inputtitle匹配情况，修改/etc/config/配置文件内容或者是/etc/init.d/启动状态配置
2.1 o.write 绑定 Table 的属性，此时可通过 sys.init.disable(inits[section].name) 的方式设置当前任务状态
2.2 o.write 通过 luci.sys.init.enable("keepalived") luci.sys.init.start("keepalived") 设置特定任务的状态
2.3 o.write 通过 self.map:set(section, "enabled", "0") self.map:del(section, "enabled") 设置 配置文件状态信息
3. inputstyle 类型有 "save" "reset" "apply" "reload" "remove"
4. 如startup.lua中实现， start，stop，restart表示按钮按下一个动作，该动作只需要执行一个脚本和一行命令
5. 如processes.lua 中实现，通过 "Hang Up" "Terminate" "Kill" 执行一个信号
6. ifaces.lua 在发现当前需要支持特定协议而不存在opkg包的时候，只是安装某个安装太，此时 o.write实现 
luci.http.redirect(luci.dispatcher.build_url( 跳转到指定网页
}
Flag(Node->AbstractValue){ 与FEXIST_PREFIX关联
1. 属性
        支持"checkbox"类型 # http://www.w3school.com.cn/jsref/dom_obj_checkbox.asp
self.enabled  = "1"
self.disabled = "0"
self.default  = self.disabled

2. 模板
<% include( valueheader or "cbi/full_valueheader" ) %>
<%+cbi/valueheader%>  # <div class="cbi-value" id="cbi-system-ntp-enable">
                      # <label class="cbi-value-title" for="cbid.system.ntp.enable">
                      # Enable NTP client
                      # </label>
                      
fvalue.htm            # <input type="hidden" value="1" name="cbi.cbe.system.ntp.enable" />
                      # <input class="cbi-input-checkbox" onclick="cbi_d_update(this.id)" onchange="cbi_d_update(this.id)" 
                      # type="checkbox" 
                      # id="cbid.system.ntp.enable" 
                      # name="cbid.system.ntp.enable" 
                      # value="1" checked="checked" />
                      # </div>
<% include( valueheader or "cbi/full_valuefooter" ) %>
<%+cbi/valuefooter%>

3. 特殊函数
Flag.parse(self, section, novld)

4. 实例
4.1 system.lua中使能ntp客户端服务，决定是否可以提供ntp服务器和ntp服务器地址配置
  o = s:option(Flag, "enable", translate("Enable NTP client"))
  o.rmempty = false
4.2 forwards.lua 中使能服务
  local o = s:option(t, "enabled", ...)
  o.default = "1"
  
总结
-- 关联 /etc/config 属性
1. o.enabled 和 o.disabled 是可以配置的，配置内容可以是 (yes|no) (on|off) (1|0) (true|false)等，根据 /etc/config配置文件要求而设定
2. o.default 默认可以等于 o.enabled 或 o.disabled 。
3. o.rmempty 则说明，如果设置状态是 no off 或 0 也不删除该选项
-- depends
1. Flag 可以依赖外部设置出现与否 	见 ifaces.lua
    br:depends("proto", "static")
	br:depends("proto", "dhcp")
	br:depends("proto", "none")
2. 其他 CBI 依赖 Flag 设置出现与否  见 system.lua

-- 重载 cfgvalue 和 write
1. o.cfgvalue(self) 重载该函数，返回值要设定是 self.enabled or self.disabled
2. o.write(self, section, value) 重载需要判断 value == self.enabled 是否相等
}

Flag_Button(){ startup.lua forwards.lua forward-details.lua文件
1. Flag 是"checkbox"类型; Button是"submit"类型。 
Flag常会关联/etc/config配置文件中一个接口的使能开关，根据配置映射。
Button常会关联文件系统上非配置文件的文件功能或者执行一个临时操作。
Flag常用在/etc/config中多节区配置展示表中，而Button常用于单节区使能非使能按钮中，
Button有 "apply" "reset" "reload" "save" "remove" "link" "button" 多种显示类型
Button在self:cfgvalue == false 时输出 - 
}
Value(Node->AbstractValue){ 通过html input size可以属性input的下列属性 -- baidu
1. value.htm 模板提供了各种可以配置属性 支持text类型 # http://www.w3school.com.cn/jsref/dom_obj_text.asp
                                        支持password类型 # http://www.w3school.com.cn/jsref/dom_obj_password.asp
1.1 必要属性
id   = cbid
name = cbid
type = self.password and "password" or "text"     是否密码类型
class = self.password and "cbi-input-password" or "cbi-input-text"
value = self:cfgvalue(section) or self.default)
1.2 可选属性
1.2.1 html标准属性
"size" = self.size                属性规定输入字段的宽度。
对于 <input type="text"> 和 <input type="password">，size 属性定义的是可见的字符数。
"placeholder" = self.placeholder  属性提供可描述输入字段预期值的提示信息
"readonly" = self.readonly        是否只读类型
"maxlength" = self.maxlength      一行数据的最大长度
1.2.2 html扩展属性
"data-type" = self.datatype
"data-optional" = self.optional or self.rmempty
"data-manual" = self.combobox_manual

下为增加 o:value(key, val)
o:value("tcp udp", "TCP+UDP")
o:value("tcp", "TCP")
o:value("udp", "UDP")
o:value("icmp", "ICMP")
//<![CDATA[
cbi_combobox_init('cbid.firewall.cfg263837.proto', {"tcp udp":"TCP+UDP","tcp":"TCP","udp":"UDP","icmp":"ICMP"}, '', ' -- custom -- ');
//]]>

2. value模板
<% include( valueheader or "cbi/full_valueheader" ) %>
<%+cbi/valuefooter%> title # <div class="cbi-value" id="cbi-system-cfg02e48a-log_size">
                           # <label class="cbi-value-title" for="cbid.system.cfg02e48a.log_size">
                           # System log buffer size (title)
                           # </label>

value.htm                  # <input type="text" class="cbi-input-text" onchange="cbi_d_update(this.id)" name="cbid.system.cfg02e48a.log_size" id="cbid.system.cfg02e48a.log_size" value="1000" placeholder="16" />

<% include( valuefooter or "cbi/full_valuefooter" ) %>
<%+cbi/valueheader%> description # <div class="cbi-value-description">
                           # <span class="cbi-value-helpicon"><img src="/luci-static/resources/cbi/help.gif" alt="help" /></span>
                           # kiB (description)
                           # </div>
                           

3. Value(UCI) -- DummyValue(non-UCI)

4. template    = "cbi/network_netlist"
实例见system.lua 和 forward-details.lua 两个文档
}

Value_ListValue(){
1. value类型接口差异
function Value.value(self, key, val) 
function ListValue.value(self, key, val, ...) 
1.1 val不存在时，key即是val。即可以Value.value(self, key) 或 ListValue.value(self, key)
1.2 ListValue不支持key重复，而Value支持key重复
1.3 ListValue将{...}赋值给deplist，而Value只能设置两个值

2. value只有select一种模式， ListValue有radio和select两种显示模式
}

ListValue(Node->AbstractValue){
.value(self, key, val)

可以
o.cfgvalue(...)               -- 获取
o.write(self, section, value) -- 设置
}

DynamicList(Node->AbstractValue){
DynamicList是多个input类型的组合，整体上是div进行布局
1. 字段
self.template  = "cbi/dynlist"
self.cast = "table"
self:reset_values()
以下两个属性传递给input(text)类型的
placeholder
size

2. 函数
write(self, section, value)  -- 写入空格分割的字符串
cfgvalue(self, section)      -- 返回一个table 从/etc/config/配置文件
formvalue(self, section)     -- 返回一个table 从Web页面的FORM部分

3. 说明
此功能对应list方式，可以动态添加多个list

4. js 实现前端动态添加减少
function cbi_dynlist_init(name, respath, datatype, optional, choices)
function cbi_dynlist_keypress(ev)
function cbi_dynlist_keydown(ev)
function cbi_dynlist_btnclick(ev)
function cbi_dynlist_redraw(focus, add, del)
}

TextValue(Node->AbstractValue){ html textarea作为关键字进行搜索 baidu
对应于html的textarea类型
size 用来表示行长；
模板属性
rows        number      文本区内的可见行数。
readonly    readonly    文本区为只读。
wrap        hard|soft   当在表单中提交时，文本区域中的文本如何换行

soft    当在表单中提交时，textarea 中的文本不换行。默认值。
hard    当在表单中提交时，textarea 中的文本换行（包含换行符）。
        当使用 "hard" 时，必须规定 cols 属性。

wrap 属性：自动换行功能(word wrapping)
    通常情况下，当用户在输入文本区域中键入文本后，浏览器会将它们按照键入时的状态发送给服务器。
    只有用户按下 Enter 键的地方生成换行。
    如果把 wrap 设置为 off，将得到默认的动作。
    wrap="virtual"
    wrap="physical"

总结: 
1. TextValue 对应的都是文件，所以其 option 都是 和 /etc/config 没有关联关系的
2. 可设置属性
keys.wrap    = "off"   规定当在表单中提交时，文本区域中的文本如何换行。
keys.rows    = 3       规定文本区内的可见行数。
keys.cols = 70         规定文本区内的可见宽度。
keys.rmempty = false

3. keys.cfgvalue() 常常是fs.readfile("/etc/dropbear/authorized_keys") or ""
4. keys.write(self, section, value) 常常是 fs.writefile("/etc/dropbear/authorized_keys", value:gsub("\r\n", "\n"))

5. 在和SimpleForm绑定的过程中，使得SimpleForm会重载hanle函数
function f.handle(self, state, data)
	if state == FORM_VALID then


}
MultiValue(StaticList){ 用于多选功能；很少用，略
mvalue.htm 有select和checkbox两种，
}

FileUpload(Node->AbstractValue){
template 
upload_fields 
formcreated 
formvalue 
remobe
}
FileBrowser(Node->AbstractValue){
template(browser.htm)
依赖cbi_browser_init('<%=cbid%>', '<%=resource%>', '<%=url('admin/filebrowser')%>'<%=self.default_path and ", '"..self.default_path.."'"
%>);
}

parse(解析从页面得到的数据){
Node.parse(self, ...)
Template.parse(self, readinput)
Map.parse(self, readinput, ...) -- 将数据输出到页面， parse过程map->sections->options ;
                                -- self.save = false
                                -- fld.error = { [sid] = "Error foobar" }
                                -- 以上过程实现validate功能
     

Compound.parse(self, ...)
Delegator.parse(self, ...)
SimpleForm.parse(self, readinput, ...)
Table.parse(self, readinput)
NamedSection.parse(self, novld)
TypedSection.parse(self, novld)

AbstractValue.parse(self, section, novld)   -- 配置文件的值和FORM内的值不一样的时候才会write
                                            -- 如果输入值为空，且rmempty、optional的时候，删除配置文件此选项
Value.parse(self, section, novld)           -- 对页面FORM中的值进行解析
                                            -- 调用AbstractValue.parse
DummyValue.parse(self)                      -- 对页面FORM中的值进行解析
                                            -- 空函数
Flag.parse(self, section, novld)            -- 获取FORM中的值，
cfgvalue获取配置文件配置，要求返回"0"和"1"
当前配置等于"0"的时候，只是删除配置文件中option，而不进行write函数。 -- 解释了不使能时候，write函数不被调用
                                                                     -- 该过程与optional、rmempty有关
parse过程
1) "on_parse"
  2) If the formvalue of "cbi.skip"
  a) FORM_SKIP activated (see: The CBI call and "on_changed_to" and "on_succes_to")
  3) if "save" (this means you have clicked the save button or set the .save value to true)
    3a) "on_save"
    3b) "on_before_save"
    3c) uci:save
    3d) "on_after_save"
      3e1)If not in a deligator (see CBI Form Value) or if "cbi.apply" has been set (You clicked the save and apply button)
      3e2) "on_before_commit"
      3e3) actually commit everything
      3e4) "on_commit"
      3e5) "on_after_commit"
      3e6) "on_before_apply"
      3e7) if apply_on_parse
        3e7a) apply on all values
        3e7b) "on_apply"
        3e7c) "on_after_apply"
TODO: Finish showing the application parsing
      3e8) set apply_needed for map to parse (see:Applying Values)
    3f) run any commit_handler functions that a map has on it . (see: CBI: Map attributres)

}
render(将数据输出到页面){
Node.render(self, scope)

Template.render(self)
Map.render(self, ...)

SimpleForm.render(self, ...)
1. 如果不对handler进行重载，会输出SimpleForm
2. 如果对handler进行重载，如果重载函数返回值不等于false，会输出SimpleForm
3. FORM_SKIP、FORM_DONE、FORM_NODATA、FORM_VALID、FORM_INVALID值会作为handle(self, state, data)的state值传递
   FORM_SKIP：不执行handle函数
   FORM_DONE: 不执行handle函数，执行on_cancel类型hook函数
   FORM_NODATA：告知handle函数，内容未发生变化
   FORM_INVALID：告知handle函数，子节点确认格式不正确
   FORM_VALID：告知handle函数，内容正常
   FORM_CHANGED:formvalue不等于uci value，且已经修改

AbstractValue.render(self, s, scope)
MultiValue.render(self, ...)
1. AbstractValue的子类都会调用AbstractValue的render函数
2. MultiValue在函数中：select类型情况下初始化了self.size 值为#self.vallist
3. AbstractValue不是可选的(optional=false);或者section:has_tabs();或者cfgvalue(s)值不为空或者formcreated(s)为真
   则，将自身self和自身特性self.section和self:cbid() 交给Node的render进行导出
}

validate(后台判断前台输入值是否有效){
TypedSection.validate()  -- 可以重载该函数，返回nil或者section名称，判断是否予以显示
AbstractValue.validate() -- 可以重载该函数，返回nil或者value的值，判断提交是否成功
1. AbstractValue默认通过verify_datatype函数判断，输入值是否符合指定类型。当前满足检查类型都包含在datatype.lua文件中
2. TypedSection默认之间返回section名称
3. Value、DummyValue、Flag、TextValue都可以使用datatype.lua数值类型判断函数

4. TypedSection.fields： for field, obj in pairs(self.fields) do local fieldval = obj:formvalue(sectionid) 从页面获取对应option的值
   然后进行判断

ListValue.validate()  -- 确保返回值在.value(self, key, val, ...)中
MultiValue.validate() -- 确保多个返回值在.value(self, key, val, ...)中  
StaticList.validate() -- 确保多个返回值在.value(self, key, val, ...)中
1. ListValue为单选下拉菜单,其类型可以有widget = "select"; "radio";  select为默认值 -- 见system.lua
2. MultiValue为多选按钮，其类型可以有widget = "checkbox";  checkbox为默认值        -- 见ruledetails.lua
3. StaticList当前没有使用实例
}

hook(){
on_init Before rendering the model           -- Map.render(self, ...)            内第一个一定执行
on_parse Before writing the config           -- Map.parse(self, readinput, ...)  内第一个一定执行

self.save 条件正确的时候                     -- on_before_save -> on_save -> on_after_save -> on_before_commit
on_before_commit Before writing the config   -- 

on_after_commit After writing the config     -- 
on_before_apply Before restarting services   -- 
on_after_apply After restarting services     -- 
on_cancel When the form was cancelled        -- 
}


cbi(form处理过程){
prepare()
parse()
render()
}
load(ipkg部分demo){
for k,v in pairs(maps) do
  for n,m in pairs(v) do
    print(n,m)
  end
end
---------------------------------------------------------------------
dorender        true
description     General options for opkg
data    table: 0xd73970
config  ipkgconf
title   OPKG-Configuration
readinput       true
handle  function: 0xd6a980
pageaction      false
children        table: 0xd70100
template        cbi/simpleform
-----------------------------
dorender        true
description     Build/distribution specific feed definitions. This file will NOT be preserved in any sysupgrade.
data    table: 0xd22510
config  distfeedconf
title   Distribution feeds
readinput       true
handle  function: 0xd82440
pageaction      false
children        table: 0xd241e0
template        cbi/simpleform
-----------------------------
dorender        true
description     Custom feed definitions, e.g. private feeds. This file can be preserved in a sysupgrade.
data    table: 0xd709a0
config  customfeedconf
title   Custom feeds
readinput       true
handle  function: 0xd07890
pageaction      false
children        table: 0xd90bb0
template        cbi/simpleform
-----------------------------
通过该实例也就理解了点load函数，以及form的作用
}

template_addremove(定制添加按钮){
nsection.htm    -- NamedSection
tsection.htm    -- TypedSection
tblsection.htm  -- TableSection

按照名字新建NamedSection

实例：
luci\model\cbi\firewall\forwards.lua
luci\model\cbi\firewall\rules.lua
luci\model\cbi\shadowsocks-libev\instances.lua
luci\model\cbi\openvpns.lua
}

id(基于cbi的自动id生成规则){
Map     -> <div class="cbi-map" id="cbi-system">    Map("system")
Section -> NamedSection    
           TypedSection    # Type dummy
                           <div class="cbi-map-descr">xxxx</div><fieldset class="cbi-section" id="cbi-system-_dummy"> TypedSection("_dummy")
                           <fieldset class="cbi-section-node" id="cbi-system-_pass">                                  TypedSection("_dummy")
                           cfgsections() return "_pass"
                           # Type dropbear
                           <fieldset class="cbi-section" id="cbi-dropbear-dropbear">                                  TypedSection("dropbear") 
                           <fieldset class="cbi-section-node" id="cbi-dropbear-cfg024dd4">                            TypedSection("dropbear") 
           .addremove      <input type="submit" class="cbi-button cbi-button-add" name="cbi.cts.dropbear.dropbear.cfg044dd4" value="Add" />
                           <input type="submit" name="cbi.rts.dropbear.cfg024dd4" onclick="this.form.cbi_state='del-section'; return true" value="Delete" class="cbi-button" />
           SimpleSection   
           Table
           
}

override_scheme(StaticList){
modules/niu/luasrc/model/cbi/niu/network/etherwan.lua
modules/niu/luasrc/model/cbi/niu/network/wlanwan.lua
applications/luci-olsr/luasrc/model/cbi/olsr/olsrdplugins.lua
libs/web/luasrc/cbi.lua
}

lua(backupfiles){
luci.http.formvalue("cbid.luci.1._list")  l(Button)._list(Button.title)
luci.http.redirect(luci.dispatcher.build_url("admin/system/flashops/backupfiles") .. "?display=list")

luci.http.formvalue("cbid.luci.1._edit")
luci.http.redirect(luci.dispatcher.build_url("admin/system/flashops/backupfiles") .. "?display=edit")

与DummyValue相关
  self.rawhtml      write(val)
  not self.rawhtml  write(pcdata(val))

}

htm(clock_status){
action_clock_status  post_on({ set = true }, "action_clock_status")  new XHR()).post()
action_clock_status  call("action_clock_status")                     XHR.get()

DummyValue.template = "admin_system/clock_status"
action_clock_status
  local set = tonumber(luci.http.formvalue("set"))
}

htm(packages){
与后台的post_on处理，复杂
}

function AbstractSection.option(self, class,       option, ...) 
                   obj  = class(self.map, self,    option, ...)
   AbstractValue.__init__(self, map,      section, option, ...)

map(){
map:Creates a generic map object.
Attributes
? mymap:readinput -- if the map should read input or not boolean
  mymap:proceed   -- If true (bool) this lets the map skip committing unless "save and apply" was clicked... then its useless
  mymap:flow      -- Values set by the cbi values passed in the entry call that called the map
  mymap:uci       -- The UCI cursor the map uses to make changes
  mymap:save      -- The flag that tells the parse function to save
  mymap:changed   -- The flag that changes the maps state when somthing has changed but save and proceed are both unset/false
  mymap:template  -- The html template that the map populates
  mymap:parsechain -- The list of objects within the map that should be rendered
  mymap:scheme    -- TODO explore what schemes are used for
  mymap:state -- Used by dispatcher to redirect the user to various on_BLANK_to pages and to otherwise dispatch the pages based upon the state of the map
  mymap:apply_on_parse -- The flag that tells the map to apply all values when parsed
  mymap:apply_needed -- This value is what is used by the CBI pages to actually apply the uci changes that were saved
Methods
    mymap:formvalue(key)
Returns the formvalue for the map

    mymap:formvaluetable(key)
return the formvalue for the map as a table

    mymap:get_scheme(sectiontype, option)
TODO explore scheme usage

    mymap:submitstate()
Get the submission type of the submitted page

    mymap:chain(config)
Chain another config file onto this maps parsechain !!!!!

    mymap:state_handler(state)
do somthing based on the maps state (dummy function in base code)

    mymap:parse(readinput, ...)
core parseing function for maps

    mymap:render(...)
Render the map

    mymap:section(class, ...)
Create a child section

    mymap:add(sectiontype)
Add a section to the attacked UCI config TODO check how this works with chain()

    mymap:set(section, option, value)
Set a value within a specified section

    mymap:del(section, option)
Delete a value from a UCI config

    mymap:get(section, option)
Get a value from this maps UCI config file

    mymap:commit_handler(submit_state)
Dummy function that gets passed submitstate on self.save
}

section(){
Attributes

mysection.map
The map that this section belongs to

mysection.config
mysection.optionals
mysection.defaults
mysection.fields
mysection.tag_error
mysection.tag_invalid
mysection.changed
mysection.optional(){
AbstractSection.parse_optionals 函数: 
1. section.optional = true;
2. value.optional = true 且 cfgvalue(配置文件没有配置) 且 has_tabs(该value不存在tab) 
此时页面才会显示"cbi.opt."

AbstractValue.render 函数
1. value.optional = true 或
2. section:has_tabs() = false 或
3. value.cfgvalue(s) = false 或
4. value.formcreated() 或
}
This section is optional(Value, Flag) 
mysection.anonymous             tblsection tsection <h3><%=section:upper()%></h3>
mysection.addremove    nsection tblsection tsection <input type="submit" name="cbi.rts.<%=self.config%>.<%=k%>" onclick="this.form.cbi_state='del-section'; return true"value="<%:Delete%>" class="cbi-button" />
mysection.dynamic      ucisection                   dynamic 总是和 self.optionals[section] 在一起是使用，正常情况dynamic为false, 见ucisection.htm
mysection.tabs         nsection tabcontainer tabmenu tsection ucisection <%+cbi/tabcontainer%>
mysection.tab_names    tabmenu                       for _, tab in ipairs(self.tab_names) 见tabmenu.htm
mysection.template     nsection tblsection tsection 自己输出格式
The html template that the section populates
mysection.data

Table
mysection.rowcolors          tblsection.htm     cbi-rowstyle-<%=rowstyle()%>
Table allow row coloration
mysection.anonymous
Table TODO explore this
mysection.deps
mysection.err_invalid
typedsection
mysection.invalid_cts
typedsection


Methods
mysection:tab(tab, title, desc)
Define a tab for the section

mysection:has_tabs()
Check whether the section has tabs

mysection:option(class, option)
Append a new option to the section

mysection:taboption(tab)
Append a new tabbed option

mysection:render_tab(tab, ...)
Render a single tab

mysection:parse_optionals(section)
Parse optional options

mysection:add_synamic(field, optional)
add a dynamic option

mysection:parse_dynamic(section)
parse all dynamic options

mysection:cfgsection(section)
Return the sections UCI table

mysection:push_events()
Set map to changed

mysection:remove(section)
Delete this section

mysection:create(section)
Creates this section

mysection:parse(readinput)
Main parser for the section and TODO explore table internals (Table)

mysection:update(data)
Refresh table with new data (Table)

mysection:depends(option, value)
imits scope to sections that have certain option => value pairs (TypedSection)

mysection:checkscope(section)
Verifies scope of sections (TypedSection)

mysection:filter(section)
A function to filter out unwanted sections from a TypedSection (TypedSection)

mysection:validate(section)
A validation function for sections (TypedSection <- dummy function)
}