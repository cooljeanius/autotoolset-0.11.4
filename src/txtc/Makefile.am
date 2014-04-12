# Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
#  
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without 
# modifications, as long as this notice is preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

bin_SCRIPTS = mktxtc
CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = txtc.sh

mktxtc: $(srcdir)/txtc.sh
	rm -f mktxtc
	cp $(srcdir)/txtc.sh txtc.sh.in
	shar txtc.sh.in > mktxtc
	rm -f txtc.sh.in
	chmod ugo+x mktxtc

