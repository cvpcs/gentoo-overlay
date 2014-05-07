# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/myodbc/myodbc-5.2.6.ebuild,v 1.1 2014/05/04 19:37:13 grknight Exp $

EAPI=5

inherit multilib versionator

MY_PV_MAJOR=$(get_major_version ${PV})
MY_LIB_NAME="lib${PN}-$(get_version_component_range 1-2 ${PV}).so.$(get_version_component_range 3-4 ${PV})"
MY_DRIVER_NAME="ODBC Driver ${MY_PV_MAJOR} for SQL Server"
MY_LANG="en_US"

DESCRIPTION="ODBC Driver for Microsoft SQL Server"
HOMEPAGE="http://technet.microsoft.com/en-us/library/hh568451.aspx"
SRC_URI="http://download.microsoft.com/download/B/C/D/BCDD264C-7517-4B7D-8159-C99FC5535680/RedHat6/${P}.tar.gz"

SLOT="0"
LICENSE="MSodbcEULA11"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-crypt/mit-krb5
	=dev-db/unixODBC-2.3.0*
	=dev-libs/openssl-1.0.1*"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="
	usr/bin/bcp-${PV}
	usr/bin/sqlcmd-${PV}
	usr/$(get_libdir)/${MY_LIB_NAME}"
QA_SONAME="
	usr/$(get_libdir)/${MY_LIB_NAME}"

pkg_setup() {
	local config=$(odbc_config --cflags)

	local sizeof_long_int=${config/SIZEOF_LONG_INT\=8/}
	local legacy_64bit_mode=${config/BUILD_LEGACY_64_BIT_MODE/}

	# configuration must have this flag set, so it should be deleted from sizeof_long_int
	if [ "$config" == "$sizeof_long_int" ]; then
		error "unixODBC must have the configuration SIZEOF_LONG_INT=8."
		error "This will probably require a rebuild of the unixODBC Driver Manager."
		die
	fi

    
	# configuration shouldn't have this flag set, so it should not be deleted (be the same)
	if [ "$config" != "$legacy_64bit_mode" ]; then
		eerror "unixODBC must not have BUILD_LEGACY_64_BIT_MODE configuration flag set."
		eerror "This will probably require a rebuild of the unixODBC Driver Manager."
		die
	fi
}

src_prepare() {
	# create the driver install ini file
	echo "[${MY_DRIVER_NAME}]" > odbcinst.ini
	echo "Description = Microsoft ODBC Driver ${MY_PV_MAJOR} for SQL Server" >> odbcinst.ini
	echo "Driver = /usr/$(get_libdir)/${MY_LIB_NAME}" >> odbcinst.ini
	echo "Threading = 1" >> odbcinst.ini
	echo "" >> odbcinst.ini

	# unpack the HTML source
	mkdir -p docs/${MY_LANG}
	tar -zxf docs/${MY_LANG}.tar.gz -C docs/${MY_LANG}
}

src_install() {
	dobin \
		bin/bcp-${PV} \
		bin/sqlcmd-${PV}

	dosym bcp-${PV} /usr/bin/bcp
	dosym sqlcmd-${PV} /usr/bin/sqlcmd

	dolib lib64/${MY_LIB_NAME}

	# setup symlinks to fix some solib resolution
	dosym libcrypto.so.1.0.0 /usr/$(get_libdir)/libcrypto.so.10
	dosym libssl.so.1.0.0 /usr/$(get_libdir)/libssl.so.10

	dodir /opt/microsoft/${PN}/${PV}/${MY_LANG}/
	insinto /opt/microsoft/${PN}/${PV}/${MY_LANG}/
	doins \
		bin/BatchParserGrammar.dfa \
		bin/BatchParserGrammar.llr \
		bin/bcp.rll \
		bin/SQLCMD.rll \
		lib64/${PN}r${MY_PV_MAJOR}.rll

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins \
		odbcinst.ini

	dodoc \
		README \
		WARNING
	dohtml -r docs/${MY_LANG}
}

pkg_config() {
	[ "${ROOT}" != "/" ] && \
		die 'Sorry, non-standard ROOT setting is not supported :-('

	local drivers=$(/usr/bin/odbcinst -q -d)

	if echo $drivers | grep -vq "^\[${MY_DRIVER_NAME}\]$" ; then
		ebegin "Installing ${MY_DRIVER_NAME}"
		/usr/bin/odbcinst -i -d -f /usr/share/${PN}/odbcinst.ini
		rc=$?
		eend $rc
		[ $rc -ne 0 ] && die
	else
		einfo "Skipping already installed ${MY_DRIVER_NAME}"
	fi
}

pkg_postinst() {
	elog "If this is a new install, please run the following command"
	elog "to configure the Microsoft SQL ODBC drivers and sources:"
	elog "emerge --config =${CATEGORY}/${PF}"
}
