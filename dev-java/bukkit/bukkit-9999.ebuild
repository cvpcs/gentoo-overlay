# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games git-2 java-pkg-2

DESCRIPTION="Bukkit extendable dedicated server for Minecraft"
HOMEPAGE="http://bukkit.org"

EGIT_REPO_URI="git://github.com/Bukkit/Bukkit"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~*"
IUSE=""
RESTRICT="mirror"

DEPEND="virtual/jdk:1.6
	>=dev-java/maven-bin-3"

RDEPEND="virtual/jre:1.6"

src_compile() {
	mvn-3.0 -Duser.home="${S}" clean package
}

src_install() {
	local artifact
	local version

	artifact="$(grep artifactId pom.xml | head -n 1 | sed -r 's/.*<artifactId>(.*)<\/artifactId>.*/\1/')"
	version="$(grep version pom.xml | head -n 1 | sed -r 's/.*<version>(.*)<\/version>.*/\1/')"

	java-pkg_newjar "target/${artifact}-${version}.jar" "${PN}.jar"
}
