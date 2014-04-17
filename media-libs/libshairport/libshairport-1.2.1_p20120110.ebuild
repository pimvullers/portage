# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils

DESCRIPTION="Airtunes emulator"
HOMEPAGE="https://github.com/amejia1/libshairport"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/libshairport_1.2.1%7Egit20120110.aeb4987.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/libao[alsa]
dev-libs/openssl
net-dns/avahi[mdnsresponder-compat]
dev-lang/perl
dev-perl/HTTP-Message
dev-perl/HTTP-Date
dev-perl/Encode-Locale
dev-perl/LWP-MediaTypes
dev-perl/Crypt-OpenSSL-RSA 
dev-perl/IO-Socket-INET6
"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1

src_prepare() {
	autotools-utils_src_prepare
}
