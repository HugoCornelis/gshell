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
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we load the cell model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
						  },
						  {
						   description => "Can we set the output format to \" %3.f\" ?",
						   disabled => "this feature is tested in one of the following tests",
						   write => 'output_format " %.3f"',
						  },
						  {
						   description => "Can we set the solver time step ?",
						   write => 'heccer_set_timestep 1e-5',
						  },
						  {
						   description => "Can we run the simulation ?",
						   wait => 1,
						   write => 'run /singlep 0.001',
						  },
						  {
						   description => "Can we produce simple output with simulation time?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "/usr/local/ssp/tests/specifications/strings/output1.txt",
							   },
						  },
						 ],
				description => "simple output with simulation time",
				side_effects => "creates a model in the model-container",
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
						  },
						  {
						   description => "Can we load the cell model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
						  },
						  {
						   description => "Can we set the output mode to \"steps\" ?",
						   write => 'output_mode steps',
						  },
						  {
						   description => "Can we set the solver time step ?",
						   write => 'heccer_set_timestep 1e-5',
						  },
						  {
						   description => "Can we run the simulation ?",
						   wait => 1,
						   write => 'run /singlep 0.001',
						  },
						  {
						   description => "Can we produce simple output with simulation time?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "/usr/local/ssp/tests/specifications/strings/output2.txt",
							   },
						  },
						 ],
				description => "simple output with simulation time",
				side_effects => "creates a model in the model-container",
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
						  },
						  {
						   description => "Can we load the cell model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
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
						   description => "Can we set the solver time step ?",
						   write => 'heccer_set_timestep 1e-5',
						  },
						  {
						   description => "Can we run the simulation ?",
						   wait => 1,
						   write => 'run /singlep 0.001',
						  },
						  {
						   description => "Can we produce simple output with simulation time?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "/usr/local/ssp/tests/specifications/strings/output3.txt",
							   },
						  },
						 ],
				description => "simple output with simulation time",
				side_effects => "creates a model in the model-container",
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
						  },
						  {
						   description => "Can we load the cell model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
						  },
						  {
						   description => "Can we set the output mode to \"steps\" ?",
						   write => 'output_mode steps',
						  },
						  {
						   description => "Can we set the output format to \" %.3f\" ?",
						   write => 'output_format %.3f',
						  },
						  {
						   description => "Can we set the solver time step ?",
						   write => 'heccer_set_timestep 1e-5',
						  },
						  {
						   description => "Can we run the simulation ?",
						   wait => 1,
						   write => 'run /singlep 0.001',
						  },
						  {
						   description => "Can we produce simple output with simulation time?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "/usr/local/ssp/tests/specifications/strings/output4.txt",
							   },
						  },
						 ],
				description => "simple output with simulation time",
				side_effects => "creates a model in the model-container",
			       },
			      ],
       description => "output functions",
       name => 'output.t',
      };


return $test;


