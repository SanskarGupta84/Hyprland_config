#!/usr/bin/env bash

exec 9>/tmp/caelestia-wal.lock
flock -n 9 || {
  echo "Another instance is running, exiting."
  exit 1
}

SRC="$HOME/.local/state/caelestia/scheme.json"
DST="$HOME/.cache/wal/colors.json"
TMP="$DST.tmp"

mkdir -p ~/.cache/wal

if [[ ! -f "$SRC" ]]; then
  echo "Error: Source file $SRC not found"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required"
  exit 1
fi

# Extract colors from caelestia scheme
# background=$(jq -r '.colours.base' "$SRC")
# foreground=$(jq -r '.colours.text' "$SRC")
# cursor=$(jq -r '.colours.primary' "$SRC")
# color0=$(jq -r '.colours.surface0' "$SRC")
# color1=$(jq -r '.colours.red' "$SRC")
# color2=$(jq -r '.colours.green' "$SRC")
# color3=$(jq -r '.colours.yellow' "$SRC")
# color4=$(jq -r '.colours.blue' "$SRC")
# color5=$(jq -r '.colours.mauve' "$SRC")
# color6=$(jq -r '.colours.teal' "$SRC")
# color7=$(jq -r '.colours.text' "$SRC")
# color8=$(jq -r '.colours.overlay0' "$SRC")
# color9=$(jq -r '.colours.maroon' "$SRC")
# color10=$(jq -r '.colours.green' "$SRC")
# color11=$(jq -r '.colours.peach' "$SRC")
# color12=$(jq -r '.colours.sapphire' "$SRC")
# color13=$(jq -r '.colours.pink' "$SRC")
# color14=$(jq -r '.colours.sky' "$SRC")
# color15=$(jq -r '.colours.rosewater' "$SRC")

# Extract colors from caelestia scheme
background=$(jq -r '.colours.surface1' "$SRC")
foreground=$(jq -r '.colours.text' "$SRC")
cursor=$(jq -r '.colours.primary' "$SRC")
color0=$(jq -r '.colours.term0' "$SRC")
color1=$(jq -r '.colours.term1' "$SRC")
color2=$(jq -r '.colours.term2' "$SRC")
color3=$(jq -r '.colours.term3' "$SRC")
color4=$(jq -r '.colours.term4' "$SRC")
color5=$(jq -r '.colours.term5' "$SRC")
color6=$(jq -r '.colours.term6' "$SRC")
color7=$(jq -r '.colours.term7' "$SRC")
color8=$(jq -r '.colours.term8' "$SRC")
color9=$(jq -r '.colours.term9' "$SRC")
color10=$(jq -r '.colours.term10' "$SRC")
color11=$(jq -r '.colours.term11' "$SRC")
color12=$(jq -r '.colours.term12' "$SRC")
color13=$(jq -r '.colours.term13' "$SRC")
color14=$(jq -r '.colours.term14' "$SRC")
color15=$(jq -r '.colours.term15' "$SRC")

# Write colors.json atomically
cat >"$TMP" <<EOF
{
  "wallpaper": "$(readlink -f "$HOME/.local/state/caelestia/wallpaper/current")",
  "alpha": "100",
  "special": {
    "background": "#${background}",
    "foreground": "#${foreground}",
    "cursor": "#${cursor}"
  },
  "colors": {
    "color0": "#${color0}",
    "color1": "#${color1}",
    "color2": "#${color2}",
    "color3": "#${color3}",
    "color4": "#${color4}",
    "color5": "#${color5}",
    "color6": "#${color6}",
    "color7": "#${color7}",
    "color8": "#${color8}",
    "color9": "#${color9}",
    "color10": "#${color10}",
    "color11": "#${color11}",
    "color12": "#${color12}",
    "color13": "#${color13}",
    "color14": "#${color14}",
    "color15": "#${color15}"
  }
}
EOF
mv "$TMP" "$DST"
echo "colors.json updated at $(date)"

# Run pywal templates
if command -v wal &>/dev/null; then
  wal -n -q -R
  echo "pywal templates regenerated"
else
  echo "Warning: pywal not installed"
fi

# Fix gtk.css to import from wal cache (prevents symlink back to system theme)
rm -f "$HOME/.config/gtk-3.0/gtk.css"
cat >"$HOME/.config/gtk-3.0/gtk.css" <<EOF
@import url("file://${HOME}/.cache/wal/colors-gtk.css");
@import "thunar.css";
EOF

rm -f "$HOME/.config/gtk-4.0/gtk.css"
cat >"$HOME/.config/gtk-4.0/gtk.css" <<EOF
@import url("file://${HOME}/.cache/wal/colors-gtk.css");
EOF

# Force GTK apps to reload theme
gsettings set org.gnome.desktop.interface gtk-theme ''
sleep 0.1
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
echo "GTK theme reloaded"

# Auto-pick closest Papirus folder color from wal accent (color5 = mauve)
ACCENT=$(jq -r '.special.cursor' "$DST" | tr -d '#')
R=$(printf '%d' 0x${ACCENT:0:2})
G=$(printf '%d' 0x${ACCENT:2:2})
B=$(printf '%d' 0x${ACCENT:4:2})

if [ "$R" -gt "$G" ] && [ "$R" -gt "$B" ]; then
  if [ "$B" -gt "$G" ]; then
    PCOL="pink"
  else PCOL="red"; fi
elif [ "$G" -gt "$R" ] && [ "$G" -gt "$B" ]; then
  if [ "$R" -gt 100 ]; then
    PCOL="yellow"
  else PCOL="green"; fi
elif [ "$B" -gt "$R" ] && [ "$B" -gt "$G" ]; then
  if [ "$R" -gt "$G" ]; then
    PCOL="violet"
  else PCOL="blue"; fi
else
  PCOL="teal"
fi

echo "Setting Papirus folder color to: $PCOL (accent #$ACCENT)"
# Run papirus-folders without sudo using user install
if command -v papirus-folders &>/dev/null; then
  papirus-folders -C "$PCOL" --theme Papirus-Dark
  echo "Papirus folders updated"
else
  echo "Warning: papirus-folders not found"
fi

# Update Firefox
if command -v pywalfox &>/dev/null; then
  pywalfox update
  echo "Pywalfox updated"
else
  echo "Warning: pywalfox not found"
fi

echo "Done!"
