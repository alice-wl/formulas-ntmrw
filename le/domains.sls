include:
  - le.getssl

{% set getssl = pillar.get('getssl', {}) %}
{% set work = getssl.get( 'work', '/etc/ssl/le' ) -%}

{% for domain,config in getssl.get( 'domains', {} ).items( ) %}
{%   set home = config.get( 'home', work+'/'+domain ) -%}

getssl-{{domain}}.cfg:
  file.managed:
    - name: {{work}}/{{domain}}/getssl.cfg
    - source: salt://le/files/getssl-domain.cfg
    - template: jinja
    - makedirs: True
    - dir_mode: 750
    - context:
      domain: {{domain}}
      home: {{home}}
    - require:
      - file: getssl.cfg

#getssl-{{domain}}:
#  cmd.run:
#    - name: /usr/local/bin/getssl -w {{work}} {{domain}}
#    - statefull: true
#    - require:
#      - file: getssl-{{domain}}.cfg

{% endfor %}
