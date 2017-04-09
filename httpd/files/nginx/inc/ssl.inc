#{% pillar.get('headers.salt.file', '# file managed by ntmrw saltstack' ) %}
ssl  on;
 
ssl_protocols TLSv1.2;
ssl_dhparam /etc/ssl/private/dhparams_4096.pem;
 
ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
ssl_prefer_server_ciphers on;
 
#ssl_stapling on;
#ssl_stapling_verify on;
resolver 8.8.4.4 8.8.8.8 valid=300s;
resolver_timeout 10s;
 
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
keepalive_timeout 70;

add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";

