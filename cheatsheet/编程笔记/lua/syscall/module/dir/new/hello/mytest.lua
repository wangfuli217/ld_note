local M = {}
local function test() print(123) end 
function M.test1() test() end 
function M.test2() M.test1(); M.test1() end 

return M
