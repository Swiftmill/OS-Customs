# Hypr Dashboard ISO Builder

Create a fully themed Arch Linux live ISO featuring a sci-fi Hyprland dashboard with glassmorphism styling.

## Prerequisites
- Arch Linux host (or Arch-based) with `archiso` package installed
- At least 20 GB free disk space
- Internet connection for package downloads

## Repository Layout
```
iso-builder/
  scripts/          # Build + install automation
  configs/          # Hyprland, Waybar, terminal, etc.
  assets/           # Icon/cursor/audio placeholders + wallpaper drop-in spot
```

## Building the ISO
1. Install archiso: `sudo pacman -S archiso`
2. Run the build script:
   ```bash
   cd iso-builder/scripts
   ./build.sh
   ```
   The script clones the stock `releng` profile, injects our packages/configs, and uses `mkarchiso` to emit `out/HyprDashboard-*.iso`.

## Booting / Installing
- Boot the ISO in a VM (QEMU/VMware/VirtualBox) or on bare metal.
- Default user: `hypr` / password `hypr`. Root password is `root`.
- SDDM autologins into Hyprland. Everything—Waybar, Kitty, btop, cava, and the Matrix rain panel—launches automatically.

## UI + Keybinds
- **Workspaces**: Super+1/2/3 move between three large dashboard bubbles (mirrored in Waybar).
- **Launcher**: Super+D launches Rofi.
- **Terminal**: Super+Enter opens Kitty.
- **System Monitor**: btop auto-tiles on the left.
- **Audio Viz**: Cava window floats near the bottom.
- **Matrix Rain**: A dedicated Kitty/foot instance runs `~/.config/hypr/scripts/matrix.sh` for the holographic feel.
- **Wallpaper**: Drop your favorite neon pixel-art PNG at `assets/wallpapers/pixel_city.png` before building. It will be copied to `/usr/share/backgrounds/pixel_city.png` inside the ISO.

## Customizing
### Wallpaper
Place (or replace) `assets/wallpapers/pixel_city.png` before running `build.sh`. The repository intentionally omits binary artwork, so use your own 4K PNG and it will be bundled automatically. After installation you can still change the wallpaper by editing the `swww` command inside `~/.config/hypr/autostart`.

### Colors & Theme
- **Hyprland**: Edit `configs/hypr/hyprland.conf` (decoration + blur) and `waybar/style.css` for gradients.
- **Waybar**: Update `configs/waybar/style.css` for background, blur, fonts, neon colors.
- **Kitty**: Adjust palette in `configs/kitty/kitty.conf`.
- **btop/cava**: Modify `configs/btop/btop.conf` and `configs/cava/config` for alternate hues.

### Fonts
Packages include JetBrains Mono + Noto. Change `font_family` entries in Kitty and update `waybar/style.css`. Add fonts to `scripts/packages.txt` if new ones are needed.

### Workspace Labels
Waybar workspace names follow Hyprland numbering. Update `configs/waybar/config` `format-icons` or rename via Hyprland workspace definitions in `configs/hypr/monitors.conf`.

## Branding Hooks
`scripts/branding.sh` installs a custom SDDM theme referencing our wallpaper and neon colors. Cursor/icon/sound placeholders live under `assets/` for future customization.
