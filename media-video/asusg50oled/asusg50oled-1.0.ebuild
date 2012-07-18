# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"

inherit linux-info subversion eutils


DESCRIPTION="ASUS G50 OLED Daeomon"
HOMEPAGE="http://asusg50oled.sourceforge.net/"
ESVN_REPO_URI="https://asusg50oled.svn.sourceforge.net/svnroot/asusg50oled/trunk"
ESVN_PROJECT="asusg50oled"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="acpi"

DEPEND=">=virtual/jdk-1.6
	acpi? ( sys-power/acpid )"
	
CONFIG_CHECK="ASUS_OLED"

DEST="/opt/asusg50oled"

pkg_setup() {
	if ! kernel_is -ge 2 6 28 ; then
		die "asusg50oled requires the asus_oled module, which is only supported in kernel >= 2.6.28"
	fi

	check_extra_config
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	sed -i "s#/opt/leds#${DEST}#g" utils/acpi/asus-g50-games.sh || die
	sed -i "s#/opt/leds#${DEST}#g" utils/gentoo/asusg50leds || die
	cp "${FILESDIR}/EmergeLog.java" src/leds/modules/ || die
	epatch "${FILESDIR}/${P}-config.patch"
}

src_install() {
	if use acpi ; then
		insinto /etc/acpi/events
		doins utils/acpi/events/* || die
		exeinto /etc/acpi
		doexe utils/acpi/*.sh || die
	fi

	newinitd utils/gentoo/asusg50leds asusg50oled || die

	dodir "${DEST}" || die
	exeinto "${DEST}"
	doexe {start,stop}.sh || die
	doexe utils/notify{,_kopete}.sh || die
	insinto "${DEST}"
	doins leds.jar || die
	doins config.properties || die
	doins policy.all || die

	dodoc CHANGELOG INSTALL README TODO || die
}
