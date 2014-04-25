
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

## should be set by autoconf calling the "LF_USE_TEXIDOC" macro:
html-local: tutorial.texi
	$(TEXI2HTML) tutorial.texi || $(MAKEINFO) --html tutorial.texi
.PHONY: html-local

CLEANFILES = tutorial.html tutorial_foot.html tutorial_toc.html

MAINTAINERCLEANFILES = tutorial/*.html

maintainer-clean-local:
	rm -rf tutorial || rmdir tutorial
.PHONY: maintainer-clean-local
