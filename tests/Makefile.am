##
## gshell: the genesis 3 shell.
##

##############################################################################
##'
##' gshell
##'
##' Copyright (C) 2007-2008 Hugo Cornelis
##'
##' Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################

#t automake does not allow to pass in arguments for tests ?

check_SCRIPTS = \
	$(srcdir)/neurospaces_harness

dist_noinst_SCRIPTS = \
	$(srcdir)/scripts/add_command_warning \
	$(srcdir)/scripts/model_state_purkinje \
	$(srcdir)/scripts/model_state_singlep \
	$(srcdir)/scripts/model_state_singlep.ptkdb \
	$(srcdir)/scripts/simple_purkinje \
	$(srcdir)/scripts/simple_purkinje.g3

TESTS = $(srcdir)/neurospaces_harness

test: check

