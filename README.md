# ansemjo.gitlab

This role targets CentOS 7 systems and installs GitLab CE.

See `defaults/main.yml` for available variables or just define your own template to be used with
`gitlab_template`.

## Configuration Notes

### TLS certificates

This role expects to find a tls certificate and key at
`/etc/pki/tls/{certs,private}/$FQDN.{crt,key}`. If this is a FreeIPA-enrolled system, this can be
achieved with my `ansemjo.ipa-getcert` role. It also assumes that a valid CA certificate is located
at `/etc/ipa/ca.crt`.

```yaml
ansemjo_ipa_getcert_request_hostnames:
  - "{{ ansible_fqdn }}"
  - "{{ gitlab_registry_fqdn }}"
gitlab_registry_enabled: true
gitlab_registry_fqdn: "{{ my_registry }}"
```

Otherwise configure the following variables appropriately:

```yaml
gitlab_tls_cert: "/etc/pki/tls/certs/{{ gitlab_fqdn }}.crt"
gitlab_tls_key: "/etc/pki/tls/private/{{ gitlab_fqdn }}.key"
gitlab_registry_tls_cert: "/etc/pki/tls/certs/{{ gitlab_registry_fqdn }}.crt"
gitlab_registry_tls_key: "/etc/pki/tls/private/{{ gitlab_registry_fqdn }}.key"
gitlab_ca_symlinks:
    - src: /etc/path/to/your/ca.crt
      dst: /etc/gitlab/trusted-certs/my-ca.crt
```

### Default project features

The default project features can be configured with:

```yaml
# default project feature settings
gitlab_default_projects_features_issues: yes
gitlab_default_projects_features_merge_requests: yes
gitlab_default_projects_features_wiki: no
gitlab_default_projects_features_snippets: no
gitlab_default_projects_features_builds: no
gitlab_default_projects_features_container_registry: no
```

### Upload Backups to Amazon S3 / Minio

To upload your GitLab backups to an S3 compatible bucket, e.g. on [minio](https://minio.io/), you
can set the following host variables:

```yaml
gitlab_backup_s3_enabled: yes
gitlab_backup_s3_key_id: YOUR-ACCESS-KEY-HERE
gitlab_backup_s3_key_secret: YOUR-SECRET-KEY-HERE
gitlab_backup_s3_endpoint: https://minio.yourdomain.com:9000
gitlab_backup_s3_path_style: yes
gitlab_backup_s3_bucket: gitlab-backups
```

For
[uploads to Amazon AWS](https://docs.gitlab.com/ee/raketasks/backup_restore.html#using-amazon-s3)
remove the `*_path_style` and `*_endpoint` variables and instead add a region:

```yaml
gitlab_backup_s3_enabled: yes
gitlab_backup_s3_region: eu-west-1
gitlab_backup_s3_key_id: YOUR-ACCESS-KEY-HERE
gitlab_backup_s3_key_secret: YOUR-SECRET-KEY-HERE
gitlab_backup_s3_bucket: gitlab-backups
```

Scheduling is done with:

```yaml
# backup scheduling
gitlab_backup_on_calendar: weekly # systemd OnCalendar= format
gitlab_backup_keep_time: 2678400 # 31 days
```

### LDAP Authentication

You can enable LDAP authentication to use e.g. FreeIPA as a central user manager. See
`defaults/main.yml` for all availabe options.
