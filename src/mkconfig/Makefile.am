AM_CPPFLAGS = -I$(top_srcdir)/lib
SUFFIXES = .txt
.txt.o:
	$(TXTC) $< 

bin_PROGRAMS = mkconfig
mkconfig_SOURCES = mkconfig.c config.txt
mkconfig_LDADD = ../../lib/libautotools.a
