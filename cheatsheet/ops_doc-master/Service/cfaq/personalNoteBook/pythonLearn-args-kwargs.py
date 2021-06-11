
def myfunc(*args): #accept any number args
    for a in args:
        print(a, end=' ; ')
    if args:
        print('\n','arg num = ',len(args))


def myfunc2(**kwargs): #accept any number key/value pairs
    for k,v in kwargs.items():
        print(k, v, sep='->', end=' ; ')
    if kwargs:
        print('\n','arg num = ',len(kwargs))

        
def myfunc3(*args,**kwargs):
    print('myfunc3: ')
    if args:
        for a in args:
            print(a, end = ' ; ')
        print()    
    if kwargs:
        for k,v in kwargs.items():
            print(k,v,sep='->',end=' ; ')
        print() 
        
        
        
if __name__ == '__main__':    
    paras = [1,2,3] #or paras = (1,2,3)
    myfunc(paras)
    myfunc(*paras)
    myfunc(4,5,6)
    config = {'name':'zeng',
              'sex' :'male'}
    myfunc2(**config)
    myfunc2(name = 'liang',age = 30)
    
    myfunc3(*paras, **config)

    
//////////////output:
[1, 2, 3] ; 
 arg num =  1
1 ; 2 ; 3 ; 
 arg num =  3
4 ; 5 ; 6 ; 
 arg num =  3
name->zeng ; sex->male ; 
 arg num =  2
name->liang ; age->30 ; 
 arg num =  2
myfunc3: 
1 ; 2 ; 3 ; 
name->zeng ; sex->male ; 
