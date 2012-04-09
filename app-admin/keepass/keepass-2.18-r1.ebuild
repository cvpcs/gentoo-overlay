# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdcollect/cdcollect-0.6.0-r1.ebuild,v 1.2 2011/03/27 11:54:29 nirbheek Exp $

EAPI=4

inherit eutils gnome2-utils mono multilib

MY_PN="KeePass"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="KeePass is a free, open source, light-weight and easy-to-use password manager."
HOMEPAGE="http://keepass.info"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-Source.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-2.6"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	unzip -qq "${DISTDIR}/${A}" -d "${P}" || die "Could not unpack ${A}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-mono.patch
	epatch "${FILESDIR}"/${PN}-${PVR}-monofix.patch

	cp -f Ext/Icons/Finals2/plockb.ico KeePass/KeePass.ico 
	cp -f Ext/Icons/Finals2/plockb.ico KeePass/Resources/Images/KeePass.ico
}

src_compile() {
	local args

	if use debug ; then
		args="/property:Configuration=Debug"
	else
		args="/property:Configuration=Release"
	fi

	xbuild ${args} KeePass.sln || die "Build failed"
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins Build/${MY_PN}/Release/${MY_PN}.exe
	doins Build/${MY_PN}Lib/Release/${MY_PN}Lib.dll

	dodir /usr/bin
	make_wrapper ${PN} "mono /usr/$(get_libdir)/${PN}/${MY_PN}.exe" || die "Failed to make wrapper"

	insinto /usr/share/pixmaps
	doins KeePass/KeePass.ico

	make_desktop_entry ${PN} ${MY_PN} ${MY_PN} Utility
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
