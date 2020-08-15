#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/interactive",
				command_tests => [
						  {
						   description => "Is startup of the interactive environment successful ?",
						   read => "genesis >",
						   timeout => 5,
						  },
						  {
						   description => "Can we echo interactively, from the command line?",
						   read => 'abcdefg',
						   write => 'echo abcdefg\n',
						  },
						 ],
				description => "starting the interactive environment from a perl script",
			       },
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/interactive.g3",
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we echo interactively, from the command line?",
						   read => 'abcdefg',
						   write => 'echo abcdefg\n',
						  },
						 ],
				description => "starting the interactive environment from a perl script",
			       },
			      ],
       description => "interactive flow",
       name => 'interactive.t',
      };


return $test;


