#!/bin/bash

infile="$1"

chars_per_line=150
indent_spaces=10

if [[ -z $infile ]]; then
  echo "ERROR: Must supply file name to encode"
  exit 1
fi

((indent_brackets = indent_spaces))
((indent_data = indent_spaces + 2))

data=$(base64 -w 0 "$infile")

tmpdir="/tmp/.do_base64"

if [[ -d "$tmpdir" ]]; then
  rm -Rf "$tmpdir" 
fi

if [[ ! -d "$tmpdir" ]]; then
  mkdir "$tmpdir" 
fi

cd "$tmpdir"
rc=$?
if [[ "$rc" != "0" ]]; then
  exit 1
fi

echo -n "$data" | split -b $chars_per_line

printf "%${indent_brackets}s[\n" ""

ls x?? | while read file; do
  line=$(cat "$file")
  printf "%${indent_data}s'%s',\n" "" "$line"
done

printf "%${indent_brackets}s].join(\"\"),\n" ""
