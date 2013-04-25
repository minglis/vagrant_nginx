### Vagrant to spin up a client certified NGINX server


#### To Run

- Install vagrant

- generate certificates

- vagrant up

- Do puppet deploy fix outlined below (will fix at some point)

#### Fix puppet key creation mistake
	vagrant ssh
	vagrant@precise64:~$ cd /etc/nginx/
	vagrant@precise64:/etc/nginx$ sudo chown root:root server.*
	vagrant@precise64:/etc/nginx$ sudo chown root:root ca.crt  
	vagrant@precise64:/etc/nginx$ sudo service nginx restart
	vagrant@precise64:/etc/nginx$ exit

#### References:
[http://blog.nategood.com/client-side-certificate-authentication-in-ngi](http://blog.nategood.com/client-side-certificate-authentication-in-ngi)

[http://www.xenocafe.com/tutorials/linux/centos/openssl/self_signed_certificates/index.php](http://www.xenocafe.com/tutorials/linux/centos/openssl/self_signed_certificates/index.php)

[https://gist.github.com/mtigas/952344](https://gist.github.com/mtigas/952344)

[http://drumcoder.co.uk/blog/2011/oct/19/client-side-certificates-web-apps/](http://drumcoder.co.uk/blog/2011/oct/19/client-side-certificates-web-apps/)

[http://jw35.blogspot.co.uk/2010/05/doing-certificate-verification-in.html](http://jw35.blogspot.co.uk/2010/05/doing-certificate-verification-in.html)

[http://rynop.com/howto-client-side-certificate-auth-with-nginx](http://rynop.com/howto-client-side-certificate-auth-with-nginx)

#### Certificate reference:

To generate your own certs follow this process EXACTLY. Place the new certs into files/modules/nginx/conf.

	# Create the CA Key and Certificate for signing Client Certs
	openssl genrsa -des3 -out ca.key 4096
	openssl req -new -x509 -days 365 -key ca.key -out ca.crt

	- Enter correct(ish) details (GB / default / default / Organisation / Bit of org / FQDN of service / minglis@admin.com )

	# Create the Server Key, CSR, and Certificate
	openssl genrsa -des3 -out server.key 1024
	## Remove server key password
	openssl rsa -in server.key -out server.key 
	openssl req -new -key server.key -out server.csr

	- Enter correct(ish) details (GB / default / default / Organisation / Bit of org / FQDN of service / minglis@admin.com / default / default )

	# We're self signing our own server cert here.  This is a no-no in production.
	openssl x509 -req -days 1095 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out server.crt

	# Create the Client Key and CSR
	openssl genrsa -des3 -out client.key 1024
	# no password on client key
	openssl rsa -in client.key -out client.key 

	openssl req -new -key client.key -out client.csr

	- Enter correct(ish) details (GB / default / default / Organisation / Bit of org / minglis / minglis@admin.com / default / default ) Note: real name not FQDN

	# Sign the client certificate with our CA cert.  Unlike signing our own server cert, this is what we want to do.
	openssl x509 -req -days 1095 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 03 -out client.crt

	# p12 version of cert for browsers
	openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12

	# pfx for windows
	openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt



#### Testing (note post 443 forwarded to 4568):
	curl -v -s -k --key client.key --cert client.crt https://localhost:4568 
