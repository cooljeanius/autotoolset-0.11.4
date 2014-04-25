#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
# Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
# Copyright (C) 2001 Thierry MICHEL <thierry@nekhem.com>
# Copyright (C) 2003 Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>
#  
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
AC_INIT([GNU autotoolset],[0.11.4],
	[Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>],
	[autotoolset])
AC_CONFIG_SRCDIR([lib/alloca.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_LIBOBJ_DIR([lib])
AM_INIT_AUTOMAKE([dist-bzip2 dist-shar gnits])
AM_MAINTAINER_MODE

# Compiler stuff:
LF_CONFIGURE_CC
AM_PROG_AR
LF_CONFIGURE_CXX
AC_PROG_INSTALL
AM_PROG_LEX
AC_PROG_LN_S
AC_PROG_MKDIR_P
LF_PROG_NM
AC_PROG_RANLIB
AC_PROG_YACC
LF_PROG_F77_ALL_CHECKS
LF_SET_WARNINGS

# docs:
LF_USE_TEXIDOC

dnl# GNU help2man creates man pages from --help output; in many cases, this
dnl# is sufficient, and obviates the need to maintain man pages separately.
dnl# However, this means invoking executables, which we generally cannot do
dnl# when cross-compiling, so we test to avoid that (the variable
dnl# "cross_compiling" is set by AC_PROG_CC).
AS_IF([test "x${cross_compiling}" = "xno"],[
  AM_MISSING_PROG([HELP2MAN],[help2man])
],[
  HELP2MAN=:
])

# Shell related stuff:
LF_PROG_BASH
LF_PROG_TXTC

if test "x${PERL}" = "x"; then
  test -z "${PERL}"
  AC_PATH_PROGS([PERL],[perl perl5],[not found])
fi
if test "x${PERL}" = "xnot found" || test "x${PERL}" = "xnope"; then
 AC_MSG_ERROR([Cannot build without perl])
fi

AC_PATH_PROG([SHAR],[shar],[not found])
if test "x${SHAR}" = "xnot found"; then
 AC_MSG_ERROR([Cannot build without shar])
fi

AC_PATH_PROG([ZCAT],[zcat],[not found])
if test "x${ZCAT}" = "xnot found"; then
 AC_MSG_ERROR([Cannot build without zcat])
fi

m4_ifdef([AM_PATH_LISPDIR],[
  test -z "${lispdir}"
  AM_PATH_LISPDIR
],[m4_ifdef([LF_PATH_LISPDIR],[
    test -z "${lf_emacs_prefix}"
    LF_PATH_LISPDIR
  ])
])
AM_PATH_PYTHON

# C configuration stuff:
AC_FUNC_ALLOCA
AC_FUNC_MALLOC
AC_CHECK_FUNCS([exit strcat])
AC_CHECK_FUNCS_ONCE([strlen strcpy])
AC_CHECK_FUNCS([getopt_long],[],[
	AC_LIBOBJ([getopt])
	AC_LIBOBJ([getopt1])
])
AC_REPLACE_FUNCS([getopt])
AC_DEFUN([AC_REQUIRE_STDBOOL],[
  AC_REQUIRE([AC_HEADER_STDC])
  AC_REQUIRE([AC_HEADER_STDBOOL])
  AC_REQUIRE([AC_CHECK_HEADER_STDBOOL])
])
AC_REQUIRE_STDBOOL
AC_CHECK_HEADERS([getopt.h libintl.h long-options.h xalloca.h])
AC_HEADER_ASSERT

# X:
LF_PATH_XLIB

#
# Files to be generated:
#
if test ! -e misc/buildinstall.in; then
  ls misc/*
else
  stat misc/buildinstall.in
fi
AC_CONFIG_FILES([misc/buildinstall],[chmod u+x misc/buildinstall])

# These are tentative in their use:
LF_LINK_HEADERS
LF_SET_INCLUDES
# (the one with the expletive in its name is unsurprisingly broken)

AC_CONFIG_FILES([
	Makefile
	txtc.sh
	doc/Makefile 
	doc/gnits/Makefile 
	doc/manual/Makefile 
	doc/notes/Makefile 
	doc/texinfo/Makefile 
	doc/tutorial/Makefile 
	lib/Makefile 
	m4/Makefile 
	misc/Makefile
	misc/autotoolset.spec 
	misc/makerpm.sh 
	src/Makefile 
	src/version.sh 
	src/version.pl 
	src/acconfig/Makefile 
	src/acmkdir/Makefile 
	src/acmkdir/python/Makefile 
	src/emacs/Makefile 
	src/gpl/Makefile 
	src/mkconfig/Makefile 
	src/txtc/Makefile 
	])

#
# Output the files:
#
AC_OUTPUT
