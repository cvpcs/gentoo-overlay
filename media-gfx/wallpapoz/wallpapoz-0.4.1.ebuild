# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GNOME multi background and wallpaper configuration tool"
HOMEPAGE="http://wallpapoz.akbarhome.com/"
SRC_URI="http://wallpapoz.akbarhome.com/files/wallpapoz-0.4.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| (
	x11-apps/xprop
	<virtual/x11-7 )
	dev-python/pygtk
	dev-python/imaging
	>=gnome-base/gnome-control-center-2"

src_install() {
	cd "${S}"

	mkdir "${D}/usr"
	./setup.py --installdir "${D}/usr" install

	dodoc CHANGELOG README
}

