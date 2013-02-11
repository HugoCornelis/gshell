#!/usr/bin/perl -w
#

use strict;


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
						   description => "Can we load the ndf file with the muscarinic current that uses the 'HH_TABLE_START' and 'HH_TABLE_END' options?",
						   read => "genesis >",
						   write => "ndf_load /usr/local/ns-sli/tests/scripts/test-channels/simplecell-M/simplecell-M.ndf",
						  },
						  {
						   description => "Can we set runtime options to inject current?",
						   read => "genesis >",
						   write => "runtime_parameter_add /cell/soma INJECT 0.5e-9",
						  },
						  {
						   description => "Can we define the somatic membrane potential as output?",
						   read => "genesis >",
						   write => "output_add /cell/soma Vm",
						  },
						  {
						   description => "Can we define the output filename?",
						   read => "genesis >",
						   write => "output_filename output/simplecell-M-ndf_load_Vm.out",
						  },
						  {
						   description => "Can we run the simulation?",
						   read => "genesis >",
						   write => "run /cell 0.5",
						  },
						  {
						   description => "Can we quit the simulator?",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Is the output correct?",
						   numerical_compare => "arithmetic rounding differences expected",
						   read => {
							    application_output_file => "output/simplecell-M-ndf_load_Vm.out",
							    expected_output_file => "/usr/local/ns-sli/tests/scripts/test-channels/simplecell-M/simplecell-M-ndf_load_Vm.out",
							   },
						  },
						 ],
				preparation => {
						description => "Create the output directory.",
						preparer =>
						sub
						{
						    `mkdir --parents output`;
						},
					       },
				reparation => {
					       description => "Remove output file from test run.",
					       reparer =>
					       sub
					       {
						   `rm output/simplecell-M-ndf_load_Vm.out`;
						   `rmdir output`;
					       },
					      },
			       },
			      ],
       description => "testing of the 'HH_TABLE_START' and 'HH_TABLE_END' options",
       overview => `cat "/usr/local/ns-sli/tests/scripts/test-channels/simplecell-M/README.rst"`,
       name => 'simplecell-M.t',
      };


return $test;


