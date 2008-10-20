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
						   description => "Can we find all tokens ?",
						   read => "
all tokens:
  - ALGORITHM
  - ATTACHMENT_POINT
  - AXON_HILLOCK
  - CELL
  - CHANNEL
  - CONCENTRATION_GATE_KINETIC
  - CONNECTION
  - CONNECTION_GROUP
  - CONTOUR_GROUP
  - CONTOUR_POINT
  - EM_CONTOUR
  - EXPONENTIAL_EQUATION
  - FIBER
  - GROUP
  - HH_GATE
  - NETWORK
  - POOL
  - POPULATION
  - PROJECTION
  - RANDOMVALUE
  - SEGMENT
  - SEGMENT_GROUP
",
						   write => 'list tokens',
						  },
						 ],
				description => "help commands",
			       },
			      ],
       description => "help commands",
       name => 'version.t',
      };


return $test;


