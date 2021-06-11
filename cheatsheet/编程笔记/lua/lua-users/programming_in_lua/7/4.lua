function iter(sv)
	local len= string.len(sv.str)
	if sv.e > len then
		sv.s=sv.s + 1
		sv.e=sv.s
	end
	if sv.s > len then
		return nil
	end

	while true do
		local s = string.sub(sv.str,sv.s,sv.e)
		if not string.match(s,"^%s+$") then
			sv.e=sv.e+1
			return s
		end
	end
end

function allsub(str)
	return iter,{str=str,s=1,e=1}
end

for s in allsub("abcdefg") do
	print(s)
end
