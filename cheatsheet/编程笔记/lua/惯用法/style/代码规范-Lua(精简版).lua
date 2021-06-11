## 概述 ##
	1. 编写目的
	本文描述了Lua程序代码开发中的有关规则，用于规范编程过程中的命名和代码书写规范。
	2. 预期读者
	全公司Lua技术人员。
	3. 适用范围
	适用于全公司基于Lua开发的项目。


## 初级阶段 ## 

1.代码基础规范
	1.1	编码规范 
		1.	文件以utf-8编码保存。
		2.	选择tab进行缩进，在编辑器中设置tab显示为四个字节。
		eg:
		 	for k,v in pairs(t) do
		 		if type(v) == "string" then 
		 			print(v)
		 		end
		 	end
		3.	任一行代码长度不超过120列。
		4.	使用单行或多行空白行来分隔内部代码的逻辑段落。


	1.2	命名规范
		总原则：
		*.	命名以能清楚描述变量作用为前提，可长可短；（注：i 可能并不是一个好全局变量，但在一个小循环中，i是一个很好的局部计数器变量名）
		*.	在本作用域内避免使用上一层或全局作用域内同名的变量，以避免混淆。
			（例如：全局已经有全局类string或函数assert，则不应该出现local string或local assert的声明和赋值）；
		*.	可以用"_"来命名变量，但"_"的变量不能被使用，而是作为被忽略的变量。
		eg:
		 	for _,v in next, tb do
		 		print(v)
		 	end 
		 	local info, _ = getInfo() 
		*.	所有变量声明避免用"_"或"__"开头，因为以它们开头的变量是被系统保留的。

		1.	变量命名：第一个单词首字母小写的驼峰法。
			a)	布尔变量用is、can、has开头
			b)	用于bit操作的数据（数字或数组）以bit开头
			c)	集合型数据用s结尾，不要为List, Array, Set等
			d)	映射型数据用Map结尾 
			eg: 
				local drawBoard = DrawBoard.new(1000, 500)
				local resources = {}              -- 集合变量 
				local scoreMap  = {}              -- 映射变量 
				local myFirstWordOfArticle = "Hello World!" 
				local isShown 	= true            -- 布尔变量 
				local canWork 	= false           -- 布尔变量 
				local bitDungons = { 0, 0, 0, 0 } -- 用于bit操作的数组 
		2.	常量命名：大写加下划线。
			a)	全局常量用GLOBAL_开头 
			eg:
				local KIND_PET_FOOD = "" 
				local MAX_SIZE 		= 10 
				local MIN_NUM 		= -10000 
				local GLOBAL_VAR 	= false 
		3.	函数命名：遵循和变量相同的命名法则（因为Lua的函数也是 first class object）。
			eg:
				function safeImport() end
				local safeImport = function() end 
		4.	类命名（metatable形式的类）：第一个单词首字母大写的驼峰法。
			a)	工具类(不需要实例化)使用table方式创建
			b)	对象类(必须要实例化)使用class("类名")方式创建
			c)	所有类独享文件时，通常声明为M，并以“return M"返回
			d)	工具类的方法以M.开头（c）
			e)	对象类的方法以M:开头（c）
			d)	对象类的成员变量用self._开头
			eg:
				XmlDocument = {} 	           -- 工具类
				Person 		= class("Person")  -- 对象类


	1.3	变量使用规范
		1.	避免使用magic number
		eg:
		 	-- 下面9.8就是magic number，可读性差 
		 	local speed = time * 9.8 
		 	-- 这样的代码更好理解
		 	_G.ACCELERATION = 9.8 
		 	local spped = time * ACCELERATION 
		2.	尽量使用 local 变量而非 global 变量 
		3.	在同一行不要给超过5个变量同时赋值，且赋值时即使没有值也用nil显式地赋值 
		4.	若变量的赋值来自于函数的返回值，则同一行不允许有除了函数返回值的其它变量赋值 
		5.	判断一个变量是否存在，不存在则给其赋值时使用 x = x or {} 的方式替代 if..else 
		6.	可以使用 x = a and b or c 的方式给变量赋值，但请注意以下几种情况：
			a)	超过2个以上的逻辑判断时，请使用 if..else
			b)	若a, b, c为函数时，请用括号包围，避免出现多返回值的函数导致错误
			c)	在多变量赋值时，禁止使用以上的方式，请改用 if..else
			d)	当a, b, c是布尔类型时改用 if..else 赋值，避免出现逻辑错误
				（因为：Lua的规范里，如果a and b or c 中a==true且b==false/nil 则返回c的值，不能返回预期中b的值）


	1.4	运算符、括号、逗号、分号、单双引号使用规范
		1.	使用二目运算符时，运算符左右两边要有一个空格。
		eg:
			(100 + 50 * i, 100 + 50 / (i + 1), time + i - 12) 
		2.	在书写算术运算和逻辑运算表达式时，使用括号，而不是默认的运算符优先级；且在使用括号时前后不要加空格。
		eg:
		 	if not a and b or c then end 		-- 不好的方式 
		 	if ((not a) and b) or c then end 	-- 好的方式 
		3.	在使用逗号时，逗号后边应该有个空格。
		eg:
		 	function Monitor:setPos(x1, y1, x2, y2)
		 		self._x1 = x1
		 		self._y1 = y1
		 		self._x2 = x2
		 		self._y2 = y2
		 	end 
		4.	在使用每行末尾使用分号时，请确保如果用分号就全用分号，如果不用，那么就都不用分号。建议不用分号(;)。
		5.	在使用字符串赋值时，如果使用双引号就都双引号，如果单引号就都单引号。建议单字符使用单引号，其它字符串使用双引号。


	1.5	Table使用规范
		1.	表的遍历
		对 table 进行迭代时，key和value应根据具体意义命名，而不是简单的k,v 
		eg:
			for charId, obj in ipairs(CharIdMap) do
				print(charId, obj)
			end
		当然，在局部小循环中，i j仍然是很好的用于计数的变量名字。
		推荐使用 next 方式遍历 table，而不是 pairs 和 ipairs ，这样可以避免区分表是否按数组方式存取。(放松)
		在使用 next 遍历 table 时，若这个 table 是某函数的返回值，除非特殊情况，请使用括号包围此函数。(这样避免因为函数有多个返回值而造成错误。) 
		eg:
			for name, role in next, (getAllRoles()) do
				print(name, role.age)
			end 
		当一个表使用metatable __index设置默认值时，请注意：无论是next，pairs还是ipairs都无法遍历元表中的值。
		2.	空表判断
		用 next(tb) == nil 来判断一个表或数组是否为空，不要用#tb == 0
		3.	数组使用
		若确定一个table是用于顺序存储（数组），则下标从1开始增长，且中间不要存取nil值，这样数组访问的效率能够保证最高。
		取数组的长度用#，不用table.getn（注：此长度仅是线性数组从索引为1开始的连续长度）
		Table的数据较多时，请分行处理，且显式地写明数组下标，增强可读性：
		eg:
			local items = {
				[1] = 108001,
				[2] = 108002,
				[3] = 108003,
			}


	1.6	字符串使用规范
		1.	避免在内层for循环使用连接符
		2.	能使用table.concat连接字符串时，不使用连接符
		3.	print中能使用逗号分隔时，不使用连接符


	1.7	函数使用规范
		1.	函数行数不能超过20行（包括注释）
		2.	重写原有函数时注意兼容原来的函数，包括传参、返回值和原有逻辑 
		3.	关键函数开头，应该对传入参数用assert进行参数检查 
		4.	当传入参数意义和数量确定时，避免使用不确定参数…，从而避免混淆和性能降低 
		5.	在设计和调用不确定参数函数时，注意：
			a)	nil值的传入请显式使用 
			b)	在函数实现内部，请用select(‘#’,…)获取实际传入的参数个数，而不要用#{…}的方式 
			c)	unpack实际传入的参数table时，请使用unpack的后两个参数unpack(args,1,n) 
		6. 	任何条件分支、循环语句都只能有一行代码(**针对编码2年以上程序**) 
		eg:
			function fn(...)
				local args 	 = {...}
				local realN  = select('#', ...) 	-- output:6
				local wrongN = #args  				-- output:2
				print(realN)
				print(wrongN)
				return unpack(args, 1, realN)
			end
 			print(fn(1, 2, nil, nil, nil, 6)) 		-- output:1,2,nil,nil,nil,6 


	1.8	回调函数使用规范 
		当函数A作为函数B的参数时，如果函数B只有一个参数，那么在调用函数B时把函数A作为函数B的参数时，直接在参数处写出函数A的实现；否则，应单独的实现回调函数，并显式地调用。
		（注：在前一种情况中，若回调函数可以被重用，则也单独实现回调函数）
		eg1:
		 	_app:onMouseDown(
		 		function(_, x, y)
		 			pickRay = _rd:buildRay(x, y)
		 			result 	= scene:pick(
		 				_Vector3.new(pickRay.x1, pickRay.y1, pickRay.z1),
		 				_Vector3.new(pickRay.x2, pickRay.y2, pickRay.z2))
		 			print(result)
		 			if result then 
		 				isLeftDown = true
		 				pickedNode = result.node
		 			end
		 		end
		 	)
		eg2:
			-- 处理事件[连接网络] 
			local function onConnect(net) 
				print("Connected", net) 
			end 
			-- 处理事件[关闭网络]
			local function onClose(net) 
				print("Closed", net) 
			end 

			-- 创建连接
			local conn = _connect("localhost:8080", onConnect, onClose)


	1.9	注释和逻辑分段规范
		统一使用 -- 来注释，-- 前后加空格；统一采用中文注释。
		eg:
		 	return nil -- 未找到(正确)
		 	return nil --未找到(错误)
		 	return nil-- 未找到(错误)


2.注释
	2.1	文件开始处应该有注释，说明文件作用。
		link:
 			参考文件：注释模板-文件头.lua


	2.2	不同功能代码段之间使用空行分隔，在接口函数和重要内部函数前部按LuaDoc风格注释，标明该函数的：作用（用多个'---'分隔）、参数(#param)、返回值(#return)、
		用法(#Useage)、关联函数(#Refer)、参考文档(#See)等；其中作用、参数、返回值必须写，用法和关联函数部分可选。
			link:
				注释模板-方法[插件].lua
				注释模板-方法[项目].lua
			eg:
 			-- 处理私有方法
			local function doPrivateMethod()

			end

 			-- 处理成员方法
			function M:doMemberMethod()

			end


	2.3	文件声明常量，通常命名为const或constant。
			link:
				注释模板-常量.lua


3.排版
	3.1	相对独立的程序块之间、变量说明之后必须加空行。
	eg:
		-- 不符合规范 
		if not isValidNi(ni) then 
		    ... -- program code 
		end 
		index = arrayObjects:objectAtIndex(index).objectIndex -- do something else 
		word  = data:objectAtIndex(index).someWord 
		 
		-- 符合规范 
		if not isValidNi(ni) then 
		    ... -- program code 
		end 
		 
		index = arrayObjects:objectAtIndex(index).objectIndex -- do something else 
		word  = data:objectAtIndex(index).someWord 
	

	3.2	循环、判断等语句中若有较长的表达式或语句，则要进行适应的划分，长表达式要在低优先级操作符处划分新行，操作符放在新行之首。
	eg:
		if (taskNo < TASK_NO_MAX) and 
		   (taskDate > TASK_DATE_MIN) and 
		   (TASK_ITEM_STATUS_VALID(statItem)) then
		    ... -- program code 
		end
		 
		for id, member in ipairs(BufferMembership.sort().keySet() or
			BackupVIPMap.keySet()) do
			... -- program code 
		end 
		 
		while (i < firstWordLength) and (j < secondWordLength) and
			  (not readToEnd()) do 
		    ... -- program code  
		end


	3.3	if、for、do、while、case、switch、default等语句自占一行。
	eg:
		-- 不符合规范
		if isUserNotAvailable() then return end

		-- 符合规范 
		if isUserNotAvailable() then
		    return
		end


	3.4	if、for、while、switch 等与后面的括号间应加空格，使 if 等关键字更为突出、明显。
	eg:
		if a >= b and c > d then 
		    ... -- program code  
		end


	3.5	逗号在后面加空格。
	eg:
		local a, b, c


	3.6	声明变量时未赋值的多个变量可以同行编写，一旦涉及某个变量赋值，则需要分行编写
	eg:
	    -- 不符合规范
	    local objectIndex = objectIndex + 10, stuffCount = stuffCount + 20
	    -- 符合规范
		local objectIndex = objectIndex + 10
		local stuffCount  = stuffCount  + 20


	3.7	除负号(-)以外的所有运算符前后要加1个空格
	eg:
		local var = (-5 * n) + 2 * math.pow(10, -17) / (1 + 100 + 1000) + 20


	3.8	空行可以将代码片段更好的区隔开，以便开发者能够更好的理解代码意图，方便再一次Review时快速定位所要查找的功能点。
		(1).lua中的空行
		    [1]文件说明与头文件下代码之间空1行
		    [2]文件块(参看文档:注释模板-代码块.lua)之间空8行。
		    [3]类文件块与公共参数文件块之间空2行。(关联[2]，特殊!)
		    [4]文件结尾如果有return，则在return前空三行；没有return，则结尾不空行。
		(2)方法里面的空行
		    [1]变量声明后需要空1行，如果需要分类区别，各类别之间空1行。
		    [2]条件、循环，选择语句，整个语句结束，需要空1行。
		    [3]各功能快之间空1行。
		    [4]最后一个括弧之前不空行。
		    [5]注释与代码之间不空行。
		    [6]方法注释之前空1行。
		    [7]方法function() end里面，不空行开始声明对象成员，如果需要分类区别，各类别之间空1行。
		    [8]构造方法function ctor() end内，不空行书写先书写参数赋值属性，再空2行书写对象属性，如果需要分类区别，各类别之间空3行。
		    [9]方法与方法之间空1行。


4.标识符命名
	4.1	标识符的命名要清晰、明了，有明确含义，同时使用完整的单词或大家基本可以理解的缩写，避免使人产生误解。 
		说明：较短的单词可通过去掉“元音"形成缩写；较长的单词可取单词的头几个字母形成缩写；一些单词有大家公认的缩写。 
		eg:
		-- 如下单词的缩写能够被大家基本认可。 
		temp 		缩写为:  tmp
		flag 		缩写为:  flg
		statistic 	缩写为:  stat
		increment 	缩写为:  inc
		message  	缩写为:  msg


	4.2	命名中若使用特殊约定或缩写，则要有注释说明。 
		说明：应该在源文件的开始之处，对文件中所使用的缩写或约定，特别是特殊的缩写，进行必要的注释说明。


	4.3	自己特有的命名风格，要自始至终保持一致，不可来回变化。 
		说明：个人的命名风格，在符合所在项目组或产品组的命名规则的前提下，才可使用。（即命名规则中没有规定到的地方才可有个人命名风格）。


	4.4	在同一软件产品内，应规划好接口部分标识符（变量、结构、方法及常量）的命名，防止编译、链接时产生冲突。 
		说明：对接口部分的标识符应该有更严格限制，防止冲突。如可规定接口部分的变量与常量之前加上“模块"标识等。(在不同模块间定义常量的划分尤为重要.)


	4.5	用正确的反义词组命名具有互斥意义的变量或相反动作的方法等。 
		说明：下面是一些在软件中常用的反义词组。 
		eg:
			add / remove       begin / end        create / destroy  
			insert / delete    first / last       get / release 
			increment / decrement                 put / get 
			add / delete       lock / unlock      open / close 
			min / max          old / new          start / stop 
			next / previous    source / target    show / hide 
			send / receive     source / destination 
			cut / paste        up / down 
		
		code:
			local minSum
			local maxSum
			function addUser(userName) end
			function deleteUser(userName) end


## 进阶阶段 ## 

5.可读性
	5.1	避免使用不易理解的数字，用有意义的标识来替代。涉及物理状态或者含有物理意义的常量，不应直接使用数字，必须用有意义的枚举来代替。 
	eg:
 		-- 如下的程序可读性差。 
		if trunks:objectAtIndex(index).trunkState == 0 then 
		    trunks:objectAtIndex(index). trunkState = 1
		    ...  -- program code 
		end 
		 
		-- 应改为如下形式。 
		local TRUNK_IDLE = 0
		local TRUNK_BUSY = 1
		 
		if trunks:objectAtIndex(index).trunkState == TRUNK_IDLE then 
			trunks:objectAtIndex(index).trunkState = TRUNK_BUSY
			...  -- program code 
		end 


	5.2	源程序中关系较为紧密的代码应尽可能相邻。 
		说明：便于程序阅读和查找。 
	eg:
		-- 以下代码布局不太合理。 
		rect.length = 10 
		charPoi 	= str 
		rect.width 	= 5 
		 
		-- 若按如下形式书写，可能更清晰一些。
		rect.length = 10 
		rect.width 	= 5 	-- 矩形的长与宽关系较密切，放在一起。 
		charPoi 	= str

	5.3	不要使用难懂的技巧性很高的语句，除非很有必要时。 
		说明：高技巧语句不等于高效率的程序，实际上程序的效率关键在于算法。 
	eg:
		-- 如下表达式，考虑不周就可能出问题，也较难理解。 
		statPoi = var or 1 << 2 
		 
		-- 应分别改为如下。 
		statPoi = ifnil(var, 4)


6.方法、过程
	6.1	函数行数不能超过20行（包括注释） 
	6.2	一个方法仅完成一件功能（进阶要求） 
	6.3	不要设计多用途面面俱到的方法
		说明：多功能集于一身的方法，很可能使方法的理解、测试、维护等变得困难。
	6.4	检查方法所有参数输入的有效性。尽量在方法顶端做过滤, 尽量将出错的风险减少到最少。
		说明：方法的输入主要有两种：
			一种是参数输入。
			一种是全局变量、数据文件的输入，即非参数输入。
			方法在使用输入之前，应进行必要的检查。(在框架中, 用J/UAssert进行断言验证)
	6.5	方法名应准确描述方法的功能。 
	6.6	避免使用无意义或含义不清的动词为方法命名。 
		说明：避免用含义不清的动词如 process、handle 等为方法命名，因为这些动词并没有说明要具体做什么。 
	6.7	让方法在调用点显得易懂、容易理解。方法的返回值要清楚、明了，让使用者不容易忽视错误情况。
		说明：方法的每种出错返回值的意义要清晰、明了、准确，防止使用者误用、理解错误或忽视错误返回码。
	6.8	在调用方法填写参数时，应尽量减少没有必要的默认数据类型转换或强制数据类型转换。 
		说明：因为数据类型转换或多或少存在危险。
	6.9	避免方法中不必要语句，防止程序中的垃圾代码。
		说明：程序中的垃圾代码不仅占用额外的空间，而且还常常影响程序的功能与性能，很可能给程序的测试、维护等造成不必要的麻烦。
	6.10 如果多段代码重复做同一件事情，那么在方法的划分上可能存在问题。能够抽取共用方法则抽取, 以免后期维护困难
		说明：若此段代码各语句之间有实质性关联并且是完成同一件功能的，那么可考虑把此段代码构造成一个新的方法。
	6.11 设计高扇入、合理扇出（小于7）的方法。
		说明：扇出是指一个方法直接调用（控制）其它方法的数目，而扇入是指有多少上级方法调用它。 
		扇出过大，表明方法过分复杂，需要控制和协调过多的下级方法；而扇出过小，如总是 1，表明方法的调用层次可能过多，这样不利程序阅读和方法结构的分析，并且程序运行时会对系统资源如堆栈空间等造成压力。
		方法较合理的扇出（调度方法除外）通常是 3-5。扇出太大，一般是由于缺乏中间层次，可适当增加中间层次的方法。扇出太小，可把下级函数进一步分解多个方法，或合并到上级方法中。
		当然分解或合并方法时，不能改变要实现的功能，也不能违背方法间的独立性。 扇入越大，表明使用此方法的上级方法越多，这样的方法使用效率高，但不能违背方法间的独立性而单纯地追求高扇入。
		公共模块中的方法及底层方法应该有较高的扇入。 较良好的软件结构通常是顶层方法的扇出较高，中层方法的扇出较少，而底层方法则扇入到公共模块中。
	6.12 减少方法本身或方法间的递归调用。
		说明：递归调用特别是方法间的递归调用（如 A->B->C->A），影响程序的可理解性；递归调用一般都占用较多的系统资源（如栈空间）；递归调用对程序的测试有一定影响。故除非为某些算法或功能的实现方便，应减少没必要的递归调用。
	6.13 改进模块中方法的结构，降低方法间的耦合度，并提高方法的独立性以及代码可读性、效率和可维护性。优化方法结构时，要遵守以下原则： 
		（1）不能影响模块功能的实现。 
		（2）仔细考查模块或方法出错处理及模块的性能要求并进行完善。 
		（3）通过分解或合并方法来改进软件结构。 
		（4）考查方法的规模，过大的要进行分解。 
		（5）降低方法间接口的复杂度。 
		（6）不同层次的方法调用要有较合理的扇入、扇出。 
		（7）方法功能应可预测。 
		（8）提高方法内聚。（单一功能的方法内聚最高） 
		说明：对初步划分后的方法结构应进行改进、优化，使之更为合理。
	6.14 使用动宾词组为执行某操作的方法命名。如果是OOP方法，可以只有动词（名词是对象本身）。 
		eg:
		-- 参照如下方式命名方法
	    function printRecord(recInd) end 
	    function inputRecord() end 
	    function getCurrentColor() end 


	6.15 为简单功能编写方法。 
		说明：虽然为仅用一两行就可完成的功能去编方法好象没有必要，但用方法可使功能明确化，增加程序可读性，亦可方便维护、测试。 
		eg:
			-- 如下语句的功能不很明显
			value = ((a > b) and a) or b
			 
			-- 改为如下就很清晰了。 
			function max(a, b)
			    return ((a > b) and a) or b
			end
			value = max(a, b) 


	6.16 防止把没有关联的语句放到一个方法中。 
		说明：防止方法或过程内出现随机内聚。随机内聚是指将没有关联或关联很弱的语句放到同一个方法或过程中。
		随机内聚给方法或过程的维护、测试及以后的升级等造成了不便，同时也使方法或过程的功能不明确。
		使用随机内聚方法，常常容易出现在一种应用场合需要改进此方法，而另一种应用场合又不允许这种改进，从而陷入困境。
		在编程时，经常遇到在不同方法中使用相同的代码，许多开发人员都愿把这些代码提出来，并构成一个新方法。
		若这些代码关联较大并且是完成一个功能的，那么这种构造是合理的，否则这种构造将产生随机内聚的方法。 
		eg:
			-- 如下方法就是一种随机内聚。 
		   	function initVar()
			    Rect.length = 0 
			    Rect.width 	= 0 	-- 初始化矩形的长与宽
			     
			    Point.x 	= 10 
			    Point.y 	= 10    -- 初始化“点"的坐标
			end 
			
			矩形的长、宽与点的坐标基本没有任何关系，故以上方法是随机内聚。 
			-- 应如下分为两个方法： 
		   	function initVar()
			    Rect.length = 0 
			    Rect.width 	= 0  	-- 初始化矩形的长与宽
			end
			 
			function initPoint()
			    Point.x 	= 10 
				Point.y 	= 10   	-- 初始化“点"的坐标
			end


7.程序效率
	7.1	编程时要经常注意代码的效率。 
		说明：代码效率分为全局效率、局部效率、时间效率及空间效率。全局效率是站在整个系统的角度上的系统效率；局部效率是站在模块或方法角度上的效率；
		时间效率是程序处理输入任务所需的时间长短；空间效率是程序所需内存空间，如机器代码空间大小、数据空间大小、栈空间大小等。
	7.2	在保证软件系统的正确性、稳定性、可读性及可测性的前提下，提高代码效率。
		说明：不能一味地追求代码效率，而对软件的正确性、稳定性、可读性及可测性造成影响。 
	7.3	循环体内工作量最小化。 
		说明：应仔细考虑循环体内的语句是否可以放在循环体之外，使循环体内工作量最小，从
		而提高程序的时间效率。 
		eg:
			-- 如下代码效率不高。 
			for i = 1, MAX_ADD_NUMBER do
			    sum = sum + ind
			    back_sum = sum 	-- backup sum
			end
			 
			-- 语句“back_sum = sum;"完全可以放在 for 语句之后，如下。 
			for i = 1, MAX_ADD_NUMBER do
			    sum = sum + ind
			end
			back_sum = sum 	-- backup sum
	7.4	不应花过多的时间拼命地提高调用不很频繁的方法代码效率。 
		说明：对代码优化可提高效率，但若考虑不周很有可能引起严重后果。
	7.5	在保证程序质量的前提下，通过压缩代码量、去掉不必要代码以及减少不必要的局部和全局变量，来提高空间效率。 
		说明：这种方式对提高空间效率可起到一定作用，但往往不能解决根本问题。
	7.6	在多重循环中，应将最忙的循环放在最内层。 
		说明：减少 CPU 切入循环层的次数。 
		eg:
			-- 如下代码效率不高。
			for row = 1, 100 do
			 	for col = 1, 5 do 
			 		sum = sum + data[row][col]
			 	end 
			end 
			 
			-- 可以改为如下方式，以提高效率。 
			for col = 1, 5 do
			 	for row = 1, 100 do
			 		sum = sum + data[row][col]
			 	end
			end 
		说明: 尽量减少循环嵌套层次。
	7.7	避免循环体内含判断语句，应将循环语句置于判断语句的代码块之中。 
		说明：目的是减少判断次数。循环体中的判断语句是否可以移到循环体外，要视程序的具体情况而言，一般情况，与循环变量无关的判断语句可以移到循环体外，而有关的则不可以。 
		eg:
			-- 如下代码效率稍低。
			for i = 1, MAX_RECT_NUMBER do 
			    if dataType == RECT_AREA then 
			        areaSum = areaSum + rectArea[ind] 
			    else 
			        rectLengthSum = rectLengthSum + rect[ind].length 
			        rectWidthSum  =  rectWidthSum + rect[ind].width 
			    end 
			end 
			 
			-- 因为判断语句与循环变量无关，故可如下改进，以减少判断次数。 
			if dataType == RECT_AREA then 
				for i = 1, MAX_RECT_NUMBER do 
			        areaSum = areaSum + rectArea[ind] 
			    end 
			else 
				for i = 1, MAX_RECT_NUMBER do
			        rectLengthSum = rectLengthSum + rect[ind].length
			        rectWidthSum  =  rectWidthSum + rect[ind].width
			    end
			end 
	7.8	尽量用乘法或其它方法代替除法，特别是浮点运算中的除法。 
		说明：浮点运算除法要占用较多 CPU 资源。 
		eg:
			-- 如下表达式运算可能要占较多 CPU 资源。 
			local PAI 	 = 3.1416 
			local radius = circleLength / (2 * PAI) 
			 
			-- 应如下把浮点除法改为浮点乘法。 
			local PAI_RECIPROCAL = (1 / 3.1416) -- 解释器解释时，将生成具体浮点数 
local radius = circleLength * PAI_RECIPROCAL / 2