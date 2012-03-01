# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games git-2 java-pkg-2

DESCRIPTION="CraftBukkit extendable dedicated server for Minecraft"
HOMEPAGE="http://bukkit.org"

EGIT_REPO_URI="git://github.com/Bukkit/CraftBukkit"
EGIT_COMMIT="66ea5a93eff5510001200d7bb5b4abaff44dfd25"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="virtual/jdk:1.6
	>=dev-java/maven-bin-3"

RDEPEND="virtual/jre:1.6
	app-misc/tmux
	sys-apps/openrc"

DIR="/var/lib/craftbukkit"
PID="/var/run/craftbukkit"

pkg_setup() {
	java-pkg-2_pkg_setup
	games_pkg_setup
}

src_prepare() {
	cp "${FILESDIR}"/{directory,init,console,console-send}.sh . || die
	sed -i "s/@GAMES_USER_DED@/${GAMES_USER_DED}/g" directory.sh init.sh || die
}

src_compile() {
	mvn-3.0 -Duser.home="${S}" clean package
}

src_install() {
	local artifact
	local version

	artifact="$(grep artifactId pom.xml | head -n 1 | sed -r 's/.*<artifactId>(.*)<\/artifactId>.*/\1/')"
	version="$(grep version pom.xml | head -n 1 | sed -r 's/.*<version>(.*)<\/version>.*/\1/')"

	java-pkg_newjar "target/${artifact}-${version}.jar" "${PN}.jar"

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
	einfo "You may run craftbukkit-server as a regular user or start a system-wide"
	einfo "instance using /etc/init.d/craftbukkit. The server files are stored in"
	einfo "~/.craftbukkit/servers or /var/lib/craftbukkit respectively."
	echo
	einfo "The console for system-wide instances can be accessed by any user in"
	einfo "the ${GAMES_GROUP} group using the craftbukkit-server-console command. This"
	einfo "starts a client instance of tmux. The most important key-binding to"
	einfo "remember is Ctrl-b d, which will detach the console and return you to"
	einfo "your previous screen without stopping the server."
	echo
	einfo "This package allows you to start multiple CraftBukkit server instances."
	einfo "You can do this by adding a name after craftbukkit-server or by creating"
	einfo "a symlink such as /etc/init.d/craftbukkit.foo. You would then access the"
	einfo "console with \"craftbukkit-server-console foo\". The default server name"
	einfo "is \"main\"."
	echo
	einfo "It is also possible to send commands to the console in a scripting fashion"
	einfo "using \"craftbukkit-server-console-send <server> <command>\"."
	echo

	games_pkg_postinst
}
