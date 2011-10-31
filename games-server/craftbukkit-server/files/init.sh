#!/sbin/runscript
# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

SERVER="${SVCNAME#*.}"
[[ "${SVCNAME}" == "${SERVER}" ]] && SERVER="main"

PID="/var/run/craftbukkit/${SERVER}.pid"
SOCKET="/tmp/tmux-craftbukkit-${SERVER}"

depend() {
	need net
}

start() {
	ebegin "Starting CraftBukkit server \"${SERVER}\""

	# We can't get the final PID of tmux or the exit status of a
	# program run within it so we use the PID of the server itself and
	# check for success with ewaitfile.
	local CMD="/sbin/start-stop-daemon -S -p '${PID}' -m -k 027 -x /usr/games/bin/craftbukkit-server -- '${SERVER}'"
	su -c "/usr/bin/tmux -S '${SOCKET}' new-session -n 'craftbukkit-${SERVER}' -d \"${CMD}\"" "@GAMES_USER_DED@"
	ewaitfile 10 "${PID}"

	eend $?
}

stop() {
	ebegin "Stopping CraftBukkit server \"${SERVER}\""

	# tmux will automatically terminate when the server does.
	start-stop-daemon -K -p "${PID}"
	rm -f "${SOCKET}"

	eend $?
}
