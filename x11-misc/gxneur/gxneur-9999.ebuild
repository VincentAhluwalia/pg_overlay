# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-r3 gnome2-utils versionator

DESCRIPTION="GTK+ based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
EGIT_REPO_URI="git://github.com/AndrewCrewKuznetsov/xneur-devel.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gconf nls"

COMMON_DEPEND="gnome-base/libglade:2.0
	>=sys-devel/gettext-0.16.1
	>=x11-libs/gtk+-2.18:2
	gconf? ( gnome-base/gconf:2 )"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	rm -f m4/{lt~obsolete,ltoptions,ltsugar,ltversion,libtool}.m4 \
		ltmain.sh aclocal.m4 || die
	sed -i "s/-Werror -g0//" configure.ac || die
	sed -i -e '/Encoding/d' -e '/Categories/s/$/;/' ${PN}.desktop.in || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gconf) \
		--without-appindicator
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS
	doicon pixmaps/gxneur.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
