#!/usr/bin/perl -w
#

use strict;


my $simple_purkinje_txt = 'loading purkinje cell
loaded
applying current injection
running for 0.001sec
output follows:
2e-05 -0.0672264
4e-05 -0.0665857
6e-05 -0.0660166
8e-05 -0.0655132
0.0001 -0.065058
0.00012 -0.0646468
0.00014 -0.0642712
0.00016 -0.0639279
0.00018 -0.063612
0.0002 -0.0633209
0.00022 -0.0630513
0.00024 -0.0628012
0.00026 -0.0625685
0.00028 -0.0623513
0.0003 -0.0621481
0.00032 -0.0619575
0.00034 -0.0617785
0.00036 -0.0616098
0.00038 -0.0614506
0.0004 -0.0612999
0.00042 -0.0611572
0.00044 -0.0610216
0.00046 -0.0608925
0.00048 -0.0607695
0.0005 -0.060652
0.00052 -0.0605396
0.00054 -0.0604319
0.00056 -0.0603285
0.00058 -0.060229
0.0006 -0.0601333
0.00062 -0.0600409
0.00064 -0.0599517
0.00066 -0.0598655
0.00068 -0.059782
0.0007 -0.059701
0.00072 -0.0596224
0.00074 -0.0595461
0.00076 -0.0594717
0.00078 -0.0593993
0.0008 -0.0593287
0.00082 -0.0592598
0.00084 -0.0591925
0.00086 -0.0591267
0.00088 -0.0590623
0.0009 -0.0589992
0.00092 -0.0589374
0.00094 -0.0588767
0.00096 -0.0588172
0.00098 -0.0587587
0.001 -0.0587013
';


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
						   description => "Can we load the purkinje cell model ?",
						   write => 'ndf_load cells/purkinje/edsjb1994.ndf',
						  },
						  {
						   description => "Can prepare the morphology of a structural analysis ?",
						   read => '
---
Number of segments: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   write => "morphology_summarize /Purkinje",
						  },
						  {
						   description => "Can we get information about the number of branch points for a chosen dendritic segment ?",
						   read => "value = 23",
						   write => "parameter_show /Purkinje/segments/b1s06[182] SOMATOPETAL_BRANCHPOINTS",
						  },
						  {
						   description => "Can we attach an event list to this dendritic segment ?",
						   write => "runtime_parameter_add /Purkinje/segments/b1s06[182]/Purkinje_spine_0/head/par/synapse EVENT_FILENAME event_data/events.yml",
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
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0587013
",
						   timeout => 100,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file, single synaptic stimulation",
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      "$::global_config->{core_directory}/tests/scripts/simple_purkinje.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run the purkinje cell with single synaptic stimulation from a G-3 batch file ?",
						   read => $simple_purkinje_txt,
						   timeout => 100,
						  },
						 ],
				description => "running the purkinje cell with single synaptic stimulation from a G-3 batch file",
			       },
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/simple_purkinje",
				command_tests => [
						  {
						   description => "Can we run the purkinje cell with single synaptic stimulation from a perl script ?",
						   read => $simple_purkinje_txt,
						   timeout => 100,
						  },
						 ],
				description => "running the purkinje cell with single synaptic stimulation from a perl script",
			       },
			      ],
       description => "single synaptic stimulation simulations",
       disabled => 'currently various problems, just try and see',
       name => 'single_synapse.t',
      };


return $test;


