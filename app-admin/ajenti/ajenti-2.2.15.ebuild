# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 python3_12 python3_13 python3_14 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 systemd

DESCRIPTION="A modular, extensible web-based server administration panel"
HOMEPAGE="https://ajenti.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="plugins"

# Dependencies adjusted for modern Python environments on Gentoo
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

# Array tracking all valid internal components
AJENTI_PLUGINS=(
	core dashboard settings plugins notepad
	terminal filemanager packages services
)

python_compile() {
	# Step 1: Compile the core engine sub-packages manually using explicit legacy setups
	einfo "Compiling Ajenti Core components..."
	cd "${S}/ajenti-core" || die
	DISTUTILS_USE_PEP517=setuptools distutils-r1_python_compile
	
	cd "${S}/ajenti-panel" || die
	DISTUTILS_USE_PEP517=setuptools distutils-r1_python_compile
	cd "${S}" || die

	# Step 2: Navigate and compile selected sub-module extensions if flag is present
	if use plugins; then
		local plugin
		for plugin in "${AJENTI_PLUGINS[@]}"; do
			if [[ -d "plugins/${plugin}" ]]; then
				einfo "Compiling plugin: ajenti.plugin.${plugin}"
				cd "${S}/plugins/${plugin}" || die
				DISTUTILS_USE_PEP517=setuptools distutils-r1_python_compile
				cd "${S}" || die
			fi
		done
	fi
}

src_install() {
	# Step 1: Install core engine sub-packages
	einfo "Installing Ajenti Core components..."
	cd "${S}/ajenti-core" || die
	DISTUTILS_USE_PEP517=setuptools distutils-r1_src_install
	
	cd "${S}/ajenti-panel" || die
	DISTUTILS_USE_PEP517=setuptools distutils-r1_src_install
	cd "${S}" || die

	# Step 2: Install plugins
	if use plugins; then
		local plugin
		for plugin in "${AJENTI_PLUGINS[@]}"; do
			if [[ -d "plugins/${plugin}" ]]; then
				einfo "Installing plugin: ajenti.plugin.${plugin}"
				cd "${S}/plugins/${plugin}" || die
				DISTUTILS_USE_PEP517=setuptools distutils-r1_src_install
				cd "${S}" || die
			fi
		done
	fi

	# Install OpenRC init configurations
	newinitd "${FILESDIR}/ajenti.initd" ajenti
	newconfd "${FILESDIR}/ajenti.confd" ajenti

	# Install Systemd service file
	systemd_dounit "${FILESDIR}/ajenti.service"

	# Install configuration templates into protected /etc/ajenti location
	insinto /etc/ajenti
	newins "${FILESDIR}/config.yml" config.yml
	newins "${FILESDIR}/users.yml" users.yml

	# Enforce persistent working directories
	keepdir /etc/ajenti
	keepdir /var/log/ajenti
}

pkg_postinst() {
	if [[ ! -f "${ROOT}/etc/ajenti/ajenti.pem" ]]; then
		elog "Generating self-signed SSL Certificate for secure browser access..."
		
		local my_py
		my_py=$(eselect python show)
		
		if ${ROOT}/usr/bin/${my_py} -c "import ajenti" &>/dev/null; then
			${ROOT}/usr/bin/${my_py} -m ajenti.scripts.ssl_gen "$(hostname)" &>/dev/null
			if [[ -f "${ROOT}/etc/ajenti/ajenti.crt" && -f "${ROOT}/etc/ajenti/ajenti.key" ]]; then
				cat "${ROOT}/etc/ajenti/ajenti.crt" "${ROOT}/etc/ajenti/ajenti.key" > "${ROOT}/etc/ajenti/ajenti.pem"
				rm "${ROOT}/etc/ajenti/ajenti.crt" "${ROOT}/etc/ajenti/ajenti.key"
			fi
		else
			ewarn "Could not automatically generate SSL cert."
			ewarn "Please generate manually or run: openssl req -new -x509 -days 365 -nodes -out /etc/ajenti/ajenti.pem -keyout /etc/ajenti/ajenti.pem"
		fi
	fi

	elog "Configuration files successfully deployed to /etc/ajenti/ (protected by Portage)."
	elog "To run Ajenti via OpenRC: rc-update add ajenti default && rc-service ajenti start"
	elog "To run Ajenti via systemd: systemctl enable --now ajenti.service"
}

