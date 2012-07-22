#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/rsnet-2x2-volumeconnect",
				command_tests => [
						  {
						   description => "Can we run a 2x2 instance of the rsnet network, uses the volumeconnect command?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rsnet-2x2.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a 2x2 instance of the rsnet network that uses the volumeconnect command",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/rsnet-2x2-createprojection",
				command_tests => [
						  {
						   description => "Can we run a 2x2 instance of the rsnet network, uses the createprojection command?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rsnet-2x2.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a 2x2 instance of the rsnet network that uses the createprojection command",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "2x2 instances of the rsnet network.",
       name => 'network-rsnet-2x2.t',
      };


return $test;


