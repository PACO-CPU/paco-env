#!/bin/sh
repos=$(find . -iname ".git" | rev | cut -c 5- | rev)
base_dir=$(pwd)
for repo in $repos; do
    echo "Pulling $repo"
    cd $repo
    git pull
    cd $base_dir
done
