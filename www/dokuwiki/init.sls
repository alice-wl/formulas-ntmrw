{% set master = grains.get( 'id', 'ntmrw' ) -%}

{% for h, dokuwiki in pillar.get('dokuwiki', {}).items() -%}

{% set home   = dokuwiki.get( 'home', '/srv/ntmrw' ) -%}
{% set wwwdir = dokuwiki.get( 'wwwdir', home + '/dokuwiki' ) -%}
{% set srcdir = dokuwiki.get( 'srcdir', home + '/src' ) -%}
{% set domdir = dokuwiki.get( 'domdir', home + '/domains' ) -%}
{% set cnfdir = dokuwiki.get( 'cnfdir', home + '/conf' ) -%}

{% set user   = dokuwiki.get( 'user', 'ai' ) -%}
{% set group  = dokuwiki.get( 'group', 'ai' ) -%}

{{ home }}:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - dir_mode: 0755
    - force: True
    - backupname: bak
{% if dokuwiki.get( 'format', 'zip' ) == 'git' %}
  git.latest:
      - name: {{dokuwiki.source_git}}
      - rev: {{dokuwiki.get( 'rev', 'master' ) }}
      - target: {{wwwdir}}
      - user: {{user}}
      - watch:
        - file: {{ home }}
{% else %}
  archive.extracted:
      - source: {{dokuwiki.source}}
      - archive_format: {{dokuwiki.format}}
      - source_hash: {{dokuwiki.source_hash}}
      - if_missing: {{wwwdir}}
      - watch:
        - file: {{ home }}
{% endif %}

{{ cnfdir }}:
  file.recurse:
    - user: {{user}}
    - group: {{group}}
    - file_mode: 644
    - dir_mode: 755
    - source: salt://www/dokuwiki/files/conf
    - include_empty: True
    - keep_symlinks: False
    - template: jinja
    - context:
      home: {{home}}
      master: {{master}}
      domdir: {{domdir}}
{{wwwdir}}/inc/preload.php:
  file.symlink:
    - target: {{ cnfdir }}/preload.php
    - user: {{user}}
    - group: {{group}}
    - force: True
    - backupname: bak
    - require:
      - file: {{ home }}
      - file: {{ cnfdir }}

{{domdir}}:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - mode: 0755

{{srcdir}}/plugins:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - mode: 0755

{% for name, plugin in dokuwiki.get('plugins', {}).items() -%}
{% set pluginformat = plugin.get( 'format', 'zip' ) -%}

{{wwwdir}}/lib/plugins/{{name}}:
  {% if pluginformat == 'git' %}
    git.latest:
      - name: {{plugin.source_git}}
      - user: {{user}}
      - rev: {{plugin.get( 'rev', 'master' ) }}
      - target: {{srcdir}}/plugins/{{name}}
      - require:
        - file: {{srcdir}}/plugins
    file.symlink:
      - target: {{srcdir}}/plugins/{{name}}
      - user: {{user}}
      - group: {{group}}
      - force: True
      - backupname: bak
      - require:
        - file: {{home}}
  {% else %}
    archive.extracted:
      - name: {{wwwdir}}/lib/plugins
      - source: {{plugin.source}}
      - archive_format: {{ pluginformat }}
      {% if plugin.get( 'options', { } ) %}
      - tar_options: {{plugin.options}} {% endif %}
      - source_hash: {{plugin.source_hash}}
      - if_missing: {{wwwdir}}/lib/plugins/{{name}}
      - require:
        - file: {{home}}
  {% endif %}
{% endfor %}


{{srcdir}}/templates:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - mode: 0755

{% for name, template in dokuwiki.get('templates', {}).items() -%}
{% set templateformat = template.get( 'format', 'zip' ) -%}

{{wwwdir}}/lib/tpl/{{name}}:
  {% if templateformat == 'git' %}
    git.latest:
      - name: {{template.source_git}}
      - user: {{user}}
      - rev: {{template.get( 'rev', 'master' ) }}
      - target: {{srcdir}}/templates/{{name}}
      - require:
        - file: {{srcdir}}/templates
    file.symlink:
      - target: {{srcdir}}/templates/{{name}}
      - user: {{user}}
      - group: {{group}}
      - force: True
      - backupname: bak
      - require:
        - file: {{home}}
  {% else %}
    archive.extracted:
      - name: {{wwwdir}}/lib/tpl
      - source: {{template.source}}
      - archive_format: {{templateformat}}
      {% if template.get( 'options', { } ) %}
      - tar_options: {{template.options}} {% endif %}
      - source_hash: {{template.source_hash}}
      - if_missing: {{wwwdir}}/lib/tpl/{{name}}
      - require:
        - file: {{home}}
  {% endif %}
{% endfor %}
{% endfor %}
