# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Convert a .deb file to a .tar.gz archive"
HOMEPAGE="https://www.miketaylor.org.uk/tech/deb/"
SRC_URI="https://www.miketaylor.org.uk/tech/deb/${PN}"

S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-any-data.patch"
	"${FILESDIR}/dirname_fix.patch"
)

src_unpack() {
	cp "${DISTDIR}/${PN}" "${S}" || die
}

src_install() {
	dobin ${PN}
}
