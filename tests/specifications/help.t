#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--help',
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Do we get an informative help message when the help command line option is given?",
						   read => "GENESIS 3 shell.

options:
    help               print usage information.
    verbose            set verbosity level ('errors', 'informational', 'debug').
    version            give version information.
",
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "the help command line option",
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
						   description => "Can we find the top level help topics ?",
						   read => "synopsis: help <topic>
synopsis: <topic> must be one of commands, components, variables, libraries
",
						   write => "help",
						  },
						  {
						   description => "Can we find the command help subtopics ?",
						   read => "
description: help on a specific command
synopsis: 'help command <command_name>'
all commands:
",
						   write => "help command",
						  },
						  {
						   description => "Can we find the command help for a specific command ?",
						   read => "
description: add a variable to the output file
synopsis: add_output <element_name> <field_name>
",
						   write => "help command add_output",
						  },
						  {
						   description => "Can we find the component help subtopics ?",
						   read => "
description: help on a specific software component
synopsis: 'help component <component_name>'
Core components:
",
						   write => "help component",
						  },
						  {
						   description => "Can we find the component help subtopics ?",
						   read => "
description: simple scheduler in perl
usage: |-
  The simple scheduler in perl binds together software components for
  running simulations.  It is based on services and solvers: services
  provide functionality to assist the solvers to construct an
  efficient simulation run-time environment, solvers apply algorithms
  to solve the problem posed, numerically or otherwise.
",
						   write => "help component ssp",
						  },
						 ],
				description => "the help command and its topics",
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
  - model_state_load
  - model_state_save
  - ndf_load
  - ndf_save
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
  - ATTACHMENT
  - AXON_HILLOCK
  - CELL
  - CHANNEL
  - CONCENTRATION_GATE_KINETIC
  - CONNECTION
  - CONNECTION_GROUP
  - CONTOUR_GROUP
  - CONTOUR_POINT
  - EM_CONTOUR
  - EQUATION_EXPONENTIAL
  - FIBER
  - GROUP
  - GROUPED_PARAMETERS
  - HH_GATE
  - NETWORK
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
				description => "list commands",
			       },
			      ],
       description => "help commands",
       name => 'help.t',
      };


return $test;


