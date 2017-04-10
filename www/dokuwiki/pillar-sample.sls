dokuwiki:
  /srv/ntmrw:
    home: /srv/ntmrw
    admin:
      user: alice
      hash: "bla"
      email: "alice@notomorrow.de"
    db:
      user: notomorrow-de
      name: notomorrow-de

    format: git
    source_git: ai@repo.m32:/srv/repo/dokuwiki-source-dokuwiki.git
    rev: master 

    plugins: 
      forcessllogin:
          format: git
          source_git: ai@repo.m32:/srv/repo/dokuwiki-plugin-forcessllogin.git
      include:
          source: http://repo.m32/dokuwiki-plugin-include/pkg/include-origin/master-20150121.zip
          source_hash: md5=392c78a99237074a27d63f09ace6be3d

    templates:
      std:
          format: git
          source_git: ai@repo.m32:/srv/repo/dokuwiki-template-std.git
