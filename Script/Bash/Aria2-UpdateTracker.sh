#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) <aria2.conf path>"
    exit 1
fi
file="$1"

if [ ! -f "$file" ]; then
    echo "aria2.conf does not exist."
    exit 1
fi

tracker="bt-tracker="
tracker+=$(
    curl -fsSL https://ghp.ci/https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all_aria2.txt ||
        curl -fsSL https://ghproxy.net/https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all_aria2.txt ||
        curl -fsSL https://fastly.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt ||
        curl -fsSL https://gcore.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt ||
        curl -fsSL https://testingcf.jsdelivr.net/gh/XIU2/TrackersListCollection@master/all_aria2.txt
)

if grep -qE "^bt-tracker\s*=" "$file"; then
    sed -i "s@^\(bt-tracker\s*=\).*@${tracker}@" "$file"
else
    echo "${tracker}" >>"$file"
fi

echo -e "\e[1;32mSuccessfully\e[0m updated the \e[1;34mbt-tracker\e[0m item in \e[1;33m$file\e[0m."
