# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://gitlab.freedesktop.org/glvnd/libglvnd.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python3_{11..12} )
VIRTUALX_REQUIRED=manual

inherit ${GIT_ECLASS} meson-multilib python-any-r1 virtualx

DESCRIPTION="The GL Vendor-Neutral Dispatch library"
HOMEPAGE="https://gitlab.freedesktop.org/glvnd/libglvnd"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	SRC_URI="https://gitlab.freedesktop.org/glvnd/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
	S=${WORKDIR}/${PN}-v${PV}
fi

LICENSE="MIT"
SLOT="0"
IUSE="test X"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	test? ( X? ( ${VIRTUALX_DEPEND} ) )"
RDEPEND="
	!media-libs/mesa[-libglvnd(+)]
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=( "${FILESDIR}/${PN}-1.7.0-backport-pr291.patch" )

src_prepare() {
	default
	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," \
		bin/symbols-check.py || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature X glx)
	)
	use elibc_musl && emesonargs+=( -Dtls=false )

	meson_src_configure
}

multilib_src_test() {
	if use X; then
		virtx meson_src_test
	else
		meson_src_test
	fi
}
