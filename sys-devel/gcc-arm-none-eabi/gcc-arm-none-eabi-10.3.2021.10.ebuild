# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1).$(ver_cut 2)-$(ver_cut 3).$(ver_cut 4)"

DESCRIPTION="GNU Arm Embedded Toolchain"
HOMEPAGE="https://developer.arm.com/open-source/gnu-toolchain/gnu-rm"

SRC_PREFIX="https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm"
SRC_URI="amd64? ( ${SRC_PREFIX}/${MY_PV}/gcc-arm-none-eabi-${MY_PV}-x86_64-linux.tar.bz2 )
	arm64? ( ${SRC_PREFIX}/${MY_PV}/gcc-arm-none-eabi-${MY_PV}-aarch64-linux.tar.bz2 )"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="sys-libs/ncurses-compat:5[tinfo]
	dev-lang/python:2.7"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	local DEST=/opt/${PN}

	dodir ${DEST}
	\cp -r "${S}"/* "${ED}${DEST}"
	fowners -R root:0 ${DEST}

	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH=${DEST}/lib
MANPATH=${DEST}/share/doc/arm-arm-none-eabi/man
EOF
	newenvd "${T}/env" 99gcc-arm-embedded-bin
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Before use you should run 'env-update' and '. /etc/profile'"
		elog "otherwise you may be missing important environmental variables."
	fi
}
