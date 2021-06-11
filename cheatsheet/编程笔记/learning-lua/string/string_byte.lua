print(string.byte("abc", 1, 3))
print(string.byte("abc", 3)) -- 缺少第三个参数，第三个参数默认与第二个相同，此时为3
print(string.byte("abc")) --缺少第二个和第三个参数，此时这两个参数都默认为 1
