# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This project implements online validation of Yubikey OTPs, written in C as a shared library."
SRC_URI="http://yubico-c-client.googlecode.com/files/${P}.tar.gz"
HOMEPAGE="http://code.google.com/p/yubico-c-client/"
KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="BSD-2"
IUSE=""

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

RESTRICT="mirror"


src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README || die
}
