List={}
function List.new()
	return { first=0, last=-1 }
end

function List.pushfirst(list,value)
	list.first = list.first - 1
	list[list.first] = value
end

function List.popfirst(list)
	if list.first >= list.last then return nil end
	local old   = list.first
	list.first  = list.first + 1
	if list.first == list.last then
		list.first,list.last = 0,0
	end
	return list[old]
end

function List.pushlast(list,value)
	list.last = list.last + 1
	list[list.last] = value
end

function List.poplast(list)
	if list.last <= list.first then return nil end
	local old = list.last
	list.last = list.last - 1
	if list.first == list.last then
		list.first,list.last = 0,0
	end
	return list[old]
end

local l = List.new()
List.pushlast(l,1)
List.pushlast(l,2)
List.popfirst(l)
List.popfirst(l)
print(l.first, l.last)
