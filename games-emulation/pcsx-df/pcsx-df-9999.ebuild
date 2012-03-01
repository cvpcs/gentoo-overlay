# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games cvs

DESCRIPTION="GNU/Linux fork of the discontinued PlayStation emulator PCSX"
HOMEPAGE="http://pcsx-df.sourceforge.net/"
ECVS_SERVER="pcsx-df.cvs.sourceforge.net:/cvsroot/pcsx-df"
ECVS_USER="anonymous"
ECVS_PASS=""
ECVS_AUTH="pserver"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="alsa nls bin_image opengl"

DEPEND=">=x11-libs/gtk+-2
	gnome-base/libglade
	alsa? ( media-libs/alsa-lib )
	nls? ( virtual/libintl )
	bin_image? (
		media-libs/portaudio
		x11-libs/fltk )
	x86? ( dev-lang/nasm )
	opengl? (
		virtual/opengl
		x11-libs/libXxf86vm )"
RDEPEND="${DEPEND}
	!games-emulation/pcsx
	nls? ( sys-devel/gettext )"
DEPEND="${DEPEND}
	x11-proto/videoproto"

RESTRICT="mirror"

S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack

	cd "${S}"

	sh autogen.sh

	if use amd64 ; then
		sed -i \
			-e "s:/lib/games/psemu/:/lib64/psemu/plugins/:" \
			$(find . -name "*.in" -or -name "*.am") \
			|| die "sed failed"
	else
		sed -i \
			-e "s:/lib/games/psemu/:/lib/psemu/plugins/:" \
			$(find . -name "*.in" -or -name "*.am") \
			|| die "sed failed"
	fi

	sed -i \
		-e 's:^icondir = .*:icondir = "/usr/share/pixmaps":' \
		-e 's:-DPIXMAPDIR=\\"${datadir}/pixmaps/\\":-DPIXMAPDIR=\\"/usr/share/pixmaps/\\":' \
		-e 's:-DLOCALE_DIR=\\"${datadir}/locale/\\":-DLOCALE_DIR=\\"/usr/share/locale/\\":' \
		-e "s:^localedir = .*:localedir = /usr/share/locale/:" \
		-e "s:^gnulocaledir = .*:gnulocaledir = /usr/share/locale/:" \
		-e 's:^desktopdir = .*:desktopdir = /usr/share/applications:' \
		$(find . -name "*.in" -or -name "*.am") \
		|| die "sed failed"

	#set some gentoo specific stuff so we'll see other psemu plugins
	sed -i \
		-e "s:/usr/lib/games/psemu/:$(games_get_libdir)/psemu/plugins:" \
		-e "s:/usr/local/lib/games/psemu/:$(games_get_libdir)/psemu/cfg:" \
		-e "s:filename, \".*\\.so$\":filename, \"lib.*\":" \
		gui/Gtk2Gui.c \
		gui/LnxMain.c \
		|| die "sed failed"
	sed -i \
		-e "s:/usr/lib/games:$(games_get_libdir):" \
		gui/LnxMain.c \
		|| die "sed failed"
	sed -i \
		-e "s:/usr/lib/games/psemu:$(games_get_libdir)/psemu/plugins:" \
		gui/Config.c \
		|| die "sed failed"
}

src_compile() {
	egamesconf --enable-shared=yes --enable-static=no \
		$(use_enable alsa) \
		$(use_enable bin_image dfbinimage) \
		$(use_enable nls) \
		--disable-nautilusburn || die

	emake || die "emake failed"

	if use opengl ; then
		emake -C plugins/dfOpenGL || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README doc/keys.txt doc/tweaks.txt ChangeLog
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "There may be some problems configuring plugins "
	elog "when you run pcsx for the first time."
	elog "So just close it and launch again."
}
