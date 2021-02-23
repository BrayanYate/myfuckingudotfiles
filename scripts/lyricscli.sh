#!/usr/bin/env bash
#
# Fetch song lyrics.

readarray -t song < <(cmus-remote -Q | awk 'BEGIN { ORS=" "};
                          /tag artist/ {$1=$2=""; sub("  ", ""); a=$0}\
                          /tag title/  {$1=$2=""; sub("  ", ""); t=$0}\
                          END { print a"\n"t }')

artist="${song[0]}"
artist="${artist/Troy/Zac Efron & Vanessa Hudgens}"
title="${song[1]}"
title="${title/,}"
title="${title/Pt./Part}"

url="https://lyrics.wikia.com/wiki/$artist:$title"
url="${url/\’/%27}"

lyrics="$(w3m -dump -T text/html "$url")"
lyrics="${lyrics/*'agreement with music Gracenote.'}"
lyrics="${lyrics/'External links'*}"
lyrics="${lyrics/'Written by:'*}"
lyrics="${lyrics/'Written '*}"
lyrics="${lyrics/'Music by:'*}"
lyrics="${lyrics/'Lyrics licensed'*}"
lyrics="${lyrics/'     '*}"

vim -c Limelight -- <(printf "%s\\n%s\\n" "$artist - $title" "$lyrics")
