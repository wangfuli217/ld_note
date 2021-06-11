
from functools import wraps


def memorization(func: object) -> object:
    cache = {}
    @wraps(func)
    def wrapper(*args):
        v = cache.get(args, None)
        if v == None:
            cache[args] = func(*args)
        return cache[args]
    
    return wrapper
    

@memorization
def fibonacci(n: int) -> int:
    global count
    count += 1
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)



count = 0
if __name__ == '__main__':
    for i in range(10):
        num = fibonacci(i)
        print(i, num, sep='->',end=';')
    print('compute times: ',count)    

     
/////////////////////////////////////output:

#0->0;1->1;2->1;3->2;4->3;5->5;6->8;7->13;8->21;9->34;compute times:  10   with memorization
#0->0;1->1;2->1;3->2;4->3;5->5;6->8;7->13;8->21;9->34;compute times:  276  without memorization  
        

    
