include:
  - ssl
  - httpd.nginx
  - le.getssl

{% set getssl = pillar.get('getssl', {}) -%}
{% set work = getssl.get( 'work', '/etc/le' ) -%}
{% set serverkey = pillar.get( 'serverkey', '/etc/ssl/private/notomorrow.de.key' ) -%}
{% set servercrt = pillar.get( 'servercrt', '/etc/ssl/certs/notomorrow.de.crt' ) -%}

{% set domains = salt['pillar.get']( 'domains', {} ) %}
{% set backends = salt['pillar.get']( 'http:backends', {} ) %}

/etc/nginx/inc/ssl.inc:
  file.managed:
    - source: salt://httpd/files/nginx/inc/ssl.inc
    - makedirs: True
    - require_in: 
      - file: nginx
/etc/nginx/inc/wellknown.inc:
  file.managed:
    - source: salt://httpd/files/nginx/inc/wellknown.inc
    - makedirs: True
    - require_in: 
      - file: nginx
/etc/nginx/inc/backend.inc:
  file.managed:
    - source: salt://httpd/files/nginx/inc/backend.inc
    - makedirs: True
    - require_in: 
      - file: nginx
/etc/nginx/inc/backend-couch.inc:
  file.managed:
    - source: salt://httpd/files/nginx/inc/backend-couch.inc
    - makedirs: True
    - require_in: 
      - file: nginx

/etc/nginx/conf.d/backends.conf:
  file.managed:
    - source: salt://httpd/files/nginx/conf.d/backends.conf
    - makedirs: True
    - template: jinja
    - context:
      domains: {{ domains }}
      backends: {{ backends }}
    - require_in: 
      - file: nginx
    - watch_in:
      - service: nginx

{% for domain,cfg in pillar.get( 'domains', {} ).items( ) %}
{%   set home = cfg.get( 'home', '/srv/domain/'+domain ) %}
{%   set keydir = cfg.get( 'keydir', work+'/'+domain+'/' ) %}
{%   set redirecthttp = cfg.get( 'redirecthttp', False ) %}
{%   set webroot = cfg.get( 'webroot', home+'/www' ) %}
{%   set backend = cfg.get( 'backend', '' ) %}
{%   set backendcouch = cfg.get( 'backendcouch', '' ) %}
{%   set alias = cfg.get( 'alias', [] ) -%}

{{domain}}-hosts-entry:
  host.present:
    - ip: 127.0.0.1
    - names: 
      - {{domain}}
{%   for a in alias %}
      - {{ a }}
{%   endfor %}

{{domain}}-getssl-run:
  cmd.run:
    - name: /usr/local/bin/getssl -w {{work}} {{domain}} >/dev/null;
    - statefull: true
    - require:
      - file: {{domain}}-getssl
    - watch_in:
      - service: nginx

{{domain}}-getssl-combine:
  cmd.run:
    - name: cd /etc/le/{{domain}} && cat crt chain.crt > combined;
    - statefull: true
    - require:
      - file: {{domain}}-getssl
    - watch_in:
      - service: nginx

{{domain}}-getssl:
  file.managed:
    - name: {{work}}/{{domain}}/getssl.cfg
    - source: salt://le/files/getssl-domain.cfg
    - template: jinja
    - makedirs: True
    - dir_mode: 750
    - context:
      domain: {{domain}}
      keydir: {{keydir}}
      alias: {{alias}}
    - require:
      - file: getssl
      - file: {{domain}}-nginx

{{domain}}-nginx:
  file.managed:
    - name: /etc/nginx/conf.d/{{domain}}.conf
    - source: salt://httpd/files/nginx-ssl-domain.conf
    - template: jinja
    - makedirs: True
    - context:
      domain: {{domain}}
      alias: {{alias}}
      redirecthttp: {{redirecthttp}}
      webroot: {{webroot}}
      backend: {{backend}}
      backendcouch: {{backendcouch}}
{%   if salt['file.file_exists' ]( keydir+'/key' ) %}
      key: {{keydir}}key
      crt: {{keydir}}combined
      combined: {{keydir}}combined.crt

{%   else %}
      key: {{serverkey}}
      crt: {{servercrt}}
      combined:
{%   endif %}
{%   if salt['file.directory_exists' ]( home+'/nginx.d' ) %}
      nginxd: {{home}}/nginx.d/*
{%   else %}
      nginxd: False
{%   endif %}
    - watch_in:
      - service: nginx

{% endfor %}

