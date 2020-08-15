#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::global_config->{core_directory}/tests/scripts/network-1x4.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates a 1x4 network?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-1x4.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates a 1x4 network",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/network-1x4",
				command_tests => [
						  {
						   description => "Can we run a G-3 perl script that instantiates a 1x4 network?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-1x4.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 perl script that instantiates a 1x4 network",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/network-1x4-loops",
				command_tests => [
						  {
						   description => "Can we run a G-3 perl script with loops that instantiates a 1x4 network?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-1x4-loops.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 perl script with loops that instantiates a 1x4 network",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::global_config->{core_directory}/tests/scripts/network-1x4-loops2",
				command_tests => [
						  {
						   description => "Can we run a G-3 perl script with loops that instantiates a 1x4 network, different connection parameters?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-1x4.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 perl script with loops that instantiates a 1x4 network, different connection parameters",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "A network consisting of a 1x4 network.",
       name => 'network-1x4.t',
      };


return $test;


