mkdir ca server client
cd ca
#生成根证书私钥(pem文件)
openssl genrsa -out ca-key.pem 2048

#生成根证书签发申请文件(csr文件)
openssl req -new -key ca-key.pem -out ca.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=myCA"

#自签发根证书(cer文件) 
openssl x509 -req -days 36500 -sha1 -extensions v3_ca -signkey ca-key.pem -in ca.csr -out  ca-cert.pem

cd ../server
#生成服务端私钥
openssl genrsa -out server-key.pem 2048

#生成证书请求文件
openssl req -new -key server-key.pem -out server.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=127.0.0.1"

#使用根证书签发服务端证书
openssl x509 -req -days 36500 -sha1 -extensions v3_req -CA ../ca/ca-cert.pem -CAkey ../ca/ca-key.pem -CAserial ca.srl -CAcreateserial -in server.csr -out server-cert.pem

#使用CA证书验证server端证书
openssl verify -CAfile ../ca/ca-cert.pem  server-cert.pem

#生成服务器端的证书库
keytool -genkey -keyalg RSA -alias endeca -keypass "123456" -keystore server-keystore.ks -storepass "123456" -dname "CN=name,OU=org,O=o,L=BJ,ST=BJ,C=CN"

#删除其中的仓库信息
keytool -delete -alias endeca -keystore server-keystore.ks -storepass "123456"

#合并公钥和私钥
cat server-cert.pem server-key.pem > combined.pem
#转码为pkcs12
openssl pkcs12 -export -out combined.pkcs12 -in combined.pem
#导入公钥和私钥进入证书库
keytool -v -importkeystore -srckeystore combined.pkcs12 -srcstoretype PKCS12 -destkeystore server-keystore.ks -deststoretype JKS

#生成服务器端的信任证书库
keytool -genkey -keyalg RSA -alias endeca -keypass "123456" -keystore server-truststore.ks -storepass "123456" -dname "CN=name,OU=org,O=o,L=BJ,ST=BJ,C=CN"
#删除其中的仓库信息
keytool -delete -alias endeca -keystore server-truststore.ks -storepass "123456"
#导入CA（不需要导入对方公钥。双方基于共同的ＣＡ互相认可对方公钥？）
keytool -import -v -trustcacerts -alias endeca-ca -file ../ca/ca-cert.pem -keystore server-truststore.ks

cd ../client
#生成客户端私钥
openssl genrsa  -out client-key.pem 2048
#生成证书请求文件
openssl req -new -key client-key.pem -out client.csr -subj "/C=CN/ST=myprovince/L=mycity/O=myorganization/OU=mygroup/CN=127.0.0.1"
#使用根证书签发客户端证书
openssl x509 -req -days 36500 -sha1 -extensions v3_req -CA  ../ca/ca-cert.pem -CAkey ../ca/ca-key.pem  -CAserial ../server/ca.srl -in client.csr -out client-cert.pem
#使用CA证书验证客户端证书
openssl verify -CAfile ../ca/ca-cert.pem  client-cert.pem

#生成客户端的证书库
keytool -genkey -keyalg RSA -alias endeca -keypass "123456" -keystore client-keystore.ks -storepass "123456" -dname "CN=name,OU=org,O=o,L=BJ,ST=BJ,C=CN"

#删除其中的仓库信息
keytool -delete -alias endeca -keystore client-keystore.ks -storepass "123456"
#合并公钥和私钥
cat client-cert.pem client-key.pem > combined.pem
#转码为pkcs12
openssl pkcs12 -export -out combinedCert.pkcs12 -in combined.pem
#导入公钥和私钥进入证书库
keytool -v -importkeystore -srckeystore combinedCert.pkcs12 -srcstoretype PKCS12 -destkeystore client-keystore.ks -deststoretype JKS

#生成客户端的信任证书库
keytool -genkey -keyalg RSA -alias endeca -keypass "123456" -keystore client-truststore.ks -storepass "123456" -dname "CN=name,OU=org,O=o,L=BJ,ST=BJ,C=CN"
#删除其中的仓库信息
keytool -delete -alias endeca -keystore client-truststore.ks -storepass "123456"
#导入CA（不需要导入对方公钥。双方基于共同的ＣＡ互相认可对方公钥？）
keytool -import -v -trustcacerts -alias endeca-ca -file ../ca/ca-cert.pem -keystore client-truststore.ks

