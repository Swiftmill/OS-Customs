#!/usr/bin/env bash
set -euo pipefail

systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl enable bluetooth.service

mkdir -p /etc/sddm.conf.d
cat <<CONF >/etc/sddm.conf.d/10-wayland.conf
[Autologin]
User=hypr
Session=hyprland.desktop
Relogin=true

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
CONF

# Copy default configs to user home
install -d -m755 /home/hypr/.config
cp -rT /etc/skel/.config /home/hypr/.config
chown -R hypr:hypr /home/hypr/.config

# Default wallpaper
install -Dm644 /usr/share/backgrounds/pixel_city.png /home/hypr/.local/share/wallpapers/pixel_city.png
chown -R hypr:hypr /home/hypr/.local

# Ensure zshrc? not needed but set fastfetch on login via bash_profile
cat <<'PROFILE' > /home/hypr/.bash_profile
[[ -f ~/.bashrc ]] && . ~/.bashrc
fastfetch
PROFILE
chown hypr:hypr /home/hypr/.bash_profile
