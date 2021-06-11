local function iter(sv,cv)
    cv = cv+sv.s
    if cv > sv.m then return nil end
    return cv
end

local function fromto(n,m,s)
    return iter,{m=m,s=s},n-s
end

for i in fromto(1,5,1) do
    print(i)
end
