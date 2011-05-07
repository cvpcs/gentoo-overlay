# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythweather/mythweather-0.21_p17719.ebuild,v 1.4 2008/12/23 17:27:25 maekke Exp $

MY_P="mythvodka.07"

DESCRIPTION="Online VOD module for MythTV."
HOMEPAGE="http://www.mythtv.org/wiki/MythStreams"
SRC_URI="http://cvpc.dyndns.org/gentoo-cvpcs/${MY_P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND="=media-tv/mythtv-0.21*
	media-video/mplayer
	net-misc/curl
	dev-perl/XML-DOM"
