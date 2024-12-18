#!/bin/bash

RED=$'\e[1;31m'
CYAN=$'\e[1;36m'
NC=$'\e[0m'

if [[ $# -ne 1 ]]; then
	echo "Usage: $(basename $0) <dir>"
	exit 1
fi
dir="$1"
branch="master"

if [[ ! -d "$dir" ]]; then
	echo "Directory does not exist."
	exit 1
fi

if [[ -d "$dir/.git" ]]; then
	remote=$(git -C "$dir" remote -v | grep "(fetch)" | awk '{print $2}')
	rm -rf "$dir/.git"
else
	while true; do
		echo "Example: git@github.com:senzyo-desu/blog.git"
		echo "         https://github.com/senzyo-desu/blog.git"
		echo "${CYAN}[Notice]${NC} Input remote origin address: "
		read -p "> " remote
		if [[ $remote =~ \.git$ ]]; then
			break
		else
			echo "${RED}[Error]${NC} Try again"
		fi
	done
fi

cd "$dir"
git init

if [[ -f ".gitmodules" ]]; then
	while IFS= read -r line; do
		path=$(echo "$line" | awk -F' = ' '/path/ {print $2}')
		if [[ -n "$path" ]]; then
			rm -rf $path
			IFS= read -r line
			url=$(echo "$line" | awk -F' = ' '/url/ {print $2}')
			if [[ -n "$url" ]]; then
				git submodule add "$url" "$path"
				git submodule update --remote --merge
			fi
		fi
	done <.gitmodules
fi

git add -A
git commit -m "Reinitialize"
git branch -m $branch
git remote add origin $remote
