# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="nehresma themes for GDM Greeter"
HOMEPAGE="http://github.com/nehresmann/gdm-themes-nehresma"
SRC_URI="https://github.com/nehresmann/${PN}/zipball/v${PV} -> ${P}.zip"

SLOT="0"
LICENSE="Artistic GPL-2 as-is"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="binchecks strip"

RDEPEND="gnome-base/gdm"
DEPEND="${RDEPEND}"

MAGICK="5cb9231"
S="${WORKDIR}/nehresmann-${PN}-${MAGICK}"

src_install() {
	dodir /usr/share/gdm/themes
	cp -r "${S}"/* "${D}"/usr/share/gdm/themes
	chmod -R ugo=rX *
}
