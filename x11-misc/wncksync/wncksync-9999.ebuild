# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.30.5.ebuild,v 1.1 2010/09/27 21:59:49 eva Exp $

EAPI="2"
GCONF_DEBUG="no"
EBZR_REPO_URI="lp:wncksync"
inherit gnome2 bzr

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE=""

RDEPEND=">=x11-libs/gtk+-2.19.7
	>=dev-libs/glib-2.16.0
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS COPYING COPYING.LGPL ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	NOCONFIGURE=1 ./autogen.sh
}

