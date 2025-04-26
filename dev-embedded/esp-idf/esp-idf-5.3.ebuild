# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="v${PV}"

DESCRIPTION="Espressif IoT Development Framework"
HOMEPAGE="https://github.com/espressif/esp-idf"
SRC_URI="https://dl.espressif.com/github_assets/espressif/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="esp32p4 esp32c61 esp32s2 esp32c5 esp32c2 esp32 esp32c6 esp32c3 esp32h2 esp32s3"

# Selected targets are: esp32p4, esp32c61, esp32s2, esp32c5, esp32c2, esp32, esp32c6, esp32c3, esp32h2, esp32s3
# 
# Installing collected packages: reedsolo, pyserial, pygdbmi, pyelftools, intelhex, bitarray, urllib3, tqdm, six, setuptools, pyyaml, pyparsing, pygments, pycparser, pyclang, packaging, msgpack, mdurl, idna, freertos_gdb, filelock, esp-idf-panic-decoder, esp-idf-kconfig, contextlib2, construct, colorama, click, charset-normalizer, certifi, bitstring, schema, requests, markdown-it-py, ecdsa, cffi, rich, requests-toolbelt, requests-file, cryptography, cachecontrol, esptool, esp-idf-size, esp-idf-nvs-partition-gen, idf-component-manager, esp-coredump, esp-idf-monitor

# Downloading https://github.com/espressif/binutils-gdb/releases/download/esp-gdb-v14.2_20240403/xtensa-esp-elf-gdb-14.2_20240403-x86_64-linux-gnu.tar.gz
# Extracting /home/pim/.espressif/dist/xtensa-esp-elf-gdb-14.2_20240403-x86_64-linux-gnu.tar.gz to /home/pim/.espressif/tools/xtensa-esp-elf-gdb/14.2_20240403

# Downloading https://github.com/espressif/binutils-gdb/releases/download/esp-gdb-v14.2_20240403/riscv32-esp-elf-gdb-14.2_20240403-x86_64-linux-gnu.tar.gz
# Extracting /home/pim/.espressif/dist/riscv32-esp-elf-gdb-14.2_20240403-x86_64-linux-gnu.tar.gz to /home/pim/.espressif/tools/riscv32-esp-elf-gdb/14.2_20240403

# Downloading https://github.com/espressif/crosstool-NG/releases/download/esp-13.2.0_20240530/xtensa-esp-elf-13.2.0_20240530-x86_64-linux-gnu.tar.xz
# Extracting /home/pim/.espressif/dist/xtensa-esp-elf-13.2.0_20240530-x86_64-linux-gnu.tar.xz to /home/pim/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240530

# Downloading https://github.com/espressif/crosstool-NG/releases/download/esp-13.2.0_20240530/riscv32-esp-elf-13.2.0_20240530-x86_64-linux-gnu.tar.xz
# Extracting /home/pim/.espressif/dist/riscv32-esp-elf-13.2.0_20240530-x86_64-linux-gnu.tar.xz to /home/pim/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20240530

# Downloading https://github.com/espressif/binutils-gdb/releases/download/esp32ulp-elf-2.38_20240113/esp32ulp-elf-2.38_20240113-linux-amd64.tar.gz
# Extracting /home/pim/.espressif/dist/esp32ulp-elf-2.38_20240113-linux-amd64.tar.gz to /home/pim/.espressif/tools/esp32ulp-elf/2.38_20240113

# Downloading https://github.com/espressif/openocd-esp32/releases/download/v0.12.0-esp32-20240318/openocd-esp32-linux-amd64-0.12.0-esp32-20240318.tar.gz
# Extracting /home/pim/.espressif/dist/openocd-esp32-linux-amd64-0.12.0-esp32-20240318.tar.gz to /home/pim/.espressif/tools/openocd-esp32/v0.12.0-esp32-20240318

# Downloading https://github.com/espressif/esp-rom-elfs/releases/download/20240305/esp-rom-elfs-20240305.tar.gz
# Extracting /home/pim/.espressif/dist/esp-rom-elfs-20240305.tar.gz to /home/pim/.espressif/tools/esp-rom-elfs/20240305

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	rm -r ${S}/.git

	mkdir -p ${ED}/opt/${PN}
	cp -R ${S}/* ${ED}/opt/${PN}
}
