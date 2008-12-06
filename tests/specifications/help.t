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
synopsis: <type> must be one of commands, components, functions, physical, sections, structure, verbose
synopsis: (you gave )
",
						   write => 'list',
						  },
						  {
						   description => "Can we find commands ?",
						   read => "all commands:
  - add_output
  - ce
  - create
  - delete
  - echo
  - help
  - list
  - list_elements
  - ndf_load
  - pwe
  - querymachine
  - quit
  - run
  - set_model_parameter
  - set_runtime_parameter
  - set_verbose
  - sh
  - show_global_time
  - show_library
  - show_parameter
  - show_runtime_parameters
  - show_verbose
",
						   write => 'list commands',
						  },
						  {
						   description => "Can we find the loaded software components ?",
						   read => "Core components:
  gshell:
    description: the GENESIS 3 shell allows convenient interaction with other components
    module: GENESIS3
    status: loaded
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


