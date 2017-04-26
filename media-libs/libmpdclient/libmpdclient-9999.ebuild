# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="A library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
EGIT_REPO_URI="git://git.musicpd.org/master/libmpdclient.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	sed -e "s:@top_srcdir@:.:" -i doc/doxygen.conf.in
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable doc documentation)
}

src_install() {
	default
	use examples && dodoc src/example.c
	use doc || rm -rf "${ED}"/usr/share/doc/${PF}/html
	find "${ED}" -name "*.la" -exec rm -rf {} + || die "failed to delete .la files"
}
