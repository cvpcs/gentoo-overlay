# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git-2 mount-boot

DESCRIPTION="Firmware for booting the Raspberry Pi"
HOMEPAGE="https://github.com/raspberrypi/firmware"

EGIT_REPO_URI="http://github.com/raspberrypi/firmware.git"
EGIT_COMMIT="542ee2c3a5aea50377b97ec0308eb884900512ca"
EGIT_PROJECT="${PN}"

LICENSE="Broadcom"
SLOT="0"
KEYWORDS="arm"
IUSE=""
RESTRICT="binchecks mirror"

src_install() {
	insinto /usr/share/${PN}
	doins \
		boot/arm128_start.elf \
		boot/arm192_start.elf \
		boot/arm224_start.elf \
		boot/bootcode.bin \
		boot/loader.bin
}

pkg_postinst() {
	local boot_dir
	local inst_dir

        mount-boot_mount_boot_partition

        if [[ -n ${DONT_MOUNT_BOOT} ]]; then
		einfo "Unable to mount boot to install firmware files!"
		einfo "Please unset DONT_MOUNT_BOOT and remerge ${PN}."
		die "Unable to mount boot"
        else
		boot_dir="${ROOT}"/boot
		inst_dir="${ROOT}"/usr/share/${PN}

		mkdir -p "${boot_dir}"

		cp \
			"${inst_dir}"/arm192_start.elf \
			"${boot_dir}"/start.elf

		cp \
			"${inst_dir}"/bootcode.bin \
			"${inst_dir}"/loader.bin \
			"${boot_dir}"/
        fi
}
