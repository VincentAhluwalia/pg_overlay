# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=VBoxGuestAdditions
MY_PV=${PV^^}
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="CD image containing guest additions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.iso"
S="${WORKDIR}"

LICENSE="GPL-3 || ( GPL-3 CDDL )"
SLOT="0/$(ver_cut 1-2)"
# Still in beta
#KEYWORDS="~amd64"

src_unpack() {
	return 0
}

src_install() {
	insinto /usr/share/${PN/-additions}
	newins "${DISTDIR}"/${MY_P}.iso ${MY_PN}.iso
}
