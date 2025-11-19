#!/usr/bin/env bash
set -euo pipefail

THEME_DIR=/usr/share/hypr-dashboard-assets
SDDM_THEME_DIR=/usr/share/sddm/themes/hypr-dashboard

rm -rf "$SDDM_THEME_DIR"
mkdir -p "$SDDM_THEME_DIR"
cat <<CONF > "$SDDM_THEME_DIR/theme.conf"
[General]
Background=${THEME_DIR}/wallpapers/pixel_city.png
Font=JetBrains Mono
FontSize=13
CursorTheme=hypr-dashboard-cursor
PrimaryColor=#54d8ff
SecondaryColor=#ff48c4
ConfettiColor=#00ffcc
CONF

cat <<CONF > /etc/sddm.conf.d/20-theme.conf
[Theme]
Current=hypr-dashboard
CONF

# Plymouth branding (fallback to text if plymouth not present)
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  plymouth-set-default-theme -R spinner || true
fi
