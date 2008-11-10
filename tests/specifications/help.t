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
synopsis: <type> must be one of physical, functions, structure, commands, sections, components
",
						   write => 'list',
						  },
						  {
						   description => "Can we find commands ?",
						   read => "all commands:
  - ce
  - compile
  - create
  - current_working_element
  - help
  - list
  - list_elements
  - ndf_load
  - output
  - pwe
  - querymachine
  - quit
  - run
  - sh
",
						   write => 'list commands',
						  },
						  {
						   description => "Can we find the loaded software components ?",
						   read => "Core components:
  heccer:
    description: single neuron equation solver
    module: Heccer
    status: loaded
  model-container:
    description: internal storage for neuronal models
    module: Neurospaces
    status: loaded
  ssp:
    description: binds the software components of a simulation together
    module: SSP
    status: loaded
Other components:
",
						   write => 'list components',
						  },
						  {
						   description => "Can we find functions ?",
						   read => "NERNST",
						   write => 'list functions',
						  },
						  {
						   description => "Can we find physical tokens ?",
						   read => "all physical tokens:
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
  - PARAMETER_GROUP
  - POOL
  - POPULATION
  - PROJECTION
  - RANDOMVALUE
  - SEGMENT
  - SEGMENT_GROUP
",
						   write => 'list physical',
						  },
						 ],
				description => "help commands",
			       },
			      ],
       description => "help commands",
       name => 'help.t',
      };


return $test;


