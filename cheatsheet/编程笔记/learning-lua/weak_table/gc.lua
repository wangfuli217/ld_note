a = {};
b = {};
setmetatable(a, b); -- 设置a为weak table
b.__mode = 'k';

key = {}; -- 增加"{}"内存块的一个引用 - key，引用数1
a[key] = 1; -- weak table引用不增引数，所以"{}"内存块的引数还为1
key = {} -- 改变key指向新增的"{}"内存块，上面的"{}"内存块引数减一为0
a[key] = 2 -- 如上上一样

collectgarbage(); -- 调用GC，清掉weak表中没有引用的内存

for k, v in pairs(a) do
    print(v); -- 只输出一个2
end