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
						   write => 'ndf_load tests/segments/soma.ndf',
						  },
						  {
						   description => "Can we find the input class template we would like to use ?",
						   read => "all input class templates:
  perfectclamp:
    module_name: Heccer
    options:
      command: command value
      name: name of this inputclass
    package: Heccer::PerfectClamp
  pulsegen:
    module_name: Heccer
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
    package: Heccer::PulseGen
",
						   write => "list inputclass_templates",
						  },
						  {
						   description => "Can we create a voltage clamp circuitry object ?",
						   write => "inputclass_add pulsegen my_pulsegen_freerun name my_pulsegen_freerun level1 50.0 width1 3.0 delay 5.0 level2 -20.0 width2 5 delay2 8.0 baselevel 10.0 triggermode 0",
						  },
						  {
						   description => "Can we find the input class we just created ?",
						   read => "all input classes:
  my_pulsegen_freerun:
    module_name: Heccer
    options:
      baselevel: 10.0
      delay: 5.0
      delay1: First pulse delay
      delay2: 8.0
      level1: 50.0
      level2: -20.0
      name: my_pulsegen_freerun
      triggermode: 0
      width1: 3.0
      width2: 5
    package: Heccer::PulseGen
",
						   write => "list inputclasses",
						  },
						  {
						   description => "Can we connect the pulsegen to the cell soma ?",
						   write => "input_add my_pulsegen_freerun /soma Vm",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /soma
  field: Vm
  inputclass: my_pulsegen_freerun
",
						   write => "input_show",
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
