# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson multilib-minimal

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/cairo/cairo.git"
	SRC_URI=""
else
	SRC_URI="https://www.cairographics.org/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="https://www.cairographics.org/ https://gitlab.freedesktop.org/cairo/cairo"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="X aqua debug gles2-only +glib opengl static-libs utils valgrind xcb"
# gtk-doc regeneration doesn't seem to work with out-of-source builds
#[[ ${PV} == *9999* ]] && IUSE="${IUSE} doc" # API docs are provided in tarball, no need to regenerate

# Test causes a circular depend on gtk+... since gtk+ needs cairo but test needs gtk+ so we need to block it
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
	>=sys-devel/libtool-2"
RDEPEND="
	>=dev-libs/lzo-2.06-r1[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2[png,${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]
	sys-libs/binutils-libs:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.36.0[${MULTILIB_USEDEP}]
	gles2-only? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	opengl? ( >=media-libs/mesa-9.1.6[egl,X(+),${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	)
	xcb? (
		>=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
#[[ ${PV} == *9999* ]] && DEPEND="${DEPEND}
#	doc? (
#		>=dev-util/gtk-doc-1.6
#		~app-text/docbook-xml-dtd-4.2
#	)"

REQUIRED_USE="
	gles2-only? ( !opengl )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.18-disable-test-suite.patch
	"${FILESDIR}"/${PN}-respect-fontconfig.patch
	"${FILESDIR}"/${PN}-1.16.0-binutils-2.34.patch
	"${FILESDIR}"/${PN}-make-lcdfilter-default.patch
	"${FILESDIR}"/${PN}-server-side-gradients.patch  
	"${FILESDIR}"/${PN}-webkit-html5-fix.patch
	"${FILESDIR}"/xlib-xcb.diff
)

src_prepare() {
	default

	# tests and perf tools require X, bug #483574
	if ! use X; then
		sed -e '/^SUBDIRS/ s#boilerplate test perf# #' -i Makefile.am || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dfonconfig=enabled
		-Dfreetype=enabled
		$(meson_feature X tee)
		$(meson_feature X xlib)
		$(meson_feature xcb)
		$(meson_feature aqua quartz)
		-Dgl-backend=$(multilib_native_usex opengl gl auto)
		-Dpng=enabled
		-Dzlib=enabled
		-Dtests=disabled
		$(meson_feature glib)
		-Dspectre=disabled
		-DCAIRO_HAS_TRACE=0
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
	einstalldocs
}
