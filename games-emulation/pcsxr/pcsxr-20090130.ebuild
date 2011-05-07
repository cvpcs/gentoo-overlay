# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="GNU/Linux fork of the discontinued PlayStation emulator PCSX"
HOMEPAGE="http://pcsxr.codeplex.com/"
SRC_URI="http://download.codeplex.com/Project/Download/FileDownload.aspx?ProjectName=pcsxr&DownloadId=56732&FileTime=128778039869130000&Build=14806 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa bin_image nls opengl"

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
	!games-emulation/pcsx-df
	nls? ( sys-devel/gettext )"
DEPEND="${DEPEND}
	x11-proto/videoproto"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use amd64 ; then
		sed -i \
			-e 's:lib/games:lib64:' \
			$(find . -name "*.in" -or -name "*.am") \
			|| die "sed failed"
	else
		sed -i \
			-e 's:lib/games:lib:' \
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

	./autogen.sh
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
