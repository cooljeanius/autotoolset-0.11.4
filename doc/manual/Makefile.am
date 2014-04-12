
info_TEXINFOS = toolsmanual.texi
toolsmanual_TEXINFOS = version.texi

html-local: toolsmanual.texi
	texi2html toolsmanual.texi || makeinfo --html toolsmanual.texi

CLEANFILES = toolsmanual.html toolsmanual_foot.html toolsmanual_toc.html

mostlyclean-local:
	-rm -f toolsmanual.fns

MAINTAINERCLEANFILES = toolsmanual/*.html

maintainer-clean-local:
	rm -rf toolsmanual || rmdir toolsmanual
