# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnfc/libnfc-1.5.1-r1.ebuild,v 1.1 2013/05/24 17:10:36 vapier Exp $

EAPI="5"

inherit eutils toolchain-funcs autotools git-r3

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
EGIT_REPO_URI="https://code.google.com/p/libnfc/"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc pcsc-lite readline static-libs usb"

RDEPEND="pcsc-lite? ( sys-apps/pcsc-lite[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

AUTOTOOLS_AUTORECONF=1

src_prepare() {
	sed -i -e 's/1.7.0-rc7/1.7.0-rc8/' configure.ac

	autotools_src_prepare
}

src_configure() {
	# Upstream doesn't use the right macro, so we need to force this.
	# https://code.google.com/p/libnfc/issues/detail?id=249
	export ac_cv_path_PKG_CONFIG=$(tc-getPKG_CONFIG)

	local drivers="acr122s,arygon,pn532_i2c,pn532_spi,pn532_uart"
	use pcsc-lite && drivers+=",acr122_pcsc"
	use usb && drivers+=",acr122_usb,pn53x_usb"

	local myeconfargs=(
		--with-drivers="${drivers}"
		$(use_enable doc)
		$(use_with readline)
	)

	autotools_src_configure
}

src_compile() {
	autotools_src_compile

	use doc && doxygen
}

src_install() {
	autotools_src_install

	use doc && dohtml "${S}"/doc/html/*
}
