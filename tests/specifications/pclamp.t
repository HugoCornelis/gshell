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
						   description => "Can we find the input class template we would like to use ?",
						   read => "all input class templates:
  perfectclamp:
    module_name: Heccer
    options:
      command: command voltage
      name: name of this inputclass
    package: Heccer::PerfectClamp
",
						   write => "list inputclass_templates",
						  },
						  {
						   description => "Can we create a voltage clamp circuitry object ?",
						   write => "add_inputclass perfectclamp voltage_clamp_protocol name voltage_clamp_protocol command -0.060",
						  },
						  {
						   description => "Can we find the input class we just created ?",
						   read => "all input classes:
  voltage_clamp_protocol:
    module_name: Heccer
    options:
      command: -0.060
      name: voltage_clamp_protocol
    package: Heccer::PerfectClamp
",
						   write => "list inputclasses",
						  },
						  {
						   description => "Can we connect the voltage clamp circuitry to the purkinje cell soma ?",
						   write => "add_input voltage_clamp_protocol /Purkinje/segments/soma Vm",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /Purkinje/segments/soma
  field: Vm
  inputclass: voltage_clamp_protocol
",
						   write => "show_inputs",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->Vm ?',
						   write => "add_output /Purkinje/segments/soma Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s01[0]->Vm ?',
						   write => "add_output /Purkinje/segments/b0s01[0] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s03[56]->Vm ?',
						   write => "add_output /Purkinje/segments/b0s03[56] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s06[137]->Vm ?',
						   write => "add_output /Purkinje/segments/b1s06[137] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s12[26]->Vm ?',
						   write => "add_output /Purkinje/segments/b1s12[26] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b2s30[3]->Vm ?',
						   write => "add_output /Purkinje/segments/b2s30[3] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b3s44[49]->Vm ?',
						   write => "add_output /Purkinje/segments/b3s44[49] Vm",
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /Purkinje",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /Purkinje 0.5",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0587013
",
						   timeout => 200,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file, voltage clamp",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "voltage clamp of models",
       name => 'pclamp.t',
      };


return $test;


