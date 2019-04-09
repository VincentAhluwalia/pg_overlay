# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils poly-c_ebuilds

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="https://github.com/g-truc/glm/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="|| ( HappyBunny MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_avx cpu_flags_x86_avx2"

RDEPEND="virtual/opengl"

src_configure() {
	if use test; then
		local mycmakeargs=(
			-DGLM_TEST_ENABLE=ON
			-DGLM_TEST_ENABLE_SIMD_SSE2="$(usex cpu_flags_x86_sse2 ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_SSE3="$(usex cpu_flags_x86_sse3 ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_AVX="$(usex cpu_flags_x86_avx ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_AVX2="$(usex cpu_flags_x86_avx2 ON OFF)"
		)
	fi

	cmake-utils_src_configure
}
