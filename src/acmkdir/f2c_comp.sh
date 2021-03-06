# Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
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
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you 
# distribute this file as part of a program that contains a configuration 
# script generated by Autoconf, you may include it under the same 
# distribution terms that you use for the rest of that program.

# ---------------------------------------------
# These definitions are imported from Autoconf
# ---------------------------------------------

CC="@CC@"
CFLAGS="@CFLAGS@"
F2C="@F2C@"
F2CFLAGS="@F2CFLAGS@"
FLIBS="@FLIBS@"

# ---------------------
# Initialize the state
# ---------------------

# A list of fortran files that we are responsible for compiling into object
# files, and corresponding lists of the intermediate c and object files
fortran_files=""
c_files=""
object_files=""

# Default modes
translate_mode="yes"
compile_mode="yes"
link_mode="yes"

# Executable filename
executable_filename="a.out"

# Optimization options
desired_optimization=""

# Library flags
library_path_flags=""
library_link_flags=""

# Pass -g flag
pass_g_flag_to_compiler="no"

# -------------------------------------------
# Now parse the options and update the state
# -------------------------------------------

while test -n "$1"
do
  argument="$1"
  case $argument in
  -t)   compile_mode="no"
        link_mode="no"
        ;;
  -c)   link_mode="no"
        ;;
  -o)   link_mode="yes"
        shift
        executable_filename="$1"
        ;;
  -g)   pass_g_flag_to_compiler="yes"
        ;;
  -O)   desired_optimization="-O"
        ;;
  -O2)  desired_optimization="-O2"
        ;;
  -O3)  desired_optimization="-O3"
        ;;
  -l)   library_link_flags="$1 $library_link_flags"
        ;;
  -L)   library_path_flags="$1 $library_path_flags"
        ;;
  -I)   
        ;;
  *.o)  object_files="$object_files $1"
        ;;
  *.f)  fortran_files="$fortran_files $1"
        ;;
  esac
  shift
done

# ---------------------------------------
# Create list of C files and object files
# ---------------------------------------

# The sed command replaces the .f suffix with corresponding .o or .c
# The awk command emulates 'basename' in that it strips the path from
# the filename, leaving the filename by itself.
for file in $fortran_files
do
  obj_file="`echo $file | sed 's/\.f$/\.o/g' | awk -F/ '{ print $NF }'`"
  c_file="`echo $file   | sed 's/\.f$/\.c/g' | awk -F/ '{ print $NF }'`"
  object_files="$object_files $obj_file"
  c_files="$c_files $c_file"
done

# ----------------------------------------------------
# Now invoke f2c, gcc and the linker as is appropriate
# ----------------------------------------------------

# First invoke the translator
for file in $fortran_files
do
  $F2C $F2CFLAGS $file 2>&1 1>&/dev/null
done

# If we are in compile mode then compile
if test x$compile_mode = xyes
then
  if test x$pass_g_flag_to_compiler = xyes
  then
    CFLAGS="$CFLAGS -g"
  fi
  for file in $c_files
  do
    $CC $CFLAGS -c $desired_optimization $file
    rm -f $file
  done
fi

# If we are in link mode then link
if test x$link_mode = xyes
then
  $CC $CFLAGS -o $executable_filename $object_files $library_path_flags $library_link_flags
fi
