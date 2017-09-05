# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson git-r3

DESCRIPTION="A library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
EGIT_REPO_URI="https://github.com/MusicPlayerDaemon/libmpdclient.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples static test"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
		test? ( dev-libs/check )
"

src_prepare() {
	default
	sed -e "s:@top_srcdir@:.:" -i doc/doxygen.conf.in

	# meson doesn't support setting docdir
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "/^install_data(/s/'COPYING', //" \
		-i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation="$(usex doc true false)"
		--default-library="$(usex static static shared)"
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	use examples && dodoc src/example.c
	use doc || rm -rf "${ED}"/usr/share/doc/${PF}/html
}
