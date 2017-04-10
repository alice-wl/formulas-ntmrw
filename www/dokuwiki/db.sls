{% set master = grains.get('id', 'd3.notomorrow.de' ) -%}
{% set runas  = pillar.get( 'postgres.adminuser', 'postgres' ) -%}

{% for h, dokuwiki in pillar.get('dokuwiki', {}).items() -%}

{% set user = dokuwiki.get( 'db.user', 'notomorrow-de' ) -%}
{% set db = dokuwiki.get( 'db.name', 'notomorrow-de' ) -%}

{% set home   = dokuwiki.get( 'home', '/srv/ntmrw' ) -%}
{% set srcdir = dokuwiki.get( 'srcdir', home + '/src' ) -%}
{% set domdir = dokuwiki.get( 'domdir', home + '/domains' ) -%}
{% set cnfdir = dokuwiki.get( 'cnfdir', home + '/conf' ) -%}
{% set sqldir = dokuwiki.get( 'domdir', cnfdir + '/sql') -%}

{% set adminuser = dokuwiki.get( 'admin.user', 'alice' ) -%}
{% set adminpass = dokuwiki.get( 'admin.hash', '' ) -%}
{% set adminemail = dokuwiki.get( 'admin.email', '' ) -%}

dokuwiki-db-{{h}}:
  postgres_database.present:
    - name: {{ db }}
    - encoding: UTF8
    - require:
      - postgres_user: dokuwiki-db-user-{{h}}
  file.recurse:
    - name: {{ sqldir }}
    - file_mode: 644
    - dir_mode: 755
    - source: salt://www/dokuwiki/files/sql
    - template: jinja
    - context:
      adminuser: {{adminuser}}
      adminpass: {{adminpass}}
      adminemail: {{adminemail}}
    - listen:
      - postgres_database: dokuwiki-db-{{h}}
  cmd.wait:
    - name: rm -r {{ sqldir }}
    - listen:
      - file: dokuwiki-db-{{h}}
    - require:
      - cmd: dokuwiki-db-data-{{h}}

dokuwiki-db-user-{{h}}:
  postgres_user.present:
    - name: {{ user }}
    - runas: {{ runas }}

dokuwiki-db-data-{{h}}:
  cmd.wait:
    - name: /usr/bin/psql -a {{ db }} < {{sqldir}}/data.sql
    - unless: /usr/bin/psql -tq -c "select * from users where email='{{ adminemail }}'" {{ db }} 2>&1 > /dev/null
    - user: {{ runas }}
    - require:
      - cmd: dokuwiki-db-usergroup-{{h}}

dokuwiki-db-usergroup-{{h}}:
  cmd.wait:
    - name: /usr/bin/psql -a {{ db }} < {{ sqldir }}/usergroup.sql
    - unless: /usr/bin/pg_dump -st usergroup {{ db }} 2>&1 > /dev/null
    - user: {{ runas }}
    - require:
      - cmd: dokuwiki-db-users-{{h}}
      - cmd: dokuwiki-db-groups-{{h}}

dokuwiki-db-users-{{h}}:
  cmd.wait:
    - name: /usr/bin/psql -a {{ db }} < {{ sqldir }}/users.sql
    - unless: /usr/bin/pg_dump -st users {{ db }} 2>&1 > /dev/null
    - user: {{ runas }}

dokuwiki-db-groups-{{h}}:
  cmd.wait:
    - name: /usr/bin/psql -a {{ db }} < {{ sqldir }}/groups.sql
    - unless: /usr/bin/pg_dump -st groups {{ db }} 2>&1 > /dev/null
    - user: {{ runas }}

{% endfor %}

