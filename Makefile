COMMENT =		GNU troff typesetter
VERSION =		1.23.0
SUBST_VARS =		VERSION
DISTNAME =		groff-${VERSION}

CATEGORIES =		textproc
DPB_PROPERTIES =	parallel

HOMEPAGE =		https://www.gnu.org/software/groff/
MAINTAINER =		Ingo Schwarze <schwarze@openbsd.org>

# GPLv3+
PERMIT_PACKAGE =	Yes

WANTLIB =		c m ${COMPILER_LIBCXX}

# Groff does not use C++, but merely pre-1995 C with classes.
COMPILER =		base-clang base-gcc

SITES =			${SITE_GNU:=groff/}

MAKE_FLAGS +=		docdir=${PREFIX}/share/doc/groff \
			exampledir=${PREFIX}/share/examples/groff \
			ac_cv_path_mkdir=/bin/mkdir

MODULES =		perl
CONFIGURE_STYLE =	gnu

# In contrast to ghostscript itself, the ghostscript fonts have no
# dependency, and they are very useful for typesetting work with groff.
BUILD_DEPENDS =		print/ghostscript/gnu-fonts

# Our groff port needs to be lightweight because a few very basic
# ports still depend on it for building their manual pages.
# In particular, avoid dependencies on the following heavy ports:
CONFIGURE_ARGS +=	--without-libiconv-prefix	# converters/libiconv
CONFIGURE_ARGS +=	--without-gs			# print/ghostscript
CONFIGURE_ARGS +=	pnmcrop=missing \
			pnmcut=missing \
			pnmtopng=missing \
			pnmtops=missing \
			XPMTOPPM=missing		# graphics/netpbm
CONFIGURE_ARGS +=	PDFFONTS=missing \
			PDFIMAGES=missing \
			PDFINFO=missing			# print/poppler-utils
CONFIGURE_ARGS +=	psselect=missing		# print/psutils

# For similar reasons, avoid the dependency on X11 for now.
# It would only provide the gxditview(1) program,
# which isn't all that important.
CONFIGURE_ARGS +=	--without-x

# This one is not very useful on OpenBSD anyway:
CONFIGURE_ARGS +=	--without-uchardet		# textproc/uchardet

# Needed because groff would otherwise prefer gawk.
CONFIGURE_ARGS +=	--with-awk=awk

# Disable bogus tests in the gnulib fprintf-posix module.
# Groff has no reason whatsoever to require these particular GNU features,
# and we don't want our printf(3) implementation replaced by the monster
# from gnulib.  In particular, groff does not use %n, so it would be
# insane to use an implementation that lacks our %n protection.
CONFIGURE_ENV +=	gl_cv_func_printf_directive_a=yes \
			gl_cv_func_printf_directive_n=yes \
			gl_cv_func_printf_enomem=yes

# Disable dependencies of the gnulib fprintf-posix module.
# Even though we tell ./configure that our fprintf(3) shall be used,
# gnulib is too stupid to understand that implies the dependecies
# aren't needed either und would still compile in needless and
# potentially risky printf(3) code from gnulib.
CONFIGURE_ENV +=	ac_cv_func_vasnprintf=yes

# Even after the above CONFIGURE_ENV cleanup, gnulib compiles in
# several bogus files that groff does not need, merely because
# gnulib enables them by default.  Get rid of them.
MAKE_FLAGS +=		lib_libgnu_a_OBJECTS=

TEST_TARGET =		check

pre-configure:
	find ${WRKBUILD} -name \*.pl -type f -exec ${MODPERL_BIN_ADJ} {} +

.include <bsd.port.mk>
