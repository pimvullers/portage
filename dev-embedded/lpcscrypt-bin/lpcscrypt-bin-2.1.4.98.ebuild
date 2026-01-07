# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Tool for programming firmware onto NXP Link2/LPC-Link2 debug probes"
HOMEPAGE="https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/lpcscrypt:LPCSCRYPT"
MY_PV=$(ver_rs 3 _)
LINKSERVER_PV="25.12.83"
P_BUILD="LinkServer_${LINKSERVER_PV}"
P_TGZ="${P_BUILD}.x86_64.tar.gz"
P_DEB="${P_BUILD}.x86_64.deb"
P_FILE="${P_DEB}.bin"
SRC_URI="https://cache.nxp.com/secured/updates/linker/${P_FILE}?fileExt=.bin -> ${P_FILE}"

LICENSE="NXP_LA_OPT_TOOL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="udev"

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

RDEPEND="
	sys-apps/util-linux"
BDEPEND="
	app-arch/deb2targz"

pkg_nofetch() {
	einfo "Please download ${P_FILE}"
	einfo "and move it to your distfiles directory:"
	einfo
	einfo "  https://www.nxp.com/webapp/Download?colCode=LINKER-SERVER-LINUX"
	einfo
	einfo "If the above mentioned URL does not point to the correct version anymore,"
	einfo "please download the file from NXP's LinkServer download site:"
	einfo
	einfo "  ${HOMEPAGE}"
	einfo
}

src_unpack() {
	sh "${DISTDIR}/${P_FILE}" --noprogress --noexec --target "${S}" || die

	pushd "${S}" > /dev/null

	deb2targz LPCScrypt.deb || die
	unpack "${S}/LPCScrypt.tar.gz" || die

	popd > /dev/null
}

src_install() {
	if use udev; then
		insinto /lib/udev/rules.d
		doins lib/udev/rules.d/*.rules
	fi

	dodir /opt/nxp/lpcscrypt
	cp -pPR "usr/local/lpcscrypt-${MY_PV}"/* "${ED}/opt/nxp/lpcscrypt/"

	cp "${FILESDIR}"/Firmware_JLink_LPC-Link2_*.bin "${ED}/opt/nxp/lpcscrypt/probe_firmware/LPCLink2/"
	cp "${FILESDIR}"/Firmware_JLink_LPCXpressoV2_*.bin "${ED}/opt/nxp/lpcscrypt/probe_firmware/LPCXpressoV2/"

	dosym ../../opt/nxp/lpcscrypt/bin/lpcscrypt /usr/bin/lpcscrypt
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
