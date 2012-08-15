#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/db-rsnet-4x4-volumeconnect-refract",
				command_tests => [
						  {
						   description => "Is the default refractory period used correctly?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/output_refract.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "default refractory period",
				disabled => "missing output file",
				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/db-rsnet-4x4-volumeconnect-refract004",
				command_tests => [
						  {
						   description => "Is a refractory period of 004 used correctly?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/output_refract_004.txt",
							   },
						   wait => 3,
						  },
						 ],
				comment => 'RSnet_Vm_4x4_refract_004.txt and output_refract_004 - hard to see any differences',
				description => "refractory period 004",
				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/db-rsnet-4x4-volumeconnect-refract010",
				command_tests => [
						  {
						   description => "Is refractory period of 010 used correctly?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/output_refract_010.txt",
							   },
						   wait => 3,
						  },
						 ],
				comment => 'RSnet_Vm_4x4_refract_010.txt and output_refract_010 - similar but slight diffs - around 0.1 sec',
				description => "refractory period 010",
				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/scripts/db-rsnet-4x4-volumeconnect-refract020",
				command_tests => [
						  {
						   description => "Is refractory period of 020 used correctly?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/output_refract_020.txt",
							   },
						   wait => 3,
						  },
						 ],
				comment => 'RSnet_Vm_4x4_refract_020.txt and output_refract_020 - no perceptible difference',
				description => "refractory period 020",
				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "different values of the refractory period",
       name => 'refractory.t',
      };


return $test;


