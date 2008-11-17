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
						   description => "Can we run the simulation ?",
						   write => "run /c 0.001",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "0.001 -0.0687098",
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands for a single passive compartment created from the shell",
			       },
			      ],
       description => "simple simulations of models",
       name => 'simple_run.t',
      };


return $test;


