假设我们有一个文件叫mymod.lua，内容如下：
文件名：mymod.lua
local HaosModel = {}
 
local function getname()
    return "Hao Chen"
end
 
function HaosModel.Greeting()
    print("Hello, My name is "..getname())
end
 
return HaosModel

于是我们可以这样使用：
local hao_model = require("mymod")
hao_model.Greeting()

其实，require干的事就如下：（所以你知道为什么我们的模块文件要写成那样了）
local hao_model = (function ()
  --mymod.lua文件的内容--
end)()