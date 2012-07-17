#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/network-1x2.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates a 1x2 network?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/network-1x2.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates a 1x2 network",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "A network consisting of a 1x2 network.",
       name => 'network-1x2.t',
      };


return $test;


