#!/usr/bin/env bash
set -e

real_location=$(command -v realpath &>/dev/null && realpath "$0" || {
    p="$0"
    while [ -L "$p" ]; do
      link=$(readlink "$p")
      [[ "$link" = /* ]] && p="$link" || p="$(dirname "$p")/$link"
    done
    echo "$p"
  }
)

cur_dir=`cd $(dirname "$real_location") && cd ..;pwd`
# echo $cur_dir

if [ "$1" == "-u" ]; then
    echo "unlink ~/.config/nvim/{init.lua,tutor,snips,lua}"
    unlink ~/.config/nvim/init.lua
    unlink ~/.config/nvim/tutor
    unlink ~/.config/nvim/snips
    unlink ~/.config/nvim/lua
else
    echo "override symlink ..."
    ln -sfnv $cur_dir/init.lua ~/.config/nvim/init.lua
    ln -sfnv $cur_dir/tutor ~/.config/nvim/tutor
    ln -sfnv $cur_dir/snips ~/.config/nvim/snips
    ln -sfnv $cur_dir/lua ~/.config/nvim/lua
fi