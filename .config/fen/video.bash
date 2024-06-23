#!/usr/bin/env bash
if test "$#" -ne 1; then
	echo "Usage: $0 [video file]"
	exit 1
fi

file -b "$1"

if type jq > /dev/null 2> /dev/null; then
	printf "" # No-op
else
	echo "jq missing, it is required to show video dimensions"
	exit 2
fi

if type ffprobe > /dev/null 2> /dev/null; then
	printf "" # No-op
else
	echo "ffprobe (of ffmpeg) missing, it is required to show video dimensions"
	exit 3
fi

ffprobe -v quiet -print_format json -show_format -show_streams "$1" \
	| jq -r '.streams[] | "Dimensions: \(.width) x \(.height)"' 2> /dev/null \
	| grep -v "null x null"
