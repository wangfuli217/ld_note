1) 自签CA证书
#生成根证书私钥(pem文件)
openssl genrsa -out cakey.pem 2048
#生成根证书签发申请文件(csr文件)
openssl req -new -key cakey.pem -out ca.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=myCA"   
#自签发根证书(cer文件)
openssl x509 -req -days 365 -sha1 -extensions v3_ca -signkey cakey.pem -in ca.csr -out  cacert.pem


2）服务端私钥和证书
#生成服务端私钥
openssl genrsa -out key.pem 2048
#生成证书请求文件
openssl req -new -key key.pem -out server.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=myServer"
#使用根证书签发服务端证书                                                                                                  
openssl x509 -req -days 365 -sha1 -extensions v3_req -CA ../CA/cacert.pem -CAkey ../CA/cakey.pem -CAserial ca.srl -CAcreateserial -in server.csr -out cert.pem
#使用CA证书验证server端证书                                                                                                
openssl verify -CAfile ../CA/cacert.pem  cert.pem

3）客户端私钥和证书
#生成客户端私钥                                                                                                            
openssl genrsa  -out key.pem 2048                                                                                         
#生成证书请求文件                                                                                                          
openssl req -new -key key.pem -out client.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=myClient"
#使用根证书签发客户端证书                                                                                                  
openssl x509 -req -days 365 -sha1 -extensions v3_req -CA  ../CA/cacert.pem -CAkey ../CA/cakey.pem  -CAserial ../server-cert/ca.srl -in client.csr -out cert.pem
#使用CA证书验证客户端证书                                                                                                  
openssl verify -CAfile ../CA/cacert.pem  cert.pem

one-way 时客户端需要验证服务端的证书，所以客户端需要加载CA证书

https://www.cnblogs.com/Anker/p/6018032.html

1. 现在开始生成CA证书
创建私钥：genrsa -out ca-key.pem 1024
创建证书请求：req -new -out ca-req.csr -key ca-key.pem -config openssl.cnf
执行之后，会在目录下生成ca-key.pem和ca-req.csr文件
自签署证书：
x509 -req -in ca-req.csr -out ca-cert.pem -signkey ca-key.pem -days 365
执行完成之后会生成ca-cert.pem文件
2. 生成server证书
创建私钥:
genrsa -out server-key.pem 1024
创建证书请求：
req -new -out server-req.csr -key server-key.pem -config openssl.cnf
执行完成生成server-key.pem和server-req.csr文件
自签署证书：
x509 -req -in server-req.csr -out server-cert.pem -signkey server-key.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -days 365
执行完成生成server-cert.pem文件
3. 生成client证书，与服务器生成证书差不多
创建私钥：
genrsa -out client-key.pem 1024
创建证书请求：
req -new -out client-req.csr -key client-key.pem -config openssl.cnf
自签署证书：
x509 -req -in client-req.csr -out client-cert.pem -signkey client-key.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -days 365

到此CA证书、server证书、client证书全部生成完成，导入对应的服务器或客户端则可以正常使用了



https://www.cnblogs.com/littleatp/p/5878763.html
一、openssl 简介
openssl 是目前最流行的 SSL 密码库工具，其提供了一个通用、健壮、功能完备的工具套件，用以支持SSL/TLS 协议的实现。
官网：https://www.openssl.org/source/
构成部分
    密码算法库
    密钥和证书封装管理功能
    SSL通信API接口
用途
    建立 RSA、DH、DSA key 参数
    建立 X.509 证书、证书签名请求(CSR)和CRLs(证书回收列表)
    计算消息摘要
    使用各种 Cipher加密/解密
    SSL/TLS 客户端以及服务器的测试
    处理S/MIME 或者加密邮件

二、RSA密钥操作
默认情况下，openssl 输出格式为 PKCS#1-PEM
生成RSA私钥(无加密)
    openssl genrsa -out rsa_private.key 2048
生成RSA公钥
    openssl rsa -in rsa_private.key -pubout -out rsa_public.key
生成RSA私钥(使用aes256加密)
    openssl genrsa -aes256 -passout pass:111111 -out rsa_aes_private.key 2048
其中 passout 代替shell 进行密码输入，否则会提示输入密码；
生成加密后的内容如：
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-256-CBC,5584D000DDDD53DD5B12AE935F05A007
Base64 Encoded Data
-----END RSA PRIVATE KEY-----
此时若生成公钥，需要提供密码
    openssl rsa -in rsa_aes_private.key -passin pass:111111 -pubout -out rsa_public.key
其中 passout 代替shell 进行密码输入，否则会提示输入密码；


转换命令
----------
私钥转非加密
    openssl rsa -in rsa_aes_private.key -passin pass:111111 -out rsa_private.key
私钥转加密
    openssl rsa -in rsa_private.key -aes256 -passout pass:111111 -out rsa_aes_private.key
私钥PEM转DER
    openssl rsa -in rsa_private.key -outform der-out rsa_aes_private.der
-inform和-outform 参数制定输入输出格式，由der转pem格式同理
查看私钥明细
    openssl rsa -in rsa_private.key -noout -text
使用-pubin参数可查看公钥明细
私钥PKCS#1转PKCS#8
    openssl pkcs8 -topk8 -in rsa_private.key -passout pass:111111 -out pkcs8_private.key
其中-passout指定了密码，输出的pkcs8格式密钥为加密形式，pkcs8默认采用des3 加密算法，内容如下：
-----BEGIN ENCRYPTED PRIVATE KEY-----
Base64 Encoded Data
-----END ENCRYPTED PRIVATE KEY-----
使用-nocrypt参数可以输出无加密的pkcs8密钥，如下：
-----BEGIN PRIVATE KEY-----
Base64 Encoded Data
-----END PRIVATE KEY-----


三、生成自签名证书
生成 RSA 私钥和自签名证书
    openssl req -newkey rsa:2048 -nodes -keyout rsa_private.key -x509 -days 365 -out cert.crt
req是证书请求的子命令，-newkey rsa:2048 -keyout private_key.pem 表示生成私钥(PKCS8格式)，-nodes 表示私钥不加密，若不带参数将提示输入密码；
-x509表示输出证书，-days365 为有效期，此后根据提示输入证书拥有者信息；
若执行自动输入，可使用-subj选项：
    openssl req -newkey rsa:2048 -nodes -keyout rsa_private.key -x509 -days 365 -out cert.crt -subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=vivo.com/emailAddress=yy@vivo.com"
使用 已有RSA 私钥生成自签名证书
    openssl req -new -x509 -days 365 -key rsa_private.key -out cert.crt
-new 指生成证书请求，加上-x509 表示直接输出证书，-key 指定私钥文件，其余选项与上述命令相同

四、生成签名请求及CA 签名
使用 RSA私钥生成 CSR 签名请求
openssl genrsa -aes256 -passout pass:111111 -out server.key 2048
openssl req -new -key server.key -out server.csr
此后输入密码、server证书信息完成，也可以命令行指定各类参数
    openssl req -new -key server.key -passin pass:111111 -out server.csr -subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=vivo.com/emailAddress=yy@vivo.com"
*** 此时生成的 csr签名请求文件可提交至 CA进行签发 ***

查看CSR 的细节
cat server.csr
-----BEGIN CERTIFICATE REQUEST-----
Base64EncodedData
-----END CERTIFICATE REQUEST-----
    openssl req -noout -text -in server.csr
使用 CA 证书及CA密钥 对请求签发证书进行签发，生成 x509证书
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -passin pass:111111 -CAcreateserial -out server.crt
其中 CAxxx 选项用于指定CA 参数输入



五、证书查看及转换
查看证书细节
openssl x509 -in cert.crt -noout -text
转换证书编码格式

openssl x509 -in cert.cer -inform DER -outform PEM -out cert.pem

合成 pkcs#12 证书(含私钥)

** 将 pem 证书和私钥转 pkcs#12 证书 **

openssl pkcs12 -export -in server.crt -inkey server.key -passin pass:111111 -password pass:111111 -out server.p12

其中-export指导出pkcs#12 证书，-inkey 指定了私钥文件，-passin 为私钥(文件)密码(nodes为无加密)，-password 指定 p12文件的密码(导入导出)

** 将 pem 证书和私钥/CA 证书 合成pkcs#12 证书**

openssl pkcs12 -export -in server.crt -inkey server.key -passin pass:111111 \
    -chain -CAfile ca.crt -password pass:111111 -out server-all.p12

其中-chain指示同时添加证书链，-CAfile 指定了CA证书，导出的p12文件将包含多个证书。(其他选项：-name可用于指定server证书别名；-caname用于指定ca证书别名)

** pcks#12 提取PEM文件(含私钥) **

openssl pkcs12 -in server.p12 -password pass:111111 -passout pass:111111 -out out/server.pem

其中-password 指定 p12文件的密码(导入导出)，-passout指输出私钥的加密密码(nodes为无加密)
导出的文件为pem格式，同时包含证书和私钥(pkcs#8)：
复制代码

Bag Attributes
    localKeyID: 97 DD 46 3D 1E 91 EF 01 3B 2E 4A 75 81 4F 11 A6 E7 1F 79 40 
subject=/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=vihoo.com/emailAddress=yy@vihoo.com
issuer=/C=CN/ST=GD/L=SZ/O=viroot/OU=dev/CN=viroot.com/emailAddress=yy@viroot.com
-----BEGIN CERTIFICATE-----
MIIDazCCAlMCCQCIOlA9/dcfEjANBgkqhkiG9w0BAQUFADB5MQswCQYDVQQGEwJD
1LpQCA+2B6dn4scZwaCD
-----END CERTIFICATE-----
Bag Attributes
    localKeyID: 97 DD 46 3D 1E 91 EF 01 3B 2E 4A 75 81 4F 11 A6 E7 1F 79 40 
Key Attributes: <No Attributes>
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDC/6rAc1YaPRNf
K9ZLHbyBTKVaxehjxzJHHw==
-----END ENCRYPTED PRIVATE KEY-----

仅提取私钥
 openssl pkcs12 -in server.p12 -password pass:111111 -passout pass:111111 -nocerts -out out/key.pem

仅提取证书(所有证书)
 openssl pkcs12 -in server.p12 -password pass:111111 -nokeys -out out/key.pem

仅提取ca证书
openssl pkcs12 -in server-all.p12 -password pass:111111 -nokeys -cacerts -out out/cacert.pem 

仅提取server证书
openssl pkcs12 -in server-all.p12 -password pass:111111 -nokeys -clcerts -out out/cert.pem