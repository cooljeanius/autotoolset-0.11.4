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

autotoolsetpythondir = $(prefix)/share/autotoolset/python
dist_autotoolsetpython_DATA = \
	install_data.py \
	setup.py \
	setup.cfg \
	MANIFEST.in \
	new_install_python.txt \
	__init__.py \
	__init__.py.zope \
	configure.ac.zope \
	src.Makefile.am.zope \
	src.dtml.Makefile.am.zope \
	src.www.Makefile.am.zope \
	src.interfaces.Makefile.am.zope

python_PYTHON = install_data.py setup.py __init__.py

build:
	$(PYTHON) ./setup.py build
