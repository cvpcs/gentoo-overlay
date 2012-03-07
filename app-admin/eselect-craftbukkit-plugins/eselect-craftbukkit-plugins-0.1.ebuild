# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-php/eselect-php-0.6.6.ebuild,v 1.3 2011/11/30 14:54:30 grobian Exp $

EAPI=3

DESCRIPTION="CraftBukkit plugin eselect module"
HOMEPAGE="http://gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x64-macos ~x86-macos"
IUSE=""

DEPEND=">=app-admin/eselect-1.2.4
		games-server/craftbukkit-server"
RDEPEND="${DEPEND}"

src_install() {
	cp "${FILESDIR}/${P}" ${PN#eselect-}.eselect
	insinto /usr/share/eselect/modules/
	doins ${PN#eselect-}.eselect
}
