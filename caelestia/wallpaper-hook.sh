##!/bin/bash
#
## Get the current wallpaper from Caelestia
#WALLPAPER=$(caelestia shell wallpaper get)
#
## Generate colors (config prevents applying to system)
#wal -i "$WALLPAPER"
#
## Update Firefox
#pywalfox update

#!/bin/bash
# Get the current wallpaper from Caelestia
WALLPAPER=$(caelestia shell wallpaper get)
# Generate colors (config prevents applying to system)
wal -i "$WALLPAPER"

# Fix gtk.css files to use wal cache instead of symlinks
rm -f "$HOME/.config/gtk-3.0/gtk.css"
cat >"$HOME/.config/gtk-3.0/gtk.css" <<EOF
@import url("file://${HOME}/.cache/wal/colors-gtk.css");
@import "thunar.css";
EOF

rm -f "$HOME/.config/gtk-4.0/gtk.css"
cat >"$HOME/.config/gtk-4.0/gtk.css" <<EOF
@import url("file://${HOME}/.cache/wal/colors-gtk.css");
EOF

# Force GTK reload
gsettings set org.gnome.desktop.interface gtk-theme ''
sleep 0.1
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

# Update Firefox
pywalfox update
