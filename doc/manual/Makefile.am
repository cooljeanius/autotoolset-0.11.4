
info_TEXINFOS = toolsmanual.texi
toolsmanual_TEXINFOS = version.texi

## should be set by autoconf calling the "LF_USE_TEXIDOC" macro:
html-local: toolsmanual.texi
	$(TEXI2HTML) toolsmanual.texi || $(MAKEINFO) --html toolsmanual.texi
.PHONY: html-local

CLEANFILES = toolsmanual.html toolsmanual_foot.html toolsmanual_toc.html

mostlyclean-local:
	-rm -f toolsmanual.fns
.PHONY: mostlyclean-local

MAINTAINERCLEANFILES = toolsmanual/*.html

maintainer-clean-local:
	rm -rf toolsmanual || rmdir toolsmanual
.PHONY: maintainer-clean-local
