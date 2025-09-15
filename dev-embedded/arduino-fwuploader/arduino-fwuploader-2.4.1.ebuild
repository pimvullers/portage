# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A Tool to update the firmware and/or add SSL certificates for Arduino boards"
HOMEPAGE="https://arduino.github.io/arduino-fwuploader/latest/"

SRC_URI="
	https://github.com/arduino/arduino-fwuploader/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_unpack() {
	default
	unpack "${FILESDIR}/${P}-vendor.tar.xz"
}

src_compile() {
	ego build -tags xversion \
		-ldflags "-X github.com/arduino/arduino-fwuploader/version.versionString=${PV}"
}

src_install() {
	dobin arduino-fwuploader
}
