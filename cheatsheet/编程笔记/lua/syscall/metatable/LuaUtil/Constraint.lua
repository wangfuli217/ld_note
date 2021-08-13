	
local Constraint = {}

-- returns a number that, if is greater than ma, ma, or less than m, m, else v
Constraint.constrain = function(m, v, ma)
	return v < m and m or v > ma and ma or v
end

-- returns a number that, if is in range of m to ma, returns a default number, d, else v
Constraint.avoid = function(m, v, ma, d)
	return (v >= m and v <= ma) and d or v
end

-- basic evaluations to each operation
local Constraint_metatable_constrain = {
		__add = function(self, v)
			self.Value = Constraint.constrain(self.Min, self.Value + v, self.Max)
			return self
		end;
		__mul = function(self, v)
			self.Value = Constraint.constrain(self.Min, self.Value * v, self.Max)
			return self
		end;
		__div = function(self, v)
			self.Value = Constraint.constrain(self.Min, self.Value / v, self.Max)
			return self
		end;
		__sub = function(self, v)
			self.Value = Constraint.constrain(self.Min, self.Value - v, self.Max)
			return self
		end;
		__mod = function(self, v)
			self.Value = Constraint.constrain(self.Min, self.Value % v, self.Max)
			return self;
		end;
	}

-- basic evaluations to each operation
local Constraint_metatable_avoid = {
		__add = function(self, v)
			self.Value = Constraint.avoid(self.Min, self.Value + v, self.Max, self.Default)
			return self
		end;
		__mul = function(self, v)
			self.Value = Constraint.avoid(self.Min, self.Value * v, self.Max, self.Default)
			return self
		end;
		__div = function(self, v)
			self.Value = Constraint.avoid(self.Min, self.Value / v, self.Max, self.Default)
			return self
		end;
		__sub = function(self, v)
			self.Value = Constraint.avoid(self.Min, self.Value - v, self.Max, self.Default)
			return self
		end;
		__mod = function(self, v)
			self.Value = Constraint.avoid(self.Min, self.Value % v, self.Max, self.Default)
			return self;
		end;
	}

-- returns a new Constraint object
-- if d == true, use the avoid metatable
Constraint.iLimit = function(m, va, ma, d)
	local this = {
		Min = m;
		Value = va;
		Max = ma;
		Default = d;
	}
	
	if(d) return setmetatable(this, Constraint_metatable_avoid)
	return setmetatable(this, Constraint_metatable_constrain)
end

return Constraint
