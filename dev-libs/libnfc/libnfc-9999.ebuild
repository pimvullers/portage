# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnfc/libnfc-1.5.1-r1.ebuild,v 1.1 2013/05/24 17:10:36 vapier Exp $

EAPI="5"

inherit eutils toolchain-funcs autotools-utils git-2

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
EGIT_REPO_URI="https://code.google.com/p/libnfc/"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc pcsc-lite readline static-libs usb"

RDEPEND="pcsc-lite? ( sys-apps/pcsc-lite )
	readline? ( sys-libs/readline )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

AUTOTOOLS_AUTORECONF=1

src_configure() {
	# Upstream doesn't use the right macro, so we need to force this.
	# https://code.google.com/p/libnfc/issues/detail?id=249
	export ac_cv_path_PKG_CONFIG=$(tc-getPKG_CONFIG)

	local drivers="acr122s,arygon,pn532_i2c,pn532_spi,pn532_uart"
	use pcsc-lite && drivers+=",acr122_pcsc"
	use usb && drivers+=",acr122_usb,pn53x_usb"
	econf \
		--with-drivers="${drivers}" \
		$(use_enable doc) \
		$(use_with readline) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && doxygen
}

src_install() {
	default
	use static-libs || find "${ED}" -name 'lib*.la' -delete
	use doc && dohtml "${S}"/doc/html/*
}
