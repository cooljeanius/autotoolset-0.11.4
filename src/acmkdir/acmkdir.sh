# Copyright (C) 1998  Eleftherios Gkioulekas <lf@amath.washington.edu>
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

# =============================
# == Usage related functions ==
# =============================

function usage
{
 cat << EOF
Creates directory tree for new software package.
Usage: acmkdir [OPTIONS] <directoryname>

* Commandline flags:
   --help           This message
   --version        Version information
   -t, --type=TYPE  Make top-level directory of type TYPE
   -latex           Make a latex subdirectory

* Types of toplevel directories supported (-t --type)
   default     -> Language C++, uses the LF macros
   traditional -> Language C, uses traditional autoconf macros
   fortran     -> Language C++ with Fortran
   python      -> Language Python, uses traditional autoconf macros
   zope        -> Zope product, uses traditional autoconf macros
   pythondist  -> Language Python, uses python-distutils
   f77         -> not implemented yet
   f90         -> not implemented yet

Bug reports: lf@amath.washington.edu
For Python/Zope features: thierry@nekhem.com
EOF
 exit
}

function version
{
 cat << EOF
automkdir $VERSION - Generate directory tree for new software package
Copyright (C) 1997 Eleftherios Gkioulekas <lf@amath.washington.edu>
Copyright (C) 2001 Thierry MICHEL <thierry@nekhem.com>
This is free software, and you are welcome to redistribute it and modify it 
under certain conditions. There is ABSOLUTELY NO WARRANTY for this software.
For legal details see the GNU General Public License.
EOF
 exit
}

function invalid_usage
{
 cat <<EOF
Invalid usage. Mode $mode does not exist !!!
For usage information type:

    % acmkdir --help

EOF
 exit
}

# =========================================
# == Make the standard information files ==
# =========================================

# ---------------------------------------------------
# This function creates a template NEWS file in the 
# present working directory.
# ---------------------------------------------------

function make_NEWS
{
 cat >> NEWS <<EOF
${package_name} -- History of visible changes.

Copyright (C) $this_year, $your_name <${email_address}>
See the end for copying conditions.

Please send ${package_name} bug reports to ${email_address}.

Version 0.1

* List your features here

-------------------------------------------------------
Copying information:

Copyright (C) $this_year, $your_name <${email_address}>

   Permission is granted to anyone to make or distribute verbatim copies
   of this document as received, in any medium, provided that the
   copyright notice and this permission notice are preserved,
   thus giving the recipient permission to redistribute in turn.

   Permission is granted to distribute modified versions
   of this document, or of portions of it,
   under the above conditions, provided also that they
   carry prominent notices stating who last changed them.

EOF
}

# ----------------------------------------------------
# This function creates a template README file in the
# present working directory
# ----------------------------------------------------

function make_README
{
 cat >> README.in <<EOF
Welcome to ${package_name}.

${package_name} is free software. Please see the file COPYING for details.
For documentation, please see the files in the doc subdirectory.
For building and installation instructions please see the INSTALL file.
EOF
}

# -------------------------------------------------------
# This function creates a template AUTHORS file in the
# present working directory
# -------------------------------------------------------

function make_AUTHORS
{
 cat >> AUTHORS <<EOF
Authors of ${package_name}.
See also the files THANKS and ChangeLog.

${your_name} designed and implemented ${package_name}.
EOF
}

# --------------------------------------------------------
# This function creates the template THANKS file in the
# present working directory
# --------------------------------------------------------

function make_THANKS
{
 cat >> THANKS <<EOF
${package_name} THANKS file

${package_name} has originally been written by ${your_name}.
Many people have further contributed to FOO by reporting problems, 
suggesting various improvements, or submitting actual code. Here is
a list of these people. Help me keep it complete and exempt of errors.
EOF
}


# ---------------------------------------------------------
# This function creates an setup.py file in the
# present working directory from a source file
# ---------------------------------------------------------

function make_setup_python
{
    cat $PREFIX/share/autotools/python/setup.py | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > src/setup.py

}

# ---------------------------------------------------------
# This function creates an config setup file file in the
# present working directory called setup.cfg
# ---------------------------------------------------------

function make_setup_cfg
{
    cp $PREFIX/share/autotools/python/setup.cfg  src/setup.cfg
}

# ---------------------------------------------------------
# This function creates an MANIFEST.in file in the
# present working directory, used by setup.py file
# ---------------------------------------------------------

function make_manifest
{
    cp $PREFIX/share/autotools/python/MANIFEST.in  src/MANIFEST.in
}

# ---------------------------------------------------------
# This function creates an install_data.py file in the
# present working directory, used by setup.py file
# ---------------------------------------------------------

function make_install_data
{
    cp $PREFIX/share/autotools/python/install_data.py  src/setupext/install_data.py
}

# ---------------------------------------------------------
# This function creates an __init__.py file in the
# present working directory, for distutils !
# ---------------------------------------------------------

function make_init
{
    cat $PREFIX/share/autotools/python/__init__.py  >> src/setupext/
}

# ---------------------------------------------------------
# This function creates an __init__.py file in the
# present working directory, for zope products !
# ---------------------------------------------------------

function make_zope_init
{
    cat $PREFIX/share/autotools/python/__init__.py.zope | sed "s/package\_name/${package_name}/g"  >> src/__init__.py
}

# ---------------------------------------------------------
# This function creates an configure.ac file in the
# present working directory, for zope products !
# ---------------------------------------------------------

function make_zope_configure
{
    cat $PREFIX/share/autotools/python/configure.ac.zope | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > configure.ac
}

# ---------------------------------------------------------
# This function creates an Makefile.am file in the
# present working directory, for zope products !
# ---------------------------------------------------------

function make_zope_makefiles
{
    cat $PREFIX/share/autotools/python/src.Makefile.am.zope | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > src/Makefile.am
    cat $PREFIX/share/autotools/python/src.www.Makefile.am.zope | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > src/www/Makefile.am
    cat $PREFIX/share/autotools/python/src.dtml.Makefile.am.zope | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > src/dtml/Makefile.am
    cat $PREFIX/share/autotools/python/src.interfaces.Makefile.am.zope | sed "s/your\_name/${your_name}/g" | sed "s/email\_address/${email_address}/g" | sed "s/package\_name/${package_name}/g" | sed "s/year/${this_year}/g" > src/interfaces/Makefile.am
}



# ---------------------------------------------------------
# This function creates an alternative INSTALL file in the
# present working directory for python-dist/zope-dist
# ---------------------------------------------------------

function make_INSTALL_python_zope
{
 rm -f INSTALL
 ln -s $PREFIX/share/autotools/python/new_install_python.txt INSTALL
}



# ---------------------------------------------------------
# This function creates an alternative INSTALL file in the
# present working directory
# ---------------------------------------------------------

function make_INSTALL_nonstandard
{
 rm -f INSTALL
 ln -s $PREFIX/share/autotools/new_install.txt INSTALL
}



# ---------------------------------------------------------------
# This function creates a Makefile for an m4 subdirectory
# and provides also a copy of mkm4.pl in case the user wants it
# FIXME: Do I want a better way of dealing with this?
# ---------------------------------------------------------------

function make_m4_makefile
{
 cat >> m4/Makefile.am <<EOF
# Install m4 macros in this directory
m4datadir = \$(datadir)/aclocal

# List your m4 macros here
m4macros = 

# The following is boilerplate
m4data_DATA = \$(m4macros) 
EXTRA_DIST = \$(m4data_DATA) 

EOF
}

# ==============================================
# == Routines for making mode dependent filei ==
# ==============================================

# --------------------------------------------------------------------
# These functions make the default configure.ac and Makefile.am files
# The default configure.ac file assumes that you are programming
# only in C++ and uses the LF macros instead of the standard
# Autoconf macros for configuring the compiler.
# It also includes a call to LF_CPP_PORTABILITY
# --------------------------------------------------------------------

function make_toplevel_configure_default
{
 cat >> configure.ac <<EOF
AC_INIT([${package_name}],
        [0.0.1],
        [${your_name} ${email_address}],
        [${package_name}])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

LF_CONFIGURE_CC
LF_CONFIGURE_CXX
LF_HOST_TYPE
LF_SET_WARNINGS
AC_PROG_RANLIB

AC_CONFIG_FILES([
   Makefile
   README
   doc/Makefile
   m4/Makefile
   src/Makefile
])

AC_OUTPUT
EOF
}

function make_toplevel_makefile_default
{
 cat >> Makefile.am <<EOF
EXTRA_DIST = reconf configure
SUBDIRS = m4 src doc
EOF
}

function make_reconf_default
{
 cat >> reconf <<EOF
#!/bin/sh
rm -f config.cache
echo "- aclocal."
aclocal -I m4
echo "- autoconf."
autoconf
echo "- autoheader."
autoheader
echo "- automake."
automake -a
exit
EOF
 chmod u+x reconf
}

function make_local_default
{
 return
}

# --------------------------------------------------------------------
# These functions make the traditional configure.ac and Makefile.am
# files. This is for people who want to follow the GNU coding
# standards a lot more closer than I do. It assumes that you are
# using C only and does not use any LF macros
# --------------------------------------------------------------------

function make_toplevel_configure_traditional
{
 cat >> configure.ac <<EOF
AC_INIT([${package_name}],
        [0.0.1],
        [${your_name} ${email_address}],
        [${package_name}}])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

AC_PROG_CC
AC_PROG_INSTALL
AC_AIX
AC_ISC_POSIX
AC_MINIX
AC_STDC_HEADERS
AC_PROG_RANLIB

AC_CONFIG_FILES([
   Makefile
   README
   doc/Makefile
   m4/Makefile
   src/Makefile
])

AC_OUTPUT
EOF
}

function make_toplevel_makefile_traditional
{
 make_toplevel_makefile_default
}

function make_reconf_traditional
{
 cat >> reconf <<EOF
#!/bin/sh
rm -f config.cache
echo "- aclocal."
aclocal -I m4
echo "- autoconf."
autoconf
echo "- autoheader."
autoheader
echo "- automake."
automake -a
exit
EOF
 chmod u+x reconf
}

function make_local_traditional
{
    DO_NOTHING=""
}

# ---------------------------------------------------------------------
# These functions make configure.ac and Makefile.am files appropriate
# for packages that use mixed C++ and Fortran.
# ---------------------------------------------------------------------

function make_toplevel_configure_fortran
{
 cat >> configure.ac <<EOF
AC_INIT([${package_name}],
        [0.0.1],
        [${your_name} ${email_address}],
        [${package_name}])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

LF_CONFIGURE_CC
LF_CONFIGURE_CXX
AC_PROG_RANLIB
LF_HOST_TYPE
LF_PROG_F77_PREFER_F2C_COMPATIBILITY
dnl LF_PROG_F77_PREFER_NATIVE_VERSION
LF_PROG_F77
LF_SET_WARNINGS

AC_CONFIG_SUBDIRS([
  fortran/f2c
  fortran/libf2c
])

AC_CONFIG_FILES([
   Makefile
   README 
   fortran/Makefile
   f2c_comp
   doc/Makefile
   m4/Makefile
   src/Makefile
])

AC_OUTPUT
EOF
}

function make_toplevel_makefile_fortran
{
 cat >> Makefile.am <<EOF
EXTRA_DIST = reconf configure
SUBDIRS = fortran m4 src
EOF
}

function make_reconf_fortran
{
 make_reconf_default
}

function make_local_fortran
{
 echo "+ Installing f2c."
 mkfortran > /dev/null
 cp $PREFIX/share/autotools/f2c_comp.sh f2c_comp.in
}

# --------------------------------------------------------------------
# These functions make the python configure.ac and Makefile.am
# files. 
# --------------------------------------------------------------------

function make_toplevel_makefile_python
{
 cat >> Makefile.am <<EOF
SUBDIRS = m4 src
EXTRA_DIST = configure Makefile.in README INSTALL AUTHORS COPYING

CLEANFILES = *~ *.swp
DISTCLEANFILES = Makefile.in

EOF
}

function make_toplevel_makefile_zope
{
    make_toplevel_makefile_python
    make_zope_makefiles
}

function make_toplevel_configure_python
{
 cat >> configure.ac <<EOF
AC_INIT([${package_name}],
        [0.0.1],
        [${your_name} ${email_address}],
        [${package_name}])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

AC_CONFIG_FILES([
   Makefile
   README
   doc/Makefile
   src/Makefile
])

AC_OUTPUT
EOF
}

function make_toplevel_configure_zope
{
    make_zope_configure
}

function make_reconf_python
{
    make_reconf_default
}

function make_reconf_pythondist
{
    make_reconf_python
}

function make_reconf_zope
{
    make_reconf_python
}

function make_reconf_zopedist
{
    make_reconf_python
}

function make_local_python
{
    make_local_default
}

function make_local_zope
{
    make_local_default
}



# ============================================================
# == These are the highlevel functions for creating various ==
# == types of directories                                   ==
# ============================================================

# -------------------------------------------------------
# This function creates the toplevel package directory.
# FIXME: Add more documentation here
# -------------------------------------------------------

function create_toplevel_directory 
{
 # Greet the user
 echo "Ready to create a new distribution skeleton directory."
 echo "The current working directory is: "
 echo " --> `pwd`"
 echo "If you make a mistake and need to abort, press ctrl-C."
 echo " "

 # Get the parameters
 echo -n "Name of distribution: "
 read package_name
 echo -n "Your full name:       "
 read your_name
 echo -n "Your email address:   "
 read email_address

 # Check whether to go ahead.
 echo " "
 echo -n "Do you want to proceed? (y/n) "
 local yesno
 read yesno
 if test "$yesno" != "y"
 then
   echo "The force is with you young Skywalker,"
   echo "but you are not a Jedi yet."
   exit
 fi

 # Get the today's year
 this_year=`date +%Y`

 # Make the directories
 echo "+ Mode is ${mode}"
 echo "+ Making directory ${dirname}"
 mkdir ${dirname}
 cd ${dirname}
    
 echo "+ Making src directory"
 mkdir src
 echo "+ Making doc directory"
 mkdir doc
 echo "+ Making m4 directory"
 mkdir m4
 echo "+ Making config directory"
 mkdir config

 if test $mode = pythondist || test $mode = zopedist
 then
    echo "+ Making src/setupext directory"
    cd src
    mkdir setupext
    cd ..
 fi

 if test $mode != pythondist && test $mode != zopedist \
    && test $mode != zope
 then
    gpl -am Makefile.am
    gpl -am doc/Makefile.am
    gpl -am src/Makefile.am
    gpl -am m4/Makefile.am
    gpl -shS configure.ac
    gpl -shS reconf
    chmod u+x reconf
 fi

 # Create templates for the standard information files

 touch NEWS README README.in AUTHORS THANKS ChangeLog

 echo "+ Making default text files"
 make_NEWS
 make_README
 make_AUTHORS
 make_THANKS

 if test $mode != pythondist && test $mode != zopedist \
    && test $mode != python && test $mode != zope
 then
    echo "+ Making INSTALL file link"
    make_INSTALL_nonstandard
 else
    echo "+ Making INSTALL file link"
    make_INSTALL_python_zope
 fi

 make_m4_makefile

 # Install python files used by python-distutils
 if test $mode = zopedist || test $mode = zope
 then
    echo "+ Creating dtml and www directories (ZOPE)"
    mkdir src/dtml
    mkdir src/www
    echo "+ Creating interfaces directory (ZOPE)"
    mkdir src/interfaces
 fi
 

 if test $mode = pythondist || test $mode = zopedist
 then
    echo "+ Copying Setup.py python file"
    make_setup_python
    echo "+ Copying Setup.cfg python file"
    make_setup_cfg
    echo "+ Copying MANIFEST.in python file"
    make_manifest
    echo "+ Copying __init__.py python file (distutils)"
    gpl -sh src/setupext/__init__.py
    make_init
    echo "+ Copying install_data.py python file"
    make_install_data
 fi

 if test $mode = zope
 then
    echo "+ Making __init__.py python file for ZOPE"
    gpl -sh src/__init__.py
    make_zope_init 
 fi

 # Invoke the mode-dependent functions to create the toplevel
 # configure.ac and Makefile.am and the reconf script
 make_toplevel_configure_${mode}
 make_toplevel_makefile_${mode}
 make_reconf_${mode}
 make_local_${mode}

 # Run the reconf script
 echo "+ Running reconf"
 sh ./reconf 

 # Important message
 cat <<EOF 

Distribution directory is ready.
Please make sure to keep the files AUTHORS, NEWS, README, THANKS up to
date before cutting a distribution.
EOF
}

# ----------------------------------------------------------------
# This function creates a subdirectory for writing texinfo 
# documentation that is preproccessed with texidoc. It uses the 
# doc_makefile.am file as standard makefile.
# $dirname contains the name of the directory to create
# ----------------------------------------------------------------

function create_doc_directory_suck
{
 echo "+ Making directory ${dirname}"
 mkdir ${dirname}
 cd ${dirname}
 cp $PREFIX/share/autotools/doc_makefile.am Makefile.am
 cp `which texi2html` texi2html.pl
 cp `which texidoc`   texidoc.pl
 cp `which texirm`    texirm.sh
 cat <<EOF

Documentation subdirectory is ready.
Please make sure to add a reference to it, to the appropriate Makefile.am
and to add an entry for it in configure.ac.
You will also need to customize the template Makefile.am in this directory.
EOF
}

function create_doc_directory
{
 echo "This feature is obsolete and will be more thoroughly removed"
 echo "in the forthcoming versions of Autotools."
 exit
}

# ------------------------------------------------------------------
# This function creates a subdirectory for writing latex based 
# documentation. It uses latex_makefile.am as the standard
# makefile. $dirname contains the name of the directory to create
# ------------------------------------------------------------------

function create_latex_directory
{
 echo "+ Making directory ${dirname}"
 mkdir ${dirname}
 cd ${dirname}
 cp $PREFIX/share/autotools/latex_makefile.am Makefile.am
 cp $PREFIX/share/autotools/bookdoc.sty bookdoc.sty
 cp $PREFIX/share/autotools/pagestyle.sty pagestyle.sty
 cat <<EOF

Documentation subdirectory is ready.
Please make sure to add a reference to it, to the Makefile.am in the upper
level directory and to add an entry for it in configure.ac.
You will also need to customize the template Makefile.am in this directory
and of course add your content :)
EOF
 exit
}

############################################################################
############################################################################

# 
# Parse the command-line arguments
#

# Force some command-line arguments to be passed
if test $# -eq 0
then
  invalid_usage
fi

# Check for --help and --version
if test $1 = --help
then
  usage
fi
if test $1 = --version
then
  version
fi

# FIXME:
# Check for -m4 , -texi , -latex here
# and take different action

if test $1 = -m4
then
  shift
  dirname=$1
  create_m4_directory
  exit
fi

if test $1 = -doc
then
  shift
  dirname=$1
  create_doc_directory
  exit
fi

if test $1 = -latex
then
  shift
  dirname=$1
  create_latex_directory
  exit
fi

# Set the mode
mode="default"
if test $1 = -t || test $1 = --type
then
  shift
  mode=$1
  shift
fi

# Check against allowed modes
allowed_modes="default traditional python zope fortran "
mode_is_ok=0
for i in ${allowed_modes}
do
  if test $i = $mode
  then
    mode_is_ok=1; break
  fi
done

if test $mode_is_ok = 0
then
  invalid_usage
fi

# Go ahead and create the toplevel directory
dirname=$1
if test -z $dirname
then
  invalid_usage
fi
create_toplevel_directory
exit
