#!/bin/bash

GREEN=$'\e[1;32m'
NC=$'\e[0m'

if [[ $# -ne 1 ]]; then
	echo "Usage: $(basename $0) <aria2.conf path>"
	exit 1
fi
file="$1"

if [[ ! -f "$file" ]]; then
	echo "aria2.conf does not exist."
	exit 1
fi

tracker="bt-tracker="
tracker+=$(
	curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all_aria2.txt ||
		curl -fsSL https://fastly.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt ||
		curl -fsSL https://gcore.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt ||
		curl -fsSL https://testingcf.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt
)

if grep -qE "^bt-tracker\s*=" "$file"; then
	sed -i "s@^\(bt-tracker\s*=\).*@${tracker}@" "$file"
else
	echo "${tracker}" >>"$file"
fi

echo "${GREEN}[Success]${NC} Updated the BT Trackers in $file"
