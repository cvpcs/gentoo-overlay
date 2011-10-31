# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/banshee-community-extensions/banshee-community-extensions-1.6.1.ebuild,v 1.3 2010/07/12 20:28:24 fauli Exp $

EAPI=3

inherit base mono

MY_PV="${PV/_beta/-beta}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SparkleShare is a file sharing and collaboration tool inspired by
Dropbox"
HOMEPAGE="http://www.sparkleshare.org"
#SRC_URI="http://www.sparkleshare.org/${MY_P}.tar.gz"
SRC_URI="https://github.com/downloads/hbons/SparkleShare/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/mono-2.2
	>=dev-util/monodevelop-2.0
	>=dev-dotnet/gtk-sharp-2.12.7
	>=dev-dotnet/webkit-sharp-0.3
	dev-dotnet/notify-sharp"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.7
	net-misc/openssh
	>=gnome-base/gvfs-1.3
	dev-util/intltool"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README COPYING
}

