# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools bzr

DESCRIPTION="Gedit Developer Plugins provides additional editing, checking, and project management features to Gedit"
HOMEPAGE="https://launchpad.net/gdp"
EBZR_REPO_URI="lp:gdp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/pocketlint"
RDEPEND="${DEPEND}"

src_prepare() {
	./autogen.sh
}

src_configure() {
	econf --without-home
}

src_install() {
	emake DESTDIR="${D}" install
}

