### Vagrant to spin up a client certified NGINX server

#### via:
[http://blog.nategood.com/client-side-certificate-authentication-in-ngi](http://blog.nategood.com/client-side-certificate-authentication-in-ngi)

[http://www.xenocafe.com/tutorials/linux/centos/openssl/self_signed_certificates/index.php](http://www.xenocafe.com/tutorials/linux/centos/openssl/self_signed_certificates/index.php)

[https://gist.github.com/mtigas/952344](https://gist.github.com/mtigas/952344)

[http://drumcoder.co.uk/blog/2011/oct/19/client-side-certificates-web-apps/](http://drumcoder.co.uk/blog/2011/oct/19/client-side-certificates-web-apps/)

[http://jw35.blogspot.co.uk/2010/05/doing-certificate-verification-in.html](http://jw35.blogspot.co.uk/2010/05/doing-certificate-verification-in.html)

[http://rynop.com/howto-client-side-certificate-auth-with-nginx](http://rynop.com/howto-client-side-certificate-auth-with-nginx)

#### Certs:

	# Create the CA Key and Certificate for signing Client Certs
	openssl genrsa -des3 -out ca.key 4096
	openssl req -new -x509 -days 365 -key ca.key -out ca.crt

	# Create the Server Key, CSR, and Certificate
	openssl genrsa -des3 -out server.key 1024
	openssl req -new -key server.key -out server.csr

	# We're self signing our own server cert here.  This is a no-no in production.
	openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

	# Create the Client Key and CSR
	openssl genrsa -des3 -out client.key 1024
	openssl req -new -key client.key -out client.csr

	# Sign the client certificate with our CA cert.  Unlike signing our own server cert, this is what we want to do.
	openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt

#### Remove passwords from keys for the server key to allow easy restart
	openssl rsa -in server.key -out server.key

#### Fix puppet bug
	vagrant ssh
	vagrant@precise64:~$ cd /etc/nginx/
	vagrant@precise64:/etc/nginx$ sudo chown root:root server.*
	vagrant@precise64:/etc/nginx$ sudo chown root:root ca.crt  
	vagrant@precise64:/etc/nginx$ exit

#### Testing:
	curl -v -s -k --key client.key --cert client.crt https://localhost:4568





2289  openssl genrsa -des3 -out ca.key 4096
 2290  openssl req -new -x509 -days 1095 -key ca.key -out ca.crt
 2291  openssl genrsa -des3 -out server.key 1024
 2292  openssl req -new -key server.key -out server.csr
 2293  ls -lrt
 2294  openssl rsa -in server.key -out server.key 
 2295  openssl x509 -req -days 1095 -in server.csr -ca ca.crt -CAkey ca.key -set_serial 02 -out server.crt
 2296  openssl x509 -req -days 1095 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out server.crt
 2297  openssl genrsa -des3 -out client.key 1024]
 2298  openssl req -new -key client.key -out client.csr
 2299  openssl x509 -req -days 1095 -in client.csr -CA ca.crt -CAkey ca.key -CAserial 03 -out client.crt
 2300  openssl x509 -req -days 1095 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 03 -out client.crt
 2301  openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12
 2302  history | grep curl
 2303  curl -v -s -k --key client.key --cert client.crt https://localhost:4568