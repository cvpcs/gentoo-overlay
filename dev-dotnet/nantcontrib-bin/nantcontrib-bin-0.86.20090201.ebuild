# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

inherit eutils multilib mono versionator

EAPI="2"

MY_PN="nantcontrib"
MY_PV_VERSION="$(get_version_component_range 1-2)"
MY_PV_BUILD_DATE="$(get_version_component_range 3)"
MY_PV_BUILD_YYYY="${MY_PV_BUILD_DATE:0:4}"
MY_PV_BUILD_MM="${MY_PV_BUILD_DATE:4:2}"
MY_PV_BUILD_DD="${MY_PV_BUILD_DATE:6:2}"

DESCRIPTION="NAntContrib - Extra goodness for NAnt"
HOMEPAGE="http://nantcontrib.sourceforge.net"
SRC_URI="http://${MY_PN}.sourceforge.net/nightly/${MY_PV_BUILD_YYYY}-${MY_PV_BUILD_MM}-${MY_PV_BUILD_DD}-${MY_PV_VERSION}/${PN}.zip -> ${P}.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/mono-2.4"
DEPEND="${RDEPEND}
		app-arch/p7zip
		>=dev-dotnet/nant-0.86_beta1"

S="${WORKDIR}/${MY_PN}-${MY_PV_VERSION}-nightly-${MY_PV_BUILD_YYYY}-${MY_PV_BUILD_MM}-${MY_PV_BUILD_DD}"

src_unpack() {
	unpack ${A};
}

src_install() {
	insinto /usr/share/NAnt/bin/extensions/common/neutral/NAntContrib
	doins bin/NAnt.Contrib.Tasks.dll
	doins bin/NAnt.Contrib.Tasks.pdb
	doins bin/NAnt.Contrib.Tasks.xml

	insinto /usr/share/NAnt/bin/lib/common/neutral/NAntContrib
	doins bin/CollectionGen.dll
	doins bin/Interop.MsmMergeTypeLib.dll
	doins bin/Interop.StarTeam.dll
	doins bin/Interop.WindowsInstaller.dll
	doins bin/SLiNgshoT.Core.dll
	doins bin/SourceSafe.Interop.dll
}
