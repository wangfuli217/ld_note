��1�����ַ�ƥ��

* 'x�� ƥ���ַ�x��

* '.�� ƥ������һ���ַ����ֽڣ������˻��з���

* '[xyz]�� ƥ�䵥���ַ�������ַ��Ƿ������и������ַ��ࣨcharacter class���е�һ����

* '[abj-oZ]�� ƥ�䵥���ַ�������ַ��Ƿ������и������ַ����е�һ��������һ��ʽ��������ָ���ַ���ʱ�õ���һ����Χ��ʾ����j-o�����ʾ����26��Ӣ����ĸ��˳�򣬴���ĸj��ʼһֱ����ĸo��6����ĸ��������ţ�-����ʾ��Χ��������ű���ҲҪ��Ϊһ��ƥ���ַ�ʱ�������ת���ַ���\��ȥ�������⺬�塣���ڻ����ţ�{}����ģʽ�������������֣��Լ���Ϊģʽ����֮��Ķ�����Action����������β�綨����������Ҫ���ַ�����ƥ�仨���ţ�������ת���ַ���\��ȥ�������⺬�塣����������Ӷ�����һ�����пɴ�ӡ�ַ����ַ��ࣺ

[[:alnum:][:blank:]]\t+\-*/&!_'?@^'~$\\()%|.;[\]\{\}:,#<>=]

* '[^A-Z]�� ƥ�䵥���ַ�������ַ������Ƿ������и����ַ���������ַ����ڷ������ڿ�ʼ����������ţ�^����ʾ�񶨡����ַ�^�����ַ���Ŀ�ʼ��ʱ�������������⺬�壬����һ����ͨ�ַ���

* '[^A-Z\n]�� ƥ�䵥���ַ�������ַ��������Ƿ������и������ַ����е��ַ�������һ��ʽ�Ĳ�ͬ���ڣ��������һ�����з���Ҳ����˵��ƥ����ַ�������26����д��ĸ��Ҳ�����ǻ��з���

����������������ڱ����ַ�����ʱ������ֱ�����ַ��Լ��ַ���Χ�������⣬����һ�ֽ����ַ������ʽ�ģ�Ҳ��ͬ�������ã�������һЩ����ʽ���£�

[:alnum:] [:alpha:] [:blank:] [:cntrl:] [:digit:] [:graph:]

[:lower:] [:print:] [:punct:] [:space:] [:upper:] [:xdigit:]

ÿһ������ʽ��ָʾ��һ���ַ����࣬�������������׼C����isXXXX�����ֶ�Ӧ�����磬[:alnum:]��ָʾ����Щ���ɺ���isalnum()���󷵻�true���ַ���Ҳ�����κε���ĸ�������֡�ע�⣬��Щϵͳ��û�и���C����isblank()�Ķ��壬����flex�Լ�������[:blank:]Ϊһ���ո����һ��tab��

�������ٵļ������ӣ����ǵȼ۵ģ�

[[:alnum:]]

[[:alpha:][:digit:]]

[[:alpha:]0-9]

[a-zA-Z0-9]

Ӧ��ע���ַ������ʽ��д����һ���ַ������ʽ����һ��[:��:]��ס�ģ���Ϊһ�����壬����дʱ����������[]������

��2���ظ�ģʽ��ƥ��

* 'r*�� r��һ���������ʽ�������ַ�"*"��ʾ0��������������ģʽ��ʾƥ��0������r��

* 'r+�� r��һ���������ʽ�������ַ�'+'��ʾ1��������������ģʽ��ʾƥ��1������r��

* 'r?�� r��һ���������ʽ�������ַ�'?'��ʾ0����1����������ģʽ��ʾƥ��0����1��r��������һ���Ƕȿ�������˵ģʽr�ǿ�ѡ�ģ�

* 'r{2,5}�� r��һ���������ʽ��{2,5}��ʾ2����5����������ģʽ��ʾƥ��2����5��r��Ҳ����˵����ƥ��'rr'��'rrr'��'rrrr'��'rrrrr'�����ظ���ģʽ��

* 'r{2,}�� r��һ���������ʽ��{2,}ʡ���˵ڶ������֣���ʾ����2�����������ޡ�������ģʽ��ʾƥ��2�������ϸ�r��Ҳ����˵���ٿ���ƥ��'rr'��������ƥ��'rrr'��'rrrr'�����޶����ظ���ģʽ��

* 'r{4}�� r��һ���������ʽ��{4}ֻ��һ�����֣���ʾ4����������ģʽȷ�е�ƥ��4��r����'rrrr'��

��3�������滻

* '{name}�� ����name������ǰ��Ķ���θ��������֡����ģʽ����������ֵĶ�����ƥ�䡣

��4��ƽ����plain���ı�����ƥ��

* '��[xyz]\��foo���� ���ģʽ����ȷ�е�ƥ���ı�����[xyz]\��foo��ע�������ĵ�������������������ģʽ����ʽ��Ҳ����˵����ϣ��ƥ���ִ�[xyz]\��fooʱ������д����ʱ���ִ�������˫������ס��

��5�����ⵥ�ַ���ƥ��

* '\x�� ��x��һ��'a'��'b'��'f'��'n'��'r'��'t'��'v'ʱ�����ͽ���ΪANSI-C�е�\x���������Ȼ��Ϊһ����ͨ�ַ�x��һ����������'*'�ַ���ת���ַ�����

* '\0�� ƥ��һ��NUL�ַ���ASCII��ֵΪ0����

* '\123�� ƥ��һ���ַ�����ֵ�ð˽��Ʊ�ʾΪ123��

* '\x2a�� ƥ��һ���ַ�����ֵ��ʮ�����Ʊ�ʾΪ2a��

��6�����ģʽ��ƥ��

* '(r)�� ƥ��������ʽr��Բ���ſ�����������ȼ���

* 'rs�� ƥ��������ʽr���������ű���ʽs�����Ϊ����(concatenation)��

* 'r|s�� ����ƥ��������ʽr������ƥ�����ʽs��

* 'r/s�� ƥ��ģʽr������Ҫ����������ģʽs������Ҫ�жϱ���ƥ���Ƿ�Ϊ���ƥ�䣨longest match��ʱ��ģʽsƥ����ı�Ҳ�ᱻ����������������жϺ�ʼִ�ж�Ӧ�Ķ�����action��֮ǰ����Щ��ģʽs������ı��ᱻ���������롣���Զ�����action��ֻ�ܿ���ģʽrƥ�䵽���ı�������ģʽ���ͽ���β�������ģ�trailing context��������Щ'r/s�������flex����ʶ��ģ���ο�����deficiencies/bugsһ���е�dangerous trailing context�����ݡ���

* '^r�� ƥ��ģʽr���������ģʽֻ������һ�еĿ�ʼ����Ҳ����˵���տ�ʼɨ��ʱ�����ģ�����˵�ڸ�ɨ����һ�������ַ�������������ġ�

* 'r$�� ƥ��ģʽr���������ģʽֻ��һ�е�β����Ҳ����˵����ģʽ�ͳ����ڻ���֮ǰ�����ģʽ�ȼ���r/\n��ע�⣬flex�еĻ��У�newline���ĸ������C����������ʹ�õ�\n��flexҲ����ͬ���ķ��źͽ��͡���DOSϵͳ�У����ܱ��������Լ��˳������е�\r��������ȷ����ģʽ��д��r/\r\n������r$������unixϵͳ�л�������һ���ֽ� \n ��ʾ�ģ���DOS/Windows����������ֽ� \r\n����ʾ���С���

��7��������������Start Condition����ģʽƥ��

* '<s>r�� ƥ��ģʽr������Ҫ��������s�����������������������ۣ���ģʽ'<s1,s2,s3>r�������Ƶģ�ƥ��ģʽr��ֻҪ��������������s1��s2��s3�е���һ�����ɡ���������������˵��������C�����е��������룬������ĳ���������������ģʽ����ƥ�䣬���򲻻�������ģʽ����ƥ�䡣��

* '<*>r�� ƥ��ģʽr�����κ����������¶�����ƥ�䣬��ʹ���ų��Ե�������

[��������Ҫ��ʵ��������京��]

��8���ļ�βƥ��

* '<<EOF>>�� ƥ���ļ�β�����������ļ�β����һ��˵������Ӧ����ģʽ�м����ļ�βģʽ�����������л������ļ�ɨ�����ʱ����һЩ����Ĵ�����

* '<s1,s2><<EOF>>�� ������������s1����s2������£�ƥ���ļ�β����