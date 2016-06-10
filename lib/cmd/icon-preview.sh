#!/usr/bin/env bash

# Ensure user has ImageMagick installed
hash convert 2>/dev/null || {
	>&2 echo "ImageMagick is required to run this program.";
	hash brew 2>/dev/null && >&2 echo 'Run `brew install imagemagick` and try again.'
	exit 2;
}

# Disable file-globbing
set -f

# Configuration
output_file=icon-preview.png
font_size=383
font_path=${1:-file-icons.ttf}
tmpdir=tmp

# Font not found
[ ! -f $font_path ] && {
	>&2 echo "Error locating font file"
	>&2 echo "Usage: $0 /path/to/font.ttf"
	exit 3;
}

# Get last two tags
tags=($(git tag --sort=taggerdate | tail -n2))

# Obtain a list of icons added since the last version
icon_rule='^\+\.(\w+)-icon(:+before)?\s*\{\s*\.(file-icons|fi);'
icons=$(git diff ${tags[0]}..${tags[1]} -w styles/icons.less |\
	grep -E $icon_rule |\
	sed -r "s/${icon_rule}\s*content:\s*\"([^\"]+)\".+$/\1\t\4/g" |\
	cut -f2)

# Dimensions
size_mult=0.25
tile_size=$(printf "%0.f\n" $(printf "(%d %s $size_mult) + %d\n" $font_size '*' $font_size | bc))


# Generate a tile image for each character in a string
letters(){
	tile_count=$tile_count
	for i in $@; do
		chr=$i
		
		echo $chr | grep "^\\\\[A-Fa-f0-9]" >/dev/null && {
			chr=$(echo $chr | tr -d '\\')
			chr=$(perl -Mutf8 -CS -e "print chr(0x$chr)")
		}
		
		file=$tmpdir/letter-$(echo $i | tr -d '\\').png
		convert -background none -fill black \
			-font "$font_path" \
			-pointsize $font_size \
			-kerning -60 \
			label:"$chr" \
			-gravity "Center" \
			-extent "${tile_size}x${tile_size}" \
			-strip \
			"$file"
		echo "$file"
	done
}


# Generate the compiled preview image
stitch(){
	count=$#
	montage -background none \
		-geometry "${tile_size}x${tile_size}" \
		"$@" $tmpdir/icon-preview.png
	rm -f "$@"
}

[ -d $tmpdir ] || mkdir $tmpdir

stitch $(letters $icons)
