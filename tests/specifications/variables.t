#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "Can we find information about the different verbosity levels ?",
						   read => "verbosity levels:
  debug:
    description: used for software development and maintenance
  errors:
    comment: this is the default
    description: displays only error state information
  information:
    description: 'displays information, warning and error messages'
  warnings:
    description: displays warning and error state information
",
						   write => 'list verbose',
						  },
						  {
						   description => "Does the verbose_level variable have a legal value ?",
						   read => "
verbose_level: errors
",
						   write => "show_verbose",
						  },
						  {
						   description => "Can we set the verbose_level variable to a different legal value ?",
						   write => "set_verbose debug",
						  },
						  {
						   description => "Does the verbose_level variable have this new legal value ?",
						   read => "
verbose_level: debug
",
						   write => "show_verbose",
						  },
						  {
						   description => "Can we set the verbose_level variable to an illegal value ?",
						   write => "set_verbose texan_deadbeaf",
						  },
						  {
						   description => "Does the verbose_level variable have this illegal value (should not) ?",
						   read => "
verbose_level: debug
",
						   write => "show_verbose",
						  },
						 ],
				description => "verbose variable",
			       },
			      ],
       description => "variables",
       name => 'variables.t',
      };


return $test;


