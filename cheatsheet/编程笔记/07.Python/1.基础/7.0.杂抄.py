

变量的绑定时机
    ### 示例1,变量值中途被修改了 ####
    def create_multipliers():
        return [lambda x : i * x for i in range(5)]

    for multiplier in create_multipliers():
        print multiplier(2)

    # 期望打印值是: 0, 2, 4, 6, 8
    # 实际打印值是: 8, 8, 8, 8, 8

    '''
    解析,闭包的变量值,会被外部函数改变
    这示例实际使用时, i 的值随着外部改变,已经是最后一个值了,即 i= 4

    另外，由于 create_multipliers 函数比较难懂，这里写个易懂的等价函数来
    def create_multipliers():
        l = []
        for i in range(5):
            l.append(lambda x: i * x)
        return l
    '''

    ### 示例2,用传参把当时变量定型下来 ###
    def create_multipliers():
        return [lambda x, i=i : i * x for i in range(5)] # 定义 lambda 函数时,需要设定参数默认值，此时定下了参数值

    for multiplier in create_multipliers():
        print multiplier(2)


    ### 示例3,利用元组不能改变的特性把当时变量定型下来 ###
    def create_multipliers():
        return (lambda x: i * x for i in range(5))

    for multiplier in create_multipliers():
        print multiplier(2)


判断奇数
    # 经典的写法，对2求余
    if a % 2: print 'it is even'

    # 自然是使用位操作最快了
    if a & 1: print 'it is even'
