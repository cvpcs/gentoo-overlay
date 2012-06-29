# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="cvpcs themes for gensplash consoles"
HOMEPAGE="http://cvpcs.org/"
SRC_URI="https://github.com/cvpcs/${PN}/zipball/v${PV} -> ${P}.zip"

SLOT="0"
LICENSE="Artistic GPL-2 as-is"
KEYWORDS="amd64 x86"
IUSE="+1024x600 +1366x768 +1680x1050 +1920x1080"
RESTRICT="binchecks strip"

RDEPEND=">=media-gfx/splashutils-1.5.4[png]"
DEPEND="app-arch/unzip
	${RDEPEND}"

MAGICK="fb26d5a"
S="${WORKDIR}/cvpcs-${PN}-${MAGICK}"

src_prepare() {
	if ! use 1024x600  ; then rm -r "${S}"/*/*1024x600*  ; fi
	if ! use 1366x768  ; then rm -r "${S}"/*/*1366x768*  ; fi
	if ! use 1680x1050 ; then rm -r "${S}"/*/*1680x1050* ; fi
	if ! use 1920x1080 ; then rm -r "${S}"/*/*1920x1080* ; fi
}

src_install() {
	dodir /etc/splash
	cp -r "${S}"/* "${D}"/etc/splash/
}
