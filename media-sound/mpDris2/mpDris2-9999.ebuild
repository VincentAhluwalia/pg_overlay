# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python{3_5,3_6})

inherit autotools distutils-r1 eutils git-r3 l10n

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"
HOMEPAGE="http://github.com/eonpatapon/mpDris2"
EGIT_REPO_URI="https://github.com/eonpatapon/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/python-3.4
		>=dev-python/dbus-python-0.80[$PYTHON_USEDEP]
		>=dev-python/pygobject-3.14.0:3[$PYTHON_USEDEP]
		>=dev-python/python-mpd2-0.5.5[$PYTHON_USEDEP]"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf --prefix=/usr \ 
		--sysconfdir=/etc
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
}
