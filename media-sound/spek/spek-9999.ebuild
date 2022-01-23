# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.1-gtk3"

inherit autotools git-r3 wxwidgets

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://spek.cc"
EGIT_REPO_URI="https://github.com/alexkay/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/ffmpeg:0=
	x11-libs/wxGTK:${WX_GTK_VER}"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-disable-updates.patch
	"${FILESDIR}"/${PN}-replace-gnu+11-with-c++11.patch
	"${FILESDIR}"/${PN}-stdlib.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets unicode
	default
}
