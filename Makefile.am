##
## The neurospaces project : modeling tools for computational
## neuroscience.
##

##############################################################################
##'
##' The neurospaces project
##'
##' Copyright (C) 2007-2008 Hugo Cornelis
##'
##' Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################


SUBDIRS = perl tests

dist_bin_SCRIPTS = \
	bin/genesis-g3

RELEASE_MAJOR=`release-extract --major`
RELEASE_MINOR=`release-extract --minor`
RELEASE_MICRO=`release-extract --micro`

show-release-labels:
	echo "Release information (major-minor-micro): $(RELEASE_MAJOR)-$(RELEASE_MINOR)-$(RELEASE_MICRO)"

dist-keywords:
	release-expand installer $(RELEASE_MAJOR) $(RELEASE_MINOR) $(RELEASE_MICRO) $(RELEASE_MAJOR)-$(RELEASE_MINOR) hugo.cornelis@gmail.com --verbose
#	release-expand installer des 10 0 des-10 hugo.cornelis@gmail.com --verbose

am__tar = ${AMTAR} chf - --format=posix "$$tardir"

dist-hook: dist-keywords
#	cd $(srcdir) && if test -n "`mtn ls changed `" ; then false ; else true ; fi
	find $(distdir) -name _Inline -exec chmod u+w -R \{\} \;
	$(RM) -fr `find $(distdir) -name _Inline`
	cp $(srcdir)/license.txt $(distdir)
#	cp -R $(srcdir)/docs $(distdir)
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
	cp -dp $(srcdir)/tests/{neurospaces_harness,neurospaces_harness.ptkdb,command_extractor,command_extractor.ptkdb,tests_2_html,tests_2_html.ptkdb,tests.config} $(distdir)/tests
	cp -a $(srcdir)/tests.config $(distdir)
	( cd $(distdir)/tests && chmod -R u+w . && ./tests_2_html --introduction introduction.html )

html-upload-prepare:

#t perhaps also add a target to check the syntax of all the html ?

html-upload: html-upload-prepare

test: check

TESTS = $(srcdir)/tests/neurospaces_harness

