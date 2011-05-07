# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

EAPI="2"

DESCRIPTION="FuseCompress - compresses filesystem"
HOMEPAGE="http://www.miio.net/fusecompress/"
SRC_URI="http://github.com/tex/fusecompress/tarball/${PV} -> ${P}.tar.gz"
COMMIT="ae67acae857c3948568505c362facc3c9c81edd4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 lzma lzo zlib"

DEPEND=">=sys-fs/fuse-2.4.1-r1
	>=dev-libs/boost-1.33.1
	>=dev-libs/rlog-1.3
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	lzo? ( >=dev-libs/lzo-2 )
	lzma? ( app-arch/xz-utils )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/tex-${PN}-${COMMIT}"

src_configure() {
	econf --with-boost-libdir=/usr/$(get_libdir) \
		$(use_with bzip2 bz2) \
		$(use_with lzma) \
		$(use_with lzo lzo2) \
		$(use_with zlib z)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc ChangeLog README
}
