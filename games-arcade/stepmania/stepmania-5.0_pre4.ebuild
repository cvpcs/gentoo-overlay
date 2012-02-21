# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/stepmania/Attic/stepmania-3.9-r2.ebuild,v 1.8 2011/11/17 20:49:25 mr_bones_ dead $

EAPI=2
inherit autotools eutils games mercurial versionator

DESCRIPTION="An advanced DDR simulator"
HOMEPAGE="http://www.stepmania.com/stepmania/"

EHG_REPO_URI="https://code.google.com/p/sm-ssc/"
EHG_REVISION="SM5-Preview4"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug ffmpeg force-oss gtk jpeg mad vorbis"

RESTRICT="test"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	mad? ( media-libs/libmad )
	>=dev-lang/lua-5
	media-libs/libsdl[joystick,opengl]
	jpeg? ( virtual/jpeg )
	media-libs/libpng
	ffmpeg? ( virtual/ffmpeg )
	vorbis? ( media-libs/libvorbis )
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ffmpeg.patch

	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_with debug) \
		$(use_with jpeg) \
		$(use_with vorbis) \
		$(use_with mad mp3) \
		$(use_enable gtk gtk2) \
		$(use_enable force-oss)
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}"
	doexe src/stepmania || die "doexe failed"

	if use gtk; then
		doexe src/GtkModule.so || die "doexe failed"
	fi

	insinto "${dir}"
	doins -r Announcers BackgroundEffects BackgroundTransitions BGAnimations Characters \
		Courses Data Docs Manual NoteSkins Scripts Songs Themes || die "doins failed"

	dodir "${dir}/Cache"

	newicon "Themes/default/Graphics/Common window icon.png" ${PN}.png
	make_desktop_entry ${PN} StepMania

	games_make_wrapper ${PN} "${dir}"/${PN} "${dir}"
	prepgamesdirs

	# stupid hack
	fperms g+w -R "${dir}"
}
