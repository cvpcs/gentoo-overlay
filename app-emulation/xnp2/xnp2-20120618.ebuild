# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic pax-utils toolchain-funcs

SRC_URI="http://www.asahi-net.or.jp/~aw9k-nnk/np2/${P}.tar.bz2"

DESCRIPTION="Port of the Neko Project 2 PC-98 Emulator"
HOMEPAGE="http://www.asahi-net.or.jp/~aw9k-nnk/np2/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X sdl"

DEPEND=">=x11-libs/gtk+-2.6
	X? ( x11-proto/xf86vidmodeproto )
	sdl? ( media-libs/libsdl
		media-libs/sdl-mixer )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/x11"

src_configure() {
	econf \
		$(use_enable X xf86vidmode) \
		$(use_enable sdl) \
		$(use_enable sdl sdlmixer)		
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ../readme.txt ../update.txt || die
	newicon resources/np2.xpm ${PN}.xpm
}
