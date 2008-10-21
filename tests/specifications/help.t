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
						   description => "Can we get a useful synopsis for the list command ?",
						   read => "synopsis: list <type>
synopsis: <type> must be one of commands, packages, tokens
",
						   write => 'list',
						  },
						  {
						   description => "Can we find all commands ?",
						   read => "all commands:
  - ce
  - help
  - list
  - list_elements
  - ndf_load
  - pwe
  - quit
  - run
  - sh
",
						   write => 'list commands',
						  },
						  {
						   description => "Can we find all tokens ?",
						   read => "all tokens:
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
						  {
						   description => "Can we find all packages ?",
						   read => "Core packages:
  SSP:
    status: loaded
  heccer:
    module: Heccer
    status: loaded
  model-container:
    module: Neurospaces
    status: loaded
Other packages:
",
						   write => 'list packages',
						  },
						 ],
				description => "help commands",
			       },
			      ],
       description => "help commands",
       name => 'version.t',
      };


return $test;


