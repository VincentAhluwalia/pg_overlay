# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="cs de fi fr gr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit desktop gnome2-utils qmake-utils git-r3 l10n

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
EGIT_REPO_URI="git://git.rockbox.org/rockbox.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=
	virtual/libusb:1"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

S="${WORKDIR}/${P}/${PN}/${PN}qt"

src_prepare() {
	default
	rem_locale() {
		rm "lang/${PN}_${1}.ts" || die "removing of ${1}.ts failed"
		sed -i "s/lang\/${PN}_${1}.ts//" ${PN}qt.pri || die "removing of ${1}.ts failed"
		sed -i "s/lang\/${PN}_${1}.qm//" rbutilqt-lang.qrc || die "removing of ${1}.ts failed"
	}

	l10n_find_plocales_changes lang "${PN}_" ".ts"
	l10n_for_each_disabled_locale_do rem_locale

	sed 's/LIBS += -lz/LIBS += -lz -lcryptopp/' -i rbutilqt.pro || die

	rm -rv zlib/ || die
}

src_configure() {
	# Generate binary translations.
	lrelease ${PN}qt.pro || die

	# noccache is required to call the correct compiler.
	eqmake5 CONFIG+="noccache $(use debug && echo dbg)"
}

src_install() {
	local icon size
	for icon in icons/rockbox-*.png; do
		size=${icon##*-}
		size=${size%%.*}
		newicon -s "${size}" "${icon}" rockbox.png
	done

	dobin RockboxUtility
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc changelog.txt
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
