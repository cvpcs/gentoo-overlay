# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_EXT_NAME="runkit"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

inherit php-ext-pecl-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Replace, rename, and remove user defined functions and classes. Define customized superglobal variables for general purpose use. Execute code in restricted environment (sandboxing)."
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

need_php_by_category

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix gcc-4 compile and PHP 5.2 compatibility
	epatch "${FILESDIR}/${PF}-buildfixes.patch"
}

pkg_setup() {
	# sandbox support requires dev-lang/php compiled 
	# with --enable-maintainer-zts - see README
	require_php_with_use threads
}
