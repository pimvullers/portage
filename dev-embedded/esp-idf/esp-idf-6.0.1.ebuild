# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit python-any-r1

MY_PV="v${PV}"

DESCRIPTION="Espressif IoT Development Framework"
HOMEPAGE="https://github.com/espressif/esp-idf"
SRC_URI="https://dl.espressif.com/github_assets/espressif/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.zip https://dl.espressif.com/dl/esp-idf/espidf.constraints.v6.0.txt"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="python riscv32 xtensa"
RESTRICT="strip"

BDEPEND="
	app-arch/unzip"
RDEPEND="
	${PYTHON_DEPS}
	xtensa? (
		sys-devel/binutils-esp32ulp-elf-bin
		sys-devel/gcc-xtensa-esp-elf-bin
		dev-debug/gdb-xtensa-esp-elf-bin
	)
	riscv32? (
		sys-devel/gcc-riscv32-esp-elf-bin
		dev-debug/gdb-riscv32-esp-elf-bin
	)
	dev-embedded/openocd-esp32
	dev-embedded/esp-rom-elfs
	dev-embedded/esptool
	python? (
		dev-python/setuptools
		dev-python/packaging
		dev-python/click
		dev-python/pyserial
		dev-python/cryptography
		dev-python/pyparsing
		dev-python/pyelftools
		dev-python/construct
		dev-python/rich
		dev-python/psutil
		dev-python/tree-sitter
		dev-libs/tree-sitter-c
	)
"
#idf-component-manager>=2.2
#esp-coredump
#esp-idf-kconfig
#esp-idf-monitor
#esp-idf-nvs-partition-gen
#esp-idf-size
#esp-idf-diag
#esp-idf-panic-decoder
#pyclang
#freertos_gdb

DEST="/opt/${PN}"
PYTHON_ENV="${DEST}/python_env"
VENV_PIP="${PYTHON_ENV}/bin/pip"

src_install() {
	rm -r "${S}/.git"

	dodir ${DEST}
	cp -R "${S}"/* "${ED}${DEST}"

	cat > "${T}/env" << EOF
IDF_PYTHON_ENV_PATH=${PYTHON_ENV}
EOF
	newenvd "${T}/env" 99esp-idf
}

pkg_postinst() {
	use python || return

	local OPTIONS="--cache-dir ${PYTHON_ENV}/.pip_cache --quiet"
	local CONSTRAINTS="-c ${DISTDIR}/espidf.constraints.v6.0.txt"
	local REQUIREMENTS="-r ${DEST}/tools/requirements/requirements.core.txt"

	einfo Creating a new Python environment in ${PYTHON_ENV}
	${PYTHON} -m venv ${PYTHON_ENV}
	einfo Upgrading pip...
	${VENV_PIP} install ${OPTIONS} --upgrade pip ${CONSTRAINTS}
	einfo Upgrading setuptools...
	${VENV_PIP} install ${OPTIONS} --upgrade setuptools ${CONSTRAINTS}
	einfo Installing python packages...
	${VENV_PIP} install ${OPTIONS} --upgrade ${REQUIREMENTS} ${CONSTRAINTS}
}
