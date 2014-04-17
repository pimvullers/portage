# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libhdhomerun/libhdhomerun-20130328.ebuild,v 1.1 2014/01/04 14:41:37 cardoe Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="SiliconDust HDHomeRun Configuration GUI"
HOMEPAGE="http://www.silicondust.com/support/hdhomerun/downloads/linux/"
SRC_URI="http://download.silicondust.com/hdhomerun/${PN}_${PV}.tgz
	http://download.silicondust.com/hdhomerun/libhdhomerun_${PV}.tgz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-system-lib.patch"
	epatch_user

	autotools-utils_src_prepare
}
