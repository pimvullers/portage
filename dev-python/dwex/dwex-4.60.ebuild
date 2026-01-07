# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi xdg

DESCRIPTION="DWARF Explorer - a GUI utility for navigating the DWARF debug information"
HOMEPAGE="
	https://pypi.org/project/dwex
	https://github.com/sevaa/dwex
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/pyqt6
	dev-python/filebytes
	dev-python/pyelftools
"

src_prepare() {
	sed -i -e "s#/usr/share/#${ED}/usr/share/#g" setup.py
	distutils-r1_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
}
