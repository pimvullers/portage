# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

SRC_BASE="http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/kepler/R/eclipse-java-kepler-R-linux-gtk"

DESCRIPTION="Eclipse SDK"
HOMEPAGE="http://www.eclipse.org"
SRC_URI="
	amd64? ( ${SRC_BASE}-x86_64.tar.gz&r=1 -> eclipse-java-kepler-linux-gtk-x86_64.tar.gz )
	x86? ( ${SRC_BASE}.tar.gz&r=1 -> eclipse-java-kepler-linux-gtk.tar.gz )"

LICENSE="EPL-1.0"
SLOT="4.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jdk-1.6
	x11-libs/gtk+:2"

S=${WORKDIR}/eclipse

src_install() {
	local dest=/opt/${PN}-${SLOT}

	insinto ${dest}
	doins -r features icon.xpm plugins artifacts.xml p2 eclipse.ini configuration dropins

	exeinto ${dest}
	doexe eclipse

	dohtml -r about.html about_files epl-v10.html notice.html readme/*

	insinto /etc
	doins "${FILESDIR}"/eclipserc-bin-${SLOT}

	dobin "${FILESDIR}"/eclipse-bin-${SLOT}
	make_desktop_entry "eclipse-bin-${SLOT}" "Eclipse SDK ${SLOT}" "${dest}/icon.xpm"
}
