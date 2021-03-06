# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pre-built GNU toolchain for Arm Cortex-M and Cortex-R processors"
HOMEPAGE="https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm"
SRC_URI="https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/gcc-arm-none-eabi-8-2018-q4-major"

src_install() {
	dodir /opt/${PN}
	cp -pPR * "${ED}/opt/${PN}"

	for file in bin/*; do
		dosym ../../opt/${PN}/${file} /usr/${file}
	done
}
