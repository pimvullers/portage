# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="QNAP Turbo NAS installation/configuration tool"
HOMEPAGE="http://www.qnap.com/"
SRC_URI="http://download.qnap.com/Storage/Utility/QNAPQFinderLinux-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-gtklibs
	app-emulation/emul-linux-x86-opengl
	app-emulation/emul-linux-x86-xlibs"

pkg_setup() {
	S="${WORKDIR}/QFinder"
}

src_install() {
	insinto /opt/${PN}
	doins -r res

	exeinto /opt/${PN}
	doexe QFinder*

	exeinto /opt/bin
	doexe "${FILESDIR}/QFinder"
}
