--从大到小排序
function compare(x, y)
    return x > y --如果第一个参数大于第二个就返回true，否则返回false
end

a = { 1, 7, 3, 4, 25 }
table.sort(a) --默认从小到大排序
print(a[1], a[2], a[3], a[4], a[5])
table.sort(a, compare) --使用比较函数进行排序
print(a[1], a[2], a[3], a[4], a[5])
