local testupvalue = require 'testupvalue'
local func = testupvalue.newCounter()
print(func())
print(func())
print(func())