# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# polyc_ebuilds.eclass: eclass for all _pre ebuilds created by Polynomial-C

MY_PV="${PV%_*}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"

try_apply() {
	[[ $# -gt 0 ]] || die "No patch files given."

	if nonfatal eapply --dry-run ${@} &>/dev/null ; then
		eapply ${@}
	fi
}
