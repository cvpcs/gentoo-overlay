# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit linux-info

DESCRIPTION="Key-value pair daemon for Hyper-V virtualized guests"
HOMEPAGE="http://kernel.org"
SRC_URI=""
SLOT="3.7.4"

CONFIG_CHECK="~HYPERV_UTILS"
ERROR_HYPERV_UTILS="CONFIG_HYPERV_UTILS is not enabled. KVP daemon will not interact with the kernel."

pkg_setup() {
  if ! kernel_is 3 7 4 ; then
    eerror "This version of KVP is designed to build against the 3.7.4 version of the kernel sources."
    eerror "Please install the proper KVP version for your kernel."
    die
  fi
}

src_unpack() {
  mkdir -p "${S}"
  cp "${KERNEL_DIR}"/tools/hv/* "${S}"

  mkdir -p "${S}"/include/linux
  cp "${KERNEL_DIR}"/include/linux/hyperv.h "${S}"/include/linux
}

src_prepare() {
  sed -r -i 's/\/var\/opt/\/var\/lib/g' \
      "${S}"/hv_kvp_daemon.c
}

src_compile() {
  gcc \
    -I"${S}"/include \
    "${S}"/hv_kvp_daemon.c \
    -o hv_kvp_daemon
}
