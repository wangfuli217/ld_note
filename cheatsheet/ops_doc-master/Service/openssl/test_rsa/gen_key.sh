#!/bin/bash

#生成私钥：
openssl genrsa -out privatekey.pem 2048
#生成公钥：
openssl rsa -in privatekey.pem -out publickey.pem -pubout

#生成私钥：
openssl genrsa -out test.key 2048
#生成公钥：
openssl rsa -in test.key -out test_pub.key -pubout
