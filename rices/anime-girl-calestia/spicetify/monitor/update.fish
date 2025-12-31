#!/bin/fish

set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME || set -l config $HOME/.config
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state
set -l scheme_path $state/caelestia/scheme/current.txt
set -l dist $config/spicetify/Themes/caelestia/color.ini

mkdir -p (dirname $dist)
cp (dirname (status filename))/../template.ini $dist
cat $scheme_path | while read line
    set -l colour (string split ' ' $line)
    sed -i "s/\$$colour[1]/$colour[2]/g" $dist
end
