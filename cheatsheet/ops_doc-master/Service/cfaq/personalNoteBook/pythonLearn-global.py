#global and local variable, don't try to modify variable through parameter, it's better to change by return value.

#when you make an assignment to a variable in a scope, that variable becomes local and shadow other same-name varialbe in outer scope.


i = 1  #global i

def setValue():
    i = 2  #define local, hidden global i, global i not change.
    print('setValue')
    
def setValue2(i):
    i = 2  #not change extern i.  argument i refer to a new object(2), dettach with extern
    print('setValue')    

def setValue3():
    i = 3
    def sub():
        nonlocal i
        i = 4
    sub()
    print(i) #4 with nonlocal, 3 without nonlocal    
    
def add2(): 
    global i
    i = i + 1 #modify global value
    print('add2')

def add3(): 
    i = 2 #local , hidden global i
    i = i + 1
    print('add3')


def add4():
    i = i + 1 #UnboundLocalError: local variable 'i' referenced before assignment
    print('add4') 


lista = []

def append():
    lista.append(3) #modify global lista
    print('append',lista)

def append2():
    listb = lista.copy() #define local listb, or listb = lista[:] or listb = lista[::]
    listb.append(4) #not impact lista
    print('append2',lista, listb)

def append3(arg: list):
    arg.append(5) #modify extern list
    print('append3',lista, arg)

if __name__ == '__main__':
    setValue() #ok
    add2() #ok
    add3() #ok    
    append()#ok
    append2()#ok
    append3(lista)#ok
    #add4() #UnboundLocalError: local variable 'i' referenced before assignment
    
    

////////////////////////////////////output:
setValue
add2
add3
append [3]
append2 [3] [3, 4]
append3 [3, 5] [3, 5]

        

    
