# sslChatDemo
simple ssl server and client<br />
<br />
openssl genrsa -out privkey.pem 2048<br />
openssl req -new -x509 -key privkey.pem -out cacert.pem -days 3650<br />
gcc sslClient.c api.c -o client -lssl -lcrypto<br />
gcc sslServer.c api.c -o server -lssl -lcrypto<br />

./server 8888 cacert.pem privkey.pem<br />
./client 127.0.0.1 8888<br />
