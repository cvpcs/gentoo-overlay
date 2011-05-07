# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PN="${PN/xf86-input-//}"
MY_PV="$(replace_version_separator 3 '')"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Provides X11 drivers for Genius (WizardPen) tablets"
HOMEPAGE="http://linuxgenius.googlecode.com"
SRC_URI="http://linuxgenius.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="x11-base/xorg-server
	x11-apps/xinput
	x11-libs/libXext
	x11-misc/xautomation"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-tablet-not-connected.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	exeinto /usr/bin
	doexe calibrate/wizardpen-calibrate
}
