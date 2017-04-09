nginx:
  pkg: 
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - file: nginx
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://httpd/files/nginx/nginx.conf
    - template: jinja
    - require:
      - pkg: nginx

