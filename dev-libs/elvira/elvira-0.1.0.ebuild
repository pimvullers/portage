# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Fast and portable C library which provides both high-level and low-level (cryptographic) credential operations"
HOMEPAGE="https://github.com/credentials/elvira"
SRC_URI="https://github.com/credentials/elvira/archive/elvira-${PV}.tar.gz ->
${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS=( README LICENSE AUTHORS )
}
