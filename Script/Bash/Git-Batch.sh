#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) <dir>"
    exit 1
fi
dir="$1"

if [ ! -d "$dir" ]; then
    echo "Directory does not exist."
    exit 1
fi

cd "$dir"
repos=()
for subdir in ./*; do
    if [ -d "$subdir/.git" ]; then
        repos+=("$(echo "$subdir" | awk -F/ '{print $NF}')")
    fi
done

function function1 {
    while true; do
        echo -e "\e[1;34mYour Command:\e[0m"
        read -p "> " command
        if [[ $command == "git "* ]]; then
            break
        else
            echo -e "\e[1;31mFormat error, try again.\e[0m"
        fi
    done
    command=${command:4}
    for repo in ${repos[@]}; do
        echo -e "\e[1;33m$repo\e[0m"
        git -C "$repo" $command
    done
}

function function2 {
    echo "Example: git@github.com:senzyo-desu"
    echo "         https://github.com/senzyo-desu"
    echo -e "\e[1;34mYour Input:\e[0m"
    read -p "> " host
    for repo in ${repos[@]}; do
        echo -e "\e[1;33m$repo\e[0m"
        newurl="$host/$repo.git"
        oldurls=$(git -C "$repo" remote -v | grep "(push)" | awk '{print $2}')
        exist=0
        for oldurl in $oldurls; do
            if [[ $oldurl == $newurl ]]; then
                exist=1
                echo -e "\e[1;31mThis address already exists!\e[0m"
                break
            fi
        done
        if [[ $exist != 1 ]]; then
            git -C "$repo" remote set-url --add origin $newurl
        fi
        git -C "$repo" remote -v
    done
}

function function3 {
    echo "Example: git@github.com:senzyo-desu"
    echo "         https://github.com/senzyo-desu"
    echo -e "\e[1;34mYour Input:\e[0m"
    read -p "> " host
    for repo in ${repos[@]}; do
        echo -e "\e[1;33m$repo\e[0m"
        newurl="$host/$repo.git"
        oldurls=$(git -C "$repo" remote -v | grep "(push)" | awk '{print $2}')
        exist=0
        for oldurl in $oldurls; do
            if [[ $oldurl == $newurl ]]; then
                exist=1
                git -C "$repo" remote set-url --delete origin $oldurl
            fi
        done
        if [[ $exist != 1 ]]; then
            echo -e "\e[1;31mThis address does not exist!\e[0m"
        fi
        git -C "$repo" remote -v
    done
}

options=(
    "Input Command"
    "git remote set-url --add origin <newurl>"
    "git remote set-url --delete origin <oldurl>"
    "Quit"
)

while true; do
    echo -e "-----\e[1;34mMenu\e[0m-----"
    for i in ${!options[@]}; do
        echo "[$((i + 1))] ${options[$i]}"
    done
    echo -e "\e[1;34mYour Choice:\e[0m"
    read -p "> " choice
    case $choice in
    1)
        function1
        ;;
    2)
        function2
        ;;
    3)
        function3
        ;;
    4)
        break
        ;;
    *)
        echo -e "\e[1;31mInvalid choice!\e[0m"
        ;;
    esac
done
