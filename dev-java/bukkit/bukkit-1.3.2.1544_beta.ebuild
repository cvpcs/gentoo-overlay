# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games git-2 java-pkg-2

DESCRIPTION="Bukkit extendable dedicated server for Minecraft"
HOMEPAGE="http://bukkit.org"

EGIT_REPO_URI="git://github.com/Bukkit/Bukkit"
EGIT_COMMIT="f35e827917618bbfd3b94e7d95d8604a5b6cfc44"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="virtual/jdk:1.6
	>=dev-java/maven-bin-3"

RDEPEND="virtual/jre:1.6"

src_prepare() {
	local group
	local artifact
	local version

	group="$(grep groupId pom.xml | head -n 1 | sed -r 's/^.*<groupId>(.*)<\/groupId>.*$/\1/')"
	artifact="$(grep artifactId pom.xml | head -n 1 | sed -r 's/^.*<artifactId>(.*)<\/artifactId>.*$/\1/')"
	version="$(grep version pom.xml | head -n 1 | sed -r 's/^.*<version>(.*)<\/version>.*$/\1/')"

	echo "groupId=${group}" >> maven.cfg
	echo "artifactId=${artifact}" >> maven.cfg
	echo "version=${version}" >> maven.cfg	
}

src_compile() {
	mvn-3.0 -Duser.home="${S}" clean package
}

src_install() {
	local dir
	local artifact
	local version

	dir=/usr/share/${PN}
	dodir ${dir}

	insinto ${dir}
	doins maven.cfg

	artifact=$(grep artifactId maven.cfg | cut -d= -f2)
	version=$(grep version maven.cfg | cut -d= -f2)

	java-pkg_newjar "target/${artifact}-${version}.jar" "${PN}.jar"
}
