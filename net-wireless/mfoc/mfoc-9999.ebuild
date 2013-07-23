# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools-utils git-2

EGIT_REPO_URI="https://code.google.com/p/mfoc/"

DESCRIPTION="Mifare Classic Offline Cracker"
HOMEPAGE="https://code.google.com/p/mfoc/"
SRC_URI=""

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="debug"

DEPEND="dev-libs/libnfc"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
