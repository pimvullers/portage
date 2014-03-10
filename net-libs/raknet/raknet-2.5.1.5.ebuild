# EBuild for RakNet 2.4.7 by Freek van Walderveen
# rakvoice is disabled

inherit eutils

DESCRIPTION="A game oriented network library that provides high performance messaging."
HOMEPAGE="http://www.rakkarsoft.com/"
# Copied file from http://www.rakkarsoft.com/raknet/downloads/RakNet.zip because
# it doesn't have a version number and changes very often.
SRC_URI="http://www.vanwal.nl/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RDEPEND=""
DEPEND=""

src_unpack() {
	mkdir ${S}
	unzip -q ${DISTDIR}/${A} -d ${S} || die "unpack failed"
	cd ${S} || die "cd \${S} failed"

	if use debug; then
	  einfo "Debugging: enabled"
	  epatch ${FILESDIR}/${P}_debug.patch || die "patching failed"
	else
	  einfo "Debugging: disabled"
	  epatch ${FILESDIR}/${P}.patch || die "patching failed"
	fi
}

src_compile() {
	make || die "Compilation failed."
}

src_install() {
	dolib ${S}/Lib/linux/libraknet.a ${S}/Lib/linux/libraknet.so*
	dohtml Help/*
	dodoc readme.txt
  dodir /usr/include/raknet
  insinto /usr/include/raknet
  doins ${S}/Include/*
}
