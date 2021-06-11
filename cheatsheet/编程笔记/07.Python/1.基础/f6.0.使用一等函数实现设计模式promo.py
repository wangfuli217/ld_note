符合模式并不表示做得对。
虽然设计模式与语言无关，但这并不意味着每一个模式都能在每一门语言中使用。

策略模式
    定义一系列算法，把它们一一封装起来，并且使它们可以相互替换。本模式使得算法可以独立于使用它的客户而变化。
    
    from abc import ABC, abstractmethod 
    from collections import namedtuple
    
    Customer = namedtuple('Customer', 'name fidelity')
    class LineItem: 
        def __init__(self, product, quantity, price): 
            self.product = product 
            self.quantity = quantity 
            self.price = price 
    
        def total(self): 
            return self.price * self.quantity
        
    class Order:  # 上下文 
        def __init__(self, customer, cart, promotion=None): 
            self.customer = customer 
            self.cart = list(cart) 
            self.promotion = promotion 
    
        def total(self): 
            if not hasattr(self, '__total'):
                self.__total = sum(item.total() for item in self.cart) 
            return self.__total 
 
        def due(self): 
            if self.promotion is None: 
                discount = 0 
            else: 
                discount = self.promotion.discount(self) 
            return self.total() - discount 
    
        def __repr__(self): 
            fmt = '<Order total: {:.2f} due: {:.2f}>' 
            return fmt.format(self.total(), self.due()) 
            
# 把Promotion 定义为抽象基类（Abstract Base Class，ABC），这么做是为了使用@abstractmethod 装饰器，从而明确表明所用的模式。
    class Promotion(ABC):  # 策略：抽象基类 
        @abstractmethod 
        def discount(self, order): 
            """返回折扣金额（正值）""" 
 
 
    class FidelityPromo(Promotion):  # 第一个具体策略 
        """为积分为1000或以上的顾客提供5%折扣""" 
        def discount(self, order): 
            return order.total() * .05 if order.customer.fidelity >= 1000 else 0 
    
    
    class BulkItemPromo(Promotion):  # 第二个具体策略 
        """单个商品为20个或以上时提供10%折扣""" 
        def discount(self, order): 
            discount = 0 
            for item in order.cart: 
                if item.quantity >= 20: 
                    discount += item.total() * .1 
            return discount 
    
    class LargeOrderPromo(Promotion):  # 第三个具体策略 
        """订单中的不同商品达到10个或以上时提供7%折扣""" 
    
        def discount(self, order): 
            distinct_items = {item.product for item in order.cart} 
            if len(distinct_items) >= 10: 
                return order.total() * .07 
            return 0
            
>>> joe = Customer('John Doe', 0)  # 两个顾客：joe 的积分是0，ann 的积分是1100。 
>>> ann = Customer('Ann Smith', 1100) 
>>> cart = [LineItem('banana', 4, .5),  # 有三个商品的购物车 
...         LineItem('apple', 10, 1.5), 
...         LineItem('watermellon', 5, 5.0)] 
>>> Order(joe, cart, FidelityPromo())  # fidelityPromo 没给joe 提供折扣 
<Order total: 42.00 due: 42.00> 
>>> Order(ann, cart, FidelityPromo())  # ann 得到了5% 折扣，因为她的积分超过1000。 
<Order total: 42.00 due: 39.90> 
>>> banana_cart = [LineItem('banana', 30, .5),  # banana_cart 中有30把香蕉和10个苹果。 
...                LineItem('apple', 10, 1.5)] 
>>> Order(joe, banana_cart, BulkItemPromo())  # BulkItemPromo 为joe 购买的香蕉优惠了1.50 美元。 
<Order total: 30.00 due: 28.50> 
>>> long_order = [LineItem(str(item_code), 1, 1.0)  # long_order中有10个不同的商品，每个商品的价格为1.00 美元。 
...               for item_code in range(10)] 
>>> Order(joe, long_order, LargeOrderPromo())  # LargerOrderPromo为joe 的整个订单提供了7% 折扣。 
<Order total: 10.00 due: 9.30> 
>>> Order(joe, cart, LargeOrderPromo()) 
<Order total: 42.00 due: 42.00>


    from collections import namedtuple 
    Customer = namedtuple('Customer', 'name fidelity') 
    
    
    class LineItem: 
    
        def __init__(self, product, quantity, price): 
            self.product = product 
            self.quantity = quantity 
            self.price = price 
    
        def total(self): 
            return self.price * self.quantity 
    
    
    class Order:  # 上下文 
    
        def __init__(self, customer, cart, promotion=None): 
            self.customer = customer 
            self.cart = list(cart) 
            self.promotion = promotion 
    
        def total(self): 
            if not hasattr(self, '__total'): 
                self.__total = sum(item.total() for item in self.cart) 
            return self.__total 
    
        def due(self): 
            if self.promotion is None: 
                discount = 0 
            else: 
                discount = self.promotion(self)  # 计算折扣只需调用self.promotion()函数。 
            return self.total() - discount 
    
        def __repr__(self): 
            fmt = '<Order total: {:.2f} due: {:.2f}>' 
            return fmt.format(self.total(), self.due()) 
    
    # 没有抽象类
    
    def fidelity_promo(order):  # 各个策略都是函数。 
        """为积分为1000或以上的顾客提供5%折扣""" 
        return order.total() * .05 if order.customer.fidelity >= 1000 else 0 
    
    
    def bulk_item_promo(order): 
        """单个商品为20个或以上时提供10%折扣""" 
        discount = 0 
        for item in order.cart: 
            if item.quantity >= 20: 
                discount += item.total() * .1 
        return discount
    def large_order_promo(order): 
        """订单中的不同商品达到10个或以上时提供7%折扣""" 
        distinct_items = {item.product for item in order.cart} 
        if len(distinct_items) >= 10: 
            return order.total() * .07 
        return 0
        
>>> joe = Customer('John Doe', 0)  ➊ 
>>> ann = Customer('Ann Smith', 1100) 
>>> cart = [LineItem('banana', 4, .5), 
...         LineItem('apple', 10, 1.5), 
...         LineItem('watermellon', 5, 5.0)] 
>>> Order(joe, cart, fidelity_promo) # 为了把折扣策略应用到Order 实例上，只需把促销函数作为参数传入。 
<Order total: 42.00 due: 42.00> 
>>> Order(ann, cart, fidelity_promo) 
<Order total: 42.00 due: 39.90> 
>>> banana_cart = [LineItem('banana', 30, .5), 
...                LineItem('apple', 10, 1.5)] 
>>> Order(joe, banana_cart, bulk_item_promo)  # 这个测试和下一个测试使用不同的促销函数 
<Order total: 30.00 due: 28.50> 
>>> long_order = [LineItem(str(item_code), 1, 1.0) 
...               for item_code in range(10)] 
>>> Order(joe, long_order, large_order_promo) 
<Order total: 10.00 due: 9.30> 
>>> Order(joe, cart, large_order_promo) 
<Order total: 42.00 due: 42.00>

# best_promo函数计算所有折扣，并返回额度最大的
>>> Order(joe, long_order, best_promo) # best_promo为顾客joe 选择larger_order_promo。 
<Order total: 10.00 due: 9.30> 
>>> Order(joe, banana_cart, best_promo)  # 订购大量香蕉时，joe 使用bulk_item_promo 提供的折扣
<Order total: 30.00 due: 28.50> 
>>> Order(ann, cart, best_promo)  # 在一个简单的购物车中，best_promo为忠实顾客ann 提供fidelity_promo优惠的折扣。 
<Order total: 42.00 due: 39.90>

promos = [fidelity_promo, bulk_item_promo, large_order_promo]  # promos列出以函数实现的各个策略。
 
def best_promo(order):  # 与其他几个*_promo 函数一样，best_promo函数的参数是一个Order 实例。
    """选择可用的最佳折扣 
    """ 
    return max(promo(order) for promo in promos) # 使用生成器表达式把order 传给promos列表中的各个函数，返回折扣额度最大的那个函数。
    
    
globals()
    返回一个字典，表示当前的全局符号表。这个符号表始终针对当前模块
    内省模块的全局命名空间，构建promos列表
    
    promos = [globals()[name] for name in globals()  # 迭代globals() 返回字典中的各个name。
            if name.endswith('_promo')  # 只选择以_promo结尾的名称。 
            and name != 'best_promo']   # 过滤掉best_promo自身，防止无限递归 
 
    def best_promo(order): 
        """选择可用的最佳折扣 
        """ 
        return max(promo(order) for promo in promos)  # best_promo内部的代码没有变化
        
内省单独的promotions模块，构建promos列表
    promos = [func for name, func in 
                inspect.getmembers(promotions, inspect.isfunction)] 
 
    def best_promo(order): 
        """选择可用的最佳折扣 
        """ 
        return max(promo(order) for promo in promos)
inspect.getmembers函数用于获取对象（这里是promotions模块）的属性，第二个参数是
可选的判断条件（一个布尔值函数）。我们使用的是inspect.isfunction，只获取模块中的
函数。
        

装饰器
    promos = []  # promos列表起初是空的。 
 
def promotion(promo_func):  # promotion 把promo_func添加到promos列表中，然后原封不动地将其返回。 
    promos.append(promo_func) 
    return promo_func 
 
@promotion  # 被@promotion装饰的函数都会添加到promos列表中。 
def fidelity(order): 
    """为积分为1000或以上的顾客提供5%折扣""" 
    return order.total() * .05 if order.customer.fidelity >= 1000 else 0 
 
@promotion 
def bulk_item(order): 
    """单个商品为20个或以上时提供10%折扣""" 
    discount = 0 
    for item in order.cart: 
        if item.quantity >= 20: 
            discount += item.total() * .1 
    return discount 
 
@promotion 
def large_order(order): 
    """订单中的不同商品达到10个或以上时提供7%折扣""" 
    distinct_items = {item.product for item in order.cart} 
    if len(distinct_items) >= 10: 
        return order.total() * .07 
    return 0 
 
def best_promo(order): # best_promos 无需修改，因为它依赖promos列表。 
    """选择可用的最佳折扣 
    """ 
    return max(promo(order) for promo in promos)