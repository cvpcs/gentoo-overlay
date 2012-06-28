# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git-2

DESCRIPTION="Utilities for use with the Raspberry Pi"
HOMEPAGE="https://github.com/raspberrypi/tools"

EGIT_REPO_URI="http://github.com/raspberrypi/tools.git"
EGIT_COMMIT="772201f23f75e6fc345d55627d4973893c440f7c"
EGIT_PROJECT="${PN}"

LICENSE=""
SLOT="0"
KEYWORDS="arm"
IUSE=""
RESTRICT="mirror"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-mkimage.patch
}

src_install() {
	insinto /usr/share/${PN}/mkimage
	doins \
		mkimage/args-uncompressed.txt \
		mkimage/boot-uncompressed.txt \
		mkimage/first32k.bin

	exeinto /usr/share/${PN}/mkimage
	doexe \
		mkimage/imagetool-uncompressed.py

	dosym \
		../../usr/share/${PN}/mkimage/imagetool-uncompressed.py \
		/usr/bin/rpi-mkimage
}
