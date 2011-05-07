# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/psemu-peopsspu/psemu-peopsspu-1.0.9.ebuild,v 1.4 2008/02/14 22:59:29 nyhm Exp $

inherit autotools eutils games multilib

DESCRIPTION="Eternal Sound Emulation (SPU) PSEmu Plugin"
HOMEPAGE="http://www.emuxhaven.net"
SRC_URI="http://www.emuxhaven.net/emuxhaven/psx/plugin/spuEternal${PV//./}_linux.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="amd64? ( app-emulation/emul-linux-x86-compat )"

S=${WORKDIR}

src_install() {
	use amd64 && multilib_toolchain_setup x86

	exeinto "$(games_get_libdir)"/psemu/plugins
	doexe libspu* || die "doexe plugins"
#	exeinto "$(games_get_libdir)"/psemu/cfg
#	doexe cfgPeopsOSS || die "doexe cfg"
#	insinto "$(games_get_libdir)"/psemu/cfg
#	doins spuPeopsOSS.cfg || die "doins failed"
	dodoc *.txt
	prepgamesdirs
}
