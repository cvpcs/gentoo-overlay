# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit games versionator

MY_PN="CrayonPhysicsDeluxe"
MY_PV=$(replace_version_separator 1 '_')

DESCRIPTION="A puzzle game where you draw your own solutions"
HOMEPAGE="http://www.crayonphysics.com/"
SRC_URI="${PN}_release${MY_PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip fetch"

RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-qtlibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
		)
	x86? (
		virtual/opengl
		net-misc/curl
		x11-libs/qt-gui
		x11-libs/qt-core
		)"
DEPEND=""

S=${WORKDIR}/${MY_PN}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}"
	doexe ${PN} || die
	doexe launcher || die
	doexe update || die

	insinto "${dir}"
	doins crayon_playground.url version.xml || die
	doins -r cache data updates || die

	make_desktop_entry ${PN} "Crayon Physics Deluxe"

	games_make_wrapper ${PN} "${dir}"/${PN} "${dir}"
	prepgamesdirs
}
