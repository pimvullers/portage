# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="IDE for the Arduino platform"
HOMEPAGE="https://www.arduino.cc/"
SRC_URI="https://downloads.arduino.cc/arduino-ide/arduino-ide_${PV}_Linux_64bit.zip"

S="${WORKDIR}/arduino-ide_${PV}_Linux_64bit/"

LICENSE="AGPL-3"
SLOT="2"
KEYWORDS="amd64"

BDEPEND="
	app-arch/unzip"

src_install() {
	dodir /opt/arduino/ide
	cp -pPR * "${ED}/opt/arduino/ide/"

	dosym ../../opt/arduino/ide/arduino-ide /usr/bin/arduino-ide

	domenu "${FILESDIR}/arduino-ide.desktop"
}
