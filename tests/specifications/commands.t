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
						   comment => 'we do expect to find a Makefile in the test directory',
						   description => "Can we get a useful synopsis for the list command ?",
						   read => "Makefile",
						   write => 'sh ls',
						  },
						 ],
				description => "elementary commands",
			       },
			      ],
       description => "commands",
       name => 'commands.t',
      };


return $test;


