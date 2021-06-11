--
-- Created by IntelliJ IDEA.
-- User: fxl
-- Date: 17/2/13
-- Time: 涓嬪崍11:06
-- To change this template use File | Settings | File Templates.
--

local count = 0

callbacks = {
    StartElement = function(parser,tagname,atts,array)
        io.write("+", string.rep(" ",count), tagname)
        for _,a in ipairs(array) do
            io.write(string.rep(" ",2 ),a,"=",atts[a]," ")
        end
        io.write("\n")
        count = count + 1
    end,
    ChatacterData = function(parser,content)
        io.write(string.rep(" ",count), content,"\n")
    end,
    EndElement   = function(parser,tagname)
        count = count - 1
        io.write("-", string.rep(" ",count), tagname, "\n")
    end
}
local lxp = require("lxp")
local p = lxp.new(callbacks)

p:parse("<p name=\"a\" t=\"1\">haha</p>")
p:close()