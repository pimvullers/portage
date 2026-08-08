# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 python3_11 python3_12 python3_13 python3_14 )
inherit distutils-r1 pypi

DESCRIPTION="Coroutine-based concurrency library for Python"
HOMEPAGE="https://gevent.org https://pypi.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/greenlet-3.0.0[${PYTHON_USEDEP}]
	dev-python/zope-event[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	distutils-r1_src_prepare
	# Prevent gevent from trying to download/build bundled libev if system has it
	export GEVENT_NO_C_EXTENSIONS=0
}
