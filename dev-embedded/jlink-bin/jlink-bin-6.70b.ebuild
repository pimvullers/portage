# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Tools for Segger J-Link JTAG adapters"
HOMEPAGE="https://www.segger.com/downloads/jlink/"
SRC_URI="https://www.segger.com/downloads/jlink/JLink_Linux_V${PV/\./}_x86_64.tgz"

LICENSE="Segger"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/libedit
	dev-qt/qtcore:4
	dev-qt/qtgui:4"

S=${WORKDIR}/"JLink_Linux_V${PV/\./}_x86_64"

pkg_nofetch() {
	einfo "Please download the source archive (after accepting the license agreement)"
	einfo "and move it to your distfiles directory:"
	einfo
	einfo "  ${SRC_URI}"
	einfo
	einfo "If the above mentioned URL does not point to the correct version anymore,"
	einfo "please download the file from SEGGER's J-Link download site:"
	einfo
	einfo "  ${HOMEPAGE}"
	einfo
}

src_install() {
	local INSTALLDIR="/opt/segger/jlink"
	local EXELINKDIR="../../opt/segger/jlink"

	exeinto ${INSTALLDIR}

	doexe JFlashLiteExe JFlashSPICLExe || die
	dosym JFlashSPICLExe ${INSTALLDIR}/JFlashSPI_CL || die
	dosym ${EXELINKDIR}/JFlashLiteExe /usr/bin/JFlashLite || die
	dosym ${EXELINKDIR}/JFlashLiteExe /usr/bin/JFlashLiteExe || die
	dosym ${EXELINKDIR}/JFlashSPICLExe /usr/bin/JFlashSPICLExe || die
	dosym ${EXELINKDIR}/JFlashSPICLExe /usr/bin/JFlashSPI_CL || die

	doexe JLinkExe || die
	dosym ${EXELINKDIR}/JLinkExe /usr/bin/JLinkExe || die

	doexe JLinkGDBServerCLExe JLinkGDBServerExe || die
	dosym JLinkGDBServerCLExe ${INSTALLDIR}/JLinkGDBServer || die
	dosym ${EXELINKDIR}/JLinkGDBServerCLExe /usr/bin/JLinkGDBServerCLExe || die
	dosym ${EXELINKDIR}/JLinkGDBServerExe /usr/bin/JLinkGDBServerExe || die
	dosym ${EXELINKDIR}/JLinkGDBServerCLExe /usr/bin/JLinkGDBServer || die

	doexe JLinkLicenseManagerExe || die
	dosym JLinkLicenseManagerExe ${INSTALLDIR}/JLinkLicenseManager || die
	dosym ${EXELINKDIR}/JLinkLicenseManagerExe /usr/bin/JLinkLicenseManagerExe || die
	dosym ${EXELINKDIR}/JLinkLicenseManagerExe /usr/bin/JLinkLicenseManager || die

	doexe JLinkRTTClientExe JLinkRTTLoggerExe JLinkRTTViewerExe || die
	dosym JLinkRTTClientExe ${INSTALLDIR}/JLinkRTTClient || die
	dosym JLinkRTTLoggerExe ${INSTALLDIR}/JLinkRTTLogger || die
	dosym ${EXELINKDIR}/JLinkRTTClientExe /usr/bin/JLinkRTTClientExe || die
	dosym ${EXELINKDIR}/JLinkRTTClientExe /usr/bin/JLinkRTTClient || die
	dosym ${EXELINKDIR}/JLinkRTTLoggerExe /usr/bin/JLinkRTTLoggerExe || die
	dosym ${EXELINKDIR}/JLinkRTTLoggerExe /usr/bin/JLinkRTTLogger || die
	dosym ${EXELINKDIR}/JLinkRTTViewerExe /usr/bin/JLinkRTTViewerExe || die

	doexe JLinkRegistrationExe || die
	dosym JLinkRegistrationExe ${INSTALLDIR}/JLinkRegistration || die
	dosym ${EXELINKDIR}/JLinkRegistrationExe /usr/bin/JLinkRegistrationExe || die
	dosym ${EXELINKDIR}/JLinkRegistrationExe /usr/bin/JLinkRegistration || die

	doexe JLinkRemoteServerCLExe JLinkRemoteServerExe || die
	dosym JLinkRemoteServerCLExe ${INSTALLDIR}/JLinkRemoteServer || die
	dosym ${EXELINKDIR}/JLinkRemoteServerCLExe /usr/bin/JLinkRemoteServerCLExe || die
	dosym ${EXELINKDIR}/JLinkRemoteServerExe /usr/bin/JLinkRemoteServerExe || die
	dosym ${EXELINKDIR}/JLinkRemoteServerCLExe /usr/bin/JLinkRemoteServer || die

	doexe JLinkSTM32Exe || die
	dosym JLinkSTM32Exe ${INSTALLDIR}/JLinkSTM32 || die
	dosym ${EXELINKDIR}/JLinkSTM32Exe /usr/bin/JLinkSTM32Exe || die
	dosym ${EXELINKDIR}/JLinkSTM32Exe /usr/bin/JLinkSTM32 || die

	doexe JLinkSWOViewerCLExe || die
	dosym JLinkSWOViewerCLExe ${INSTALLDIR}/JLinkSWOViewer || die
	dosym ${EXELINKDIR}/JLinkSWOViewerCLExe /usr/bin/JLinkSWOViewerCLExe || die
	dosym ${EXELINKDIR}/JLinkSWOViewerCLExe /usr/bin/JLinkSWOViewer || die

	doexe JTAGLoadExe || die
	dosym ${EXELINKDIR}/JTAGLoadExe /usr/bin/JTAGLoadExe || die

	local V_ARRAY=( $(ver_rs 1- ' ') )
	local V_MAJOR=${V_ARRAY[0]}
	local V_MINOR=${V_ARRAY[1]}
	local V_PATCH=$(( $(printf "%d" "'${V_ARRAY[2]}'") - 96 ))

	for LIB in libjlinkarm libjlinkarm_x86; do
		doexe "${LIB}.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" || die
		dosym "${LIB}.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" "${INSTALLDIR}/${LIB}.so.${V_MAJOR}.${V_MINOR}" || die
		dosym "${LIB}.so.${V_MAJOR}.${V_MINOR}" "${INSTALLDIR}/${LIB}.so.${V_MAJOR}" || die
		dosym "${LIB}.so.${V_MAJOR}" "${INSTALLDIR}/${LIB}.so" || die
	done
	dosym "../libjlinkarm_x86.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" "${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" || die
	dosym "libjlinkarm.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" "${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}.${V_MINOR}" || die
	dosym "libjlinkarm.so.${V_MAJOR}.${V_MINOR}" "${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}" || die
	dosym "libjlinkarm.so.${V_MAJOR}" "${INSTALLDIR}/x86/libjlinkarm.so" || die

	exeinto ${INSTALLDIR}/GDBServer
	doexe GDBServer/* || die

	insinto ${INSTALLDIR}
	doins -r Devices || die
	doins -r Doc || die
	doins -r Samples || die
	doins JLinkDevices.xml || die

	insinto /lib/udev/rules.d/
	doins 99-jlink.rules || die
}

pkg_postinst() {
	enewgroup plugdev
	elog "To be able to access the jlink usb adapter, you have to be"
	elog "a member of the 'plugdev' group."
}
