function arr_except_first(arr)
	return table.unpack(arr,2,#arr)
end
print(arr_except_first({"a","b","c"}))
