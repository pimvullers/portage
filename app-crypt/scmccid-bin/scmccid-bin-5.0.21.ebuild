# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs udev

DESCRIPTION="pcsc-lite driver for the SCM SDI010"
HOMEPAGE="http://www.scmmicro.com/"
SRC_URI="
	amd64? ( http://www.identive-infrastructure.com/support/download/scmccid_linux_64bit_driver_V${PV}.tar.gz )
	x86? ( http://www.identive-infrastructure.com/support/download/scmccid_linux_32bit_driver_V${PV}.tar.gz )"

LICENSE="SCM-MICRO"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-apps/pcsc-lite
	virtual/libusb"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

RESTRICT="mirror bindist"

src_install() {
	local INSTALL_DIR=`$(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir`
	local BASEPATH
	case $(tc-arch) in
		amd64) BASEPATH="${S}/scmccid_${PV}_linux" ;;
		x86)   BASEPATH="${S}/scmccid_${PV}_linux_rel" ;;
	esac

	insinto "${INSTALL_DIR}"/scmccid.bundle/Contents
	doins "${BASEPATH}"/proprietary/scmccid.bundle/Contents/Info.plist
	exeinto "${INSTALL_DIR}"/scmccid.bundle/Contents/Linux
	doexe "${BASEPATH}"/proprietary/scmccid.bundle/Contents/Linux/libscmccid.so.${PV}

	udev_dorules "${FILESDIR}"/92_pcscd_scmccid-bin.rules

#	insinto "/usr/local/scm/ini/"
#	doins scmccid.ini
}
