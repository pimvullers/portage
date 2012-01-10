# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EBZR_REPO_URI="lp:liblauncher"
inherit gnome2 eutils bzr

DESCRIPTION="Shared library to monitor desktop-wide state"
HOMEPAGE="https://launchpad.net/liblauncher"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.10.0
	gnome-base/gconf
	gnome-base/gnome-menus
	x11-libs/libwnck"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	NOCONFIGURE=1 ./autogen.sh
}

