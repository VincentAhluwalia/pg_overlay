# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="cs de el en_GB es et hr hu it ja nl pl pt ru sl sv th uk zh_CN"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 l10n git-r3

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="http://bleachbit.org/"
EGIT_REPO_URI="https://github.com/andrewgee/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sci-geosciences/osm-gps-map"

DEPEND="${RDEPEND}
	dev-python/python-distutils-extra"

DOCS=( README )

python_prepare_all() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale

	distutils-r1_python_prepare_all
}
