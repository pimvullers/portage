# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 3 _)

DESCRIPTION="GCC for Xtensa (crosstool-NG with support for Xtensa)"
HOMEPAGE="https://github.com/espressif/crosstool-NG"
SRC_URI="https://github.com/espressif/crosstool-NG/releases/download/esp-${MY_PV}/xtensa-esp-elf-${MY_PV}-x86_64-linux-gnu.tar.xz"

S="${WORKDIR}/xtensa-esp-elf"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"
QA_PREBUILT="*"

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
	newenvd "${T}/env" 99gcc-xtensa-esp-elf-bin
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Before use you should run 'env-update' and '. /etc/profile'"
		elog "otherwise you may be missing important environmental variables."
	fi
}
