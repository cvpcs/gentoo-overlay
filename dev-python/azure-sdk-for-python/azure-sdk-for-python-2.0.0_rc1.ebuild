# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5})

inherit distutils-r1 versionator

MY_PV="$(replace_version_separator 3 '')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Azure SDK for Python"
HOMEPAGE="https://github.com/Azure/azure-sdk-for-python"
SRC_URI="https://github.com/Azure/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
