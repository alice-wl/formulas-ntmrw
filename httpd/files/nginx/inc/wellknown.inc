#{{ pillar.get('headers.salt.file', '# file managed by ntmrw saltstack' ) }}
location /.well-known/acme-challenge {
  alias /etc/le/www;
  break;
}

