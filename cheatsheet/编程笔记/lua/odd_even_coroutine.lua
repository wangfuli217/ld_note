# /usr/bin/env lua

function odd(x)
   print('A: odd', x)
   coroutine.yield(x)
   print('B: odd', x)
 end

function even(x)
   print('C: even', x)
   if x==2 then return x end
   print('D: even ', x)
 end

co = coroutine.create(
   function (x)
     for i=1,x do
       if i==3 then coroutine.yield(-1) end
       if i % 2 == 0 then even(i) else odd(i) end
     end
   end)

count = 1
while coroutine.status(co) ~= 'dead' do
   print('----', count) ; count = count+1
   errorfree, value = coroutine.resume(co, 5)
   print('E: errorfree, value, status', errorfree, value, coroutine.status(co))
 end
-- ----    1
-- A: odd  1
-- E: errorfree, value, status     true    1       suspended
-- ----    2
-- B: odd  1
-- C: even 2
-- E: errorfree, value, status     true    -1      suspended
-- ----    3
-- A: odd  3
-- E: errorfree, value, status     true    3       suspended
-- ----    4
-- B: odd  3
-- C: even 4
-- D: even         4
-- A: odd  5
-- E: errorfree, value, status     true    5       suspended
-- ----    5
-- B: odd  5
-- E: errorfree, value, status     true    nil     dead