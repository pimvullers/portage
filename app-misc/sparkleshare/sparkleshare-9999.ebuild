# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/banshee-community-extensions/banshee-community-extensions-1.6.1.ebuild,v 1.3 2010/07/12 20:28:24 fauli Exp $

EAPI=4

inherit base mono git-2

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SparkleShare is a file sharing and collaboration tool inspired by
Dropbox"
HOMEPAGE="http://www.sparkleshare.org"
EGIT_REPO_URI="https://github.com/hbons/SparkleShare.git"

EGIT_BOOTSTRAP="autogen.sh"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nautilus"

DEPEND=">=dev-dotnet/gtk-sharp-2.12.7
	>=dev-lang/mono-2.2
	>=dev-util/monodevelop-2.0	
	>=dev-dotnet/ndesk-dbus-0.6
	>=dev-dotnet/ndesk-dbus-glib-0.4.1
	nautilus? ( dev-python/nautilus-python )
	dev-dotnet/nant
	dev-dotnet/notify-sharp
	net-libs/webkit-gtk
	dev-dotnet/webkit-sharp"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.7
	net-misc/openssh
	>=gnome-base/gvfs-1.3
	dev-util/intltool
	x11-libs/libnotify
	dev-python/pygtk"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	DOCS="README COPYING"
}

