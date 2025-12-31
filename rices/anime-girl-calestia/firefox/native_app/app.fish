#!/bin/fish

function get-scheme-json -a scheme_dir
    set -l lines (cat $scheme_dir/current.txt)
    set -l len (count $lines)
    echo -n '{'
    echo -n '"mode":"'(cat $scheme_dir/current-mode.txt)'",'
    for i in (seq 1 $len)
        set -l split (string split ' ' $lines[$i])
        echo -n '"'$split[1]'":"#'$split[2]'"'
        test $i != $len && echo -n ','
    end
    echo -n '}'
end

set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state
set -l scheme_dir $state/caelestia/scheme
set -l message (dirname (status filename))/message.sh

$message (get-scheme-json $scheme_dir)

inotifywait -q -e 'close_write,moved_to,create' -m $scheme_dir | while read dir events file
    test "$dir$file" = $scheme_dir/current.txt && $message (get-scheme-json $scheme_dir)
end
