# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/psemu-peopssoftgpu/psemu-peopssoftgpu-1.17.ebuild,v 1.8 2008/12/23 23:41:39 flameeyes Exp $

inherit eutils games multilib

DESCRIPTION="P.E.Op.S Software GPU plugin"
HOMEPAGE="http://sourceforge.net/projects/peops/"
SRC_URI="mirror://sourceforge/peops/PeopsSoftGpu${PV//./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/gpuPeopsSoft

src_install() {
	use amd64 && multilib_toolchain_setup x86

	dodoc *.txt
	insinto "$(games_get_libdir)"/psemu/cfg
	doins gpuPeopsSoftX.cfg || die "doins failed"
	exeinto "$(games_get_libdir)"/psemu/plugins
	doexe libgpuPeops* || die "doexe failed"
	exeinto "$(games_get_libdir)"/psemu/cfg
	doexe cfgPeopsSoft || die "doexe failed"
	prepgamesdirs
}
