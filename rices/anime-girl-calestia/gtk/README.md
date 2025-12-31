# caelestia-gtk

## THIS REPO IS ARCHIVED IN FAVOUR OF https://github.com/caelestia-dots/caelestia

![showcase](https://github.com/caelestia-dots/readme/blob/main/gtk/showcase.gif)

GTK3 colour scheme for my caelestia dotfiles.
This works by using the `adw-gtk3` theme GTK named colours.

You need to restart the apps to reload the theme (idk why but live reloading doesn't work).

## Installation

Install [`caelestia-scripts`](https://github.com/caelestia-dots/scripts.git),
then run `caelestia install gtk`.

## Usage

If using `systemd`, the service will be installed and enabled automatically.
Otherwise, autostart `$XDG_DATA_HOME/caelestia/gtk/monitor/inotifywait.fish`.
