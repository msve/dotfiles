#!/bin/bash

DOTDIR=$(dirname $0)
TARGET=${1:-~}

# ZSH setup
ln $DOTDIR/zshrc $TARGET/.zshrc
ln $DOTDIR/zprofile $TARGET/.zprofile

# VIM setup
ln $DOTDIR/vimrc $TARGET/.vimrc
[ -d $TARGET/.vim ] || mkdir $TARGET/.vim
[ -d $TARGET/.vim/colors ] || mkdir $TARGET/.vim/colors
ln $DOTDIR/vim/colors/BusyBee.vim $TARGET/.vim/colors/BusyBee.vim

# git setup
ln $DOTDIR/gitconfig $TARGET/.gitconfig

# ls colors
ln $DOTDIR/dir_colors $TARGET/.dir_colors

# I3 setup
[ -d $TARGET/.i3 ] || mkdir $TARGET/.i3
ln $DOTDIR/i3/config $TARGET/.i3/config
ln $DOTDIR/i3/status $TARGET/.i3/status

