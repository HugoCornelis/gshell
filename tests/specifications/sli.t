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
						   description => "Can we run the current injection script?",
						   write => 'sli_run /usr/local/nsgenesis/tests/scripts/PurkM9_model/CURRENT9.g',
						  },
						  (
						   {
						    description => "Can the morphology be read ?",
						    read => 'tests/scripts/PurkM9_model/Purk2M9.p read: 1600 compartments',
						    timeout => 10,
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total volume ?",
						    read => "value = 5.37774e-14
",
						    write => "printparameter /Purkinje TOTALVOLUME",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total surface ?",
						    read => "value = 2.61092e-07
",
						    write => "printparameter /Purkinje TOTALSURFACE",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: segment count ?",
						    read => "Number of segments : 1600
",
						    write => "segmentcount /Purkinje",
						   },
						   {
						    description => "quit the querymachine",
						    write => "quit",
						   },
						   {
						    description => 'Do we see the simulation time after the simulation has finished ?',
						    read => 'time = 0.500060 ; step = 25003',
						    timeout => 200,
						   },
						   {
						    comment => "The output file is taken from the ns-sli installation.",
						    description => "Is the generated output correct ?",
						    numerical_compare => 'small differences between the output of different architectures',
						    read => {
							     application_output_file => "$::config->{core_directory}/results/PurkM9_soma_1.5nA",
							     expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_soma_1.5nA.g3",
							    },
						    wait => 1,
						   },
						  ),
						 ],
				comment => 'This test uses the original scripts of the Purkinje cell model',
				description => "running a GENESIS 2 script",
				preparation => {
						description => "Create the results directory",
						preparer =>
						sub
						{
						    `mkdir results`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
 						   `rm "$::config->{core_directory}/results/PurkM9_soma_1.5nA"`;
						   `rmdir results`;
					       },
					      },
			       },
			      ],
       description => "running GENESIS 2 scripts and importing their models",
       name => 'sli.t',
      };


return $test;


