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
						   description => "Can we load the purkinje cell model ?",
						   write => 'ndf_load cells/purkinje/edsjb1994.ndf',
						  },
						  {
						   description => "Can we set the endogenous frequency for inhibitory channels ?",
						   write => "set_runtime_parameter thickd::gaba::/Purk_GABA FREQUENCY 1",
						  },
						  {
						   description => "Can we set the endogenous frequency for excitatory channels ?",
						   write => "set_runtime_parameter spine::/Purk_spine/head/par FREQUENCY 25",
						  },
						  {
						   description => "Can we get information about the runtime_parameters ?",
						   read => "
runtime_parameters:
  - component_name: thickd::gaba::/Purk_GABA
    field: FREQUENCY
    value: 1
    value_type: number
  - component_name: spine::/Purk_spine/head/par
    field: FREQUENCY
    value: 25
    value_type: number
",
						   write => "show_runtime_parameters",
						  },
						  {
						   description => "Can we define the output /Purkinje/segments/soma ?",
						   wait => 1,
						   write => "add_output /Purkinje/segments/soma Vm",
						  },
						  {
						   description => "Can we define the output /Purkinje/segments/soma/ca_pool ?",
						   wait => 1,
						   write => "add_output /Purkinje/segments/soma/ca_pool Ca",
						  },
						  {
						   description => "Can we define the output /Purkinje/segments/b0s01[0] ?",
						   wait => 1,
						   write => "add_output /Purkinje/segments/b0s01[0] Vm",
						  },
# 						  {
# 						   description => "Can we check the simulation ?",
# 						   wait => 1,
# 						   write => "check /Purkinje",
# 						  },
						  {
						   description => "Can we run the simulation ?",
						   wait => 1,
						   write => "run /Purkinje 0.1",
						  },
						  {
						   description => "Can we find the output ?",
						   disabled => (`cat /usr/local/include/heccer/config.h` !~ m/define RANDOM.*ran1/ ? 'not using ran1() as heccer random number generator' : 0),
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt",
							   },
						   todo => "make this test work with the other heccer rng",
						   wait => 100,
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file, endogenous / poissonian activation",
				disabled => 'the gshell hangs after execution of one of the commands ...',
				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
				todo => 'the gshell hangs after execution of one of the command ...',
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/simple_purkinje_endogenous.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run the purkinje cell with endogenous / poissonian activation from a G3 batch file ?",
						   disabled => (`cat /usr/local/include/heccer/config.h` !~ m/define RANDOM.*ran1/ ? 'not using ran1() as heccer random number generator' : 0),
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt",
							   },
						   todo => "make this test work with the other heccer rng",
						   wait => 100,
						  },
						 ],
				description => "running the purkinje cell with endogenous / poissonian activation from a G3 batch file",
				numerical_compare => 'arithmetic rounding differences between different architectures',
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/simple_purkinje_endogenous",
				command_tests => [
						  {
						   description => "Can we run the purkinje cell with endogenous / poissonian activation from a perl script ?",
						   disabled => (`cat /usr/local/include/heccer/config.h` !~ m/define RANDOM.*ran1/ ? 'not using ran1() as heccer random number generator' : 0),
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt",
							   },
						   wait => 100,
						  },
						 ],
				description => "running the purkinje cell with current injection from a perl script",
				numerical_compare => 'arithmetic rounding differences between different architectures',
			       },
			      ],
       description => "poissonian / endogenous synaptic activation",
       name => 'endogenous.t',
      };


return $test;


