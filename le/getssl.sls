{% set getssl = pillar.get('getssl', {}) %}

{% set work = getssl.get( 'work', '/etc/le' ) -%}
{% set webroot = getssl.get( 'webroot', '/etc/le/www' ) -%}
{% set email = getssl.get( 'email', 'admin@notomorrow.de' ) -%}
{% set reload = getssl.get( 'reload', 'sudo service nginx restart' ) -%}

getssl-script:
  file.managed:
    - name: /usr/local/bin/getssl
    - source: salt://le/getssl/getssl
    - mode: 755
  pkg: 
    - installed
    - names:
      - curl
      - dnsutils

getssl-schedule:
  schedule.present:
    - function: state.sls
    - job_args:
      - le.run:
    - seconds: 86400
    - splay: 3600

getssl:
  file.managed:
    - name: {{work}}/getssl.cfg
    - source: salt://le/files/getssl.cfg
    - template: jinja
    - makedirs: True
    - context:
      email: {{email}}
      reload: {{reload}}
      webroot: {{webroot}}
    - require:
      - file: getssl-script

