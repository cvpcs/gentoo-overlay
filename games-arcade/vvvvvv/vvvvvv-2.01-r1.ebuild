# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

EAPI="2"

MY_PN="VVVVVV"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="An arcade puzzle game about space and Vs"
HOMEPAGE="http://thelettervsixtim.es/"
SRC_URI="${MY_P}_Linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip fetch"

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis,wav]"
DEPEND=""

S=${WORKDIR}/${MY_PN}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}"
	if use amd64 ; then
		newexe ${MY_PN}_64 ${MY_PN} || die
	elif use x86 ; then
		newexe ${MY_PN}_32 ${MY_PN} || die
	else
		die "${PN} only supports amd64 and x86 architecture"
	fi

	insinto "${dir}"
	doins -r data

	newicon "data/icons/32_2.png" ${PN}.png
	make_desktop_entry ${PN} ${MY_PN}

	games_make_wrapper ${PN} "${dir}"/${MY_PN} "${dir}"
	prepgamesdirs
}
