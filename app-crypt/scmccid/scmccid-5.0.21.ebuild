# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="pcsc-lite driver for the SCM SDI010"
HOMEPAGE="http://www.scmmicro.com/"
SRC_URI="http://www.identive-infrastructure.com/support/download/scmccid_linux_64bit_driver_V${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-apps/pcsc-lite
	virtual/libusb"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	S="${WORKDIR}/${PN}_${PV}_linux"
}

src_install() {
	insinto "$(pkg-config libpcsclite --variable=usbdropdir)"
	doins -r ./proprietary/*.bundle

	insinto "/usr/local/scm/ini/"
	doins scmccid.ini
}

