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
						   description => "Can we load a simple soma model ?",
						   write => 'ndf_load cells/purkinje/edsjb1994.ndf',
						  },
						  {
						   description => "Can we find the input class template we would like to use ?",
						   read => "all input class templates:
  perfectclamp:
    module_name: Experiment
    options:
      command: command value
      name: name of this inputclass
    package: Experiment::PerfectClamp
  pulsegen:
    module_name: Experiment
    options:
      baselevel: The pulse base level
      delay1: First pulse delay
      delay2: Second pulse delay
      level1: First pulse level
      level2: Second pulse level
      name: name of this inputclass
      triggermode: 'The pulse triggermode, 0 - freerun, 1 - ext trig, 2 - ext gate'
      width1: First pulse width
      width2: Second pulse width
    package: Experiment::PulseGen
",
						   write => "list inputclass_templates",
						  },
						  {
						   description => "Can we create a pulsegen object ?",
						   write => "inputclass_add pulsegen my_pulsegen_freerun name my_pulsegen_freerun baselevel 0.0 level1 1e-10 width1 0.001 delay1 0.001 level2 1e-9 width2 0.005 delay2 0.002 triggermode 0",
						  },
						  {
						   description => "Can we find the pulsegen input class we just created ?",
						   read => "all input classes:
  my_pulsegen_freerun:
    module_name: Experiment
    options:
      baselevel: 0.0
      delay1: 0.001
      delay2: 0.002
      level1: 1e-10
      level2: 1e-9
      name: my_pulsegen_freerun
      triggermode: 0
      width1: 0.001
      width2: 0.005
    package: Experiment::PulseGen
",
						   write => "list inputclasses",
						  },
						  {
						   description => "Can we connect the pulsegen to the cell soma ?",
						   write => "input_add my_pulsegen_freerun /Purkinje/segments/soma INJECT",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /Purkinje/segments/soma
  field: INJECT
  inputclass: my_pulsegen_freerun
",
						   write => "input_show",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->Vm ?',
						   write => "output_add /Purkinje/segments/soma Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->INJECT ?',
						   write => "output_add /Purkinje/segments/soma INJECT",
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /Purkinje",
						  },
						  {
						   description => "Has correct output been produced?",
						   write => "run /Purkinje 0.1",
						  },
						  {
						   description => "Can we verify the output ?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/pulsegen-freerun.txt",
							   },
						   wait => 20,
						  },
						 ],
				description => "simple application of a pulsegen protocol",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "Attaching a pulsegen object to a simple soma model.",
       name => 'pulsegen.t',
      };


return $test;


