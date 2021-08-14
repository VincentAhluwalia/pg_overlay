# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )

inherit git-r3 cmake python-any-r1

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
EGIT_REPO_URI="https://github.com/arvidn/libtorrent.git"
EGIT_BRANCH="RC_1_2"
EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/10"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="+dht debug gnutls python ssl test"

RESTRICT="!test? ( test ) test" # not yet fixed
RDEPEND="dev-libs/boost:="
DEPEND="
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-libs/boost[python,${PYTHON_USEDEP}]')
	)
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	${DEPEND}
"

pkg_setup() {
	use python && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-Dboost-python-module-name='python3.9'
		-DCMAKE_CXX_STANDARD=14
		-DBUILD_SHARED_LIBS=ON
		-Dbuild_examples=OFF
		-Ddht=$(usex dht ON OFF)
		-Dencryption=$(usex ssl ON OFF)
		-Dgnutls=$(usex gnutls ON OFF)
		-Dlogging=$(usex debug ON OFF)
		-Dpython-bindings=$(usex python ON OFF)
		-Dbuild_tests=$(usex test ON OFF)
	)

	use python && mycmakeargs+=( -Dboost-python-module-name="${EPYTHON}" )

	cmake_src_configure
}
