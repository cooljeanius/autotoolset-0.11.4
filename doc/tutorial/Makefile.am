
info_TEXINFOS = tutorial.texi
tutorial_TEXINFOS = \
	version.texi \
	preface.texi \
	acknowledgements.texi \
	copying.texi \
	basic_concepts.texi \
	good_code.texi \
	gnu_emacs.texi \
	makefiles.texi \
	using_automake_autoconf.texi \
	using_autotools.texi \
	fortran.texi \
	cxx.texi \
	documentation.texi \
	legal.texi \
	philosophy.texi

html-local: tutorial.texi
	texi2html tutorial.texi || makeinfo --html tutorial.texi

CLEANFILES = tutorial.html tutorial_foot.html tutorial_toc.html

MAINTAINERCLEANFILES = tutorial/*.html

maintainer-clean-local:
	rm -rf tutorial || rmdir tutorial
