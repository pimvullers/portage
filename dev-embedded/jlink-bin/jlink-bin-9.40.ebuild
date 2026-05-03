# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Tools for Segger J-Link JTAG adapters"
HOMEPAGE="https://www.segger.com/downloads/jlink/"
SRC_URI="https://www.segger.com/downloads/jlink/JLink_Linux_V${PV/\./}_x86_64.tgz"

S=${WORKDIR}/"JLink_Linux_V${PV/\./}_x86_64"

LICENSE="Segger"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

RDEPEND="
	acct-group/plugdev"

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
	local EXE_FILES=(
		"JFlashExe"
		"JFlashLiteExe"
		"JFlashSPICLExe"
		"JFlashSPIExe"
		"JLinkConfigExe"
		"JLinkExe"
		"JLinkGDBServerCLExe"
		"JLinkGDBServerExe"
		"JLinkGUIServerExe"
		"JLinkLicenseManagerExe"
		"JLinkRTTClientExe"
		"JLinkRTTLoggerExe"
		"JLinkRTTViewerExe"
		"JLinkRegistrationExe"
		"JLinkRemoteServerCLExe"
		"JLinkRemoteServerExe"
		"JLinkSTM32Exe"
		"JLinkSWOViewerCLExe"
		"JLinkSWOViewerExe"
		"JMemExe"
		"JRunExe"
		"JTAGLoadExe"
	)
	local CLEXE_SYMS=(
		"JLinkGDBServer"
		"JLinkRemoteServer"
		"JLinkSWOViewer"
	)
	local EXE_SYMS=(
		"JLinkLicenseManager"
		"JLinkRTTClient"
		"JLinkRTTLogger"
		"JLinkRegistration"
		"JLinkSTM32"
	)

	# Install binaries and symlinks in INSTALLDIR
	exeinto ${INSTALLDIR}
	for exe in ${EXE_FILES[@]}; do
		doexe ${exe} || die
	done
	for sym in ${CLEXE_SYMS[@]}; do
		dosym "${sym}CLExe" ${INSTALLDIR}/${sym} || die
	done
	for sym in ${EXE_SYMS[@]}; do
		dosym "${sym}Exe" ${INSTALLDIR}/${sym} || die
	done
	dosym JFlashSPICLExe ${INSTALLDIR}/JFlashSPI_CL || die

	# Create symlinks in /usr/bin
	for exe in ${EXE_FILES[@]} ${EXE_SYMS[@]} ${CLEXE_SYMS[@]} JFlashSPI_CL; do
		dosym ${EXELINKDIR}/${exe} /usr/bin/${exe} || die
	done

	# Install libraries
	local V_ARRAY=( $(ver_rs 1- ' ') )
	local V_MAJOR=${V_ARRAY[0]}
	local V_MINOR=${V_ARRAY[1]}
	local V_PATCH=0 #$(( $(printf "%d" "'${V_ARRAY[2]}'") - 96 ))

	for LIB in libjlinkarm libjlinkarm_x86; do
		doexe "${LIB}.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" || die
		dosym "${LIB}.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" \
			"${INSTALLDIR}/${LIB}.so.${V_MAJOR}.${V_MINOR}" || die
		dosym "${LIB}.so.${V_MAJOR}.${V_MINOR}" \
			"${INSTALLDIR}/${LIB}.so.${V_MAJOR}" || die
		dosym "${LIB}.so.${V_MAJOR}" \
			"${INSTALLDIR}/${LIB}.so" || die
	done
	dosym "../libjlinkarm_x86.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" \
		"${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" || die
	dosym "libjlinkarm.so.${V_MAJOR}.${V_MINOR}.${V_PATCH}" \
		"${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}.${V_MINOR}" || die
	dosym "libjlinkarm.so.${V_MAJOR}.${V_MINOR}" \
		"${INSTALLDIR}/x86/libjlinkarm.so.${V_MAJOR}" || die
	dosym "libjlinkarm.so.${V_MAJOR}" \
		"${INSTALLDIR}/x86/libjlinkarm.so" || die

	for LIB in libQtCore libQtGui; do
		doexe "${LIB}.so.4.8.7" || die
		dosym "${LIB}.so.4.8.7" "${INSTALLDIR}/${LIB}.so.4.8" || die
		dosym "${LIB}.so.4.8" "${INSTALLDIR}/${LIB}.so.4" || die
		dosym "${LIB}.so.4" "${INSTALLDIR}/${LIB}.so" || die
	done

	# Install other files
	exeinto ${INSTALLDIR}/GDBServer
	doexe GDBServer/*.so || die
	insinto ${INSTALLDIR}/GDBServer
	doins GDBServer/*.txt || die

	insinto ${INSTALLDIR}
	doins -r Doc || die
	doins -r ETC || die
	doins -r Firmwares || die
	doins -r Samples || die

	insinto /lib/udev/rules.d/
	doins 99-jlink.rules || die
}

pkg_postinst() {
	udev_reload
	elog "To be able to access the jlink usb adapter, you have to be"
	elog "a member of the 'plugdev' group."
}

pkg_postrm() {
	udev_reload
}
