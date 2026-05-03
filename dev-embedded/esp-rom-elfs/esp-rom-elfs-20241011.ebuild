# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Espressif ROM binaries"
HOMEPAGE="https://github.com/espressif/esp-rom-elfs"
SRC_URI="https://github.com/espressif/esp-rom-elfs/releases/download/${PV}/esp-rom-elfs-${PV}.tar.gz"

LICENSE="BSD GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	local DEST=/opt/${PN}

	dodir ${DEST}
	cp -r "${S}"/* "${ED}${DEST}"
	fowners -R root:0 ${DEST}
}
