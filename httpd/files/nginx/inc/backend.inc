location / {
  error_page   502 504  /50x.html;
  client_max_body_size 1600m;

  proxy_intercept_errors on;
  proxy_buffers 16 256k;
  proxy_buffer_size 2k;
  proxy_pass  $upstream;
  #proxy_buffering off;
  proxy_set_header        Accept-Encoding   "";
  proxy_set_header        Host            $host;
  proxy_set_header        scheme          $scheme;
  proxy_set_header        X-Real-IP       $remote_addr;
  proxy_set_header        X-Forwarded-Port       $server_port;
  proxy_set_header        X-Forwarded-For        $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto      $scheme;
  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
  proxy_redirect off;
}
location /q/request_denied {
  return 500;
}
 
location @fallback {
  root /usr/share/nginx/www;
  error_page   502 504  /50x.html;                                                                                                               
}

