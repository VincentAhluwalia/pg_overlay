# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af ar ast be bg bn bs ca cs da de el en_AU en_CA en_GB eo es et eu fa fi fo fr gl he hi hr hu hy ia id it ja ko ku ky lt lv ms my nb nds nl nn pl pt pt_BR ro ru se si sk sl sq sr sv ta te th tr ug uk uz vi zh_CN zh_TW"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1 l10n git-r3

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="http://bleachbit.org/"
EGIT_REPO_URI="https://github.com/az0/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+gtk"

RDEPEND="gtk? ( dev-python/pygtk:2[$PYTHON_USEDEP] )"

DEPEND="${RDEPEND}
	sys-devel/gettext"

python_prepare_all() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale

	# choose correct Python implementation, bug #465254
	sed -i 's/python/$(PYTHON)/g' po/Makefile || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C po local
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	# https://bugs.gentoo.org/388999
	insinto /usr/share/${PN}/cleaners
	doins cleaners/*.xml

	doicon ${PN}.png
	domenu ${PN}.desktop
}

pkg_postinst() {
	elog "Bleachbit has optional notification support. To enable, please install:"
	elog ""
	elog "  dev-python/notify-python"
}
