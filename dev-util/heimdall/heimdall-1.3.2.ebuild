# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git-2

DESCRIPTION="Utility to flash firmware on Samsung Galaxy S devices"
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"

EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"
RESTRICT="mirror"

RDEPEND=">=dev-libs/libusb-1.0.8
	qt4? ( >=x11-libs/qt-gui-4.7 )"
DEPEND="${RDEPEND}"

src_configure() {
	# remove the udev service reload from the install step
	epatch "${FILESDIR}"/${PN}-udev.patch

	# configure libpit
	cd "${S}"/libpit
	econf

	# configure heimdall
	cd "${S}"/${PN}
	econf

	# optionally configure heimdall-frontend
	if use qt4; then
		cd "${S}"/${PN}-frontend
		qmake ${PN}-frontend.pro
	fi
}

src_compile() {
	# build libpit
	cd "${S}"/libpit
	emake || die

	# build heimdall
	cd "${S}"/${PN}
	emake || die

	# optionally build heimdall-frontend
	if use qt4; then
		cd "${S}"/${PN}-frontend
		emake || die
	fi
}

src_install() {
	# install heimdall
	cd "${S}"/${PN}
	emake DESTDIR="${D}" install || die
	cd "${S}"

	# optionally install heimdall-frontend
	if use qt4; then
		exeinto /usr/bin
		doexe Linux/${PN}-frontend || die
	fi

	# install docs
	dodoc Linux/README || die
}
