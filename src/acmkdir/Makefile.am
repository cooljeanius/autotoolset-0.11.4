# Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
# Copyright (C) 2001 Thierry Michel <thierry@nekhem.com>
# Copyright (C) 2003 Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>
#  
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without 
# modifications, as long as this notice is preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


autotoolsetdir = $(prefix)/share/autotoolset
autotoolset_DATA = \
	new_install.txt \
	doc_makefile.am \
	f2c_comp.sh

bin_SCRIPTS = \
	acmkdir \
	mkf2c \
	mkfortran \
	mkf2c_comp

CLEANFILES = $(bin_SCRIPTS)

DISTCLEANFILES = .DS_Store

EXTRA_DIST = \
	acmkdir.sh \
	fortran.tar.gz \
	f2c_comp.sh \
	f2c-main.c.src \
	f2c.h.src \
	new_install.txt \
	doc_makefile.am \
	m4_makefile.am

SUBDIRS = python

acmkdir: ../version.sh $(srcdir)/acmkdir.sh
	rm -f acmkdir
	echo "#! " $(BASH) > acmkdir
	cat ../version.sh $(srcdir)/acmkdir.sh >> acmkdir
	chmod ugo+x acmkdir

mkfortran: $(srcdir)/fortran.tar.gz
	rm -f mkfortran
	$(ZCAT) $(srcdir)/fortran.tar.gz > fortran.tar
	tar xf fortran.tar
	($(SHAR) fortran > mkfortran) >& /dev/null
	chmod ugo+x mkfortran
	rm -rf fortran
	rm -f fortran.tar

mkf2c: $(srcdir)/f2c-main.c.src $(srcdir)/f2c.h.src
	rm -f mkf2c
	cp $(srcdir)/f2c-main.c.src f2c-main.c
	cp $(srcdir)/f2c.h.src f2c.h
	($(SHAR) f2c-main.c f2c.h > mkf2c) >& /dev/null
	rm -f f2c-main.c f2c.h
	chmod ugo+x mkf2c

mkf2c_comp: $(srcdir)/f2c_comp.sh
	cp $(srcdir)/f2c_comp.sh f2c_comp.in
	$(SHAR) f2c_comp.in > mkf2c_comp
	chmod ugo+x mkf2c_comp
	rm -f f2c_comp.in