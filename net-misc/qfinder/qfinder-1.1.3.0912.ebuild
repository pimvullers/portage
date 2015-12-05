# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="QNAP Turbo NAS installation/configuration tool"
HOMEPAGE="http://www.qnap.com/"
SRC_URI="http://download.qnap.com/Storage/Utility/QNAPQfinderLinux-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	media-libs/libpng:1.2[abi_x86_32]"

pkg_setup() {
	S="${WORKDIR}/Qfinder"
}

src_install() {
	insinto /opt/${PN}
	doins -r res

	exeinto /opt/${PN}
	doexe Qfinder*

	exeinto /opt/bin
	doexe "${FILESDIR}/QFinder"
}
