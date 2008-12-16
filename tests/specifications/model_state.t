#!/usr/bin/perl -w
#

use strict;


my $simple_purkinje_txt = '';


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/model_state_singlep",
				command_tests => [
						  {
						   description => "Can we reinitialize using the serialized state of a single passive compartment, saved state ?",
						   read => '
0.09992 -0.0799729
0.09994 -0.0799729
0.09996 -0.079973
0.09998 -0.079973
0.1 -0.079973
',
						   timeout => 10,
						  },
						  {
						   description => "Can we reinitialize using the serialized state of a single passive compartment, computed state ?",
						   read => '
0.19992 -0.0799729
0.19994 -0.0799729
0.19996 -0.079973
0.19998 -0.079973
0.2 -0.079973
',
						   timeout => 10,
						  },
						 ],
				description => "reinitializing using the serialized state of a single passive compartment",
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/model_state_purkinje",
				command_tests => [
						  {
						   description => "Can we reinitialize using the serialized state of the purkinje cell, saved state ?",
						   read => '
0.09992 -0.0799729
0.09994 -0.0799729
0.09996 -0.079973
0.09998 -0.079973
0.1 -0.079973
',
						   timeout => 100,
						  },
						  {
						   description => "Can we reinitialize using the serialized state of the purkinje cell, computed state ?",
						   read => '
0.19992 -0.0799729
0.19994 -0.0799729
0.19996 -0.079973
0.19998 -0.079973
0.2 -0.079973
',
						   timeout => 10,
						  },
						 ],
				description => "reinitializing using the serialized state of the purkinje cell",
# 				disabled => "testing only, should be enabled again",
			       },
			      ],
       description => "model state saving and loading",
       name => 'model_state.t',
      };


return $test;


