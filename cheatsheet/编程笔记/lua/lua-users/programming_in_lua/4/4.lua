local room1,room2,room3
function room1()
	local move = io.read()
	if move == "south" then
		return room3()
	elseif move == "east" then
		return room2()
	else
		print("invalid move")
		room1()
	end
end

function room2()
	local move = io.read()
	if move=="south" then
		return exit()
	elseif move == "west" then
		return room1()
	else
		print("invalid move")
		room2()
	end
end

function room3()
	local move = io.read()
	if move=="north" then
		return room1()
	elseif move == "east" then
		return exit()
	else
		print("invalid move")
		room3()
	end
end

function exit()
	print("Congratulations,you won!")
end
room1()
