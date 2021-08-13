
local Math = require("Math")

local Vector2 = {}

-- low 'float' precision linear interpolation
-- v is ending vector2
-- a is normalized distance ratio between point a and b
local Vector2_lerpl = function(self, v, a)
		return Vector2.new(
			Math.lerpl(self.X, v.X, a),
			Math.lerpl(self.Y, v.Y, a)
		)
	end

-- high 'double' precision linear interpolation
-- v is goal number
-- a is normalized distance ratio between point a and b
local Vector2_lerph = function(self, v, a)
		return Vector2.new(
			Math.lerph(self.X, v.X, a),
			Math.lerph(self.Y, v.Y, a)
		)
	end

-- returns a vector of length 1 (normalized unit)
local Vector2_unit = function(self)
		local mag = self.magnitude()
		return Vector2.new(self.X / mag, self.Y / mag)
	end

-- returns the length of a vector
local Vector2_magnitude = function(self)
		return Math.pythag(self.X, self.Y)
	end

-- returns analog cross product of a 2d vector
-- v the vector to cross with
local Vector2_across = function(self, v)
		return Vector2.new(self.X * v.Y - self.Y * v.X, v.Y * -v.X)
	end

-- returns cross product of a 2d vector
-- v the vector to cross with
local Vector2_cross = function(self, v)
		return self.X * v.Y - self.Y * v.X
	end

-- just standard operations that manipulate X and Y based off the operator being used
local Vector2_metatable = {
		__add = function(self, v)
			local t = type(v) == "number"
			self.X = self.X + (t and v or v.X)
			self.Y = self.Y + (t and v or v.Y)
			return self
		end;
		__sub = function(self, v)
			local t = type(v) == "number"
			self.X = self.X - (t and v or v.X)
			self.Y = self.Y - (t and v or v.Y)
			return self
		end;
		__mul = function(self, v)
			local t = type(v) == "number"
			self.X = self.X * (t and v or v.X)
			self.Y = self.Y * (t and v or v.Y)
			return self
		end;
		__div = function(self, v)
			local t = type(v) == "number"
			self.X = self.X / (t and v or v.X)
			self.Y = self.Y / (t and v or v.Y)
			return self
		end;
		__mod = function(self, v)
			local t = type(v) == "number"
			self.X = self.X % (t and v or v.X)
			self.Y = self.Y % (t and v or v.Y)
			return self
		end;
		__unm = function(self)
			self.X = -self.X
			self.Y = -self.Y
		end;
	}


-- creates a new vector2 object
Vector2.new = function(x, y)
	local this = {
		X = x or 0;
		Y = y or 0;
	}
	
	this.lerpl = Vector2_lerpl
	this.lerph = Vector2_lerph
	
	this.magnitude = Vector2_magnitude
	this.unit = Vector2_unit
	
	this.cross = Vector2_cross
	this.crossa = Vector2_crossa
	
	return setmetatable(this, Vector2_metatable)
end

return Vector2
