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
						  },
						  {
						   description => "Can we load a simple cell model ?",
						   write => 'ndf_load cells/RScell-nolib.ndf',
						  },
						  {
						   description => "Can we create a current clamp circuitry object ?",
						   write => "inputclass_add perfectclamp current_injection_protocol name current_injection command 1e-9",
						  },
						  {
						   description => "Can we connect the current clamp circuitry to the simple cell's soma ?",
						   write => "input_add current_injection_protocol /cell/soma INJECT",
						  },
						  {
						   description => "Can we add an output to the soma's Vm ?",
						   write => "output_add /cell/soma Vm",
						  },
						  {
						   description => "Can we set the output mode to \"steps\" ?",
						   write => 'output_mode steps',
						  },
						  {
						   description => "Can we set the output resolution to 10 ?",
						   write => 'output_resolution 10',
						  },
						  {
						   description => "Can we run the simulation for a limited amount of time?",
						   write => "run /cell 0.2",
						  },
						  {
						   description => "Can we quit the simulator?",
						   write => "quit",
						  },
						  {
						   description => "Do we see the expected output ?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/network-simple.txt",
							   },
						   wait => 2,
						  },
						 ],
				description => "preparation commands for network simulations",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "A simple network model (in preparation).",
       name => 'network-simple.t',
      };


return $test;


