# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="IDE for the Arduino platform"
HOMEPAGE="https://www.arduino.cc/"
SRC_URI="https://downloads.arduino.cc/arduino-ide/arduino-ide_${PV}_Linux_64bit.zip"

LICENSE="AGPL-3"
SLOT="2"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/arduino-ide_${PV}_Linux_64bit/"

src_install() {
	dodir /opt/arduino/ide
	cp -pPR * "${ED}/opt/arduino/ide/"

	dosym ../../opt/arduino/ide/arduino-ide /usr/bin/arduino-ide

	insinto /usr/share/applications
	doins ${FILESDIR}/arduino-ide.desktop
}

