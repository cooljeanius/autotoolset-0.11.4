# The following script makes it easy for you to GPL your programs
#
# Copyright (C) 1996  Eleftherios Gkioulekas <lf@amath.washington.edu>
# Copyright (C) 2001 Thierry MICHEL <thierry@nekhem.com>
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
Usage: gpl [OPTION] [FILENAME]

 -c       file.c      Make notice for a C file
 -cc      file.cc     Make notice for a C++ file
 -python  file.py     Make notice for a Python file
 -sh      file.sh     Make notice for a shell file (sh, perl, etc)
 -cS      file.c      Make special notice for a C file (exception to GPL)
 -ccS     file.cc     Make special notice for a C++ file
 -pyS     file.py     Make special notice for a Python file
 -shS     file.sh     Make special notice for a shell file
 -cL  LIB file.c      Make Guile-like notice for a C file 
 -ccL LIB file.cc     Make Guile-like notice for a C++ file
 -pyL LIB file.py     Make Guile-like notice for a Python file
 -shL LIB file.sh     Make Guile-like notice for a shell file 
 -m4      file.m4     Make notice for an m4 file (autoconf macros)
 -am      file.am     Make notice for Makefile.am
 -l       COPYING     Create a copy of the GNU GPL
 -lt      gpl.texi    Create a copy of the GNU GPL in texinfo format
 -bs      bob         Get Bob in your life

The -cL, -ccL, -pyL, -shL options require that you name the library that your
files are forming. The name of the library (LIB) is required to be included in
the copyright notice. Please name the library in all-caps.

Bug reports to: lf@amath.washington.edu & thierry@nekhem.com
EOF
}

function version
{
 cat << EOF
gpl $VERSION - The GNU copyright notice generator
Copyright (C) 1997 Eleftherios Gkioulekas <lf@amath.washington.edu>
Copyright (C) 2001 Thierry Michel <thierry@nekhem.com>
This is free software, and you are welcome to redistribute it and modify it 
under certain conditions. There is ABSOLUTELY NO WARRANTY for this software.
For legal details use the --license flag.
EOF
}

# =========================================
# == Configure the copyright information ==
# =========================================

function configure
{
 if test -r ${HOME}/.GPL
 then
   author_name="$(cat ${HOME}/.GPL | head -1 | tail -1)"
   email_address="$(cat ${HOME}/.GPL | head -2 | tail -1)"
   todays_year="$(cat ${HOME}/.GPL | head -3 | tail -1)"
 else
   echo "The following information is required for your copyright notices."
   echo -n "Your name is:          "
   read author_name
   echo -n "Your email address is: "
   read email_address
   echo -n "Today's year is:       "
   read todays_year
   echo ${author_name} > ${HOME}/.GPL
   echo ${email_address} >> ${HOME}/.GPL
   echo ${todays_year} >> ${HOME}/.GPL
   echo "Got it! If you ever need to change any of this, edit the file .GPL"
   echo "at the top of your home-directory"
 fi
 export author_name
 export email_address
 export todays_year
}

# ===============================================
# == Assert that we are not overwriting a file ==
# ===============================================

function assert_file_not_exist
{
 if test -f $1
 then
  echo "File $1 exists. I'm sorry, but I can't do that Dave."
  exit
 fi
}

# ==================================================
# == Print generic header to append to every file ==
# ==================================================

function generic_header
{
 echo "Copyright (C) ${todays_year} ${author_name} <${email_address}>"
 echo " "
 cat << EOF
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software 
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
EOF
}

# ==================================================
# == Print special header to append to some files ==
# ==================================================

function special_header
{
 echo "Copyright (C) ${todays_year} ${author_name} <${email_address}>"
 echo " "
 cat << EOF
This file is free software; as a special exception the author gives
unlimited permission to copy and/or distribute it, with or without 
modifications, as long as this notice is preserved.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
EOF
}

# ==================================================
# == Print the special header for Autoconf macros ==
# ==================================================

function m4_header_extra_permission
{
 cat <<EOF

As a special exception to the GNU General Public License, if you 
distribute this file as part of a program that contains a configuration 
script generated by Autoconf, you may include it under the same 
distribution terms that you use for the rest of that program.
EOF
}

# ============================================
# == Print the GUILE additional permissions ==
# ============================================

function guile_header
{
 local libname=$1
 cat <<EOF

As a special exception to the GNU General Public License, permission is 
granted for additional uses of the text contained in its release 
of ${libname}.

The exception is that, if you link the ${libname} library with other files
to produce an executable, this does not by itself cause the
resulting executable to be covered by the GNU General Public License.
Your use of that executable is in no way restricted on account of
linking the ${libname} library code into it.

This exception does not however invalidate any other reasons why
the executable file might be covered by the GNU General Public License.

This exception applies only to the code released under the 
name ${libname}.  If you copy code from other releases into a copy of
${libname}, as the General Public License permits, the exception does
not apply to the code that you add in this way.  To avoid misleading
anyone as to the status of such modified files, you must delete
this exception notice from them.

If you write modifications of your own for ${libname}, it is your choice
whether to permit this exception to apply to your modifications.
If you do not wish that, delete this exception notice.  
EOF
}

# =====================================
# == Print GNU header for C programs ==
# =====================================

function cc_header
{
 echo "/*"
 generic_header | awk '{ print "** " $0 }'
 echo "*/"
 echo "" 
}

function cc_header_special
{
 echo "/*"
 special_header | awk '{ print "** " $0 }'
 echo "*/"
 echo ""
}

function cc_header_library
{
 echo "/*"
 (generic_header; guile_header $1) | awk '{ print "** " $0 }'
 echo "*/"
 echo ""
}

# =======================================
# == Print GNU header for C++ programs ==
# =======================================

function cpp_header
{
 generic_header | awk '{ print "// " $0 }'
 echo ""
}

function cpp_header_special
{
 special_header | awk '{ print "// " $0 }'
 echo ""
}

function cpp_header_library
{
 (generic_header; guile_header $1) | awk '{ print "// " $0 }'
 echo ""
}

# =======================================
# == Print GNU header for Python programs ==
# =======================================

function py_header
{
 generic_header | awk '{ print "## " $0 }'
 echo ""
}

function py_header_special
{
 special_header | awk '{ print "## " $0 }'
 echo ""
}

function py_header_library
{
 (generic_header; guile_header $1) | awk '{ print "## " $0 }'
 echo ""
}

# ========================================
# == Print GNU header for shell scripts ==
# ========================================

function sh_header
{
 generic_header | awk '{ print "# " $0 }'
 echo ""
}

function sh_header_special
{
 special_header | awk '{ print "# " $0 }'
 echo ""
}

function sh_header_library
{
 (generic_header; guile_header $1) | awk '{ print "# " $0 }'
 echo ""
}


# ===================================
# == Print GNU header for m4 files ==
# ===================================

function m4_header
{
 (generic_header; m4_header_extra_permission) | awk '{ print "dnl " $0 }'
 echo ""
}

function am_header
{
 special_header | awk '{ print "# " $0 }'
 echo ""
}

# ============================
# == The GNU public license ==
# ============================

function print_gnu_public_license
{
  sed 's/^X//' << 'SHAR_EOF' 
X		    GNU GENERAL PUBLIC LICENSE
X		       Version 2, June 1991
X
X Copyright (C) 1989, 1991 Free Software Foundation, Inc.
X                          675 Mass Ave, Cambridge, MA 02139, USA
X Everyone is permitted to copy and distribute verbatim copies
X of this license document, but changing it is not allowed.
X
X			    Preamble
X
X  The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Library General Public License instead.)  You can apply it to
your programs, too.
X
X  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.
X
X  To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.
X
X  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.
X
X  We protect your rights with two steps: (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.
X
X  Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.
X
X  Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.
X
X  The precise terms and conditions for copying, distribution and
modification follow.
X
X		    GNU GENERAL PUBLIC LICENSE
X   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
X
X  0. This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law:
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term "modification".)  Each licensee is addressed as "you".
X
Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.
X
X  1. You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.
X
You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.
X
X  2. You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:
X
X    a) You must cause the modified files to carry prominent notices
X    stating that you changed the files and the date of any change.
X
X    b) You must cause any work that you distribute or publish, that in
X    whole or in part contains or is derived from the Program or any
X    part thereof, to be licensed as a whole at no charge to all third
X    parties under the terms of this License.
X
X    c) If the modified program normally reads commands interactively
X    when run, you must cause it, when started running for such
X    interactive use in the most ordinary way, to print or display an
X    announcement including an appropriate copyright notice and a
X    notice that there is no warranty (or else, saying that you provide
X    a warranty) and that users may redistribute the program under
X    these conditions, and telling the user how to view a copy of this
X    License.  (Exception: if the Program itself is interactive but
X    does not normally print such an announcement, your work based on
X    the Program is not required to print an announcement.)
X
These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.
X
Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.
X
In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.
X
X  3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:
X
X    a) Accompany it with the complete corresponding machine-readable
X    source code, which must be distributed under the terms of Sections
X    1 and 2 above on a medium customarily used for software interchange; or,
X
X    b) Accompany it with a written offer, valid for at least three
X    years, to give any third party, for a charge no more than your
X    cost of physically performing source distribution, a complete
X    machine-readable copy of the corresponding source code, to be
X    distributed under the terms of Sections 1 and 2 above on a medium
X    customarily used for software interchange; or,
X
X    c) Accompany it with the information you received as to the offer
X    to distribute corresponding source code.  (This alternative is
X    allowed only for noncommercial distribution and only if you
X    received the program in object code or executable form with such
X    an offer, in accord with Subsection b above.)
X
The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.
X
If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.
X
X  4. You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.
X
X  5. You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.
X
X  6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.
X
X  7. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.
X
If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.
X
It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.
X
This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.
X
X  8. If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.
X
X  9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.
X
Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.
X
X  10. If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.
X
X			    NO WARRANTY
X
X  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.
X
X  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.
X
X		     END OF TERMS AND CONDITIONS
X
X	Appendix: How to Apply These Terms to Your New Programs
X
X  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.
X
X  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.
X
X    <one line to give the program's name and a brief idea of what it does.>
X    Copyright (C) 19yy  <name of author>
X
X    This program is free software; you can redistribute it and/or modify
X    it under the terms of the GNU General Public License as published by
X    the Free Software Foundation; either version 2 of the License, or
X    (at your option) any later version.
X
X    This program is distributed in the hope that it will be useful,
X    but WITHOUT ANY WARRANTY; without even the implied warranty of
X    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
X    GNU General Public License for more details.
X
X    You should have received a copy of the GNU General Public License
X    along with this program; if not, write to the Free Software
X    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
X
Also add information on how to contact you by electronic and paper mail.
X
If the program is interactive, make it output a short notice like this
when it starts in an interactive mode:
X
X    Gnomovision version 69, Copyright (C) 19yy name of author
X    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
X    This is free software, and you are welcome to redistribute it
X    under certain conditions; type `show c' for details.
X
The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, the commands you use may
be called something other than `show w' and `show c'; they could even be
mouse-clicks or menu items--whatever suits your program.
X
You should also get your employer (if you work as a programmer) or your
school, if any, to sign a "copyright disclaimer" for the program, if
necessary.  Here is a sample; alter the names:
X
X  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
X  `Gnomovision' (which makes passes at compilers) written by James Hacker.
X
X  <signature of Ty Coon>, 1 April 1989
X  Ty Coon, President of Vice
X
This General Public License does not permit incorporating your program into
proprietary programs.  If your program is a subroutine library, you may
consider it more useful to permit linking proprietary applications with the
library.  If this is what you want to do, use the GNU Library General
Public License instead of this License.
SHAR_EOF
}

# ==============================================
# == The GNU public license in TexInfo format ==
# ==============================================

function print_gnu_public_license_in_texinfo
{
  sed 's/^X//' << 'SHAR_EOF' &&
X@unnumbered GNU GENERAL PUBLIC LICENSE
X@center Version 2, June 1991
X
X@display
XCopyright @copyright{} 1989, 1991 Free Software Foundation, Inc.
X675 Mass Ave, Cambridge, MA 02139, USA
X
XEveryone is permitted to copy and distribute verbatim copies
Xof this license document, but changing it is not allowed.
X@end display
X
X@unnumberedsec Preamble
X
X  The licenses for most software are designed to take away your
Xfreedom to share and change it.  By contrast, the GNU General Public
XLicense is intended to guarantee your freedom to share and change free
Xsoftware---to make sure the software is free for all its users.  This
XGeneral Public License applies to most of the Free Software
XFoundation's software and to any other program whose authors commit to
Xusing it.  (Some other Free Software Foundation software is covered by
Xthe GNU Library General Public License instead.)  You can apply it to
Xyour programs, too.
X
X  When we speak of free software, we are referring to freedom, not
Xprice.  Our General Public Licenses are designed to make sure that you
Xhave the freedom to distribute copies of free software (and charge for
Xthis service if you wish), that you receive source code or can get it
Xif you want it, that you can change the software or use pieces of it
Xin new free programs; and that you know you can do these things.
X
X  To protect your rights, we need to make restrictions that forbid
Xanyone to deny you these rights or to ask you to surrender the rights.
XThese restrictions translate to certain responsibilities for you if you
Xdistribute copies of the software, or if you modify it.
X
X  For example, if you distribute copies of such a program, whether
Xgratis or for a fee, you must give the recipients all the rights that
Xyou have.  You must make sure that they, too, receive or can get the
Xsource code.  And you must show them these terms so they know their
Xrights.
X
X  We protect your rights with two steps: (1) copyright the software, and
X(2) offer you this license which gives you legal permission to copy,
Xdistribute and/or modify the software.
X
X  Also, for each author's protection and ours, we want to make certain
Xthat everyone understands that there is no warranty for this free
Xsoftware.  If the software is modified by someone else and passed on, we
Xwant its recipients to know that what they have is not the original, so
Xthat any problems introduced by others will not reflect on the original
Xauthors' reputations.
X
X  Finally, any free program is threatened constantly by software
Xpatents.  We wish to avoid the danger that redistributors of a free
Xprogram will individually obtain patent licenses, in effect making the
Xprogram proprietary.  To prevent this, we have made it clear that any
Xpatent must be licensed for everyone's free use or not licensed at all.
X
X  The precise terms and conditions for copying, distribution and
Xmodification follow.
X
X@iftex
X@unnumberedsec TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
X@end iftex
X@ifinfo
X@center TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
X@end ifinfo
X
X@enumerate
X@item
XThis License applies to any program or other work which contains
Xa notice placed by the copyright holder saying it may be distributed
Xunder the terms of this General Public License.  The ``Program'', below,
Xrefers to any such program or work, and a ``work based on the Program''
Xmeans either the Program or any derivative work under copyright law:
Xthat is to say, a work containing the Program or a portion of it,
Xeither verbatim or with modifications and/or translated into another
Xlanguage.  (Hereinafter, translation is included without limitation in
Xthe term ``modification''.)  Each licensee is addressed as ``you''.
X
XActivities other than copying, distribution and modification are not
Xcovered by this License; they are outside its scope.  The act of
Xrunning the Program is not restricted, and the output from the Program
Xis covered only if its contents constitute a work based on the
XProgram (independent of having been made by running the Program).
XWhether that is true depends on what the Program does.
X
X@item
XYou may copy and distribute verbatim copies of the Program's
Xsource code as you receive it, in any medium, provided that you
Xconspicuously and appropriately publish on each copy an appropriate
Xcopyright notice and disclaimer of warranty; keep intact all the
Xnotices that refer to this License and to the absence of any warranty;
Xand give any other recipients of the Program a copy of this License
Xalong with the Program.
X
XYou may charge a fee for the physical act of transferring a copy, and
Xyou may at your option offer warranty protection in exchange for a fee.
X
X@item
XYou may modify your copy or copies of the Program or any portion
Xof it, thus forming a work based on the Program, and copy and
Xdistribute such modifications or work under the terms of Section 1
Xabove, provided that you also meet all of these conditions:
X
X@enumerate a
X@item
XYou must cause the modified files to carry prominent notices
Xstating that you changed the files and the date of any change.
X
X@item
XYou must cause any work that you distribute or publish, that in
Xwhole or in part contains or is derived from the Program or any
Xpart thereof, to be licensed as a whole at no charge to all third
Xparties under the terms of this License.
X
X@item
XIf the modified program normally reads commands interactively
Xwhen run, you must cause it, when started running for such
Xinteractive use in the most ordinary way, to print or display an
Xannouncement including an appropriate copyright notice and a
Xnotice that there is no warranty (or else, saying that you provide
Xa warranty) and that users may redistribute the program under
Xthese conditions, and telling the user how to view a copy of this
XLicense.  (Exception: if the Program itself is interactive but
Xdoes not normally print such an announcement, your work based on
Xthe Program is not required to print an announcement.)
X@end enumerate
X
XThese requirements apply to the modified work as a whole.  If
Xidentifiable sections of that work are not derived from the Program,
Xand can be reasonably considered independent and separate works in
Xthemselves, then this License, and its terms, do not apply to those
Xsections when you distribute them as separate works.  But when you
Xdistribute the same sections as part of a whole which is a work based
Xon the Program, the distribution of the whole must be on the terms of
Xthis License, whose permissions for other licensees extend to the
Xentire whole, and thus to each and every part regardless of who wrote it.
X
XThus, it is not the intent of this section to claim rights or contest
Xyour rights to work written entirely by you; rather, the intent is to
Xexercise the right to control the distribution of derivative or
Xcollective works based on the Program.
X
XIn addition, mere aggregation of another work not based on the Program
Xwith the Program (or with a work based on the Program) on a volume of
Xa storage or distribution medium does not bring the other work under
Xthe scope of this License.
X
X@item
XYou may copy and distribute the Program (or a work based on it,
Xunder Section 2) in object code or executable form under the terms of
XSections 1 and 2 above provided that you also do one of the following:
X
X@enumerate a
X@item
XAccompany it with the complete corresponding machine-readable
Xsource code, which must be distributed under the terms of Sections
X1 and 2 above on a medium customarily used for software interchange; or,
X
X@item
XAccompany it with a written offer, valid for at least three
Xyears, to give any third party, for a charge no more than your
Xcost of physically performing source distribution, a complete
Xmachine-readable copy of the corresponding source code, to be
Xdistributed under the terms of Sections 1 and 2 above on a medium
Xcustomarily used for software interchange; or,
X
X@item
XAccompany it with the information you received as to the offer
Xto distribute corresponding source code.  (This alternative is
Xallowed only for noncommercial distribution and only if you
Xreceived the program in object code or executable form with such
Xan offer, in accord with Subsection b above.)
X@end enumerate
X
XThe source code for a work means the preferred form of the work for
Xmaking modifications to it.  For an executable work, complete source
Xcode means all the source code for all modules it contains, plus any
Xassociated interface definition files, plus the scripts used to
Xcontrol compilation and installation of the executable.  However, as a
Xspecial exception, the source code distributed need not include
Xanything that is normally distributed (in either source or binary
Xform) with the major components (compiler, kernel, and so on) of the
Xoperating system on which the executable runs, unless that component
Xitself accompanies the executable.
X
XIf distribution of executable or object code is made by offering
Xaccess to copy from a designated place, then offering equivalent
Xaccess to copy the source code from the same place counts as
Xdistribution of the source code, even though third parties are not
Xcompelled to copy the source along with the object code.
X
X@item
XYou may not copy, modify, sublicense, or distribute the Program
Xexcept as expressly provided under this License.  Any attempt
Xotherwise to copy, modify, sublicense or distribute the Program is
Xvoid, and will automatically terminate your rights under this License.
XHowever, parties who have received copies, or rights, from you under
Xthis License will not have their licenses terminated so long as such
Xparties remain in full compliance.
X
X@item
XYou are not required to accept this License, since you have not
Xsigned it.  However, nothing else grants you permission to modify or
Xdistribute the Program or its derivative works.  These actions are
Xprohibited by law if you do not accept this License.  Therefore, by
Xmodifying or distributing the Program (or any work based on the
XProgram), you indicate your acceptance of this License to do so, and
Xall its terms and conditions for copying, distributing or modifying
Xthe Program or works based on it.
X
X@item
XEach time you redistribute the Program (or any work based on the
XProgram), the recipient automatically receives a license from the
Xoriginal licensor to copy, distribute or modify the Program subject to
Xthese terms and conditions.  You may not impose any further
Xrestrictions on the recipients' exercise of the rights granted herein.
XYou are not responsible for enforcing compliance by third parties to
Xthis License.
X
X@item
XIf, as a consequence of a court judgment or allegation of patent
Xinfringement or for any other reason (not limited to patent issues),
Xconditions are imposed on you (whether by court order, agreement or
Xotherwise) that contradict the conditions of this License, they do not
Xexcuse you from the conditions of this License.  If you cannot
Xdistribute so as to satisfy simultaneously your obligations under this
XLicense and any other pertinent obligations, then as a consequence you
Xmay not distribute the Program at all.  For example, if a patent
Xlicense would not permit royalty-free redistribution of the Program by
Xall those who receive copies directly or indirectly through you, then
Xthe only way you could satisfy both it and this License would be to
Xrefrain entirely from distribution of the Program.
X
XIf any portion of this section is held invalid or unenforceable under
Xany particular circumstance, the balance of the section is intended to
Xapply and the section as a whole is intended to apply in other
Xcircumstances.
X
XIt is not the purpose of this section to induce you to infringe any
Xpatents or other property right claims or to contest validity of any
Xsuch claims; this section has the sole purpose of protecting the
Xintegrity of the free software distribution system, which is
Ximplemented by public license practices.  Many people have made
Xgenerous contributions to the wide range of software distributed
Xthrough that system in reliance on consistent application of that
Xsystem; it is up to the author/donor to decide if he or she is willing
Xto distribute software through any other system and a licensee cannot
Ximpose that choice.
X
XThis section is intended to make thoroughly clear what is believed to
Xbe a consequence of the rest of this License.
X
X@item
XIf the distribution and/or use of the Program is restricted in
Xcertain countries either by patents or by copyrighted interfaces, the
Xoriginal copyright holder who places the Program under this License
Xmay add an explicit geographical distribution limitation excluding
Xthose countries, so that distribution is permitted only in or among
Xcountries not thus excluded.  In such case, this License incorporates
Xthe limitation as if written in the body of this License.
X
X@item
XThe Free Software Foundation may publish revised and/or new versions
Xof the General Public License from time to time.  Such new versions will
Xbe similar in spirit to the present version, but may differ in detail to
Xaddress new problems or concerns.
X
XEach version is given a distinguishing version number.  If the Program
Xspecifies a version number of this License which applies to it and ``any
Xlater version'', you have the option of following the terms and conditions
Xeither of that version or of any later version published by the Free
XSoftware Foundation.  If the Program does not specify a version number of
Xthis License, you may choose any version ever published by the Free Software
XFoundation.
X
X@item
XIf you wish to incorporate parts of the Program into other free
Xprograms whose distribution conditions are different, write to the author
Xto ask for permission.  For software which is copyrighted by the Free
XSoftware Foundation, write to the Free Software Foundation; we sometimes
Xmake exceptions for this.  Our decision will be guided by the two goals
Xof preserving the free status of all derivatives of our free software and
Xof promoting the sharing and reuse of software generally.
X
X@iftex
X@heading NO WARRANTY
X@end iftex
X@ifinfo
X@center NO WARRANTY
X@end ifinfo
X
X@item
XBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
XFOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
XOTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
XPROVIDE THE PROGRAM ``AS IS'' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
XOR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
XMERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
XTO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
XPROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
XREPAIR OR CORRECTION.
X
X@item
XIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
XWILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
XREDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
XINCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
XOUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
XTO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
XYOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
XPROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
XPOSSIBILITY OF SUCH DAMAGES.
X@end enumerate
X
X@iftex
X@heading END OF TERMS AND CONDITIONS
X@end iftex
X@ifinfo
X@center END OF TERMS AND CONDITIONS
X@end ifinfo
X
X@page
X@unnumberedsec How to Apply These Terms to Your New Programs
X
X  If you develop a new program, and you want it to be of the greatest
Xpossible use to the public, the best way to achieve this is to make it
Xfree software which everyone can redistribute and change under these terms.
X
X  To do so, attach the following notices to the program.  It is safest
Xto attach them to the start of each source file to most effectively
Xconvey the exclusion of warranty; and each file should have at least
Xthe ``copyright'' line and a pointer to where the full notice is found.
X
X@smallexample
X@var{one line to give the program's name and an idea of what it does.}
XCopyright (C) 19@var{yy}  @var{name of author}
X
XThis program is free software; you can redistribute it and/or
Xmodify it under the terms of the GNU General Public License
Xas published by the Free Software Foundation; either version 2
Xof the License, or (at your option) any later version.
X
XThis program is distributed in the hope that it will be useful,
Xbut WITHOUT ANY WARRANTY; without even the implied warranty of
XMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
XGNU General Public License for more details.
X
XYou should have received a copy of the GNU General Public License
Xalong with this program; if not, write to the Free Software
XFoundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
X@end smallexample
X
XAlso add information on how to contact you by electronic and paper mail.
X
XIf the program is interactive, make it output a short notice like this
Xwhen it starts in an interactive mode:
X
X@smallexample
XGnomovision version 69, Copyright (C) 19@var{yy} @var{name of author}
XGnomovision comes with ABSOLUTELY NO WARRANTY; for details
Xtype `show w'.  This is free software, and you are welcome
Xto redistribute it under certain conditions; type `show c' 
Xfor details.
X@end smallexample
X
XThe hypothetical commands @samp{show w} and @samp{show c} should show
Xthe appropriate parts of the General Public License.  Of course, the
Xcommands you use may be called something other than @samp{show w} and
X@samp{show c}; they could even be mouse-clicks or menu items---whatever
Xsuits your program.
X
XYou should also get your employer (if you work as a programmer) or your
Xschool, if any, to sign a ``copyright disclaimer'' for the program, if
Xnecessary.  Here is a sample; alter the names:
X
X@smallexample
X@group
XYoyodyne, Inc., hereby disclaims all copyright
Xinterest in the program `Gnomovision'
X(which makes passes at compilers) written 
Xby James Hacker.
X
X@var{signature of Ty Coon}, 1 April 1989
XTy Coon, President of Vice
X@end group
X@end smallexample
X
XThis General Public License does not permit incorporating your program into
Xproprietary programs.  If your program is a subroutine library, you may
Xconsider it more useful to permit linking proprietary applications with the
Xlibrary.  If this is what you want to do, use the GNU Library General
XPublic License instead of this License.
SHAR_EOF
  : || echo 'restore of gpl.texi failed'
}

# '
# The comment above is used to fix fontification under emacs

# ===================
# == What the hell ==
# ===================

function print_bullshit
{
 cat << EOF

For information about getting "Bob" in your life, send \$1 to:

        Church of the SubGenius
        P.O. Box 140306 Dallas TX 75214 USA ($2 US extra if outside US)

EOF
}

# ==========================================================================
# ==========================================================================

# =========================================
# == Here is the main part of the script ==
# =========================================

# first check of correct usage
if test $# -ne 3 -a $# -ne 2 -a $# -ne 1
then
  echo "Invalid usage. For usage information type:"
  echo "% gpl --help"
  exit
fi

# branch out for the various flags
case $1 in
--help)
  usage
  exit
  ;;
--version)
  version
  exit
  ;;
--license)
  print_gnu_public_license 
  exit
  ;;
-c)
  configure
  assert_file_not_exist $2
  cc_header > $2
  exit
  ;;
-cS)
  configure
  assert_file_not_exist $2
  cc_header_special > $2
  exit
  ;;
-cL)
  configure
  assert_file_not_exist $3
  cc_header_library $2 > $3
  exit
  ;;
-cc)
  configure
  assert_file_not_exist $2 
  cpp_header > $2
  exit
  ;;
-ccS)
  configure
  assert_file_not_exist $2
  cpp_header_special > $2
  exit
  ;;
-ccL)
  configure
  assert_file_not_exist $3
  cpp_header_library $2 > $3
  exit
  ;;
-py)
  configure
  assert_file_not_exist $2
  py_header > $2
  exit
  ;;
-pyS)
  configure
  assert_file_not_exist $2
  py_header_special > $2
  exit
  ;;
-pyL)
  configure
  assert_file_not_exist $3
  py_header_library $2 > $3
  exit
  ;;
-sh)
  configure
  assert_file_not_exist $2
  sh_header > $2  
  exit
  ;;
-shS)
  configure
  assert_file_not_exist $2
  sh_header_special > $2
  exit
  ;;
-shL)
  configure
  assert_file_not_exist $3
  sh_header_library $2 > $3
  exit
  ;;
-m4)
  configure
  assert_file_not_exist $2
  m4_header > $2
  exit
  ;;
-am)
  configure
  assert_file_not_exist $2
  am_header > $2
  exit
  ;;
-l)
  assert_file_not_exist $2
  print_gnu_public_license > $2
  exit
  ;;
-lt)
  assert_file_not_exist $2
  print_gnu_public_license_in_texinfo > $2
  exit
  ;;
-bs)
  assert_file_not_exist $2
  print_bullshit > $2
  exit
  ;;
*)
  usage
  exit
  ;;
esac



