local registrytest = require 'registrytest'
local func = registrytest.registry_func
func()
print(__G['key1'])