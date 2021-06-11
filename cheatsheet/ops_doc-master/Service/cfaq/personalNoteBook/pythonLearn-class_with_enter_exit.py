# "with" statement call flow:  __init__  ,   __enter__ (setup) ,   __exit__ (teardown)


class CountFromBy(): #default derive from object
    def __init__(self, start:int = 0, step:int = 1) -> None:
        self.num = start
        self.step = step
        print('init')
        
    def increase(self) -> None:
        self.num += self.step
        print('increase')

    def __enter__(self) -> object:
        print('enter')
        return self

    def __exit__(self, exc_type, exc_value, exc_trace) -> None:
        print('exit')
        

if __name__ == '__main__':
    with CountFromBy(start = 10, step = 5) as c: # c is return value of __enter__()
        c.increase()
        print(c.num)
    
    
    
///////////////////output:
init
enter
increase
15
exit
