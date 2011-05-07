# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

inherit eutils multilib mono versionator

EAPI="2"

MY_PN="opentk"
MY_PV_BETA="$(get_version_component_range 3)"
MY_PV="$(get_version_component_range 1-2)-beta-${MY_PV_BETA:4:1}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openal opengl"

RDEPEND=">=dev-lang/mono-2.0
		openal? ( media-libs/openal )
		opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
		app-arch/p7zip
		>=dev-dotnet/nant-0.86_beta1"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A};
}

src_install() {
	ebegin "Installing dlls into the GAC"
	gacutil -i Binaries/OpenTK/Release/OpenTK.dll -root "${D}/usr/$(get_libdir)" \
		-gacdir "/usr/$(get_libdir)" -package "${MY_PN}" > /dev/null
	gacutil -i Binaries/OpenTK/Release/OpenTK.Compatibility.dll -root "${D}/usr/$(get_libdir)" \
		-gacdir "/usr/$(get_libdir)" -package "${MY_PN}" > /dev/null
	gacutil -i Binaries/OpenTK/Release/OpenTK.GLControl.dll -root "${D}/usr/$(get_libdir)" \
		-gacdir "/usr/$(get_libdir)" -package "${MY_PN}" > /dev/null
	eend

	dodoc Documentation/*.txt

	mono_multilib_comply
}
