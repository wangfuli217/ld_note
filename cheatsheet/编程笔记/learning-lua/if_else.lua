x = 10
if x > 0 then
    print("x is a positive number")
end

x = 10
if x > 0 then
    print("x is a positive number")
else
    print("x is a non-positive number")
end

score = 90
if score == 100 then
    print("Very good! Your score is 100")
elseif score >= 60 then
    print("Congratulations, you have passed it,your score greater or equal to 60")
else
    print("Sorry, you do not pass the exam!")
end

score = 0
if score == 100 then
    print("Very good!Your score is 100")
elseif score >= 60 then
    print("Congratulations, you have passed it,your score greater or equal to 60")
else
    if score > 0 then
        print("Your score is better than 0")
    else
        print("My God, your score turned out to be 0")
    end --与上一示例代码不同的是，此处要添加一个end
end