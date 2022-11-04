# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU RISC-V Embedded GCC"
HOMEPAGE="https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack"

SRC_URI="https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v12.2.0-1/xpack-riscv-none-elf-gcc-12.2.0-1-linux-x64.tar.gz"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="strip"
QA_PREBUILT="*"

DEPEND="
	!sys-devel/gcc-riscv-none-embed"
RDEPEND="
	virtual/libcrypt:="

S="${WORKDIR}/xpack-riscv-none-elf-gcc-12.2.0-1"

src_install() {
	local DEST=/opt/${PN}

	dodir ${DEST}
	\cp -r "${S}"/* "${ED}${DEST}"
	fowners -R root:0 ${DEST}

	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH="${DEST}/lib:${DEST}/libexec"
EOF
	newenvd "${T}/env" 99gcc-riscv-embedded-bin
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Before use you should run 'env-update' and '. /etc/profile'"
		elog "otherwise you may be missing important environmental variables."
	fi
}
