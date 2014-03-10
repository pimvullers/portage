# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnfc/libnfc-1.7.0-r1.ebuild,v 1.1 2013/09/26 02:58:50 mrueg Exp $

EAPI=5

inherit toolchain-funcs autotools-multilib

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc pcsc-lite readline static-libs usb"

RDEPEND="pcsc-lite? ( sys-apps/pcsc-lite[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local drivers="arygon,pn532_uart,pn532_spi,pn532_i2c,acr122s"
	use pcsc-lite && drivers+=",acr122_pcsc"
	use usb && drivers+=",pn53x_usb,acr122_usb"
	
	local myeconfargs=(
		--with-drivers="${drivers}"
		$(use_enable doc)
		$(use_with readline)
	)

	autotools-multilib_src_configure
}

src_compile() {
	autotools-multilib_src_compile

	use doc && doxygen
}

src_install() {
	autotools-multilib_src_install

	use doc && dohtml "${S}"/doc/html/*
}
