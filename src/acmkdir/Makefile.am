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

## should be set by autoconf calling the "LF_PROG_F77" macro somewhere:
if USE_F2C
all: run_mkfortran run_mkf2c run_mkf2c_comp

run_mkfortran: mkfortran
	./mkfortran
.PHONY: run_mkfortran

run_mkf2c: mkf2c
	./mkf2c
.PHONY: run_mkf2c

run_mkf2c_comp: mkf2c_comp
	./mkf2c_comp
.PHONY: run_mkf2c_comp

f2c.h: run_mkf2c
f2c-main.c: run_mkf2c
f2c_comp.in: run_mkf2c_comp

BUILT_SOURCES = f2c.h f2c-main.c f2c_comp.in
CLEANFILES += f2c.h f2c-main.c f2c_comp.in

clean-local:
	rm -rf fortran || rmdir fortran
else
## (not USE_F2C)

# still build, just not as part of the normal build process:
TESTS = mkfortran mkf2c mkf2c_comp

# only maintainers should be running the tests:
MAINTAINERCLEANFILES = f2c.h f2c-main.c f2c_comp.in

maintainer-clean-local:
	rm -rf fortran || rmdir fortran

endif
## (end USE_F2C)
