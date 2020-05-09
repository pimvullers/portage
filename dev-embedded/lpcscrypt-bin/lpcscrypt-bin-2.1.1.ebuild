# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An IDE for creating, building, debugging, and optimizing embedded applications"
HOMEPAGE="https://www.nxp.com/support/developer-resources/microcontrollers-developer-resources/lpc-microcontroller-utilities/lpcscrypt-v2.1.0:LPCSCRYPT"
BUILDNR="15"
P_BUILD="lpcscrypt-${PV}_${BUILDNR}"
P_TGZ="${P_BUILD}.x86_64.tar.gz"
P_DEB="${P_BUILD}.x86_64.deb"
P_FILE="${P_DEB}.bin"
SRC_URI="https://www.nxp.com/downloads/en/software/${P_FILE}"

LICENSE="NXP_LA_OPT_TOOL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="udev"

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/util-linux"
BDEPEND=""

src_unpack() {
	sh "${DISTDIR}/${P_FILE}" --noprogress --noexec --target "${S}" || die

	pushd "${S}" > /dev/null

	"${FILESDIR}/deb2targz" ${P_DEB} || die
	unpack "${S}/${P_TGZ}" || die

	popd > /dev/null
}

src_install() {
	if use udev; then
		insinto /lib/udev/rules.d
		doins lib/udev/rules.d/*.rules
	fi

	dodir /opt/nxp/lpcscrypt
	cp -pPR "usr/local/${P_BUILD}"/* "${ED}/opt/nxp/lpcscrypt/"

	cp "${FILESDIR}"/Firmware_JLink_LPC-Link2_*.bin "${ED}/opt/nxp/lpcscrypt/probe_firmware/LPCLink2/"
	cp "${FILESDIR}"/Firmware_JLink_LPCXpressoV2_*.bin "${ED}/opt/nxp/lpcscrypt/probe_firmware/LPCXpressoV2/"

	dosym ../../opt/nxp/lpcscrypt/bin/lpcscrypt /usr/bin/lpcscrypt
}
