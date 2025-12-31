#!/bin/fish

set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME || set -l config $HOME/.config
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state
set -l scheme_path $state/caelestia/scheme/current.txt
set -l schemes (dirname (status filename))/../schemes

# Update GTK+ theme colours
cp $schemes/template.css $schemes/current.css
cat $scheme_path | while read line
    set -l colour (string split ' ' $line)
    sed -i "s/\$$colour[1]/#$colour[2]/g" $schemes/current.css
end

cp $schemes/current.css $config/gtk-3.0/gtk.css
cp $schemes/current.css $config/gtk-4.0/gtk.css

# Update GTK+ icon theme
set -l colour_scheme (cat $state/caelestia/scheme/current-mode.txt)
gsettings set org.gnome.desktop.interface color-scheme \'prefer-$colour_scheme\'

set -l icon_themes /usr/share/icons/* ~/.icons/* ~/.local/share/icons/*
set i 1
while test $i -le (count $icon_themes)
    if test ! -d $icon_themes[$i] -o -d $icon_themes[$i]/cursors
        # Filter out cursor themes
        set -e icon_themes[$i]
    else
        # Get icon theme name
        set icon_themes[$i] (basename $icon_themes[$i])
        set i (math $i + 1)
    end
end

set -l icon_theme (gsettings get org.gnome.desktop.interface icon-theme | string sub -s 2 -e -1 | string replace -ri -- '-(dark|light)' '')
set -l mode_theme (string match -i $icon_theme-$colour_scheme $icon_themes)
test -n "$mode_theme" && gsettings set org.gnome.desktop.interface icon-theme \'$mode_theme[1]\'

# Reload GTK+ theme (not working)
set -l theme (gsettings get org.gnome.desktop.interface gtk-theme)
gsettings set org.gnome.desktop.interface gtk-theme ''
sleep .1
gsettings set org.gnome.desktop.interface gtk-theme $theme
