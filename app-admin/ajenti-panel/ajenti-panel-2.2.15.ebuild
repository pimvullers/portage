# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_12 python3_13 python3_14 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A modular, extensible web-based server administration panel"
HOMEPAGE="https://ajenti.org https://github.com"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Dependencies adjusted for modern Python 3 environments on Gentoo
RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	app-admin/augeas
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install

	# Install OpenRC init script and config file from FILESDIR
	newinitd "${FILESDIR}/ajenti.initd" ajenti
	newconfd "${FILESDIR}/ajenti.confd" ajenti

	# Ensure system configuration paths exist
	keepdir /etc/ajenti
	keepdir /var/log/ajenti
}
