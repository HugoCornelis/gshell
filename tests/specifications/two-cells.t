#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-cells1.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-cells1.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "Two cells connected in different ways.",
       name => 'two-cells.t',
      };


return $test;


