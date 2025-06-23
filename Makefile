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
CONFIGURE_ARGS +=	--with-awk=awk --without-gs \
			--without-libiconv-prefix --without-uchardet \
			--without-urw-fonts-dir --without-x \
			pnmcrop=missing pnmcut=missing pnmtopng=missing \
			pnmtops=missing psselect=missing
CONFIGURE_ENV +=	ac_cv_prog_PDFFONTS= \
			ac_cv_prog_PDFIMAGES= \
			ac_cv_prog_PDFINFO= \
			ac_cv_prog_XPMTOPPM=

# Disable bogus tests in the gnulib fprintf-posix module.
# Groff has no reason whatsoever to require these particular GNU features,
# and we don't want our printf(3) implementation replaced by the monster
# from gnulib.  In particular, groff does not use %n, so it would be
# insane to use an implementation that lacks our %n protection.
CONFIGURE_ENV +=	gl_cv_func_printf_directive_a=yes \
			gl_cv_func_printf_directive_n=yes \
			gl_cv_func_printf_enomem=yes

TEST_TARGET =		check

pre-configure:
	find ${WRKBUILD} -name \*.pl -type f -exec ${MODPERL_BIN_ADJ} {} +

.include <bsd.port.mk>
