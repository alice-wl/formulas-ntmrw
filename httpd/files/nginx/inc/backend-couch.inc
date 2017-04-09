location / {
  proxy_pass  $upstream;
  proxy_set_header        Accept-Encoding   "";
  proxy_set_header        Host            $host;
  proxy_set_header        scheme          $scheme;
  proxy_set_header        X-Real-IP       $remote_addr;

  proxy_set_header        X-Forwarded-Port       $server_port;
  proxy_set_header        X-Forwarded-For        $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Ssl on;
  proxy_set_header        X-Forwarded-Proto      $scheme;

  proxy_redirect off;
}
location ~ ^/(.*)/_changes {
    proxy_pass  $upstream;
    proxy_redirect off;
    proxy_buffering off;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
