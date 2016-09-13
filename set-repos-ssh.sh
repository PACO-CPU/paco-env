#!/bin/sh
repos=$(find . -iname ".git" | rev | cut -c 5- | rev)
root=$(pwd)
for repo in $repos; do
    cd $repo
    url=$(git config --get remote.origin.url)
    url=$(echo $url | sed 's,https://git.cs.upb.de/,irb-git@git.cs.upb.de:,g')
    echo Setting url for $repo to \'$url\'
    git remote set-url origin $url
    cd $root
done

