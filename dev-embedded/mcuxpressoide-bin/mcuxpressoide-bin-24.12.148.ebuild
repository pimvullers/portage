# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev xdg

DESCRIPTION="An IDE for creating, building, debugging, and optimizing embedded applications"
HOMEPAGE="https://mcuxpresso.nxp.com/"
P_BUILD="mcuxpressoide-${PV}"
P_TGZ="${P_BUILD}.x86_64.tar.gz"
P_DEB="${P_BUILD}.x86_64.deb"
P_FILE="${P_DEB}.bin"
SRC_URI="https://freescaleesd.flexnetoperations.com/337170/901/13309901/${P_FILE}"

LICENSE="NXP_LA_OPT_TOOL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="udev"

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/libusb-compat
	app-mobilephone/dfu-util
	sys-libs/ncurses-compat:5[tinfo]
	dev-lang/python:2.7
	virtual/libcrypt:="
BDEPEND=""

pkg_nofetch() {
	einfo "Please download ${P_FILE}"
	einfo "and move it to your distfiles directory:"
	einfo
	einfo "  https://www.nxp.com/support/developer-resources/software-development-tools/mcuxpresso-software-and-tools/mcuxpresso-integrated-development-environment-ide:MCUXpresso-IDE?tab=Design_Tools_Tab"
	einfo
	einfo "If the above mentioned URL does not point to the correct version anymore,"
	einfo "please download the file from NXP's MCUXpresso download site:"
	einfo
	einfo "  ${HOMEPAGE}"
	einfo
}

src_unpack() {
	"${DISTDIR}/${P_FILE}" --noprogress --noexec --target "${S}" || die

	pushd "${S}" > /dev/null

	"${FILESDIR}/deb2targz" ${P_DEB} || die
	unpack "${S}/${P_TGZ}" || die

	popd > /dev/null
}

src_prepare() {
	eapply_user

	sed -i \
		-e "s#/usr/local/${P_BUILD}#/opt/nxp/mcuxpressoide#g" \
		-e "s#${PN} ${PV}_${BUILDNR}#MCUXpresso#g" \
		usr/share/applications/*.desktop

	xdg_src_prepare
}

src_install() {
	if use udev; then
		insinto /lib/udev/rules.d
		doins lib/udev/rules.d/*.rules
	fi

	dolib.so usr/lib/*

	insinto /usr/share/applications
	doins usr/share/applications/*.desktop

	dodir /opt/nxp/mcuxpressoide
	cp -pPR "usr/local/${P_BUILD}"/* "${ED}/opt/nxp/mcuxpressoide/"

	dosym ../../opt/nxp/mcuxpressoide/ide/mcuxpressoide /usr/bin/mcuxpressoide
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
