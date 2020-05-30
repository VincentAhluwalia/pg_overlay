# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit autotools python-single-r1

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"
	inherit git-r3
else
	SRC_URI="https://kohei.us/files/ixion/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0/0.15" # based on SONAME of libixion.so
IUSE="debug python +threads"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=
	dev-util/mdds:1/1.5
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-libs/spdlog
"

PATCHES=(
	"${FILESDIR}/${P}-musl-clang.patch" # bug 714018
	"${FILESDIR}/${P}-bashism.patch" # bug 723128
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable debug)
		$(use_enable python)
		$(use_enable threads)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
