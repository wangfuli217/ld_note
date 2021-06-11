local function findline(sv)
	local s,e,w=string.find(sv.line,"(%w+)",sv.pos + 1)
	while s ~= nil do
		pos = e
		if sv.tbl[w] == nil then
			sv.tbl[w] = 0
			sv.pos = e
			return w
		end
		s,e,w=string.find(sv.line,"(%w+)",pos+1)
	end
end

local function iter(sv)
	local w = findline(sv)
	if w~=nil then return w end
	local line = sv.f:read("*L")
	while line ~= nil do
		sv.line = line
		sv.pos = 1
		w = findline(sv)
		if w~=nil then return w end
	end
end

function uniquewords(file)
	local f = io.open(file,"r")
	local line=f:read("*L")
	local t = {
		f = f,
		pos=1,
		tbl={},
		line=line
	}
	return iter,t
end

local iterf,cv = uniquewords("/Users/fxl/Documents/workspace/programming_in_lua/7/test.txt")
for w in iterf,cv do
	print(w)
end
