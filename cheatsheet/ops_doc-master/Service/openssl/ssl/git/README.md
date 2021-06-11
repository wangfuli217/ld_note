# 仓库介绍
## 缘起
因为要在TCP长连接上实现通道加密，需要TLS方案。目前网上C和Java两个平行世界里的人在openssl和keytool中自说自话，找不到多语言环境下的TLS完整方案，甚至有的demo对TLS方案存在误解。
## 脚本介绍
### ca.sh

此脚本用来生成签名用到的CA，客户端的公钥和私钥、服务端的公钥和私钥，以及两端要用到的keystore和trust store。这里最大的误解是trust store中需要存入对方的公钥，其实不用，只需CA的公钥（链）.

### another-build.sh

此脚本生成Ｃ语言单向验证方案的服务端和客户端

### dual-build.sh

此脚本生成Ｃ语言双向验证方案的服务端和客户端

### build.sh
此脚本生成Ｃ语言多线程demo
