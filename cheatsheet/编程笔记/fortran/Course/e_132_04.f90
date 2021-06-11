!-- character*100 who_am_i
!-- 在语句行最后加上续行符“&”号。如果字符串跨2行以上,则在续行的开始位置也要加&号。注意语句的有效字符是从“&”前和续行符“&”之后的位置算起。
abcdefghijklmnopqrstuvwxyz= &
         a+b+c+d+e+f+g+h+i+j+k+l+ &
         m+n+o+p+q+r+s+t+u+v+w+x+ &
         y+z; print *, abcdefghijklmnopqrstuvwxyz
who_am_i="我是谁？         1&
 &2       我是谁？"; print *, who_am_i        
end