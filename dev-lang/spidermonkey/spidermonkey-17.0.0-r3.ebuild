# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-17.0.0-r3.ebuild,v 1.1 2014/03/08 14:38:51 anarchy Exp $

EAPI="5"
WANT_AUTOCONF="2.1"
PYTHON_COMPAT=( python2_{6,7} )
PYTHON_REQ_USE="threads"
inherit eutils toolchain-funcs multilib python-any-r1 versionator pax-utils multilib-minimal

MY_PN="mozjs"
MY_P="${MY_PN}${PV}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/js/${MY_PN}${PV}.tar.gz"

LICENSE="NPL-1.1"
SLOT="17"
KEYWORDS="~alpha amd64 arm -hppa ~ia64 -mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="debug jit minimal static-libs test"

REQUIRED_USE="debug? ( jit )"
RESTRICT="ia64? ( test )"

S="${WORKDIR}/${MY_P}"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.9.4
	virtual/libffi
	>=sys-libs/zlib-1.1.4"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	virtual/pkgconfig"

pkg_setup(){
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		python-any-r1_pkg_setup
		export LC_ALL="C"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${SLOT}-js-config-shebang.patch
	epatch "${FILESDIR}"/${PN}-${SLOT}-ia64-mmap.patch
	epatch "${FILESDIR}"/${PN}-17.0.0-fix-file-permissions.patch
	epatch_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk" || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	cd "${S}-${ABI}/js/src" || die

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
	LD="$(tc-getLD)" \
	econf \
		${myopts} \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		--enable-system-ffi \
		--enable-jemalloc \
		$(use_enable debug) \
		$(use_enable jit tracejit) \
		$(use_enable jit methodjit) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

multilib_src_compile() {
	cd "${S}-${ABI}/js/src" || die
	if tc-is-cross-compiler; then
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			AR=$(tc-getBUILD_AR) RANLIB=$(tc-getBUILD_RANLIB) \
			jscpucfg host_jsoplengen host_jskwgen || die
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			AR=$(tc-getBUILD_AR) RANLIB=$(tc-getBUILD_RANLIB) \
			-C config nsinstall || die
		mv {,native-}jscpucfg || die
		mv {,native-}host_jskwgen || die
		mv {,native-}host_jsoplengen || die
		mv config/{,native-}nsinstall || die
		sed -e 's@./jscpucfg@./native-jscpucfg@' \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			-i Makefile || die
		sed -e 's@/nsinstall@/native-nsinstall@' -i config/config.mk || die
		rm -f config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o || die
	fi
	emake
}

multilib_src_test() {
	cd "${S}-${ABI}/js/src/jsapi-tests" || die
	emake check
}

multilib_check_headers() {
	einfo "Skipping headers check..."
}

multilib_src_install() {
	cd "${S}-${ABI}/js/src" || die
	emake DESTDIR="${D}" install

	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}/usr/bin/js${SLOT}"
		fi
	else
		rm -f "${ED}/usr/bin/js${SLOT}"
	fi

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi
}
