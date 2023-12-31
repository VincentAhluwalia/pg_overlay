# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo multibuild xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S="${WORKDIR}"/qBittorrent-release-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui test webui"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( gui webui )"

RDEPEND="
	dev-libs/openssl:=
	dev-qt/qtbase:6[network,ssl,sql,sqlite,xml(+)]
	>=net-libs/libtorrent-rasterbar-2.0.0:=
	sys-libs/zlib
	gui? (
		dev-libs/geoip
		dev-qt/qtbase:6[dbus?,gui,widgets]]
		dev-qt/qtsvg:6
	)"
DEPEND="
	${RDEPEND}
	dev-libs/boost"
BDEPEND="dev-qt/qttools:6[linguist]
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

src_prepare() {
	sed -i "s/QBT_VERSION_MINOR 6/QBT_VERSION_MINOR 5/g" src/base/version.h.in
#	sed -i "s/QBT_VERSION_BUGFIX 0/QBT_VERSION_BUGFIX 5/g" src/base/version.h.in
	sed -i "s/alpha1//g" src/base/version.h.in
	sed -i "s/beta1//g" src/base/version.h.in

	MULTIBUILD_VARIANTS=()
	use gui && MULTIBUILD_VARIANTS+=( gui )
	use webui && MULTIBUILD_VARIANTS+=( nogui )

	cmake_src_prepare
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			# musl lacks execinfo.h
			-DSTACKTRACE=OFF

			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=OFF

			-DQT6=ON

			-DWEBUI=$(usex webui)

			-DTESTING=$(usex test)
			-DCMAKE_BUILD_TYPE=Release
		)

		if [[ ${MULTIBUILD_VARIANT} == "gui" ]]; then
			# We do this in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			mycmakeargs+=(
				-DGUI=ON
				-DDBUS=$(usex dbus)
				-DSYSTEMD=OFF
			)
		else
			mycmakeargs+=(
				-DGUI=OFF
				-DDBUS=OFF
				# The systemd service calls qbittorrent-nox, which is only
				# installed when GUI=OFF.
				-DSYSTEMD=OFF
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	my_src_test() {
		cd "${BUILD_DIR}"/test || die
		edo ctest .
	}

	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
