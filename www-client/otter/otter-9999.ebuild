# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_CMAKE="always"
inherit eutils cmake-utils git-r3

DESCRIPTION="Project aiming to recreate classic Opera (12.x) UI using Qt5"
HOMEPAGE="http://otter-browser.org/"
EGIT_REPO_URI="git://github.com/OtterBrowser/otter-browser.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="spell"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtscript:5
	dev-qt/qtwebengine:5
	dev-qt/qtxmlpatterns:5
	spell? ( kde-frameworks/sonnet )
"
RDEPEND="
	${DEPEND}
"
DOCS=( CHANGELOG CONTRIBUTING.md TODO )

src_prepare() {
	default
	if [[ -n ${LINGUAS} ]]; then
		local lingua
		for lingua in resources/translations/*.qm; do
			lingua=$(basename ${lingua})
			lingua=${lingua/otter-browser_/}
			lingua=${lingua/.qm/}
			if ! has ${lingua} ${LINGUAS}; then
				rm resources/translations/otter-browser_${lingua}.qm || die
			fi
		done
	fi

	if ! use spell; then
		sed -i -e '/find_package(KF5Sonnet)/d' CMakeLists.txt || die
	fi
}

src_install() {
	cmake-utils_src_install
	domenu ${PN}-browser.desktop
}
