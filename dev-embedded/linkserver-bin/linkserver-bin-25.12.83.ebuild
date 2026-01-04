# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utility for launching and managing GDB servers for NXP debug probes"
HOMEPAGE="https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/linkserver-for-microcontrollers:LINKERSERVER"
BUILDNR="57"
P_BUILD="LinkServer_${PV}"
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

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/util-linux"
BDEPEND=""

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

	"${FILESDIR}/deb2targz" ${P_DEB} || die
	unpack "${S}/${P_TGZ}" || die

	popd > /dev/null
}

src_install() {
	if use udev; then
		insinto /lib/udev/rules.d
		doins lib/udev/rules.d/*.rules
	fi

	dodir /opt/nxp/linkserver
	cp -pPR "usr/local/${P_BUILD}"/* "${ED}/opt/nxp/linkserver/"

	dosym ../../opt/nxp/linkserver/LinkServer /usr/bin/LinkServer
	dosym ../../opt/nxp/linkserver/LinkFlash /usr/bin/LinkFlash
}
