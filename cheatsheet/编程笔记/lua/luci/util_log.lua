-- 通过logread查看输出内容
-- https://github.com/seamustuohy/luci_tutorials/blob/master/06-debugging.md

local util = require "luci.util"

if type(logged_item) == "table" then 
  util.dumptable(logged_item) 
else 
  util.perror(logged_item) 
end