
local Table = {}

-- arranges elements in a dictionary that represents how many terms there are in a given table
-- tab the given table to be evaluated
-- for each number found, it will, at the number as index, add, or start at, 1 in the dictionary
Table.count = function(tab)
	local out = {}
	for i=1, #tab do
		out[tab[i]] = out[tab[i]] and out[tab[i]] + 1 or 1
	end
	return out
end

return Table
