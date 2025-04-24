#!/bin/bash -e
# modified from https://github.com/jackfido/nightMode

# Check for themes at:
# /usr/share/themes
LIGHT_GTK_THEME="Yaru-purple"
DARK_GTK_THEME="Yaru-dark"
# /usr/share/icons
LIGHT_ICON_THEME="Yaru-purple"
DARK_ICON_THEME="Yaru-dark"

# editable, check www.timeanddate.com/sun for options
COUNTRY="usa"
CITY="chicago"

LOGFILE=~/tmp/theme_switcher_data_"$COUNTRY"_"$CITY".out
wget -q "https://www.timeanddate.com/sun/$COUNTRY/$CITY" -O "$LOGFILE"

SUNR=$(grep "Sunrise Today" "$LOGFILE" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | head -1 | date -f - +%Y%m%d%H%M)
SUNS=$(grep "Sunset Today" "$LOGFILE" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | tail -1 | date -f - +%Y%m%d%H%M)
hour=$(date +%Y%m%d%H%M)
current_theme_setting=$(gsettings get org.gnome.desktop.interface gtk-theme)

# set theme
if [ "$hour" -gt "$SUNR" ] && [ "$hour" -lt "$SUNS" ];
then
    gsettings set org.gnome.desktop.interface gtk-theme $LIGHT_GTK_THEME
	gsettings set org.gnome.desktop.interface icon-theme $LIGHT_ICON_THEME
else
    gsettings set org.gnome.desktop.interface gtk-theme $DARK_GTK_THEME
	gsettings set org.gnome.desktop.interface icon-theme $DARK_ICON_THEME
fi

if [ "$current_theme_setting" != "$(gsettings get org.gnome.desktop.interface gtk-theme)" ];
then 
    notify-send "Theme changed to $(gsettings get org.gnome.desktop.interface gtk-theme)"
fi
