[root@localhost testLua]# g++ -g lua_thrad.c -ldl -llua
[root@localhost testLua]# ./a.out 
coroutine begin
stack value: 100,  hello c++,now stack size:2
3333 stack szie: 3
coroutine continue: from c++
C Stop Func: call c yield!
Stop func stack szie: 2
555 stack szie: 1
coroutine continue after yield
coroutine end