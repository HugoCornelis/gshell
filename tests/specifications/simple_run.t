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
						   description => "Can we create a cell ?",
						   write => 'create cell /c',
						  },
						  {
						   description => "Can we create a segment ?",
						   write => 'create segment /c/s',
						  },
						  {
						   description => "Can we set parameter CM of the segment ?",
						   write => 'set_model_parameter /c/s CM 0.0164',
						  },
						  {
						   description => "Can we set parameter Vm_init of the segment ?",
						   write => 'set_model_parameter /c/s Vm_init -0.0680',
						  },
						  {
						   description => "Can we set parameter RM of the segment ?",
						   write => 'set_model_parameter /c/s RM 1.000',
						  },
						  {
						   description => "Can we set parameter RA of the segment ?",
						   write => 'set_model_parameter /c/s RA 2.50',
						  },
						  {
						   description => "Can we set parameter ELEAK of the segment ?",
						   write => 'set_model_parameter /c/s ELEAK -0.080',
						  },
						  {
						   description => "Can we set parameter DIA of the segment ?",
						   write => 'set_model_parameter /c/s DIA 2e-05',
						  },
						  {
						   description => "Can we set parameter LENGTH of the segment ?",
						   write => 'set_model_parameter /c/s LENGTH 4.47e-05',
						  },
						  {
						   description => "Can we define the output ?",
						   write => "add_output /c/s Vm",
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /c",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /c 0.001",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands for a single passive compartment created from the shell",
				side_effects => "creates a model in the model container",
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
						   description => "Can we load the purkinje cell model ?",
						   write => 'ndf_load cells/purkinje/edsjb1994.ndf',
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /Purkinje",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /Purkinje 0.001",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0678441
",
						   timeout => 100,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file",
				side_effects => "creates a model in the model container",
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
						   description => "Can we load a single passive compartment model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /singlep 0.001",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Can we determine the size of the output ?",
						   read => "50 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						  {
						   description => "Can we check the simulation again ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we reset the simulation ?",
						   write => "reset /singlep",
						  },
						  {
						   description => "Is the output file empty ?",
						   read => "0 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   description => "Can we rerun the simulation ?",
						   write => "run /singlep 0.001",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Has output been reproduced again?",
						   read => "50 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Do we find the same output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						  {
						   description => "Can we check the simulation once more ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we reset the simulation once more ?",
						   write => "reset /singlep",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Is the output file again empty ?",
						   read => "0 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						 ],
				description => "run, checking and resetting a simulation",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "simple simulations of models, checking and resetting a simulation",
       name => 'simple_run.t',
      };


return $test;


