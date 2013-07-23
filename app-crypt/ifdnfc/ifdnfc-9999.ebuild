# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="PC/SC IFD Handler based on libnfc"
HOMEPAGE="https://code.google.com/p/ifdnfc/"
EGIT_REPO_URI="https://code.google.com/p/ifdnfc/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
