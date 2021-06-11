--[[
Copyright (c) 2012-2015 baby-bus.com
http://www.baby-bus.com/
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]

--[[!--
<<某某>>类，定义<<相关领域>>的公用操作方法及逻辑实现。
-   定义<<某某>>基础相关信息。
-   定义<<某某>>通用操作。
***************
- 使用示例：
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点
    U.loadNode():to(layer)
    ----------------------
    -- 示例2: 全API操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点
    U.loadNode({
    	anchor 		= D.LEFT_RIGHT,
    	x 			= 480,
    	y 			= 320,
		parent 		= layer,
        ...
    })
***************
- 发布信息： 
	v1.00.00 2014/12/01 AC
	v1.00.01 2014/12/02 Cailw
]]