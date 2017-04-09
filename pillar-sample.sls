getssl: work: /etc/le
  admin: admin@notomorrow.de

http:
  listen:
    - '[::]:80'
  listen_ssl:
    - '[::]:443'
  usetrustedssl: False

  backends:
    ww1: ww1
    wwz: wwz
    www: ww2

domains:
  m32.notomorrow.de:
    backend: ww1
    webroot:
    wildcard:
      - .d3.notomorrow.de
    redirecthttp: True
  r.notomorrow.de:
    backend: repo
    webroot:
  wwz.notomorrow.de:
    backend: www
    webroot:
    alias: 
      - dev.notomorrow.de
