# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils emul-linux-x86

SRC_URI=""
HOMEPAGE="http://ppa.launchpad.net/khashayar/ppa/ubuntu/pool/main/q/qgtkstyle/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	~app-emulation/emul-linux-x86-gtklibs-${PV}
	~app-emulation/emul-linux-x86-qtlibs-${PV}"

src_unpack() {
	mkdir -p "${S}/usr/lib32/qt4/plugins/styles/"
	cp "${FILESDIR}/libgtkstyle.so" "${S}/usr/lib32/qt4/plugins/styles/"
}

