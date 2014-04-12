dnl Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
dnl  
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl  
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl  
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
dnl  
dnl  
dnl As a special exception to the GNU General Public License, if you
dnl distribute this file as part of a program that contains a configuration
dnl script generated by Autoconf, you may include it under the same
dnl distribution terms that you use for the rest of that program.
dnl  

AC_DEFUN([LF_PROG_BASH],[
  dnl Look for bash
  AC_PATH_PROGS(BASH, bash sh, no)
  if test "$BASH" = "no"
  then
    AC_MSG_ERROR([can not find a shell! How are you running this script?])
  fi
  dnl Make sure it is bash
  AC_MSG_CHECKING([whether $BASH is GNU bash])
  bash_output=`$BASH -version -c exit | grep GNU`
  if test -n "$bash_output"
  then
    AC_MSG_RESULT(yes)
  else
    AC_MSG_RESULT(no)
    AC_MSG_WARN([you need the GNU bash to build this package correctly!!])
  fi
  AC_SUBST(BASH)
])
