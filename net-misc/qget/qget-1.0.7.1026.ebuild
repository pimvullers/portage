# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="QNAP Turbo NAS download management tool"
HOMEPAGE="http://www.qnap.com/"
SRC_URI="http://download.qnap.com/Storage/Utility/QGet-1.0.7.1026.tar.gz"

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
	S="${WORKDIR}/QGet"
}

src_install() {
	dodoc -r help/*

	insinto /opt/${PN}
	doins -r res

	exeinto /opt/${PN}
	doexe QGet*

	exeinto /opt/bin
	doexe "${FILESDIR}/QGet"
}
