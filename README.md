# ansemjo.gitlab

This role targets CentOS 7 systems and installs GitLab CE.

See `defaults/main.yml` for available variables or just define your
own template to be used with `ansemjo_gitlab_template`.

## playbook

This role expects to find a tls certificate and key at
`/etc/pki/tls/{certs,private}/$FQDN.{crt,key}`. If this is
a FreeIPA-enrolled system, this can be achieved with my
`ansemjo.ipa-getcert` role.
