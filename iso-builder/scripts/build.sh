#!/usr/bin/env bash
set -euo pipefail

# Location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORK_DIR="${ROOT_DIR}/work"
OUT_DIR="${ROOT_DIR}/out"
ISO_NAME="hypr-dashboard-$(date +%Y%m%d).iso"

PACKAGES_FILE="${SCRIPT_DIR}/packages.txt"

mkdir -p "${WORK_DIR}" "${OUT_DIR}"

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "mkarchiso is required. Install archiso package." >&2
  exit 1
fi

PROFILE_DIR="${WORK_DIR}/profile"
rm -rf "${PROFILE_DIR}"
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" -L "HyprDashboard" -D releng --copy
mv "${WORK_DIR}/releng" "${PROFILE_DIR}"

# Copy packages list
cp "${PACKAGES_FILE}" "${PROFILE_DIR}/packages.x86_64"

# Copy custom scripts
install -Dm755 "${SCRIPT_DIR}/chroot_prepare.sh" "${PROFILE_DIR}/airootfs/root/chroot_prepare.sh"
install -Dm755 "${SCRIPT_DIR}/chroot_install.sh" "${PROFILE_DIR}/airootfs/root/chroot_install.sh"
install -Dm755 "${SCRIPT_DIR}/branding.sh" "${PROFILE_DIR}/airootfs/root/branding.sh"
install -Dm755 "${SCRIPT_DIR}/post_install.sh" "${PROFILE_DIR}/airootfs/root/post_install.sh"

# User configs
rsync -a "${ROOT_DIR}/configs/hypr/" "${PROFILE_DIR}/airootfs/etc/skel/.config/hypr/"
rsync -a "${ROOT_DIR}/configs/waybar/" "${PROFILE_DIR}/airootfs/etc/skel/.config/waybar/"
rsync -a "${ROOT_DIR}/configs/kitty/" "${PROFILE_DIR}/airootfs/etc/skel/.config/kitty/"
rsync -a "${ROOT_DIR}/configs/cava/" "${PROFILE_DIR}/airootfs/etc/skel/.config/cava/"
rsync -a "${ROOT_DIR}/configs/btop/" "${PROFILE_DIR}/airootfs/etc/skel/.config/btop/"

# System configs
install -Dm644 "${ROOT_DIR}/configs/sddm/sddm.conf" "${PROFILE_DIR}/airootfs/etc/sddm.conf"
install -Dm644 "${ROOT_DIR}/configs/sddm/theme.conf" "${PROFILE_DIR}/airootfs/usr/share/sddm/themes/hypr-dashboard/theme.conf"
install -Dm644 "${ROOT_DIR}/configs/system/autologin.service" "${PROFILE_DIR}/airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf"
install -Dm644 "${ROOT_DIR}/configs/system/pipewire.conf" "${PROFILE_DIR}/airootfs/etc/pipewire/pipewire.conf"

# Copy assets
rsync -a --delete "${ROOT_DIR}/assets/" "${PROFILE_DIR}/airootfs/usr/share/hypr-dashboard-assets/"

# Ensure wallpaper default
install -Dm644 "${ROOT_DIR}/assets/wallpapers/pixel_city.png" \
  "${PROFILE_DIR}/airootfs/usr/share/backgrounds/pixel_city.png"

# Hook scripts into mkarchiso process
cat <<'HOOK' > "${PROFILE_DIR}/airootfs/root/customize_airootfs.sh"
#!/usr/bin/env bash
set -euo pipefail
/root/chroot_prepare.sh
/root/chroot_install.sh
/root/branding.sh
/root/post_install.sh
HOOK
chmod +x "${PROFILE_DIR}/airootfs/root/customize_airootfs.sh"

pushd "${PROFILE_DIR}" >/dev/null
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" -L "HyprDashboard" .
popd >/dev/null

echo "ISO generated at ${OUT_DIR}/${ISO_NAME} (see mkarchiso output for actual filename)."
