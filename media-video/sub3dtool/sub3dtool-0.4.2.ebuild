# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Convert subtitle to 3D (ASS format), use with VLC or MPlayer"
HOMEPAGE="http://code.google.com/p/sub3dtool/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/bin
	doexe sub3dtool
}
