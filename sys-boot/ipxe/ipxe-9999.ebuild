# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git-2

DESCRIPTION="iPXE Open Source Boot Firmware"
HOMEPAGE="http://ipxe.org/"
SRC_URI=""

EGIT_REPO_URI="git://git.ipxe.org/${PN}.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~*"
IUSE=""

DEPEND="app-cdr/cdrtools
	sys-boot/syslinux"

src_unpack() {
	git-2_src_unpack
}

src_compile() {
	cd src
	emake || die
}

src_install() {
	local dir=/usr/share/${PN}

	dodir ${dir}

	insinto ${dir}
	doins src/bin/ipxe.dsk \
		src/bin/ipxe.iso \
		src/bin/ipxe.lkrn \
		src/bin/ipxe.usb \
		src/bin/undionly.kpxe

	dodoc COPYING COPYRIGHTS README
}
