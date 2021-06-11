integer function irue(i)
k = i / 2
k = k * 2
if (i .EQ. k) then
    irue = i
else
#ifdef ROUNDUP
    irue = i + 1
#else
    irue = i - 1 
#endif
end if
end function irue