;;; Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
;;;  
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.
;;;  
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;  
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
;;;  

(require 'texinfo)
(require 'texnfo-upd)

;;
;; The following command updates the nodes in the specific buffer
;; rebuilds the structure of the document as shown in *Occur* and
;; makes sure to preserve the current location of the cursor on both
;; buffers.
;;

(defun texi-update ()
  "Update all the nodes and menus in this buffer"
  (interactive)
  (let ((this-buffer (current-buffer)))
    (save-excursion (texinfo-master-menu t))
    (texinfo-show-structure)
    (goto-line 1)))

;;
;; The following command parses the current line, which should be the
;; declaration of a C function and replaces it with a @deftypefun 
;; definition block.
;;

(defun texi-parse-c-function-declaration ()
  "Parse the declaration of a C function and edit it into a Texinfo
definition."
  (interactive)
  (let (l1 l2 p1 p2)

    ; Set l1 and l2 to the beginning and end of this line
    (setq l1 (make-marker))
    (setq l2 (make-marker))
    (save-excursion
      (beginning-of-line)
      (set-marker l1 (point))
      (end-of-line)
      (set-marker l2 (point)))

    ; Set p1 and p2 to the operning and closing parenthesis 
    (setq p1 (make-marker))
    (setq p2 (make-marker))
    (save-excursion
      (beginning-of-line)
      (set-marker p1 (re-search-forward "(" l2 t))
      (set-marker p2 (re-search-forward ")" l2 t))
      (if (or (eq p1 nil) (eq p2 nil))
	  (error "Current line is not a C function declaration.")))
    ; Go to the closing parenthesis and then go back one word.
    ; We want to check if we have a function that simply takes (void)
    ; as the only argument. If so, then there is nothing else that we
    ; need to do to cook the arguments and we can move on
    (if (not (progn (goto-char (marker-position p2))
		    (backward-word 1)
		    (looking-at "void")))
	; otherwise, process each argument and mark-up the variables
	; with @var{}
	(progn
	  (goto-char (marker-position p1))
	  (while (or (re-search-forward "," (marker-position l2) t)
		     (re-search-forward ")" (marker-position l2) t))
	    ; To be on the safe side, go back one word and insert a space.
	    ; That will separate the word from a possible * that belongs to
	    ; a pointer. For some stupid reason, texinfo-insert-@var
	    ; wants to include that * in the variable definition.
	    (save-excursion
	      (backward-word 1)
	      (insert " "))
	    ; Now surround the variable with the @var{} markup. 
	    ; This is tricky
	    (save-excursion
	      (backward-char 1)
	      (insert " ")
	      (texinfo-insert-@var -1)
	      (delete-char 1)))))

    ; Check if the function is terminated with a semi-colon
    ; If so, then get rid of it
    (end-of-line)
    (if (re-search-backward ";" l1 t)
	(delete-char 1))

    ; Go to the opening braces and make sure that the pointer symbol
    ; is separated from the name of the function and that the return
    ; type of the function is guarded by braces
     (goto-char (1- (marker-position p1)))
     (skip-chars-backward " ")            ; skip whitespace
     (skip-chars-backward "a-zA-Z_")      ; skip name of a C function
     (insert " } ")
     (beginning-of-line)
     (insert "{ ")

    ; Kill the markets
    (set-marker l1 nil)
    (set-marker l2 nil)
    (set-marker p1 nil)
    (set-marker p2 nil)))

(defun texi-define-method ()
  "Parse the declaration of a C function, edit it into a Texinfo definition,
and prepend it with an @item. This is useful when you want to list the
methods of a C++ class as part of a table"
  (interactive)
  (texi-parse-c-function-declaration)
  (beginning-of-line)
  (insert "@item ")
  (end-of-line)
  (insert "\n"))

(defun texi-define-function ()
  "Parse the declaration of a C function, edit it into a Texinfo definition,
and prepend it with a deftypefun definition. This is useful for documenting
C functions"
  (interactive)
  (texi-parse-c-function-declaration)
  (beginning-of-line)
  (insert "@deftypefun ")
  (end-of-line)
  (insert "\n")
  (save-excursion
    (insert "\n@end deftypefun\n")))

(defun texi-define-variable ()
  "Parse the declaration of a C global variable and prepend the appropriate
@deftypevar definition"
  (interactive)
  (let (l1)
    ; Get rid of the semicolon, if there is one
    (beginning-of-line)
    (setq l1 (point))
    (end-of-line)
    (if (re-search-backward ";" l1 t)
	(delete-char 1))
    ; Guard the variable type with braces
    (end-of-line)
    (skip-chars-backward " ")
    (skip-chars-backward "a-zA-Z_")
    (insert " } ")
    (beginning-of-line)
    (insert "{ ")
    (beginning-of-line)
    (insert "@deftypevar ")
    (end-of-line)
    (insert "\n")
    (save-excursion (insert "\n@end deftypevar\n"))))

(defun texi-define-type ()
  "Parse the name of a C data type (e.g. `struct foo') and create an 
appropriate @deftp invokation"
  (interactive)
  (beginning-of-line)
  (insert "@deftp {Data Type} {")
  (end-of-line)
  (insert "}\n")
  (save-excursion
    (insert "\n@end deftp\n")))

;;
;; Define commands to automagically handle @example and @end example
;; You should map certain keys to these functions so that you can
;; easily make blocks of examples:
;;   (global-set-key [f9]  'texi-insert-@example)
;;   (global-set-key [f10] 'texi-insert-@smallexample)
;;

(defun texi-insert-@example ()
  "Insert an @example @end example block"
  (interactive)
  (beginning-of-line)
  (insert "\n@example\n")
  (save-excursion 
    (insert "\n")
    (insert "@end example\n")
    (insert "\n@noindent\n")))

(defun texi-insert-@smallexample ()
  "Insert a @smallexample block"
  (interactive)
  (beginning-of-line)
  (insert "\n@smallexample\n")
  (save-excursion
    (insert "\n")
    (insert "@end smallexample\n")
    (insert "\n@noindent")))

;;
;; Define commands to automagically handle annoying definitions
;; You should probably invoke these with M-x. There is no reason
;; to bind them to keys
;;

(defun texi-insert-def (command extra)
 "Insert Texinfo definitions in general"
 (let ((howmany (string-to-number (read-string "How many blocks: "))))
   (while (> howmany 0)
     (insert "\n")
     (insert "@c ----------------------------\n")
     (insert "\n")
     (insert "@" command " " extra "\n\n")
     (insert "@end " command "\n")
     (setq howmany (- howmany 1)))))

;;
;; Functions and similar entities
;;

(defun texi-deffn ()
  "Insert @deffn"
  (interactive)
  (let ((category (read-string "Category: ")))
    (texi-insert-def "deffn" (concat "{" category "}"))))

(defun texi-defun ()
  "Insert @defun"
  (interactive)
  (texi-insert-def "defun" ""))

(defun texi-defmac ()
  "Insert @defmac"
  (interactive)
  (texi-insert-def "defmac" ""))

(defun texi-defspec ()
  "Insert @defspec"
  (interactive)
  (texi-insert-def "defspec" ""))

;;
;; Variables and similar entities
;;

(defun texi-defvr ()
  "Insert @defvr"
  (interactive)
  (let ((category (read-string "Category: ")))
    (texi-insert-def "defvr" (concat "{" category "}"))))

(defun texi-defvar ()
  "Insert @defvar"
  (interactive)
  (texi-insert-def "defvar" ""))

(defun texi-defopt ()
  "Insert @defopt"
  (interactive)
  (texi-insert-def "defopt" ""))

;;
;; Functions in typed languages
;;

(defun texi-deftypefn ()
  "Insert @deftypefn"
  (interactive)
  (let ((category (read-string "Category: ")))
    (texi-insert-def "deftypefn" (concat "{" category "}"))))

(defun texi-deftypefun ()
  "Insert @deftypefun"
  (interactive)
  (texi-insert-def "deftypefun" ""))

;;
;; Variables in typed languages
;;

(defun texi-deftypevr ()
  "Insert @deftypevr"
  (interactive)
  (texi-insert-def "deftypevr" (concat "{" (read-string "Category: ") "}")))

(defun texi-deftypevar ()
  "Insert @deftypevar"
  (interactive)
  (texi-insert-def "deftypevar" ""))

;;
;; Object-oriented programming
;;

(defun texi-defcv ()
  "Insert @defcv"
  (interactive)
  (texi-insert-def "defcv" 
		   (concat "{" (read-string "Category: ") "}"
			   " "
			   "{" (read-string "Class: ") "}")))

(defun texi-defivar ()
  "Insert @defivar"
  (interactive)
  (texi-insert-def "defivar" (concat "{" (read-string "Class: ") "}")))

(defun texi-defop ()
  "Insert @defop"
  (interactive)
  (texi-insert-def "defop" (concat "{" (read-string "Category: ") "}"
				   " "
				   "{" (read-string "Class: ") "}")))

(defun texi-defmethod ()
  "Insert @defmethod"
  (interactive)
  (texi-insert-def "defmethod" (concat "{" (read-string "Class: ") "}")))

(defun texi-deftypemethod ()
  "Insert @deftypemethod"
  (interactive)
  (texi-insert-def "deftypemethod" (concat "{" (read-string "Class: ") "}")))

;;
;; C++ programming
;;

(defun texi-cxxclass ()
  "Insert definition for C++ class"
  (interactive)
  (texi-insert-def "deftypevr" "Class"))

;;
;; The following define the command M-x texi-template which
;; will insert a standard template for a new Texinfo document
;;

(defun texi-get-header-from-user ()
  "This routine prompts the user for information and provides with the"
  "header for the Texinfo template file. The rest of the template is"
  "provided through a defconst"
  (let ((filename (read-string "File name without extension: "))
	(title (read-string "Document title: "))
	(dircategory (read-string "Directory category: "))
	(years (format-time-string "%Y" (current-time))))
    (concat "\\input texinfo\n"
	    "\n"
	    "@c %**start of header\n"
	    "@setfilename " filename ".info\n"
	    "@set TITLE "   title    "\n"
	    "@settitle @value{TITLE}\n"
	    "@c %**end of header\n"
	    "\n"
	    "@c ---------------------------------------- \n"
	    "@c Include configuration information here.\n"
	    "@c ---------------------------------------- \n"
	    "@include version.texi\n"
	    "@set OWNER " user-full-name "\n"
	    "@set YEARS " years "\n"
	    "\n"
	    "@dircategory " dircategory "\n"
	    "@direntry\n"
	    "* " filename ": (" filename ").     " title "\n"
	    "@end direntry\n"
	    "\n"
	    "@c You should add similar direntries under the category\n"
	    "@c `General Commands' for each ``invoking'' node\n"
	    "\n")))

(defconst texi-the-rest-of-the-template
 (concat
 "\n"
"@c ------------------------------------------------------------\n"
"@c Formatting style commands. You may insert more of them here.\n"
"@c For example: headings, indices, etc...\n"
"@c ------------------------------------------------------------\n"
"@setchapternewpage odd\n"
"\n"
"@c ---------------------------------\n"
"@c Canonical title related template\n"
"@c ---------------------------------\n"
"\n"
"@shorttitlepage @value{TITLE}\n"
"@titlepage\n"
"@title @value{TITLE}\n"
"@subtitle This is edition @value{EDITION}\n"
"@subtitle Last updated, @value{UPDATED}\n"
"@author @value{OWNER}\n"
"@page\n"
"@vskip 0pt plus 1filll\n"
"Copyright @copyright{} @value{YEARS} @value{OWNER}. All rights reserved.\n"
"\n"
"Permission is granted to make and distribute verbatim copies of\n"
"this manual provided the copyright notice and this permission notice\n"
"are preserved on all copies.\n"
"\n"
"@ignore \n"
"Permission is granted to process this file through Tex and print the\n"
"results, provided the printed document carries copying permission notice\n"
"identical to this one except for the removal of this paragraph\n"
"@end ignore\n"
"\n"
"Permission is granted to copy and distribute modified versions of this\n"
"manual under the conditions for verbatim copying, provided that the entire\n"
"resulting derived work is distributed under the terms of a permission\n"
"notice identical to this one.\n"
"\n"
"Permission is granted to copy and distribute translations of this manual\n"
"into another language, under the above conditions for modified versions,\n"
"except that this permission notice may be stated in a translation approved\n"
"by the Free Software Foundation.\n"
"@end titlepage\n"
"\n"
"@c ---------------------\n"
"@c Menu stuff for info\n"
"@c ----------------------\n"
"\n"
"@ifinfo\n"
"@node Top\n"
"@comment node-name, next, previous, up\n"
"@top @value{TITLE}\n"
"@end ifinfo\n"
"\n"
"@c ===================================================================\n"
"@c ===================================================================\n"
"\n"
"@c Include chapters and indices here\n"
"\n"
"\n"
"@c ===================================================================\n"
"@c ===================================================================\n"
"\n"
"@c @shortcontents\n"
"@contents\n"
"@bye\n"
"\n"))

(defun texi-template ()
  "Insert a standard template file for a new Texinfo document."
  (interactive)
  (insert (texi-get-header-from-user) texi-the-rest-of-the-template))

;;
;; Insert a `copying' section
;;

(defun texi-copying ()
  "This command inserts the paragraphs that one normally includes in the
Texinfo documentation of a software package under the title `Copying'.
You will be prompted for the name of the package."
 (interactive)
 (let ((name (concat "@emph{" 
		     (read-string "Please enter name of this package: ")
		     "}")))
   (insert
    (concat "The " name " package is ``free''; this means that everyone is\n"
           "free to use it and free to redistribute it on a free basis.\n"
           "The " name " package is not in the public domain; it is \n"
           "copyrighted and there are restrictions on its distribution,\n"
           "but these restrictions are designed to permit everything that\n"
           "a good cooperating citizen would want to do. What is not allowed\n"
           "is to try to prevent others from further sharing any version\n"
           "of this package that they might get from you.\n"
           " \n"
           "Specifically, we want to make sure that you have the right to\n"
           "give away copies of the programs and documents that relate to\n"
           name ", that you receive source code or else can get it if you\n"
           "want it, that you can change these programs or use pices of\n"  
           "them in new free programs, and that you know you can do these\n"
           "things.\n"
           " \n"
           "To make sure that everyone has such rights, we don't permit you\n"
           "to deprive anyone else of these rights. For example, if you\n"
           "distribute copies of the " name "-related code, you must give\n"
           "the recipients all the rights that you have. You must make sure\n"
           "that they, too, receive of can get the source code. And you\n"
           "must tell them their rights.\n"
           " \n"
           "Also, for our own protection, we must make certain that everyone\n"
           "finds out that there is no warranty for the programs that\n"
           "relate to " name ". If these programs are modified by someone\n"
           "else and passed on, we want their recipients to know that what\n"
           "they have is not what we distributed, so that any problems\n"
           "introduced by others will not reflect on our reputation.\n"
           " \n"
           "The precise conditions of the licenses for the programs \n"
           "currently being distributed that relate to " name " are found in\n"
           "the General Public Licenses that accompany them.\n"))))

(defun texi-gpl ()
    "This command inserts the full text of the GNU General Public License
encoded in Texinfo. This is useful for inserting a copy of the GPL in
software documentation written in Texinfo"
  (interactive)
  (insert
"@unnumbered GNU GENERAL PUBLIC LICENSE\n"
"@center Version 2, June 1991\n"
"\n"
"@display\n"
"Copyright @copyright{} 1989, 1991 Free Software Foundation, Inc.\n"
"675 Mass Ave, Cambridge, MA 02139, USA\n"
"\n"
"Everyone is permitted to copy and distribute verbatim copies\n"
"of this license document, but changing it is not allowed.\n"
"@end display\n"
"\n"
"@unnumberedsec Preamble\n"
"\n"
"  The licenses for most software are designed to take away your\n"
"freedom to share and change it.  By contrast, the GNU General Public\n"
"License is intended to guarantee your freedom to share and change free\n"
"software---to make sure the software is free for all its users.  This\n"
"General Public License applies to most of the Free Software\n"
"Foundation's software and to any other program whose authors commit to\n"
"using it.  (Some other Free Software Foundation software is covered by\n"
"the GNU Library General Public License instead.)  You can apply it to\n"
"your programs, too.\n"
"\n"
"  When we speak of free software, we are referring to freedom, not\n"
"price.  Our General Public Licenses are designed to make sure that you\n"
"have the freedom to distribute copies of free software (and charge for\n"
"this service if you wish), that you receive source code or can get it\n"
"if you want it, that you can change the software or use pieces of it\n"
"in new free programs; and that you know you can do these things.\n"
"\n"
"  To protect your rights, we need to make restrictions that forbid\n"
"anyone to deny you these rights or to ask you to surrender the rights.\n"
"These restrictions translate to certain responsibilities for you if you\n"
"distribute copies of the software, or if you modify it.\n"
"\n"
"  For example, if you distribute copies of such a program, whether\n"
"gratis or for a fee, you must give the recipients all the rights that\n"
"you have.  You must make sure that they, too, receive or can get the\n"
"source code.  And you must show them these terms so they know their\n"
"rights.\n"
"\n"
"  We protect your rights with two steps: (1) copyright the software, and\n"
"(2) offer you this license which gives you legal permission to copy,\n"
"distribute and/or modify the software.\n"
"\n"
"  Also, for each author's protection and ours, we want to make certain\n"
"that everyone understands that there is no warranty for this free\n"
"software.  If the software is modified by someone else and passed on, we\n"
"want its recipients to know that what they have is not the original, so\n"
"that any problems introduced by others will not reflect on the original\n"
"authors' reputations.\n"
"\n"
"  Finally, any free program is threatened constantly by software\n"
"patents.  We wish to avoid the danger that redistributors of a free\n"
"program will individually obtain patent licenses, in effect making the\n"
"program proprietary.  To prevent this, we have made it clear that any\n"
"patent must be licensed for everyone's free use or not licensed at all.\n"
"\n"
"  The precise terms and conditions for copying, distribution and\n"
"modification follow.\n"
"\n"
"@iftex\n"
"@unnumberedsec TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION\n"
"@end iftex\n"
"@ifinfo\n"
"@center TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION\n"
"@end ifinfo\n"
"\n"
"@enumerate\n"
"@item\n"
"This License applies to any program or other work which contains\n"
"a notice placed by the copyright holder saying it may be distributed\n"
"under the terms of this General Public License.  The ``Program'', below,\n"
"refers to any such program or work, and a ``work based on the Program''\n"
"means either the Program or any derivative work under copyright law:\n"
"that is to say, a work containing the Program or a portion of it,\n"
"either verbatim or with modifications and/or translated into another\n"
"language.  (Hereinafter, translation is included without limitation in\n"
"the term ``modification''.)  Each licensee is addressed as ``you''.\n"
"\n"
"Activities other than copying, distribution and modification are not\n"
"covered by this License; they are outside its scope.  The act of\n"
"running the Program is not restricted, and the output from the Program\n"
"is covered only if its contents constitute a work based on the\n"
"Program (independent of having been made by running the Program).\n"
"Whether that is true depends on what the Program does.\n"
"\n"
"@item\n"
"You may copy and distribute verbatim copies of the Program's\n"
"source code as you receive it, in any medium, provided that you\n"
"conspicuously and appropriately publish on each copy an appropriate\n"
"copyright notice and disclaimer of warranty; keep intact all the\n"
"notices that refer to this License and to the absence of any warranty;\n"
"and give any other recipients of the Program a copy of this License\n"
"along with the Program.\n"
"\n"
"You may charge a fee for the physical act of transferring a copy, and\n"
"you may at your option offer warranty protection in exchange for a fee.\n"
"\n"
"@item\n"
"You may modify your copy or copies of the Program or any portion\n"
"of it, thus forming a work based on the Program, and copy and\n"
"distribute such modifications or work under the terms of Section 1\n"
"above, provided that you also meet all of these conditions:\n"
"\n"
"@enumerate a\n"
"@item\n"
"You must cause the modified files to carry prominent notices\n"
"stating that you changed the files and the date of any change.\n"
"\n"
"@item\n"
"You must cause any work that you distribute or publish, that in\n"
"whole or in part contains or is derived from the Program or any\n"
"part thereof, to be licensed as a whole at no charge to all third\n"
"parties under the terms of this License.\n"
"\n"
"@item\n"
"If the modified program normally reads commands interactively\n"
"when run, you must cause it, when started running for such\n"
"interactive use in the most ordinary way, to print or display an\n"
"announcement including an appropriate copyright notice and a\n"
"notice that there is no warranty (or else, saying that you provide\n"
"a warranty) and that users may redistribute the program under\n"
"these conditions, and telling the user how to view a copy of this\n"
"License.  (Exception: if the Program itself is interactive but\n"
"does not normally print such an announcement, your work based on\n"
"the Program is not required to print an announcement.)\n"
"@end enumerate\n"
"\n"
"These requirements apply to the modified work as a whole.  If\n"
"identifiable sections of that work are not derived from the Program,\n"
"and can be reasonably considered independent and separate works in\n"
"themselves, then this License, and its terms, do not apply to those\n"
"sections when you distribute them as separate works.  But when you\n"
"distribute the same sections as part of a whole which is a work based\n"
"on the Program, the distribution of the whole must be on the terms of\n"
"this License, whose permissions for other licensees extend to the\n"
"entire whole, and thus to each and every part regardless of who wrote it.\n"
"\n"
"Thus, it is not the intent of this section to claim rights or contest\n"
"your rights to work written entirely by you; rather, the intent is to\n"
"exercise the right to control the distribution of derivative or\n"
"collective works based on the Program.\n"
"\n"
"In addition, mere aggregation of another work not based on the Program\n"
"with the Program (or with a work based on the Program) on a volume of\n"
"a storage or distribution medium does not bring the other work under\n"
"the scope of this License.\n"
"\n"
"@item\n"
"You may copy and distribute the Program (or a work based on it,\n"
"under Section 2) in object code or executable form under the terms of\n"
"Sections 1 and 2 above provided that you also do one of the following:\n"
"\n"
"@enumerate a\n"
"@item\n"
"Accompany it with the complete corresponding machine-readable\n"
"source code, which must be distributed under the terms of Sections\n"
"1 and 2 above on a medium customarily used for software interchange; or,\n"
"\n"
"@item\n"
"Accompany it with a written offer, valid for at least three\n"
"years, to give any third party, for a charge no more than your\n"
"cost of physically performing source distribution, a complete\n"
"machine-readable copy of the corresponding source code, to be\n"
"distributed under the terms of Sections 1 and 2 above on a medium\n"
"customarily used for software interchange; or,\n"
"\n"
"@item\n"
"Accompany it with the information you received as to the offer\n"
"to distribute corresponding source code.  (This alternative is\n"
"allowed only for noncommercial distribution and only if you\n"
"received the program in object code or executable form with such\n"
"an offer, in accord with Subsection b above.)\n"
"@end enumerate\n"
"\n"
"The source code for a work means the preferred form of the work for\n"
"making modifications to it.  For an executable work, complete source\n"
"code means all the source code for all modules it contains, plus any\n"
"associated interface definition files, plus the scripts used to\n"
"control compilation and installation of the executable.  However, as a\n"
"special exception, the source code distributed need not include\n"
"anything that is normally distributed (in either source or binary\n"
"form) with the major components (compiler, kernel, and so on) of the\n"
"operating system on which the executable runs, unless that component\n"
"itself accompanies the executable.\n"
"\n"
"If distribution of executable or object code is made by offering\n"
"access to copy from a designated place, then offering equivalent\n"
"access to copy the source code from the same place counts as\n"
"distribution of the source code, even though third parties are not\n"
"compelled to copy the source along with the object code.\n"
"\n"
"@item\n"
"You may not copy, modify, sublicense, or distribute the Program\n"
"except as expressly provided under this License.  Any attempt\n"
"otherwise to copy, modify, sublicense or distribute the Program is\n"
"void, and will automatically terminate your rights under this License.\n"
"However, parties who have received copies, or rights, from you under\n"
"this License will not have their licenses terminated so long as such\n"
"parties remain in full compliance.\n"
"\n"
"@item\n"
"You are not required to accept this License, since you have not\n"
"signed it.  However, nothing else grants you permission to modify or\n"
"distribute the Program or its derivative works.  These actions are\n"
"prohibited by law if you do not accept this License.  Therefore, by\n"
"modifying or distributing the Program (or any work based on the\n"
"Program), you indicate your acceptance of this License to do so, and\n"
"all its terms and conditions for copying, distributing or modifying\n"
"the Program or works based on it.\n"
"\n"
"@item\n"
"Each time you redistribute the Program (or any work based on the\n"
"Program), the recipient automatically receives a license from the\n"
"original licensor to copy, distribute or modify the Program subject to\n"
"these terms and conditions.  You may not impose any further\n"
"restrictions on the recipients' exercise of the rights granted herein.\n"
"You are not responsible for enforcing compliance by third parties to\n"
"this License.\n"
"\n"
"@item\n"
"If, as a consequence of a court judgment or allegation of patent\n"
"infringement or for any other reason (not limited to patent issues),\n"
"conditions are imposed on you (whether by court order, agreement or\n"
"otherwise) that contradict the conditions of this License, they do not\n"
"excuse you from the conditions of this License.  If you cannot\n"
"distribute so as to satisfy simultaneously your obligations under this\n"
"License and any other pertinent obligations, then as a consequence you\n"
"may not distribute the Program at all.  For example, if a patent\n"
"license would not permit royalty-free redistribution of the Program by\n"
"all those who receive copies directly or indirectly through you, then\n"
"the only way you could satisfy both it and this License would be to\n"
"refrain entirely from distribution of the Program.\n"
"\n"
"If any portion of this section is held invalid or unenforceable under\n"
"any particular circumstance, the balance of the section is intended to\n"
"apply and the section as a whole is intended to apply in other\n"
"circumstances.\n"
"\n"
"It is not the purpose of this section to induce you to infringe any\n"
"patents or other property right claims or to contest validity of any\n"
"such claims; this section has the sole purpose of protecting the\n"
"integrity of the free software distribution system, which is\n"
"implemented by public license practices.  Many people have made\n"
"generous contributions to the wide range of software distributed\n"
"through that system in reliance on consistent application of that\n"
"system; it is up to the author/donor to decide if he or she is willing\n"
"to distribute software through any other system and a licensee cannot\n"
"impose that choice.\n"
"\n"
"This section is intended to make thoroughly clear what is believed to\n"
"be a consequence of the rest of this License.\n"
"\n"
"@item\n"
"If the distribution and/or use of the Program is restricted in\n"
"certain countries either by patents or by copyrighted interfaces, the\n"
"original copyright holder who places the Program under this License\n"
"may add an explicit geographical distribution limitation excluding\n"
"those countries, so that distribution is permitted only in or among\n"
"countries not thus excluded.  In such case, this License incorporates\n"
"the limitation as if written in the body of this License.\n"
"\n"
"@item\n"
"The Free Software Foundation may publish revised and/or new versions\n"
"of the General Public License from time to time.  Such new versions will\n"
"be similar in spirit to the present version, but may differ in detail to\n"
"address new problems or concerns.\n"
"\n"
"Each version is given a distinguishing version number.  If the Program\n"
"specifies a version number of this License which applies to it and ``any\n"
"later version'', you have the option of following the terms and conditions\n"
"either of that version or of any later version published by the Free\n"
"Software Foundation.  If the Program does not specify a version number of\n"
"this License, you may choose any version ever published by the Free Software\n"
"Foundation.\n"
"\n"
"@item\n"
"If you wish to incorporate parts of the Program into other free\n"
"programs whose distribution conditions are different, write to the author\n"
"to ask for permission.  For software which is copyrighted by the Free\n"
"Software Foundation, write to the Free Software Foundation; we sometimes\n"
"make exceptions for this.  Our decision will be guided by the two goals\n"
"of preserving the free status of all derivatives of our free software and\n"
"of promoting the sharing and reuse of software generally.\n"
"\n"
"@iftex\n"
"@heading NO WARRANTY\n"
"@end iftex\n"
"@ifinfo\n"
"@center NO WARRANTY\n"
"@end ifinfo\n"
"\n"
"@item\n"
"BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY\n"
"FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN\n"
"OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES\n"
"PROVIDE THE PROGRAM ``AS IS'' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED\n"
"OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF\n"
"MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS\n"
"TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE\n"
"PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,\n"
"REPAIR OR CORRECTION.\n"
"\n"
"@item\n"
"IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING\n"
"WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR\n"
"REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,\n"
"INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING\n"
"OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED\n"
"TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY\n"
"YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER\n"
"PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE\n"
"POSSIBILITY OF SUCH DAMAGES.\n"
"@end enumerate\n"
"\n"
"@iftex\n"
"@heading END OF TERMS AND CONDITIONS\n"
"@end iftex\n"
"@ifinfo\n"
"@center END OF TERMS AND CONDITIONS\n"
"@end ifinfo\n"
"\n"
"@page\n"
"@unnumberedsec How to Apply These Terms to Your New Programs\n"
"\n"
"  If you develop a new program, and you want it to be of the greatest\n"
"possible use to the public, the best way to achieve this is to make it\n"
"free software which everyone can redistribute and change under these terms.\n"
"\n"
"  To do so, attach the following notices to the program.  It is safest\n"
"to attach them to the start of each source file to most effectively\n"
"convey the exclusion of warranty; and each file should have at least\n"
"the ``copyright'' line and a pointer to where the full notice is found.\n"
"\n"
"@smallexample\n"
"@var{one line to give the program's name and an idea of what it does.}\n"
"Copyright (C) 19@var{yy}  @var{name of author}\n"
"\n"
"This program is free software; you can redistribute it and/or\n"
"modify it under the terms of the GNU General Public License\n"
"as published by the Free Software Foundation; either version 2\n"
"of the License, or (at your option) any later version.\n"
"\n"
"This program is distributed in the hope that it will be useful,\n"
"but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
"GNU General Public License for more details.\n"
"\n"
"You should have received a copy of the GNU General Public License\n"
"along with this program; if not, write to the Free Software\n"
"Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n"
"@end smallexample\n"
"\n"
"Also add information on how to contact you by electronic and paper mail.\n"
"\n"
"If the program is interactive, make it output a short notice like this\n"
"when it starts in an interactive mode:\n"
"\n"
"@smallexample\n"
"Gnomovision version 69, Copyright (C) 19@var{yy} @var{name of author}\n"
"Gnomovision comes with ABSOLUTELY NO WARRANTY; for details\n"
"type `show w'.  This is free software, and you are welcome\n"
"to redistribute it under certain conditions; type `show c' \n"
"for details.\n"
"@end smallexample\n"
"\n"
"The hypothetical commands @samp{show w} and @samp{show c} should show\n"
"the appropriate parts of the General Public License.  Of course, the\n"
"commands you use may be called something other than @samp{show w} and\n"
"@samp{show c}; they could even be mouse-clicks or menu items---whatever\n"
"suits your program.\n"
"\n"
"You should also get your employer (if you work as a programmer) or your\n"
"school, if any, to sign a ``copyright disclaimer'' for the program, if\n"
"necessary.  Here is a sample; alter the names:\n"
"\n"
"@smallexample\n"
"@group\n"
"Yoyodyne, Inc., hereby disclaims all copyright\n"
"interest in the program `Gnomovision'\n"
"(which makes passes at compilers) written \n"
"by James Hacker.\n"
"\n"
"@var{signature of Ty Coon}, 1 April 1989\n"
"Ty Coon, President of Vice\n"
"@end group\n"
"@end smallexample\n"
"\n"
"This General Public License does not permit incorporating your program into\n"
"proprietary programs.  If your program is a subroutine library, you may\n"
"consider it more useful to permit linking proprietary applications with the\n"
"library.  If this is what you want to do, use the GNU Library General\n"
"Public License instead of this License.\n"))

;;
;; Separators
;;

(defun texi-chapter-separator ()
  "Separate chapters from each other with two double lines."
  (interactive)
  (insert "\n")
  (insert "@c ============================================================\n")
  (insert "@c ============================================================\n")
  (insert "\n"))

(defun texi-section-separator ()
  "Separate sections from each other with a double line."
  (interactive)
  (insert "\n")
  (insert "@c ============================================================\n")
  (insert "\n"))

(defun texi-subsection-separator ()
  "Separate subsections from each other with a single line."
  (interactive)
  (insert "\n")
  (insert "@c ------------------------------------------------------------\n")
  (insert "\n"))

;;
;; Hook to the Texinfo mode
;;

(defun texi-menu-hook ()
  "Create menus for the Texinfo mode."
  (interactive)

  ; Bind the C declaration editing functions
  (define-key texinfo-mode-map "\M-m" 'texi-define-method)
  (define-key texinfo-mode-map "\M-f" 'texi-define-function)
  (define-key texinfo-mode-map "\M-v" 'texi-define-variable)
  (define-key texinfo-mode-map "\M-t" 'texi-define-type)

  ; Create the Texinfo menu
  (define-key texinfo-mode-map [menu-bar Texinfo]
    (cons "Texinfo" (make-sparse-keymap "Texinfo")))

  (define-key texinfo-mode-map [menu-bar Texinfo chapter-sep]
    '("Chapter separator" . texi-chapter-separator))
  (define-key texinfo-mode-map [menu-bar Texinfo section-sep]
    '("Section separator" . texi-section-separator))
  (define-key texinfo-mode-map [menu-bar Texinfo subsection-sep]
    '("Subsection separator" . texi-subsection-separator))

;;  (define-key texinfo-mode-map [menu-bar Texinfo separator-sep] '("--"))


  (define-key texinfo-mode-map [menu-bar Texinfo gpl]
    '("Insert the GPL" . texi-gpl))
  (define-key texinfo-mode-map [menu-bar Texinfo copying]
    '("Insert Copying" . texi-copying))
  (define-key texinfo-mode-map [menu-bar Texinfo setup]
    '("Setup New Manual" . texi-template))

 ;; (define-key texinfo-mode-map [menu-bar Texinfo separator-insert] '("--"))

  (define-key texinfo-mode-map [menu-bar Texinfo goto]
    '("Goto node" . occur-mode-goto-occurence))
  (define-key texinfo-mode-map [menu-bar Texinfo structure]
    '("Show structure" . texinfo-show-structure))
  (define-key texinfo-mode-map [menu-bar Texinfo update]
    '("Update nodes" . texi-update))
)

;;
;; Provide
;;

(provide 'texinfo-xtra)

