# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
# PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit autotools distutils-r1 flag-o-matic git-r3

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
EGIT_REPO_URI="https://github.com/arvidn/libtorrent.git"
EGIT_BRANCH="RC_1_2"

LICENSE="BSD"
SLOT="0/10"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug +dht doc examples libressl python +ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=[threads]
	virtual/libiconv
	examples? ( !net-p2p/mldonkey )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	sys-devel/libtool
"

src_prepare() {
	# Versions
	sed -i s/1.2.0/1.1.12/g configure.ac || die
	sed -i s/1.2.0.0/1.1.12.0/g include/libtorrent/version.hpp || die

	mkdir "${S}"/build-aux/ || die
	touch "${S}"/build-aux/config.rpath || die
	eautoreconf

	default

	# bug 578026
	# prepend -L${S}/... to ensure bindings link against the lib we just built
	sed -i -e "s|^|-L${S}/src/.libs |" bindings/python/link_flags.in || die

	# prepend -I${S}/... to ensure bindings use the right headers
	sed -i -e "s|^|-I${S}/src/include |" bindings/python/compile_flags.in || die

	use python && distutils-r1_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug export-all)
		$(use_enable dht dht $(usex debug logging $(usex ('yes' 'no'))))
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--with-libiconv
	)
	econf "${myeconfargs[@]}"

	if use python; then
		python_configure() {
			econf "${myeconfargs[@]}" \
				--enable-python-binding \
				--with-boost-python="${EPYTHON#python}"
		}
		distutils-r1_src_configure
	fi
}

src_compile() {
	default

	python_compile() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_compile
	}
	use python && distutils-r1_src_compile
}

src_install() {
	use doc && HTML_DOCS+=( "${S}"/docs )

	default

	python_install() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_install
	}
	use python && distutils-r1_src_install

	find "${D}" -name '*.la' -delete || die
}
