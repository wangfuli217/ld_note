function producer()
   return coroutine.create(function()
	 while true do
	    local x = io.read()
	    send(x) --produce a value for filter
	 end
   end)
end

function consumer(filter)
   while true do
      local x = receive(filter)
      io.write(x, "\n")
   end
end

function receive(prod)
   local status, value = coroutine.resume(prod)
   return value
end

function send(x)
   coroutine.yield(x)
end

function filter (prod)
   return coroutine.create(function()
	 for line = 1, math.huge do
	    local x = receive(prod)
	    x = string.format("%5d %s", line, x)
	    send(x) --produce a value for consumer
	 end
   end)
end

p = producer()
f= filter(p)
consumer(f)
