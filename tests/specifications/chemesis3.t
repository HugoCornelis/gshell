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
				command => 'tests/scripts/chemesis3-cal1',
				command_tests => [
						  {
						   description => "Is a chemesis3 model solved correctly, cal1, three pools one reaction ?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "/usr/local/ssp/tests/specifications/strings/chemesis3/cal1.txt",
							   },
						   wait => 2,
						  },
						 ],
				description => "chemesis3, cal1, three pools one reaction",
				reparation => {
					       description => "Remove output file from test run.",
					       reparer =>
					       sub
					       {
						   `rm /tmp/output`;
					       },
					      },
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
						   description => "Can we enable the chemesis3 solver?",
						   read => "genesis >",
						   timeout => 5,
						   write => "component_load chemesis3",
						  },
						  {
						   description => "Can we load the chemesis3 cal1 model from the NDF file?",
						   write => "ndf_load chemesis/cal1.ndf",
						  },
						  {
						   description => "Can we set the chemesis3 time step?",
						   write => "chemesis3_set_timestep 0.002",
						  },
						  {
						   description => "Can we add the somaCa output?",
						   write => "output_add /cal1/somaCa concentration",
						  },
						  {
						   description => "Can we add the somaCabuf output?",
						   write => "output_add /cal1/somaCabuf concentration",
						  },
						  {
						   description => "Can we add the somabuf output?",
						   write => "output_add /cal1/somabuf concentration",
						  },
						  {
						   description => "Can we run the simulation?",
						   wait => 2,
						   write => "run /cal1 2",
						  },
						 ],
				description => "chemesis3, cal1, three pools one reaction",
				reparation => {
					       description => "Remove output file from test run.",
					       reparer =>
					       sub
					       {
						   `rm /tmp/output`;
					       },
					      },
			       },
			      ],
       description => "chemesis3",
       name => 'integration/chemesis3.t',
      };


return $test;


