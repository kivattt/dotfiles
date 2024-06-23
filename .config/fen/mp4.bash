#!/usr/bin/env bash
if test "$#" -ne 1; then
	echo "Usage: $0 [video file]"
	exit 1
fi

file -b "$1"

if type jq > /dev/null 2> /dev/null; then
	ffprobe -v quiet -print_format json -show_format -show_streams "$1" \
		| jq -r '.streams[] | "Dimensions: \(.width) x \(.height)"' 2> /dev/null \
		| grep -v "null x null"
else
	echo "jq missing, it is required to show video dimensions"
	exit 2
fi

