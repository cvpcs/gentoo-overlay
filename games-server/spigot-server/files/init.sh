#!/sbin/runscript
# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

SERVER="${SVCNAME#*.}"
[[ "${SVCNAME}" == "${SERVER}" ]] && SERVER="main"

PID="/var/run/spigot/${SERVER}.pid"
SOCKET="/tmp/tmux-spigot-${SERVER}"

depend() {
	need net
}

start() {
	ebegin "Starting Spigot server \"${SERVER}\""

        # make sure that the run directory exists
        if [ ! -d "$(dirname ${PID})" ] ; then
                mkdir -p "$(dirname ${PID})"
                chown games:games "$(dirname ${PID})"
        fi

	# We can't get the final PID of tmux or the exit status of a
	# program run within it so we use the PID of the server itself and
	# check for success with ewaitfile.
	local CMD="/sbin/start-stop-daemon -S -p '${PID}' -m -k 027 -x /usr/games/bin/spigot-server -- '${SERVER}'"
	su -c "/usr/bin/tmux -S '${SOCKET}' new-session -n 'spigot-${SERVER}' -d \"${CMD}\"" "@GAMES_USER_DED@"
	ewaitfile 10 "${PID}"

	eend $?
}

stop() {
	ebegin "Stopping Spigot server \"${SERVER}\""

	# tmux will automatically terminate when the server does.
	start-stop-daemon -K -p "${PID}"
	rm -f "${SOCKET}"

	eend $?
}
