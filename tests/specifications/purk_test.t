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
						   description => "Can we load the standard purkinje cell model ?",
						   write => "ndf_load tests/cells/purk_test_segment.ndf",
						  },
						  {
						   description => "Can we find the root element of the model ?",
						   read => "
- /purk_test_segment
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we create a current clamp circuitry object ?",
						   write => "inputclass_add perfectclamp current_injection_protocol name current_injection command 2e-9",
						  },
						  {
						   description => "Can we connect the current clamp circuitry to the purkinje cell soma ?",
						   write => "input_add current_injection_protocol /purk_test_segment/segments/test_segment INJECT",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment Vm ?",
						   write => "output_add /purk_test_segment/segments/test_segment Vm",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/cat/cat_gate_activation state_m",
						   write => "output_add /purk_test_segment/segments/test_segment/cat/cat_gate_activation state_m",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/cat/cat_gate_inactivation state_h",
						   write => "output_add /purk_test_segment/segments/test_segment/cat/cat_gate_inactivation state_h",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/kdr state_m",
						   write => "output_add /purk_test_segment/segments/test_segment/kdr state_m",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/kdr state_h",
						   write => "output_add /purk_test_segment/segments/test_segment/kdr state_h",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/nap state_n",
						   write => "output_add /purk_test_segment/segments/test_segment/nap state_n",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/naf state_m",
						   write => "output_add /purk_test_segment/segments/test_segment/naf state_m",
						  },
						  {
						   description => "Can we add an output for /purk_test_segment/segments/test_segment/naf state_h",
						   write => "output_add /purk_test_segment/segments/test_segment/naf state_h",
						  },
						  {
						   description => "Can we run the simulation ?",
						   read => "genesis",
						   wait => 4,
						   write => "run /purk_test_segment 0.1",
						  },
# 						  {
# 						   description => "Can we find the output file in the file system ?",
# 						   read => " output
# ",
# 						   timeout => 4,
# 						   write => "sh ls -l /tmp/",
# 						  },
						  {
						   description => "Can we find the output ?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/purkinje/purk_test.txt",
							   },
						   timeout => 4,
# 						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands for a simple simulation of the purkinje cell model",
				disabled => (
					     $^O =~ /^darwin/i
					     ? "this test is disabled on darwin (aka MAC) based systems"
					     : ""
					    ),
				mac_report => 'Test fails from a possible IO lock/lag. The output file /tmp/output is empty. When executing the commands of the test this case completes fine and the output matches the expected output. This test also completes fine on 64bit Mac OSX with no signs of the lock/lag.',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "simple simulations of parts of the purkinje cell model",
       name => 'purk_test.t',
      };


return $test;


