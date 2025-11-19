#!/usr/bin/env bash
set -euo pipefail

# Prepare environment inside airootfs during build
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

echo 'KEYMAP=us' > /etc/vconsole.conf

useradd -m -G wheel hypr
printf 'hypr\nhypr\n' | passwd hypr
printf 'root\nroot\n' | passwd

echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/00_wheel
chmod 0440 /etc/sudoers.d/00_wheel
