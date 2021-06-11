simple_strtoull   string -> unsigned long long
simple_strtoul    string -> unsigned long 
simple_strtoll    string -> long long
simple_strtol     string -> long 
vsnprintf         format -> buffer
vscnprintf        format -> buffer
snprintf          format -> buffer
scnprintf         format -> buffer
vsprintf          format -> buffer
vprintf           format -> buffer
vbin_printf       bin -> buffer
bstr_printf       bin -> buffer
bprintf           bin -> buffer
vsscanf           string -> type
sscanf            string -> type
kstrtoull        string -> unsigned long long
kstrtoul         string -> unsigned long 
kstrtoll         string -> long long
kstrtol          string -> long 
kstrtouint       string -> unsigned int
kstrtoint        string -> int


strnicmp        长度有限的字符串比较，这里不区分大小写
strcpy          复制一个以NULL结尾的字符串
strncpy         复制一个以NULL结尾的有限长度字符串
strlcpy         复制一个以NULL结尾的有限长度字符串到缓冲区中
strcat          在字符串附加以NULL结尾的字符串
strncat         在字符串后附加以NULL结尾的一定长度的字符串
strlcat         在字符串后附加以NULL结尾的一定长度的字符串
strcmp          比较两个字符串
strncmp         比较两个限定长度的字符串
strchr          在字符串中查找第一个出现指定字符的位置
strrchr         在字符串中查找最后一个出现指定字符的位置
strnchr         在字符串中查找出现指定字符串的位置
skip_spaces     从字符中移除前置空格
strim           从字符串中移除前置以及后置空格
strlen          获得字符串长度
strnlen         获得一个有限长度字符串的长度
strspn          计算一个仅包含可接受字母集合的字符串的长度
strcspn         计算一个不包含可接受字母集合的字符串的长度
strpbrk         找到字符集合在字符串第一次出现的位置
strsep          分割字符串
sysfs_streq     字符串比较，用于sysfs
strtobool       用户输入转换成布尔值
memset          
memcpy          
memmove         
memcmp          
memscan         
strstr          
memchr          
memcr_inv       
