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
IUSE=""
RESTRICT="binchecks strip"

RDEPEND=">=media-gfx/splashutils-1.5.4[png]"
DEPEND="${RDEPEND}"

MAGICK="9d7bc82"
S="${WORKDIR}/cvpcs-${PN}-${MAGICK}"

src_install() {
	dodir /etc/splash
	cp -r "${S}"/* "${D}"/etc/splash/
}
