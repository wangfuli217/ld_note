require "test_so" --指定包名称 2 3 
--在调用时，必须是package.function 
print(test_so.add(1.0,2.0))
print(test_so.sub(20.1,19))