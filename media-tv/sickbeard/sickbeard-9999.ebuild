# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2

DESCRIPTION="Sick Beard - Internet PVR for your TV Shows"
HOMEPAGE="http://sickbeard.com/"
SRC_URI=""

MY_PN="Sick-Beard"

EGIT_REPO_URI="git://github.com/midgetspy/${MY_PN}.git"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="|| ( dev-lang/python:2.5
		dev-lang/python:2.6
		dev-lang/python:2.7 )
	dev-python/cheetah
	"

pkg_setup() {
	enewgroup sickbeard
	enewuser sickbeard -1 -1 -1 sickbeard
}

src_unpack() {
	git-2_src_unpack
}

src_install() {
	local dir=/usr/share/${PN}

	dodir ${dir}

	insinto ${dir}
	doins -r \
		autoProcessTV \
		cherrypy \
		data \
		lib \
		sickbeard \
		SickBeard.py \
		tests

	dodoc COPYING.txt readme.md

	newinitd "${FILESDIR}"/${PN}-daemon.initd ${PN}-daemon
	newconfd "${FILESDIR}"/${PN}-daemon.confd ${PN}-daemon

        keepdir /var/{lib,log,run}/sickbeard
        fowners -R sickbeard:sickbeard /var/{lib,log,run}/sickbeard
}
