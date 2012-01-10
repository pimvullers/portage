# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EBZR_REPO_URI="lp:netbook-remix-launcher"
inherit gnome2 eutils bzr

DESCRIPTION="A clutter-based desktop launcher, typically used on netbooks"
HOMEPAGE="http://launchpad.net/netbook-remix-launcher"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc nls"

DEPEND=">=dev-libs/glib-2.20
	>=x11-libs/pango-1.18.0
	>=gnome-base/librsvg-2.18.0
	>=x11-libs/gtk+-2.10.0
	>=gnome-base/libgnomeui-2.0
	gnome-base/gnome-desktop
	gnome-base/gconf
	dev-util/gtk-doc
	>=x11-libs/cairo-1.2.4
	>=sys-apps/dbus-1.0
	>=dev-libs/dbus-glib-0.7
	>=media-libs/clutter-1.0
	>=media-libs/clutter-gtk-0.10
	>=media-libs/clutk-0.2
	gnome-base/gnome-menus
	=x11-libs/liblauncher-0.1*
	x11-libs/libwnck
	x11-libs/startup-notification"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	sed -i 's/clutk-0.2/clutk-0.3/' configure.ac
	NOCONFIGURE=1 ./autogen.sh
}

src_configure(){
	econf \
		$(use_enable nls) \
		$(use_enable doc gtk-doc)
}
