local function iter(sv,cv)
    if cv < sv then
        return cv +1
    end
    return nil
end

local function fromto(n,m)
    return iter,m,n-1
end

for i in fromto(1,5) do
    print(i)
end
