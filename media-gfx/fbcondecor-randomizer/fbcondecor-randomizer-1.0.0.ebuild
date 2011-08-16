# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Script to randomize FBCondecor splash themes prior to startup"
HOMEPAGE="http://cvpcs.org/"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-gfx/splashutils[fbcondecor]"
DEPEND="${RDEPEND}"

src_install() {
	exeinto /etc/init.d
	newexe "${FILESDIR}"/${P}.init ${PN}

	insinto /etc/conf.d
	newins "${FILESDIR}"/${P}.conf ${PN}
}
