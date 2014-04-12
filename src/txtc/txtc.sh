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


# Usage:
# 1. To produce object files for a bunch of text files:
#      sh txtc.sh foo1.txt foo2.txt foo3.txt ...
# 2. To produce only C files for a bunch of text files:
#      sh txtc.sh -c foo1.txt foo2.txt foo3.txt ...
# 3. To produce pic object files object files
#      sh txtc.sh -l libtool foo1.txt foo2.txt foo3.txt ...

# ---------------------------------------------
# These definitions are imported from Autoconf
# ---------------------------------------------

CC="@CC@"
AWK="@AWK@"

# --------------------
# Initialize the data 
# --------------------

# File names
text_files=""
path_to_libtool=""

# Flags
only_the_c_files="no"


# ------------------------------------------
# Now parse the options and update the state
# ------------------------------------------

while test -n "$1"
do
  argument="$1"
  case $argument in
  -c)  only_the_c_files="yes"
       ;;
  -l)  shift
       path_to_libtool="$1"
       ;;
  *)   text_files="$text_files $1"
       ;;
  esac
  shift
done

# ---------------------------------
# Now look over all the text files
# ---------------------------------

for file in $text_files
do
  # Get the filenames for C, object and pic object files
  c_file="`echo $file  | sed 's/\.[a-zA-Z]*$/.c/g'  | $AWK -F/ '{ print $NF }'`"
  o_file="`echo $file  | sed 's/\.[a-zA-Z]*$/.o/g'  | $AWK -F/ '{ print $NF }'`"
  lo_file="`echo $file | sed 's/\.[a-zA-Z]*$/.lo/g' | $AWK -F/ '{ print $NF }'`"

  # Get the symbol name for the file and the length
  symbol_name="`echo $file | sed 's/\./_/g' | $AWK -F/ '{ print $NF }'`"
  file_length="`cat $file | wc -l`"

  # Create the C file
  # First apply the following substitutions with sed
  # 1. Escape the escapes
  # 2. Escape the quotes
  # 3. Nuke whitespace after the last character
  # Then pipe through awk to make the C program
  # FIXME: perhaps another substitution needed for tabs?
  rm -f $c_file
  cat $file | sed 's/\\/\\\\/g
                   s/\"/\\\"/g
                   s/[[:blank:]]*$//g' | 
              $AWK -v symbol_name="$symbol_name" -v file_length="$file_length" \
                   -v filename="$file"  '
     BEGIN { print "#define NULL (char *) 0"
             print "int " symbol_name "_length = " file_length ";"
             print "char *" symbol_name "[] = { " 
             print "  \"" filename "\"," }

           { print "  \"" $0 "\"," }

     END   { print "  NULL }; " }
  ' > $c_file

  # If we also want to build an object file, do so here 
  # FIXME: At the moment I am not supporting shared libraries
  # Will do so once I get a stable version.
  if test "$only_the_c_files" = "no"
  then
    $CC $CFLAGS -c $c_file
    rm -f $c_file
  fi
done