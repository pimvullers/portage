# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 2 _)

DESCRIPTION="Binutils with support for the ESP32 ULP co-processor"
HOMEPAGE="https://github.com/espressif/binutils-gdb"
SRC_URI="https://github.com/espressif/binutils-gdb/releases/download/esp32ulp-elf-${MY_PV}/esp32ulp-elf-${MY_PV}-linux-amd64.tar.gz"

S="${WORKDIR}/esp32ulp-elf"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	local DEST=/opt/${PN}

	dodir ${DEST}
	cp -r "${S}"/* "${ED}${DEST}"
	fowners -R root:0 ${DEST}

	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH=${DEST}/lib
MANPATH=${DEST}/share/man
EOF
	newenvd "${T}/env" 99binutils-esp32ulp-elf-bin
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Before use you should run 'env-update' and '. /etc/profile'"
		elog "otherwise you may be missing important environmental variables."
	fi
}
