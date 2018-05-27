# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Loader.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Loader/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-Loader-sdk-${PV}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Loader"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="demos layers wayland X"
REQUIRED_USE="demos? ( X )"

RDEPEND=""
DEPEND="${PYTHON_DEPS}
	demos? ( dev-util/glslang:=[${MULTILIB_USEDEP}] )
	layers? (
			dev-util/glslang:=[${MULTILIB_USEDEP}]
			>=dev-util/spirv-tools-2018.2-r1:=[${MULTILIB_USEDEP}]
		)
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)"

PATCHES=(
		#"${FILESDIR}/${PN}-1.1.70.0-Dont-require-glslang-if-not-building-layers.patch"
		"${FILESDIR}/${PN}-Fix-layers-install-directory.patch"
		"${FILESDIR}/${PN}-Use-a-file-to-get-the-spirv-tools-commit-ID.patch"
	)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_LAYERS=$(usex layers)
		-DBUILD_DEMOS=$(usex demos)
		-DBUILD_VKJSON=OFF
		-DBUILD_LOADER=ON
		-DBUILD_WSI_MIR_SUPPORT=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cmake-utils_src_install
}
