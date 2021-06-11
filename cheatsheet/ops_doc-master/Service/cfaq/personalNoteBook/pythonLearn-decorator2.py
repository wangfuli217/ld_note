

class Callable:
    def __init__(self, func):#initialize obj
        self.func = func
        print('_init_')

    def __new__(cls, func): #allocate memory for obj
        print('_new_')
        return super().__new__(cls)

        
    def __call__(self, *args, **kwargs): #this method make obj callable
        print('_call_ ',end='')
        return self.func(*args, **kwargs)

@Callable      #define a global obj,same name with foo:  foo = Callable(foo)
def foo(n:int):     
    print(' foo',n)
    



if __name__ == '__main__':
    print('main')
    for i in range(3):
        foo(i) # == foo.__call__()

        
    
        

///////////////////////output:
_new_
_init_
main
_call_  foo 0
_call_  foo 1
_call_  foo 2

