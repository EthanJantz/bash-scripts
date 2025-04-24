#!/bin/bash -e

# # necessary for me on Ubuntu 24.04.2 LTS
REAL_UID=$(id --real --user)
PID=$(pgrep --euid $REAL_UID gnome-session | head -n 1)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2- | sed -e "s/\x0//g")

# Check for themes at:
# /usr/share/themes
LIGHT_GTK_THEME="Yaru"
DARK_GTK_THEME="Yaru-dark"
# /usr/share/icons
LIGHT_ICON_THEME="Yaru"
DARK_ICON_THEME="Yaru-dark"

# editable, check www.timeanddate.com/sun for options
COUNTRY="usa"
CITY="chicago"

LOGFILE=theme_switcher_data_"$COUNTRY"_"$CITY".out
wget -q "https://www.timeanddate.com/sun/$COUNTRY/$CITY" -O "$LOGFILE"

SUNR=$(grep "Sunrise Today" "$LOGFILE" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | head -1 | date -f - +%Y%m%d%H%M)
SUNS=$(grep "Sunset Today" "$LOGFILE" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | tail -1 | date -f - +%Y%m%d%H%M)
hour=$(date +%Y%m%d%H%M)
current_theme_setting=$(gsettings get org.gnome.desktop.interface color-scheme)

# set theme
if [ "$hour" -gt "$SUNR" ] && [ "$hour" -lt "$SUNS" ];
then
    theme=$LIGHT_GTK_THEME
    icons=$LIGHT_ICON_THEME
    preference='prefer-light'
else
    theme=$DARK_GTK_THEME
    icons=$DARK_ICON_THEME
    preference='prefer-dark'
fi

gsettings set org.gnome.desktop.interface gtk-theme $theme
gsettings set org.gnome.desktop.interface icon-theme $icons
gsettings set org.gnome.desktop.interface color-scheme $preference

# Checks the theme preference setting, but the gtk-theme setting looks nicer in a message.
if [ "$current_theme_setting" != "$(gsettings get org.gnome.desktop.interface color-scheme)" ];
then 
    notify-send "Theme changed to $(gsettings get org.gnome.desktop.interface gtk-theme)"
fi
