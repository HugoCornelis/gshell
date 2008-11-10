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
						   description => "Can we create a segment ?",
						   write => 'create segment /s',
						  },
						  {
						   description => "Can we create a channel in the segment ?",
						   write => 'create channel /s/na',
						  },
						  {
						   description => "Can we find the channel in the segment ?",
						   read => '/s
- /s/na
',
						   write => 'querymachine expand /**',
						  },
						 ],
				description => "commands for creating a model",
			       },
			      ],
       description => "creating elements",
       name => 'creating_elements.t',
      };


return $test;


