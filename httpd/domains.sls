{% set domains = pillar.get( 'domains', {} ) %}

{% for domain,cfg in domains.get( 'domains', {} ).items( ) %}
{%   set webroot = cfg.get( 'webroot', '/srv/public' ) -%}

nginx-{{domain}}:
  file.managed:
    - name: /etc/nginx/conf.d/{{domain}}.conf
    - source: salt://nginx/files/domain.conf
    - template: jinja
    - makedirs: True
    - context:
      domain: {{domain}}
      webroot: {{webroot}}
    - watch_in:
      - service: nginx

{% endfor %}
