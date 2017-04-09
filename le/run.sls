{% set getssl = pillar.get('getssl', {}) %}
{% set work = getssl.get( 'work', '/etc/le' ) %}

{% for domain,cfg in pillar.get( 'domains', {} ).items( ) %}

{{domain}}-getssl-run:
  cmd.run:
    - name: /usr/local/bin/getssl -w {{work}} {{domain}};
    - statefull: true
{% endfor %}

