#!/bin/sh

NAME="$1"
SOCKET="/tmp/tmux-spigot-${NAME}"

if [[ ! -S "${SOCKET}" ]] ; then
	echo "The socket file is missing. Is the server running?" >&2
	exit 1
else
	shift 1
fi

exec /usr/bin/tmux -S "${SOCKET}" send-keys "$*" C-m
