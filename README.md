# ansemjo.gitlab

This role targets CentOS 7 systems and installs GitLab CE.

See `defaults/main.yml` for available variables or just define your own template to be used with
`ansemjo_gitlab_template`.

## Playbook Execution

## Configuration Notes

### TLS certificates

This role expects to find a tls certificate and key at
`/etc/pki/tls/{certs,private}/$FQDN.{crt,key}`. If this is a FreeIPA-enrolled system, this can be
achieved with my `ansemjo.ipa-getcert` role.

```yaml
ansemjo_ipa_getcert_request_hostnames:
  - "{{ ansible_fqdn }}"
  - "{{ gitlab_registry_fqdn }}"
gitlab_registry_enabled: true
gitlab_registry_fqdn: "{{ my_registry }}"
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
