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
						   description => "Is startup successful?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we load the model neuron?",
						   write => 'ndf_namespace_load rscell cells/RScell-nolib2.ndf',
						  },
						  {
						   description => "Can we create the first neuron out of two?",
						   write => 'create network /two_cells',
						  },
						  {
						   description => "Can we create the first neuron out of two?",
						   write => 'insert_alias ::rscell::/cell /two_cells/1',
						  },
						  {
						   description => "Can we create the second neuron out of two?",
						   write => 'insert_alias ::rscell::/cell /two_cells/2',
						  },
						  {
						   description => "Can we create a projection?",
						   write => 'create projection /two_cells/projection',
						  },
						 ],
				comment => 'Unfinished, but trivial and should work.  Replaced with the completed batch file based test.',
				description => "a two neuron network with a single connection (unfinished).",
				disabled => 'Unfinished, but trivial and should work.  Replaced with the completed batch file based test.',
				side_effects => "creates a model in the model container",
			       },
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
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-baskcells.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-baskcells.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-BDK5cells.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-BDK5cells.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-pyrcells.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-pyrcells.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-simplecells.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-simplecells.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/two-VAcells.g3",
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run a G-3 batch file that instantiates two model neurons and connects them with a single connection?",
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/two-VAcells.txt",
							   },
						   wait => 3,
						  },
						 ],
				description => "running a G-3 batch file that instantiates two model neurons and connects them with a single connection",
# 				numerical_compare => 'arithmetic rounding differences between different architectures',
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "Various networks consisting of two model neurons of different types.",
       name => 'network-two-cells.t',
      };


return $test;


