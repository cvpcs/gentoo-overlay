# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils games

DESCRIPTION="Nintendo GameCube / Wii Emulator"
HOMEPAGE="http://www.dolphin-emu.com"
ESVN_REPO_URI="http://dolphin-emu.googlecode.com/svn/trunk"
ESVN_PROJECT="${P}"
ESVN_FETCH_CMD="svn checkout -r ${PV}"
ESVN_UPDATE_CMD="svn update -r ${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="opengl sdl"

DEPEND=">=dev-util/scons-0.98
	>=x11-libs/wxGTK-2.8
	sdl? >=media-libs/libsdl-1.2
	opengl? virtual/opengl
	media-gfx/nvidia-cg-toolkit
	x11-libs/libXxf86vm
	x11-libs/libXext
	gl? >=media-libs/glew-1.5
	x11-libs/cairo
	media-libs/libao
	media-libs/portaudio"
RDEPEND="${DEPEND}"

pkg_setup(){
	if built_with_use x11-libs/wxGTK odbc ; then
		einfo "Currently, wxGTK will not allow dolphin-emu to build if the odbc"
		einfo "use flag is enabled.  Please disable it using /etc/portage/package.use"
		die "invalid use flag combination"	
	fi
}

src_compile() {
	cd "${S}"

	SCONSCONF=""

	use opengl && SCONSCONF="${SCONSCONF} wxgl=True"
	use sdl && SCONSCONF="${SCONSCONF} sdlgl=True"

	scons ${SCONSCONF} || die "scons failed"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${P}"
	local bdir="Binary/Linux-x86"

	use amd64 && bdir="${bdir}_64"

	exeinto ${dir}
	doexe ${bdir}/Dolphin

	cp -r "${S}/${bdir}/"{Plugins,Sys,Libs,User} "${D}/${dir}"
}
