# Copyright 2006-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-releases/raw/master/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"
fi

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE="appindicator cli gtk lightweight nls mbedtls qt5 static-libs systemd test web"
RESTRICT="!test? ( test )"

ACCT_DEPEND="
	acct-group/transmission
	acct-user/transmission
"
BDEPEND="${ACCT_DEPEND}
	virtual/pkgconfig
	nls? (
		gtk? (
			dev-util/intltool
			sys-devel/gettext
		)
		qt5? (
			dev-qt/linguist-tools:5
		)
	)
"
COMMON_DEPEND="
	>=dev-libs/libevent-2.0.10:=
	!mbedtls? ( dev-libs/openssl:0= )
	mbedtls? ( net-libs/mbedtls:0= )
	>=net-misc/curl-7.16.3[ssl]
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	gtk? (
		>=dev-libs/dbus-glib-0.100
		>=dev-libs/glib-2.32:2
		>=x11-libs/gtk+-3.4:3
		appindicator? ( >=dev-libs/libappindicator-0.4.30:3 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
	)
"
DEPEND="${COMMON_DEPEND}
	nls? (
		virtual/libintl
		gtk? (
			dev-util/intltool
			sys-devel/gettext
		)
		qt5? (
			dev-qt/linguist-tools:5
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	${ACCT_DEPEND}
"

src_prepare() {
	default
	sed -i 's/3.00+/3.00/g' CMakeLists.txt
	sed -i 's/TR300Z/TR3000/g' CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_CLI=$(usex cli ON OFF)
		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_LIGHTWEIGHT=$(usex lightweight ON OFF)
		-DENABLE_NLS=$(usex nls ON OFF)
		-DENABLE_QT=$(usex qt5 ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_WEB=$(usex web ON OFF)

		# https://bugs.gentoo.org/807993
		-DINSTALL_LIB=$(usex static-libs ON OFF)

		-DUSE_SYSTEM_EVENT2=ON
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=OFF
		-DUSE_SYSTEM_NATPMP=OFF
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=OFF

		-DWITH_CRYPTO=$(usex mbedtls polarssl openssl)
		-DWITH_INOTIFY=ON
		-DWITH_LIBAPPINDICATOR=$(usex appindicator ON OFF)
		-DWITH_SYSTEMD=OFF
		-DENABLE_UTP=ON
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon
}

pkg_postrm() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
