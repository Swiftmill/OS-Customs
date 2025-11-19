#!/usr/bin/env bash
set -euo pipefail

# Cleanup build artifacts to keep ISO small
rm -f /root/chroot_prepare.sh /root/chroot_install.sh /root/branding.sh /root/post_install.sh
