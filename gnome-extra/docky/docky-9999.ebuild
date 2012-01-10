# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils gnome2 mono bzr

DESCRIPTION="Elegant, powerful, clean dock"
HOMEPAGE="https://wiki.go-docky.com"
SRC_URI=""

EBZR_REPO_URI="lp:docky"
EBZR_BOOTSTRAP="eautoreconf" # or ./autogen.sh

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug nls"

RDEPEND="dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	dev-dotnet/gconf-sharp
	>=dev-dotnet/gio-sharp-0.2-r1
	dev-dotnet/glib-sharp
	dev-dotnet/gnome-desktop-sharp
	dev-dotnet/gnome-keyring-sharp
	dev-dotnet/gtk-sharp
	dev-dotnet/mono-addins
	dev-dotnet/notify-sharp
	dev-dotnet/rsvg-sharp
	dev-dotnet/wnck-sharp"

DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--enable-release
		$(use_enable nls)"

	DOCS="AUTHORS NEWS"
}

