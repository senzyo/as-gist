#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <root directory> <output file>"
  exit 1
fi

root_dir=$1
output_file=$2

if [ ! -d "$root_dir" ]; then
  echo "Directory does not exist."
  exit 1
fi

raw="https://raw.githubusercontent.com/senzyo/sing-box-templates/public"

function generate {
    local path="$1"
    local depth="$2"

    echo -e "$(printf '#%.0s' $(seq 1 $depth)) $(basename "$path")\n" >>$output_file

    for item in "$path"/*; do
        if [ -f "$item" ]; then
            echo -e "$raw/$(basename "$root_dir")/${item#$root_dir/}\n" >>$output_file
        fi
    done

    for item in "$path"/*; do
        if [ -d "$item" ]; then
            generate "$item" $((depth + 1))
        fi
    done
}

generate "$root_dir" 1
