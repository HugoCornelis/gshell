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
						   description => "Can we create a voltage clamp circuitry object ?",
						   write => "inputclass_add pulsegen my_pulsegen_freerun name my_pulsegen_freerun level1 50.0 width1 3.0 delay1 5.0 level2 -20.0 width2 5 delay2 8.0 baselevel 10.0 triggermode 0",
						  },
						  {
						   description => "Can we find the input class we just created ?",
						   read => "all input classes:
  my_pulsegen_freerun:
    module_name: Experiment
    options:
      baselevel: 10.0
      delay1: 5.0
      delay2: 8.0
      level1: 50.0
      level2: -20.0
      name: my_pulsegen_freerun
      triggermode: 0
      width1: 3.0
      width2: 5
    package: Experiment::PulseGen
",
						   write => "list inputclasses",
						  },
						  {
						   description => "Can we connect the pulsegen to the cell soma ?",
						   write => "input_add my_pulsegen_freerun /Purkinje/segments/soma Vm",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /Purkinje/segments/soma
  field: Vm
  inputclass: my_pulsegen_freerun
",
						   write => "input_show",
						  },

						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->Vm ?',
						   write => "output_add /Purkinje/segments/soma Vm",
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
						   disabled => "Previous command is not producing an output file for some reason",
						   description => "Can we verify the output ?",

						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/pulsegen-freerun.txt",
							   },
						  },
						 ],
				description => "commands load a simple soma model and connect it to a pulsegen solver object",
				side_effects => "creates a model in the model container",

			      

			       },
			      ],
       description => "Attaching a pulsegen object to a simple soma model.",
       name => 'pulsegen.t',
      };


return $test;
