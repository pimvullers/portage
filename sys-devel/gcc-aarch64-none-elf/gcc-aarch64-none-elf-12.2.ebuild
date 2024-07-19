# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV}.rel1"

DESCRIPTION="GNU Arm Embedded Toolchain"
HOMEPAGE="https://developer.arm.com/open-source/gnu-toolchain/gnu-rm"

SRC_URI="https://developer.arm.com/-/media/Files/downloads/gnu/${MY_PV}/binrel/arm-gnu-toolchain-${MY_PV}-x86_64-aarch64-none-elf.tar.xz"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="strip"
QA_PREBUILT="*"

DEPEND="virtual/libcrypt:="
RDEPEND="sys-libs/ncurses-compat:5[tinfo]"

S="${WORKDIR}/arm-gnu-toolchain-${MY_PV}-x86_64-aarch64-none-elf"

src_install() {
	local DEST=/opt/${PN}

	dodir ${DEST}
	\cp -r "${S}"/* "${ED}${DEST}"
	fowners -R root:0 ${DEST}

	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH=${DEST}/lib
MANPATH=${DEST}/share/man
EOF
	newenvd "${T}/env" 99gcc-aarch64-embedded-bin
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Before use you should run 'env-update' and '. /etc/profile'"
		elog "otherwise you may be missing important environmental variables."
	fi
}
