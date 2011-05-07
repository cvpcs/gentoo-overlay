# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="${PN}-${PV/_p/_r}"
MY_PP="${MY_P}-linux-x86"
MY_PB="${MY_P/_r*/}"

DESCRIPTION="Open Handset Alliance's Android NDK/"
HOMEPAGE="http://developer.android.com/sdk/ndk/${PV/_p/_r}/index.html"
SRC_URI="http://dl.google.com/android/ndk/${MY_PP}.zip"
RESTRICT="mirror strip"

LICENSE="android"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="app-arch/unzip dev-util/android-sdk-update-manager"
RDEPEND=""
QA_TEXTRELS="opt/${MY_PB}/build/platforms/android-1.5/arch-arm/usr/lib/libc.so
opt/${MY_PB}/build/platforms/android-1.5/arch-arm/usr/lib/libdl.so
opt/${MY_PB}/build/platforms/android-1.5/arch-arm/usr/lib/libthread_db.so"

src_install(){
	local destdir="/opt/${P/_p*/}"
	dodir "${destdir}"

	cd "${MY_P}"

	dodoc README.TXT || die
	cp GNUmakefile "${D}/${destdir}/" || die "failed to copy"
	cp -pPR apps "${D}/${destdir}/" || die "failed to copy"
	chgrp android "${D}/${destdir}/apps" || die "failed to chgrp apps dir"
	chmod g+w,+t "${D}/${destdir}/apps" || die "failed to chmod apps dir"
	mkdir "${D}/${destdir}/out" || die "failed to create out dir"
	chgrp android "${D}/${destdir}/out" || die "failed to chgrp out dir"
	chmod g+ws "${D}/${destdir}/out" || die "failed to chmod out dir" 
	cp -pPR build "${D}/${destdir}/" || die "failed to copy"
	dodoc docs/*.TXT
	use doc && mkdir -p "${D}/usr/share/doc/${PF}/system/libc"
	docinto "${D}/usr/share/doc/${PF}/system/libc"
	dodoc docs/system/libc/*
	
	ewarn "You have to install the necessary SDK (1.6) using 'android' command from android-sdk-update-manager."
}
