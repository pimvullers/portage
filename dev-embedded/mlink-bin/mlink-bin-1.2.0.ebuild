# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="mBlock web version driver"
HOMEPAGE="https://mblock.cc/pages/downloads"
P_BUILD="mLink-${PV}"
P_TGZ="${P_BUILD}-amd64.tar.xz"
P_DEB="${P_BUILD}-amd64.deb"
SRC_URI="https://dls-cdn.makeblock.com/download-site/mblock5/linux/${P_DEB}"

S="${WORKDIR}"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-arch/deb2targz"
RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

pkg_nofetch() {
	einfo "Please download ${P_DEB}"
	einfo "and move it to your distfiles directory:"
	einfo
	einfo "  https://mblock.makeblock.com/en/download/mlink/"
	einfo
}

src_unpack() {
	cp "${DISTDIR}/${P_DEB}" "${WORKDIR}" || die

	pushd "${WORKDIR}" > /dev/null

	deb2targz ${P_DEB} || die
	unpack "${WORKDIR}/${P_TGZ}" || die

	popd > /dev/null
}

src_install() {
	dodir /opt/makeblock/mlink
	cp -pPR "usr/local/makeblock/mLink"/* "${ED}/opt/makeblock/mlink/"
	sed -i -e "s#/usr/local/makeblock/mLink#/opt/makeblock/mlink#" "${ED}/opt/makeblock/mlink/mlink"
	chmod +x "${ED}/opt/makeblock/mlink/mlink"

	dosym ../../opt/makeblock/mlink/mlink /usr/bin/mblock-mlink
}
