# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="http://www.abisource.com/enchant/"
SRC_URI="https://github.com/AbiWord/${PN}/archive/${PN}-1-6-1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="aspell +hunspell static-libs zemberek"
REQUIRED_USE="|| ( hunspell aspell zemberek )"

COMMON_DEPENDS="
	dev-libs/glib:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )
	zemberek? ( dev-libs/dbus-glib )
"
RDEPEND="${COMMON_DEPENDS}
	zemberek? ( app-text/zemberek-server )
"
DEPEND="${COMMON_DEPENDS}
	virtual/pkgconfig
"

DOCS="AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README TODO"

S=${WORKDIR}/${PN}-${PN}-1-6-1

src_prepare() {
	default
	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		tests/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable aspell) \
		$(use_enable hunspell myspell) \
		$(use_with hunspell system-myspell) \
		$(use_enable static-libs static) \
		$(use_enable zemberek) \
		--disable-ispell \
		--with-myspell-dir="${EPREFIX}"/usr/share/myspell/
}

src_install() {
	default
	prune_libtool_files --modules
}
