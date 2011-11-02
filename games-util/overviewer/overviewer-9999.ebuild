# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/id3-py/id3-py-1.2.ebuild,v 1.18 2010/11/08 17:18:24 arfrever Exp $

EAPI="4"

inherit distutils git-2

DESCRIPTION="Command-line tool for rendering high-resolution maps of Minecraft worlds."
HOMEPAGE="http://docs.overviewer.org"

EGIT_REPO_URI="git://github.com/overviewer/Minecraft-Overviewer.git"
#EGIT_COMMIT="450e8f38d479dfb8f5b3151d1c0bdcc2e9c6c6cc"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/imaging
	dev-python/numpy"
DEPEND="${RDEPEND}"
