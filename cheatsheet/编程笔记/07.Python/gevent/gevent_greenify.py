
gevent 目前只能针对纯 python 打补丁，遇到 C 语言写的库(如 MySQLdb 等等)无能为力。
而现在 greenify 库针对这方面作了改善，允许 C 语言库也打上补丁：

https://github.com/douban/greenify


用法如：

import greenify
greenify.greenify()

assert greenify.patch_lib('/usr/lib/libmemcached.so') # 必须这样给 C 语言库打上补丁，后面才可以用


from gevent import monkey
monkey.patch_all() # greenify 打上补丁之后， gevent 就可以正常使用

# 下面跟 gevent 一样用法
...
