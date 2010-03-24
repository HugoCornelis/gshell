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
      command: command value
      name: name of this inputclass
    package: Heccer::PerfectClamp
",
						   write => "list inputclass_templates",
						  },
						  {
						   description => "Can we create a voltage clamp circuitry object ?",
						   write => "inputclass_add perfectclamp voltage_clamp_protocol name voltage_clamp_protocol command -0.060",
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
						   write => "input_add voltage_clamp_protocol /Purkinje/segments/soma Vm",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /Purkinje/segments/soma
  field: Vm
  inputclass: voltage_clamp_protocol
",
						   write => "input_show",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->Vm ?',
						   write => "output_add /Purkinje/segments/soma Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s01[0]->Vm ?',
						   write => "output_add /Purkinje/segments/b0s01[0] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s03[56]->Vm ?',
						   write => "output_add /Purkinje/segments/b0s03[56] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s06[137]->Vm ?',
						   write => "output_add /Purkinje/segments/b1s06[137] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s12[26]->Vm ?',
						   write => "output_add /Purkinje/segments/b1s12[26] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b2s30[3]->Vm ?',
						   write => "output_add /Purkinje/segments/b2s30[3] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b3s44[49]->Vm ?',
						   write => "output_add /Purkinje/segments/b3s44[49] Vm",
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
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 20,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file, voltage clamp",
				side_effects => "creates a model in the model container",
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
      command: command value
      name: name of this inputclass
    package: Heccer::PerfectClamp
",
						   write => "list inputclass_templates",
						  },
						  {
						   description => "Can we create a current clamp circuitry object ?",
						   write => "inputclass_add perfectclamp current_clamp_protocol name current_clamp_protocol command 1e-9",
						  },
						  {
						   description => "Can we find the input class we just created ?",
						   read => "all input classes:
  current_clamp_protocol:
    module_name: Heccer
    options:
      command: 1e-9
      name: current_clamp_protocol
    package: Heccer::PerfectClamp
",
						   write => "list inputclasses",
						  },
						  {
						   description => "Can we connect the current clamp circuitry to the purkinje cell soma ?",
						   write => "input_add current_clamp_protocol /Purkinje/segments/soma INJECT",
						  },
						  {
						   description => "Can we get information about the applied inputs ?",
						   read => "
- component_name: /Purkinje/segments/soma
  field: INJECT
  inputclass: current_clamp_protocol
",
						   write => "input_show",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/soma->Vm ?',
						   write => "output_add /Purkinje/segments/soma Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s01[0]->Vm ?',
						   write => "output_add /Purkinje/segments/b0s01[0] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b0s03[56]->Vm ?',
						   write => "output_add /Purkinje/segments/b0s03[56] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s06[137]->Vm ?',
						   write => "output_add /Purkinje/segments/b1s06[137] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b1s12[26]->Vm ?',
						   write => "output_add /Purkinje/segments/b1s12[26] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b2s30[3]->Vm ?',
						   write => "output_add /Purkinje/segments/b2s30[3] Vm",
						  },
						  {
						   description => 'Can we add an output for /Purkinje/segments/b3s44[49]->Vm ?',
						   write => "output_add /Purkinje/segments/b3s44[49] Vm",
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
						   comment => "This is supposed to produce the same as /usr/local/ssp/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-current.txt, but it is slightly different",
						   description => "Can we find the output ?",
						   numerical_compare => 'differences',
# 						   read => (join '', `cat /usr/local/ssp/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-current.txt`),
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-current.txt`),
						   timeout => 20,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file, current clamp",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "clamping parameters of a model to a (series of) predefined value(s)",
       name => 'pclamp.t',
      };


return $test;


