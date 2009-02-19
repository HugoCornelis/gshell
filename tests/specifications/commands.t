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
						   description => "Can we execute system shell commands ?",
						   read => "Makefile",
						   write => 'sh ls',
						  },
						 ],
				description => "system shell interaction",
			       },
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
						   description => "Can we create a cell ?",
						   write => 'create cell /c',
						  },
						  {
						   description => "Can we create a segment ?",
						   write => 'create segment /c/s',
						  },
						  {
						   description => "Can we change the working element to the cell, absolute path ?",
						   write => 'ce /c',
						  },
						  {
						   description => "Has the working element changed to the cell, absolute path ?",
						   read => '/c
',
						   write => 'pwe',
						  },
						  {
						   description => "Can we change the working element to the segment, absolute path ?",
						   write => 'ce /c/s',
						  },
						  {
						   description => "Has the working element changed to the segment, absolute path ?",
						   read => '/c/s
',
						   write => 'pwe',
						  },
						  {
						   description => "Can we change the working element to the cell, relative path ?",
						   write => 'ce ../..',
						  },
						  {
						   description => "Has the working element changed to the cell, relative path ?",
						   read => '/
',
						   write => 'pwe',
						  },
						  {
						   description => "Can we change the working element to the cell, relative path ?",
						   write => 'ce c',
						  },
						  {
						   description => "Has the working element changed to the cell, relative path ?",
						   read => '/c
',
						   write => 'pwe',
						  },
						  {
						   description => "Can we change the working element to the segment, relative path ?",
						   write => 'ce s',
						  },
						  {
						   description => "Has the working element changed to the segment, relative path ?",
						   read => '/c/s
',
						   write => 'pwe',
						  },
						 ],
				description => "working element",
			       },
			      ],
       description => "commands",
       name => 'commands.t',
      };


return $test;


