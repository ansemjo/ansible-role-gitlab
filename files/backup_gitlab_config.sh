#!/usr/bin/env bash

set -x

CONFIG=/etc/gitlab
BACKUPS=/var/opt/gitlab/backups

RECIPIENT=YOUR-GPG-FINGERPRINT-HERE

VERSION=$(gitlab-rake gitlab:env:info | \
  sed -n -e '/^GitLab information/{n;p}' | \
  sed 's/.*[[:space:]]\([0-9.]\+\)/\1/')

FILENAME=$(printf '%s_%s_gitlab_config.tar.gpg' "$(date +%s_%Y_%m_%d)" "$VERSION")

USER=git

umask 0077
(cd "$CONFIG" && tar -c *) | \
  gpg -e -r "$RECIPIENT" | \
  sudo -u "$USER" tee "$BACKUPS/$FILENAME" >/dev/null

set +x

