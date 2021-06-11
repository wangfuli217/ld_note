function serialize(i,o)
	local t = type(o)

	if t == "number" then
		io.write(o)
	elseif t == "string" then
		io.write(string.format("%q",o))
	elseif t == "table" then
		i=i+2
		io.write("{\n")
		for k,v in pairs(o) do
			io.write(string.rep(" ",i))
			io.write("  "..k.."=")
			serialize(i,v)
			io.write(",\n")
		end
		io.write(string.rep(" ",i))
		io.write("}\n")
		i=i-2
	else
		error("cannot serialize a " .. t)
	end
end
serialize(0,{a="aa",b=1,c={d="d"},e={f="f"}})
