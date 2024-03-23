# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit bash-completion-r1 check-reqs estack flag-o-matic llvm multiprocessing \
	multilib multilib-build python-any-r1 rust-toolchain toolchain-funcs verify-sig

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz"
else
	ABI_VER="$(ver_cut 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

RUST_STAGE0_VERSION="1.$(($(ver_cut 2))).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

SRC_URI="
	https://static.rust-lang.org/dist/${SRC}
	verify-sig? ( https://static.rust-lang.org/dist/${SRC}.asc )
	!system-bootstrap? ( $(rust_all_arch_uris rust-${RUST_STAGE0_VERSION}) )
"

# keep in sync with llvm ebuild of the same version as bundled one.
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARC ARM AVR BPF CSKY DirectX Hexagon Lanai
	LoongArch M68k Mips MSP430 NVPTX PowerPC RISCV Sparc SPIRV SystemZ VE
	WebAssembly X86 XCore Xtensa )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"

IUSE="big-endian clippy cpu_flags_x86_sse2 debug dist doc llvm-libunwind +lto miri nightly parallel-compiler profiler rustfmt rust-analyzer rust-src system-bootstrap system-llvm test wasm ${ALL_LLVM_TARGETS[*]}"

# Please keep the LLVM dependency block separate. Since LLVM is slotted,
# we need to *really* make sure we're not pulling more than one slot
# simultaneously.

# How to use it:
# List all the working slots in LLVM_VALID_SLOTS, newest first.
LLVM_VALID_SLOTS=( 18 )
LLVM_MAX_SLOT="${LLVM_VALID_SLOTS[0]}"

# splitting usedeps needed to avoid CI/pkgcheck's UncheckableDep limitation
# (-) usedep needed because we may build with older llvm without that target
LLVM_DEPEND="|| ( "
for _s in ${LLVM_VALID_SLOTS[@]}; do
	LLVM_DEPEND+=" ( "
	for _x in ${ALL_LLVM_TARGETS[@]}; do
		LLVM_DEPEND+="
			${_x}? ( sys-devel/llvm:${_s}[${_x}(-)] )
			wasm? ( sys-devel/lld:${_s} )"
	done
	LLVM_DEPEND+=" )"
done
unset _s _x
LLVM_DEPEND+=" )
	<sys-devel/llvm-$(( LLVM_MAX_SLOT + 1 )):=
"

# to bootstrap we need at least exactly previous version, or same.
# most of the time previous versions fail to bootstrap with newer
# for example 1.47.x, requires at least 1.46.x, 1.47.x is ok,
# but it fails to bootstrap with 1.48.x
# https://github.com/rust-lang/rust/blob/${PV}/src/stage0.json
RUST_DEP_PREV="$(ver_cut 1).$(($(ver_cut 2) - 1))*"
RUST_DEP_CURR="$(ver_cut 1).$(ver_cut 2)*"
BOOTSTRAP_DEPEND="||
	(
		=dev-lang/rust-"${RUST_DEP_PREV}"
		=dev-lang/rust-bin-"${RUST_DEP_PREV}"
		=dev-lang/rust-"${RUST_DEP_CURR}"
		=dev-lang/rust-bin-"${RUST_DEP_CURR}"
	)
"

BDEPEND="${PYTHON_DEPS}
	app-eselect/eselect-rust
	|| (
		>=sys-devel/gcc-4.7
		>=sys-devel/clang-3.5
	)
	system-bootstrap? ( ${BOOTSTRAP_DEPEND} )
	!system-llvm? (
		>=dev-build/cmake-3.13.4
		app-alternatives/ninja
	)
	test? ( dev-debug/gdb )
	verify-sig? ( sec-keys/openpgp-keys-rust )
"

DEPEND="
	>=app-arch/xz-utils-5.2
	net-libs/libssh2:=
	net-libs/http-parser:=
	net-misc/curl:=[http2,ssl]
	sys-libs/zlib:=
	dev-libs/openssl:0=
	system-llvm? (
		${LLVM_DEPEND}
		llvm-libunwind? ( sys-libs/llvm-libunwind:= )
		>=sys-devel/clang-runtime-14.0[libcxx]
	)
	!system-llvm? (
		!llvm-libunwind? (
			elibc_musl? ( sys-libs/libunwind:= )
		)
	)
"

RDEPEND="${DEPEND}
	app-eselect/eselect-rust
	sys-apps/lsb-release
"

REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )
	miri? ( nightly )
	parallel-compiler? ( nightly )
	rust-analyzer? ( rust-src )
	test? ( ${ALL_LLVM_TARGETS[*]} )
	wasm? ( llvm_targets_WebAssembly )
	x86? ( cpu_flags_x86_sse2 )
"

# we don't use cmake.eclass, but can get a warning
CMAKE_WARN_UNUSED_CLI=no

QA_FLAGS_IGNORED="
	usr/lib/${PN}/${PV}/bin/.*
	usr/lib/${PN}/${PV}/libexec/.*
	usr/lib/${PN}/${PV}/lib/lib.*.so
	usr/lib/${PN}/${PV}/lib/rustlib/.*/bin/.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

QA_SONAME="
	usr/lib/${PN}/${PV}/lib/lib.*.so.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

QA_PRESTRIPPED="
	usr/lib/${PN}/${PV}/lib/rustlib/.*/bin/rust-llvm-dwp
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/self-contained/crtn.o
"

# An rmeta file is custom binary format that contains the metadata for the crate.
# rmeta files do not support linking, since they do not contain compiled object files.
# so we can safely silence the warning for this QA check.
QA_EXECSTACK="usr/lib/${PN}/${PV}/lib/rustlib/*/lib*.rlib:lib.rmeta"

# causes double bootstrap
RESTRICT="test"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/rust.asc

PATCHES=(
	"${FILESDIR}"/1.74.1-cross-compile-libz.patch
	"${FILESDIR}"/1.70.0-ignore-broken-and-non-applicable-tests.patch
	"${FILESDIR}"/1.67.0-doc-wasm.patch
	"${FILESDIR}"/0001-Use-lld-provided-by-system.patch
	"${FILESDIR}"/0003-compiler-Change-LLVM-targets.patch
	"${FILESDIR}"/rustc-1.77.0-unbundle-sqlite.patch
)

S="${WORKDIR}/${MY_P}-src"

clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' "vendor/${1}/.cargo-checksum.json" || die
}

toml_usex() {
	usex "${1}" true false
}

bootstrap_rust_version_check() {
	# never call from pkg_pretend. eselect-rust may be not installed yet.
	[[ ${MERGE_TYPE} == binary ]] && return
	local rustc_wanted="$(ver_cut 1).$(($(ver_cut 2) - 1))"
	local rustc_toonew="$(ver_cut 1).$(($(ver_cut 2) + 1))"
	local rustc_version=( $(eselect --brief --root="${BROOT}" rust show 2>/dev/null) )
	rustc_version=${rustc_version[0]#rust-bin-}
	rustc_version=${rustc_version#rust-}

	[[ -z "${rustc_version}" ]] && die "Failed to determine rust version, check 'eselect rust' output"

	if ver_test "${rustc_version}" -lt "${rustc_wanted}" ; then
		eerror "Rust >=${rustc_wanted} is required"
		eerror "please run 'eselect rust' and set correct rust version"
		die "selected rust version is too old"
	elif ver_test "${rustc_version}" -ge "${rustc_toonew}" ; then
		eerror "Rust <${rustc_toonew} is required"
		eerror "please run 'eselect rust' and set correct rust version"
		die "selected rust version is too new"
	else
		einfo "Using rust ${rustc_version} to build"
	fi
}

pre_build_checks() {
	local M=8192
	# multiply requirements by 1.3 if we are doing x86-multilib
	if use amd64; then
		M=$(( $(usex abi_x86_32 13 10) * ${M} / 10 ))
	fi
	M=$(( $(usex clippy 128 0) + ${M} ))
	M=$(( $(usex miri 128 0) + ${M} ))
	M=$(( $(usex rustfmt 256 0) + ${M} ))
	# add 2G if we compile llvm and 256M per llvm_target
	if ! use system-llvm; then
		M=$(( 2048 + ${M} ))
		local ltarget
		for ltarget in ${ALL_LLVM_TARGETS[@]}; do
			M=$(( $(usex ${ltarget} 256 0) + ${M} ))
		done
	fi
	M=$(( $(usex wasm 256 0) + ${M} ))
	M=$(( $(usex debug 2 1) * ${M} ))
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		M=$(( 15 * ${M} / 10 ))
	fi
	eshopts_pop
	M=$(( $(usex system-bootstrap 0 1024) + ${M} ))
	M=$(( $(usex doc 256 0) + ${M} ))
	CHECKREQS_DISK_BUILD=${M}M check-reqs_pkg_${EBUILD_PHASE}
}

llvm_check_deps() {
	has_version -r "sys-devel/llvm:${LLVM_SLOT}[${LLVM_TARGET_USEDEPS// /,}]"
}

# Is LLVM being linked against libc++?
is_libcxx_linked() {
	local code='#include <ciso646>
#if defined(_LIBCPP_VERSION)
	HAVE_LIBCXX
#endif
'
	local out=$($(tc-getCXX) ${CXXFLAGS} ${CPPFLAGS} -x c++ -E -P - <<<"${code}") || return 1
	[[ ${out} == *HAVE_LIBCXX* ]]
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
	python-any-r1_pkg_setup

	# required to link agains system libs, otherwise
	# crates use bundled sources and compile own static version
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_NO_PKG_CONFIG=0 #749381
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1

	use system-bootstrap && bootstrap_rust_version_check

	if use system-llvm; then
		llvm_pkg_setup

		local llvm_config="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
		export LLVM_LINK_SHARED=1
		export RUSTFLAGS="${RUSTFLAGS} -Lnative=$("${llvm_config}" --libdir)"
	fi
}

src_prepare() {
	# Clear vendor checksums for crates that we patched to bump libc.
	# NOTE: refresh this on each bump.
	#for i in addr2line-0.20.0 bstr cranelift-jit crossbeam-channel elasticlunr-rs handlebars icu_locid libffi \
	#	terminal_size tracing-tree; do
	#	clear_vendor_checksums "${i}"
	#done

	if ! use system-bootstrap; then
		local rust_stage0_root="${WORKDIR}"/rust-stage0
		local rust_stage0="rust-${RUST_STAGE0_VERSION}-$(rust_abi "${CBUILD}")"

		"${WORKDIR}/${rust_stage0}"/install.sh --disable-ldconfig \
			--without=rust-docs-json-preview,rust-docs --destdir="${rust_stage0_root}" --prefix=/ || die
	fi

	if use system-llvm; then
		rm -rf src/llvm-project/
		mkdir -p src/llvm-project/libunwind/
		# We never enable emscripten.
		rm -rf src/llvm-emscripten/
		# We never enable other LLVM tools.
		rm -rf src/tools/clang
		rm -rf src/tools/lld
		rm -rf src/tools/lldb
		# CI tooling won't be used
		rm -rf src/ci
	fi

	# Remove other unused vendored libraries 
	rm -rf vendor/*jemalloc-sys*/jemalloc/
	rm -rf vendor/libmimalloc-sys/c_src/mimalloc/
	rm -rf vendor/openssl-src/openssl/
	rm -rf vendor/libsqlite3-sys*/{sqlite3,sqlcipher}/

	default
}

src_configure() {
	filter-lto # https://bugs.gentoo.org/862109 https://bugs.gentoo.org/866231

	local rust_target="" rust_targets="" arch_cflags

	# Collect rust target names to compile standard libs for all ABIs.
	for v in $(multilib_get_enabled_abi_pairs); do
		rust_targets+=",\"$(rust_abi $(get_abi_CHOST ${v##*.}))\""
	done
	if use wasm; then
		rust_targets+=",\"wasm32-unknown-unknown\""
		if use system-llvm; then
			# un-hardcode rust-lld linker for this target
			# https://bugs.gentoo.org/715348
			sed -i '/linker:/ s/rust-lld/wasm-ld/' compiler/rustc_target/src/spec/base/wasm.rs || die
		fi
	fi
	rust_targets="${rust_targets#,}"

	# cargo and rustdoc are mandatory and should always be included
	local tools='"cargo","rustdoc"'
	use clippy && tools+=',"clippy"'
	use miri && tools+=',"miri"'
	use profiler && tools+=',"rust-demangler"'
	use rustfmt && tools+=',"rustfmt"'
	use rust-analyzer && tools+=',"rust-analyzer"'
	use rust-src && tools+=',"src"'

	local rust_stage0_root
	if use system-bootstrap; then
		local printsysroot
		printsysroot="$(rustc --print sysroot || die "Can't determine rust's sysroot")"
		rust_stage0_root="${printsysroot}"
	else
		rust_stage0_root="${WORKDIR}"/rust-stage0
	fi
	# in case of prefix it will be already prefixed, as --print sysroot returns full path
	[[ -d ${rust_stage0_root} ]] || die "${rust_stage0_root} is not a directory"

	rust_target="$(rust_abi)"
	rust_build="$(rust_abi "${CBUILD}")"
	rust_host="$(rust_abi "${CHOST}")"

	local cm_btype="$(usex debug DEBUG RELEASE)"
	cat <<- _EOF_ > "${S}"/config.toml
		changelog-seen = 2
		[llvm]
		download-ci-llvm = false
		optimize = $(toml_usex !debug)
		thin-lto =  $(toml_usex system-llvm)
		release-debuginfo = $(toml_usex debug)
		assertions = $(toml_usex debug)
		ninja = true
		targets = "${LLVM_TARGETS// /;}"
		experimental-targets = ""
		link-jobs = $(makeopts_jobs)
		link-shared =  $(toml_usex system-llvm)
		static-libstdcpp = $(usex system-llvm false true)
		use-libcxx =  $(toml_usex system-llvm)
		use-linker = "lld"
		polly = true

		[llvm.build-config]
		CMAKE_VERBOSE_MAKEFILE = "ON"
		CMAKE_C_FLAGS_${cm_btype} = "${CFLAGS}"
		CMAKE_CXX_FLAGS_${cm_btype} = "${CXXFLAGS}"
		CMAKE_EXE_LINKER_FLAGS_${cm_btype} = "${LDFLAGS}"
		CMAKE_MODULE_LINKER_FLAGS_${cm_btype} = "${LDFLAGS}"
		CMAKE_SHARED_LINKER_FLAGS_${cm_btype} = "${LDFLAGS}"
		CMAKE_STATIC_LINKER_FLAGS_${cm_btype} = "${ARFLAGS}"
		[build]
		build-stage = 2
		test-stage = 2
		build = "${rust_build}"
		host = ["${rust_host}"]
		target = [${rust_targets}]
		cargo = "${rust_stage0_root}/bin/cargo"
		rustc = "${rust_stage0_root}/bin/rustc"
		rustfmt = "${rust_stage0_root}/bin/rustfmt"
		docs = $(toml_usex doc)
		compiler-docs = $(toml_usex doc)
		#
		submodules = true
		optimized-compiler-builtins = false
		#
		python = "${EPYTHON}"
		locked-deps = false
		vendor = true
		extended = true
		tools = [${tools}]
		verbose = 2
		sanitizers = false
		profiler = $(toml_usex profiler)
		cargo-native-static = false
		local-rebuild = false

		[install]
		prefix = "${EPREFIX}/usr/lib/${PN}/${PV}"
		sysconfdir = "etc"
		docdir = "share/doc/rust"
		bindir = "bin"
		libdir = "lib"
		mandir = "share/man"

		[rust]
		# https://github.com/rust-lang/rust/issues/54872
		codegen-units-std = 1
		optimize = 3
		debug = $(toml_usex debug)
		debug-assertions = $(toml_usex debug)
		debug-assertions-std = $(toml_usex debug)
		debuginfo-level = $(usex debug 2 0)
		debuginfo-level-rustc = $(usex debug 2 0)
		debuginfo-level-std = $(usex debug 2 0)
		debuginfo-level-tools = $(usex debug 2 0)
		debuginfo-level-tests = 0
		backtrace = $(toml_usex debug)
		incremental = false
		default-linker = "$(tc-getCC)"
		parallel-compiler = $(toml_usex parallel-compiler)
		channel = "$(usex nightly nightly stable)"
		description = "gentoo"
		rpath = false
		verbose-tests = false
		optimize-tests = $(toml_usex !debug)
		codegen-tests = $(toml_usex debug)
		dist-src = $(toml_usex debug)
		remap-debuginfo = $(toml_usex debug)
		lld = $(usex system-llvm false $(toml_usex wasm))
		use-lld = true
		# only deny warnings if doc+wasm are NOT requested, documenting stage0 wasm std fails without it
		# https://github.com/rust-lang/rust/issues/74976
		# https://github.com/rust-lang/rust/issues/76526
		deny-warnings = $(usex wasm $(usex doc false true) true)
		backtrace-on-ice = true
		jemalloc = false
		lto = "$(usex lto thin off)"
		llvm-libunwind = "$(usex system-llvm system)"

		[dist]
		src-tarball = false
		compression-formats = ["xz"]
		compression-profile = "balanced"
	_EOF_

	for v in $(multilib_get_enabled_abi_pairs); do
		rust_target=$(rust_abi $(get_abi_CHOST ${v##*.}))
		arch_cflags="$(get_abi_CFLAGS ${v##*.})"

		export CFLAGS_${rust_target//-/_}="${arch_cflags}"

		cat <<- _EOF_ >> "${S}"/config.toml
			[target.${rust_target}]
			ar = "$(tc-getAR)"
			cc = "$(tc-getCC)"
			cxx = "$(tc-getCXX)"
			linker = "$(tc-getCC)"
			ranlib = "$(tc-getRANLIB)"
			#llvm-libunwind = "$(usex llvm-libunwind $(usex system-llvm system in-tree) no)"
		_EOF_
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
			_EOF_
		fi
		# by default librustc_target/spec/linux_musl_base.rs sets base.crt_static_default = true;
		# but we patch it and set to false here as well
		if use elibc_musl; then
			cat <<- _EOF_ >> "${S}"/config.toml
				crt-static = false
			_EOF_
		fi
	done
	if use wasm; then
		cat <<- _EOF_ >> "${S}"/config.toml
			[target.wasm32-unknown-unknown]
			linker = "$(usex system-llvm lld rust-lld)"
			# wasm target does not have profiler_builtins https://bugs.gentoo.org/848483
			profiler = false
		_EOF_
	fi

	if [[ -n ${I_KNOW_WHAT_I_AM_DOING_CROSS} ]]; then # whitespace intentionally shifted below
	# experimental cross support
	# discussion: https://bugs.gentoo.org/679878
	# TODO: c*flags, clang, system-llvm, cargo.eclass target support
	# it would be much better if we could split out stdlib
	# complilation to separate ebuild and abuse CATEGORY to
	# just install to /usr/lib/rustlib/<target>

	# extra targets defined as a bash array
	# spec format:  <LLVM target>:<rust-target>:<CTARGET>
	# best place would be /etc/portage/env/dev-lang/rust
	# Example:
	# RUST_CROSS_TARGETS=(
	#	"AArch64:aarch64-unknown-linux-gnu:aarch64-unknown-linux-gnu"
	# )
	# no extra hand holding is done, no target transformations, all
	# values are passed as-is with just basic checks, so it's up to user to supply correct values
	# valid rust targets can be obtained with
	# 	rustc --print target-list
	# matching cross toolchain has to be installed
	# matching LLVM_TARGET has to be enabled for both rust and llvm (if using system one)
	# only gcc toolchains installed with crossdev are checked for now.

	# BUG: we can't pass host flags to cross compiler, so just filter for now
	# BUG: this should be more fine-grained.
	filter-flags '-mcpu=*' '-march=*' '-mtune=*'

	local cross_target_spec
	for cross_target_spec in "${RUST_CROSS_TARGETS[@]}";do
		# extracts first element form <LLVM target>:<rust-target>:<CTARGET>
		local cross_llvm_target="${cross_target_spec%%:*}"
		# extracts toolchain triples, <rust-target>:<CTARGET>
		local cross_triples="${cross_target_spec#*:}"
		# extracts first element after before : separator
		local cross_rust_target="${cross_triples%%:*}"
		# extracts last element after : separator
		local cross_toolchain="${cross_triples##*:}"
		use llvm_targets_${cross_llvm_target} || die "need llvm_targets_${cross_llvm_target} target enabled"
		command -v ${cross_toolchain}-gcc > /dev/null 2>&1 || die "need ${cross_toolchain} cross toolchain"

		cat <<- _EOF_ >> "${S}"/config.toml
			[target.${cross_rust_target}]
			ar = "${cross_toolchain}-ar"
			cc = "${cross_toolchain}-gcc"
			cxx = "${cross_toolchain}-g++"
			linker = "${cross_toolchain}-gcc"
			ranlib = "${cross_toolchain}-ranlib"
		_EOF_
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
			_EOF_
		fi
		if [[ "${cross_toolchain}" == *-musl* ]]; then
			cat <<- _EOF_ >> "${S}"/config.toml
				musl-root = "$(${cross_toolchain}-gcc -print-sysroot)/usr"
			_EOF_
		fi

		# append cross target to "normal" target list
		# example 'target = ["powerpc64le-unknown-linux-gnu"]'
		# becomes 'target = ["powerpc64le-unknown-linux-gnu","aarch64-unknown-linux-gnu"]'

		rust_targets="${rust_targets},\"${cross_rust_target}\""
		sed -i "/^target = \[/ s#\[.*\]#\[${rust_targets}\]#" config.toml || die

		ewarn
		ewarn "Enabled ${cross_rust_target} rust target"
		ewarn "Using ${cross_toolchain} cross toolchain"
		ewarn
		if ! has_version -b 'sys-devel/binutils[multitarget]' ; then
			ewarn "'sys-devel/binutils[multitarget]' is not installed"
			ewarn "'strip' will be unable to strip cross libraries"
			ewarn "cross targets will be installed with full debug information"
			ewarn "enable 'multitarget' USE flag for binutils to be able to strip object files"
			ewarn
			ewarn "Alternatively llvm-strip can be used, it supports stripping any target"
			ewarn "define STRIP=\"llvm-strip\" to use it (experimental)"
			ewarn
		fi
	done
	fi # I_KNOW_WHAT_I_AM_DOING_CROSS

	einfo "Rust configured with the following flags:"
	echo
	echo RUSTFLAGS="\"${RUSTFLAGS}\""
	echo RUSTFLAGS_BOOTSTRAP="\"${RUSTFLAGS_BOOTSTRAP}\""
	echo RUSTFLAGS_NOT_BOOTSTRAP="\"${RUSTFLAGS_NOT_BOOTSTRAP}\""
	echo MAGIC_EXTRA_RUSTFLAGS="\"${MAGIC_EXTRA_RUSTFLAGS}\""
	env | grep "CARGO_TARGET_.*_RUSTFLAGS="
	env | grep "CFLAGS_.*"
	echo
	einfo "config.toml contents:"
	cat "${S}"/config.toml || die
	echo
}

src_compile() {
	RUST_BACKTRACE=1 "${EPYTHON}" ./x.py build -vvv --config="${S}"/config.toml -j$(makeopts_jobs) || die
}

src_test() {
	# https://rustc-dev-guide.rust-lang.org/tests/intro.html

	# those are basic and codegen tests.
	local tests=(
		codegen
		codegen-units
		compile-fail
		incremental
		mir-opt
		pretty
		run-make
	)

	# fails if llvm is not built with ALL targets.
	# and known to fail with system llvm sometimes.
	use system-llvm || tests+=( assembly )

	# fragile/expensive/less important tests
	# or tests that require extra builds
	# TODO: instead of skipping, just make some nonfatal.
	if [[ ${ERUST_RUN_EXTRA_TESTS:-no} != no ]]; then
		tests+=(
			rustdoc
			rustdoc-js
			rustdoc-js-std
			rustdoc-ui
			run-make-fulldeps
			ui
			ui-fulldeps
		)
	fi

	local i failed=()
	einfo "rust_src_test: enabled tests ${tests[@]/#/src/test/}"
	for i in "${tests[@]}"; do
		local t="src/test/${i}"
		einfo "rust_src_test: running ${t}"
		if ! RUST_BACKTRACE=1 "${EPYTHON}" ./x.py test -vv --config="${S}"/config.toml \
				-j$(makeopts_jobs) --no-doc --no-fail-fast "${t}"
		then
				failed+=( "${t}" )
				eerror "rust_src_test: ${t} failed"
		fi
	done

	if [[ ${#failed[@]} -ne 0 ]]; then
		eerror "rust_src_test: failure summary: ${failed[@]}"
		die "aborting due to test failures"
	fi
}

src_install() {
	DESTDIR="${D}" "${EPYTHON}" ./x.py install -vv --config="${S}"/config.toml -j$(makeopts_jobs) || die

	# bug #689562, #689160
	rm -v "${ED}/usr/lib/${PN}/${PV}/etc/bash_completion.d/cargo" || die
	rmdir -v "${ED}/usr/lib/${PN}/${PV}"/etc{/bash_completion.d,} || die
	newbashcomp src/tools/cargo/src/etc/cargo.bashcomp.sh cargo

	local symlinks=(
		cargo
		rustc
		rustdoc
		rust-gdb
		rust-gdbgui
		rust-lldb
	)

	use clippy && symlinks+=( clippy-driver cargo-clippy )
	use miri && symlinks+=( miri cargo-miri )
	use profiler && symlinks+=( rust-demangler )
	use rustfmt && symlinks+=( rustfmt cargo-fmt )
	use rust-analyzer && symlinks+=( rust-analyzer )

	einfo "installing eselect-rust symlinks and paths: ${symlinks[@]}"
	local i
	for i in "${symlinks[@]}"; do
		# we need realpath on /usr/bin/* symlink return version-appended binary path.
		# so /usr/bin/rustc should point to /usr/lib/rust/<ver>/bin/rustc-<ver>
		# need to fix eselect-rust to remove this hack.
		local ver_i="${i}-${PV}"
		if [[ -f "${ED}/usr/lib/${PN}/${PV}/bin/${i}" ]]; then
			einfo "Installing ${i} symlink"
			ln -v "${ED}/usr/lib/${PN}/${PV}/bin/${i}" "${ED}/usr/lib/${PN}/${PV}/bin/${ver_i}" || die
		else
			ewarn "${i} symlink requested, but source file not found"
			ewarn "please report this"
		fi
		dosym "../lib/${PN}/${PV}/bin/${ver_i}" "/usr/bin/${ver_i}"
	done

	# symlinks to switch components to active rust in eselect
	dosym "${PV}/lib" "/usr/lib/${PN}/lib-${PV}"
	dosym "${PV}/libexec" "/usr/lib/${PN}/libexec-${PV}"
	dosym "${PV}/share/man" "/usr/lib/${PN}/man-${PV}"
	dosym "rust/${PV}/lib/rustlib" "/usr/lib/rustlib-${PV}"
	dosym "../../lib/${PN}/${PV}/share/doc/rust" "/usr/share/doc/${P}"

	newenvd - "50${P}" <<-_EOF_
		LDPATH="${EPREFIX}/usr/lib/rust/lib"
		MANPATH="${EPREFIX}/usr/lib/rust/man"
	_EOF_

	rm -rf "${ED}/usr/lib/${PN}/${PV}"/*.old || die
	rm -rf "${ED}/usr/lib/${PN}/${PV}/bin"/*.old || die
	rm -rf "${ED}/usr/lib/${PN}/${PV}/doc"/*.old || die

	# note: eselect-rust adds EROOT to all paths below
	cat <<-_EOF_ > "${T}/provider-${P}"
		/usr/bin/cargo
		/usr/bin/rustdoc
		/usr/bin/rust-gdb
		/usr/bin/rust-gdbgui
		/usr/bin/rust-lldb
		/usr/lib/rustlib
		/usr/lib/rust/lib
		/usr/lib/rust/libexec
		/usr/lib/rust/man
		/usr/share/doc/rust
	_EOF_

	if use clippy; then
		echo /usr/bin/clippy-driver >> "${T}/provider-${P}"
		echo /usr/bin/cargo-clippy >> "${T}/provider-${P}"
	fi
	if use miri; then
		echo /usr/bin/miri >> "${T}/provider-${P}"
		echo /usr/bin/cargo-miri >> "${T}/provider-${P}"
	fi
	if use profiler; then
		echo /usr/bin/rust-demangler >> "${T}/provider-${P}"
	fi
	if use rustfmt; then
		echo /usr/bin/rustfmt >> "${T}/provider-${P}"
		echo /usr/bin/cargo-fmt >> "${T}/provider-${P}"
	fi
	if use rust-analyzer; then
		echo /usr/bin/rust-analyzer >> "${T}/provider-${P}"
	fi

	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"

	if use dist; then
		insinto "/usr/lib/${PN}/${PV}/dist"
		doins -r "${S}/build/dist/."
	fi
}

pkg_postinst() {
	eselect rust update

	if has_version dev-debug/gdb || has_version dev-debug/lldb; then
		elog "Rust installs a helper script for calling GDB and LLDB,"
		elog "for your convenience it is installed under /usr/bin/rust-{gdb,lldb}-${PV}."
	fi

	if has_version app-editors/emacs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi
}

pkg_postrm() {
	eselect rust cleanup
}
