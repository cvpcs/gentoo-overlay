# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/smc/smc-1.4.ebuild,v 1.3 2008/01/06 23:53:26 tupone Exp $

inherit autotools eutils games subversion

DESCRIPTION="Secret Maryo Chronicles"
HOMEPAGE="http://www.secretmaryo.org/"
ESVN_REPO_URI="http://opensvn.csie.org/SMC/SMC"
ESVN_PROJECT="SMC"
ESVN_BOOTSTRAP="autogen.sh"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND=">=dev-games/cegui-0.5
	dev-libs/boost
	virtual/opengl
	virtual/glu
	media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-arch/unzip"

pkg_setup() {
	games_pkg_setup
	if ! built_with_use media-libs/sdl-image png ; then
		die "Please emerge sdl-image with USE=png"
	fi
	if ! built_with_use dev-games/cegui opengl ; then
		die "Please emerge cegui with USE=opengl"
	fi
	if ! built_with_use dev-games/cegui devil ; then
		die "Please emerge cegui with USE=devil"
	fi
	if ! built_with_use dev-libs/libpcre unicode ; then
		die "Please emerge dev-libs/libpcre with USE=unicode"
	fi
}

src_unpack() {
	subversion_src_unpack
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon data/icon/window_32.png ${PN}.png
	make_desktop_entry ${PN} "Secret Maryo Chronicles"
	dodoc docs/*.txt
	dohtml docs/{*.css,*.html}
	prepgamesdirs
}
