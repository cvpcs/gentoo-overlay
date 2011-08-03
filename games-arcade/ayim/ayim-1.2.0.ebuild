# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

EAPI="2"

MY_PN="AndYetItMoves"

DESCRIPTION="An arcade puzzle game about space and Vs"
HOMEPAGE="http://thelettervsixtim.es/"
SRC_URI="
	amd64? ( ${MY_PN}-${PV}_x86_64.tar.gz )
	x86? ( ${MY_PN}-${PV}_i386.tar.gz )"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip fetch"

RDEPEND="
	 media-libs/libogg
	 media-libs/libsdl
	 media-libs/libvorbis
	 media-libs/libtheora
	 media-libs/sdl-image[jpeg,png]
	 virtual/opengl
	 x11-libs/libXft
	 x11-libs/libX11"
DEPEND=""

S=${WORKDIR}/${MY_PN}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}/lib"
	doexe lib/${MY_PN} || die

	insinto "${dir}"
	doins -r Language NandIcon common game icons resources
	doins main.cs

	newicon "icons/32x32.png" ${PN}.png
	make_desktop_entry ${PN} "And Yet It Moves"

	games_make_wrapper ${PN} "${dir}"/lib/${MY_PN} "${dir}"
	prepgamesdirs
}
