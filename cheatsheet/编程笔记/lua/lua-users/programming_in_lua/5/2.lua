function print_all(arr)
	local i=1
	while i<=#arr do
		print(table.unpack(arr,i,i))
		i=i+1
	end
end

print_all({"1","a","c","f","e"})
