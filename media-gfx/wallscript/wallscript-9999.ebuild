# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git-2

DESCRIPTION="Wallscript TCL auto-wallpaper grabber for Konachan"
HOMEPAGE="http://cvpcs.org/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/cvpcs/${PN}.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~*"
IUSE=""

RDEPEND="dev-lang/tcl
	dev-tcltk/tdom
	dev-java/commons-daemon"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	dodir /usr/share/wallscript

	exeinto /usr/share/wallscript
	doexe wallscript.tcl
	doexe wallscript_save.tcl

	insinto /usr/share/wallscript
	doins wallscript.conf.dist

	insinto /etc/xdg/autostart
	doins wallscript-startup.desktop

	exeinto /usr/bin
	doexe wallscript-startup
}

pkg_postinst() {
	einfo "You must install a wallscript config and set your backdrop execution"
	einfo "line in order for wallscript to function properly!"
	einfo ""
	einfo "A sample wallscript config can be found in"
	einfo "  /usr/share/wallscript/wallscript.conf.dist"
	einfo ""
	einfo "Copy that file to ~/.wallscript.conf and modify it to suit your needs,"
	einfo "then re-login to your X session to enjoy some wallscript goodness!"
}
