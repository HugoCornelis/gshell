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
						   write => 'ndf_load_library rscell cells/RScell-nolib2.ndf',
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
				description => "a two neuron network with a single connection.",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "A network consisting of two model neurons.",
       name => 'network-two-cells.t',
      };


return $test;


