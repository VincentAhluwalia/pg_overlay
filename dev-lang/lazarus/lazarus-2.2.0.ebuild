# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

# See https://wiki.freepascal.org/Lazarus_2.0_fixes_branch for notes and
# changes in FPCVER. It *does* change between minor versions of lazarus.
FPCVER="3.2.2"

DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi"
HOMEPAGE="https://www.lazarus-ide.org/"
SRC_URI="https://gitlab.com/freepascal.org/${PN}/${PN}/-/archive/${PN}_2_2_0/${PN}-${PN}_2_2_0.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
SLOT="0" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
KEYWORDS="amd64 x86"
IUSE="minimal"

DEPEND=">=dev-lang/fpc-${FPCVER}[source]
	net-misc/rsync
	>=sys-devel/binutils-2.19.1-r1:="
RDEPEND="${DEPEND}"

RESTRICT="strip" #269221

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-0.9.26-fpcsrc.patch )

src_unpack() {
	unpack ${A}
	mv * ${S}
}

src_prepare() {
	default
	# Use default configuration (minus stripping) unless specifically requested otherwise
	if ! test ${PPC_CONFIG_PATH+set} ; then
		local FPCVER=$(fpc -iV)
		export PPC_CONFIG_PATH="${WORKDIR}"
		sed -e 's/^FPBIN=/#&/' /usr/lib/fpc/${FPCVER}/samplecfg |
			sh -s /usr/lib/fpc/${FPCVER} "${PPC_CONFIG_PATH}" || die
	fi
	sed -i \
		-e "s;SecondaryConfigPath:='/etc/lazarus';SecondaryConfigPath:=ExpandFileNameUTF8('~/.lazarus');g" \
		-e "s;PrimaryConfigPath:=ExpandFileNameUTF8('~/.lazarus');PrimaryConfigPath:='/etc/lazarus';g" \
		ide/include/unix/lazbaseconf.inc \
		|| die
}

src_compile() {
	# TODO: Change to LCL_PLATFORM=qt5?
	# bug #732758
	LCL_PLATFORM=qt5 emake \
		$(usex minimal "" "bigide")
}

src_install() {
	diropts -m0755
	dodir /usr/share
	# Using rsync to avoid unnecessary copies and cleaning...
	# Note: *.o and *.ppu are needed
	rsync -a \
		--exclude="CVS"     --exclude=".cvsignore" \
		--exclude="*.ppw"   --exclude="*.ppl" \
		--exclude="*.ow"    --exclude="*.a"\
		--exclude="*.rst"   --exclude=".#*" \
		--exclude="*.~*"    --exclude="*.bak" \
		--exclude="*.orig"  --exclude="*.rej" \
		--exclude=".xvpics" --exclude="*.compiled" \
		--exclude="killme*" --exclude=".gdb_hist*" \
		--exclude="debian"  --exclude="COPYING*" \
		--exclude="*.app" \
		"${S}" "${ED}"/usr/share \
		|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../share/lazarus/startlazarus /usr/bin/lazarus
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	use minimal || dosym ../share/lazarus/components/chmhelp/lhelp/lhelp /usr/bin/lhelp
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus"
}
