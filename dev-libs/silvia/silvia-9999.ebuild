# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit flag-o-matic autotools-multilib git-2

DESCRIPTION="SImple Library for the Verification and Issuance of Attributes"
HOMEPAGE="https://github.com/credentials/silvia"
EGIT_REPO_URI="https://github.com/credentials/silvia"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-fbsd ~arm ~arm-fbsd ~mips ~x86 ~x86-fbsd"
IUSE="smartcard pcsc-lite libnfc test xml static static-libs"
REQUIRED_USE="smartcard? ( || ( pcsc-lite libnfc ) )"

LIB_DEPEND="
	abi_x86_32? ( app-emulation/emul-linux-x86-baselibs )
	=dev-libs/gmp-5*[cxx,static-libs(+),${MULTILIB_USEDEP}]
	dev-libs/openssl[static-libs(+)]
	pcsc-lite? ( sys-apps/pcsc-lite[static-libs(+),${MULTILIB_USEDEP}] )
	libnfc? ( dev-libs/libnfc[static-libs(+),${MULTILIB_USEDEP}] )
	xml? ( dev-libs/libxml2[static-libs(+),${MULTILIB_USEDEP}] )
	sys-libs/zlib[static-libs(+),${MULTILIB_USEDEP}]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? ( dev-util/cppunit[${MULTILIB_USEDEP}]	)"

AUTOTOOLS_AUTORECONF=1

src_configure() {
	use static && append-ldflags -static -lpthread

	local myeconfargs=(
		$(use_with pcsc-lite pcsc)
		$(use_with libnfc nfc)
		$(use_with test tests)
		$(use_with xml xmlcfg)
	)

	autotools-multilib_src_configure
}
