#!/bin/sh

BASEDIR=`dirname $0`
echo ${BASEDIR}

# fish
ln -fns ${BASEDIR}/fish ${HOME}/.config

# tmux
ln -fns ${BASEDIR}/.tmux.conf ${HOME}
