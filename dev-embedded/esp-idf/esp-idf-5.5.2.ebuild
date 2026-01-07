# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="v${PV}"

DESCRIPTION="Espressif IoT Development Framework"
HOMEPAGE="https://github.com/espressif/esp-idf"
SRC_URI="https://dl.espressif.com/github_assets/espressif/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.zip"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="esp32p4 esp32c61 esp32s2 esp32c5 esp32c2 esp32 esp32c6 esp32c3 esp32h2 esp32s3"
RESTRICT="strip"

BDEPEND="
	app-arch/unzip"

src_install() {
	rm -r "${S}/.git"

	mkdir -p "${ED}/opt/${PN}"
	cp -R "${S}"/* "${ED}/opt/${PN}"
}
