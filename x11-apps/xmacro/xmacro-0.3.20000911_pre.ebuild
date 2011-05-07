# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mesa-progs/mesa-progs-6.5.2.ebuild,v 1.12 2009/04/03 12:39:42 chainsaw Exp $

inherit versionator

MY_PV="pre$(replace_version_separator 2 '-')"
MY_PV="${MY_PV%%_pre}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="XMacro package containing programs for recording and replaying X events"
HOMEPAGE="xmacro.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-proto/xextproto"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

