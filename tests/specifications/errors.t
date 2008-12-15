#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/scripts/add_command_warning',
				command_tests => [
						  {
						   description => "Do we get a warning that the help message for a dynamically added command is missing ?",
						   read => '*** Warning: command new_command found, but no help available for it
',
						  },
						 ],
				description => "help message missing warning for a dynamically added command",
			       },
			      ],
       description => "errors and warnings",
       name => 'errors.t',
      };


return $test;


