# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="cs de fi fr gr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit desktop plocale qmake-utils xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
COMMIT="1ddc5a202d6986f5e981ce16c0fce6c49b767765"
SRC_URI="https://git.rockbox.org/cgit/rockbox.git/snapshot/rockbox-${COMMIT}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-libs/crypto++:=
	dev-libs/quazip
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/rockbox-${COMMIT}"
QTDIR="utils/${PN}qt"

PATCHES=(
	"${FILESDIR}"/${P}-quazip1.patch
	"${FILESDIR}"/${P}-fix-versionstring.patch # bug 734178
)

src_prepare() {
	xdg_src_prepare

	rem_locale() {
		rm "lang/${PN}_${1}.ts" || die "removing of ${1}.ts failed"
		sed -i "s/lang\/${PN}_${1}.ts//" ${PN}qt.pri || die "removing of ${1}.ts failed"
		sed -i "s/lang\/${PN}_${1}.qm//" rbutilqt-lang.qrc || die "removing of ${1}.ts failed"
	}

	if has_version "<dev-libs/quazip-1.0"; then
		sed -e "/^PKGCONFIG/s/quazip1-qt5/quazip/" -i ${QTDIR}/${PN}qt.pro || die
	fi

	rm -rv "${QTDIR}"/{quazip,zlib}/ || die
}

src_configure() {
	cd "${QTDIR}" || die

	# Generate binary translations.
	"$(qt5_get_bindir)"/lrelease ${PN}qt.pro || die

	# noccache is required to call the correct compiler.
	eqmake5 CONFIG+="noccache $(use debug && echo dbg)"
}

src_compile() {
	emake -C "${QTDIR}"
}

src_install() {
	cd "${QTDIR}" || die

	dobin RockboxUtility
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox Utility
	dodoc changelog.txt
}
