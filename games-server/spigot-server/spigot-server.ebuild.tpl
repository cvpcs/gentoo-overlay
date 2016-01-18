# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games java-pkg-2 versionator

DESCRIPTION="Spigot extendable dedicated server for Minecraft"
HOMEPAGE="http://spigotmc.org"

BUILDTOOLS="${PN}-buildtools-${PV}.jar"
SRC_URI="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -> ${BUILDTOOLS}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""
RESTRICT="mirror"

DEPEND="virtual/jdk:1.7
	dev-vcs/git"

RDEPEND="virtual/jre:1.7
	app-misc/tmux
	sys-apps/openrc"

DIR="/var/lib/spigot"
PID="/var/run/spigot"

pkg_setup() {
	java-pkg-2_pkg_setup
	games_pkg_setup
}

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}"/* "${S}"/
}

src_prepare() {
	cp "${FILESDIR}"/{directory,init,console,console-send}.sh . || die
	sed -i "s/@GAMES_USER_DED@/${GAMES_USER_DED}/g" directory.sh init.sh || die
}

src_compile() {
	MAVEN_OPTS="-Duser.home=${S}" \
	java -jar "${BUILDTOOLS}" --rev ${PV}
}

src_install() {
	local dir
	local artifact
	local version

	dir=/usr/share/${PN}
	dodir ${dir}

	java-pkg_newjar "spigot-${PV}.jar" "${PN}.jar"

	java-pkg_dolauncher "${PN}" -into "${GAMES_PREFIX}" -pre "directory.sh" \
		--main org.bukkit.craftbukkit.Main --java_args "-Xmx1024M -Xms512M  -Djava.net.preferIPv4Stack=true" --pkg_args "nogui"

	diropts -o "${GAMES_USER_DED}" -g "${GAMES_GROUP}"
	keepdir "${DIR}" "${PID}" || die
	gamesperms "${D}${DIR}" "${D}${PID}" || die

	newinitd init.sh "${PN}" || die
	newgamesbin console.sh "${PN}-console" || die
	newgamesbin console-send.sh "${PN}-console-send" || die

	prepgamesdirs
}

pkg_postinst() {
	einfo "You may run spigot-server as a regular user or start a system-wide"
	einfo "instance using /etc/init.d/spigot. The server files are stored in"
	einfo "~/.spigot/servers or /var/lib/spigot respectively."
	echo
	einfo "The console for system-wide instances can be accessed by any user in"
	einfo "the ${GAMES_GROUP} group using the spigot-server-console command. This"
	einfo "starts a client instance of tmux. The most important key-binding to"
	einfo "remember is Ctrl-b d, which will detach the console and return you to"
	einfo "your previous screen without stopping the server."
	echo
	einfo "This package allows you to start multiple Spigot server instances."
	einfo "You can do this by adding a name after spigot-server or by creating"
	einfo "a symlink such as /etc/init.d/spigot.foo. You would then access the"
	einfo "console with \"spigot-server-console foo\". The default server name"
	einfo "is \"main\"."
	echo
	einfo "It is also possible to send commands to the console in a scripting fashion"
	einfo "using \"spigot-server-console-send <server> <command>\"."
	echo

	games_pkg_postinst
}
