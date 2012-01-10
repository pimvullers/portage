# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools

DESCRIPTION="Gedit Developer Plugins provides additional editing, checking, and project management features to Gedit"
HOMEPAGE="https://launchpad.net/gdp"
SRC_URI="http://launchpad.net/gdp/0.5.x/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/pocketlint"
RDEPEND="${DEPEND}"

src_configure() {
	econf --without-home
}

src_install() {
	emake DESTDIR="${D}" install || die
}
