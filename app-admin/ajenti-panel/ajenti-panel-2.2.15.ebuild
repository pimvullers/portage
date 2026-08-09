# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 python3_12 python3_13 python3_14 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi systemd

DESCRIPTION="A modular, extensible web-based server administration panel"
HOMEPAGE="https://ajenti.org"

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

# List of internal plugins to build if USE=plugins is set
AJENTI_PLUGINS=(
	core dashboard settings plugins notepad
	terminal filemanager packages services
)

python_compile() {
	distutils-r1_python_compile

	# Build plugins if USE flag is active
	if use plugins; then
		local plugin
		for plugin in "${AJENTI_PLUGINS[@]}"; do
			if [[ -d "plugins/${plugin}" ]]; then
				einfo "Compiling plugin: ajenti.plugin.${plugin}"
				cd "plugins/${plugin}" || die
				distutils-r1_python_compile
				cd "${S}" || die
			fi
		done
	fi
}

src_install() {
	distutils-r1_src_install

	# Install plugins if USE flag is active
	if use plugins; then
		local plugin
		for plugin in "${AJENTI_PLUGINS[@]}"; do
			if [[ -d "plugins/${plugin}" ]]; then
				einfo "Installing plugin: ajenti.plugin.${plugin}"
				cd "plugins/${plugin}" || die
				distutils-r1_src_install
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
	# Check if certificate exists; generate matching default if missing
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

