# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 git-r3

DESCRIPTION="Linux kernel driver for ITE IT87xx and compatible Super I/O chips (including IT8613E)"
HOMEPAGE="https://github.com/frankcrawford/it87"
EGIT_REPO_URI="https://github.com/frankcrawford/it87.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"

src_compile() {
	local modlist=( it87=hwmon )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	# Install custom modprobe configuration for TerraMaster F4-424 Pro compatibility
	insinto /etc/modprobe.d
	newins "${FILESDIR}/it87.conf" it87.conf
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	elog "To properly initialize the IT8613E chip on the TerraMaster F4-424 Pro,"
	elog "ensure that /etc/modprobe.d/it87.conf forces the 0x8620 or native ID configuration."
	elog ""
	elog "CRITICAL FOR HARDENED KERNELS:"
	elog "You must append 'acpi_enforce_resources=lax' to your kernel boot parameters"
	elog "to resolve ACPI resource allocation conflicts with the system BIOS."
}
