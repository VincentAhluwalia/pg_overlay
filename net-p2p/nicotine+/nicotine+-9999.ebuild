# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature xdg git-r3

DESCRIPTION="Graphical client for the Soulseek peer to peer network written in Python"
HOMEPAGE="https://nicotine-plus.org/"
EGIT_REPO_URI="https://github.com/nicotine-plus/nicotine-plus"

LICENSE="GPL-3+ MIT CC-BY-SA-4.0"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

# NOTE: good link - https://github.com/nicotine-plus/nicotine-plus/blob/master/doc/DEPENDENCIES.md
BDEPEND="
	sys-devel/gettext
	test? (
		dev-python/pytest
		>=gui-libs/gtk-4.6.9[broadway]
	)
"
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gui-libs/gtk-4.6.9[introspection]
"

distutils_enable_tests pytest

DOCS=( AUTHORS.md NEWS.md README.md )

src_prepare() {
	default
	# remove update check test violating network sandbox
	sed -i -e 's:test_update_check:_&:' \
		"${S}"/pynicotine/tests/unit/test_version.py || die
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update

	elog "Nicotine can work with both gtk3+ and gtk4."
	elog "The newer version is preferred but it has worse screen reader support"
	elog "If you need it you can switch to gtk3+ by running nicotine"
	elog "with an environmental variable like this:"
	elog "   $ NICOTINE_GTK_VERSION=3 nicotine"

	optfeature "Adwaita theme on GNOME (GTK 4)" gui-libs/libadwaita
	optfeature "Chat spellchecking (GTK 3)" app-text/gspell
}
