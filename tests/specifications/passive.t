#!/usr/bin/perl -w
#

use strict;


my $passive_models
    = [
       'singlep',
       'doublep',
       'fork3p',
       'fork4p1',
       'fork4p2',
       'fork4p3',
       'triplep',
       'tensizesp',
      ];

my $test
    = {
       command_definitions => [
			       map
			       {
				   my $model_name = $_;

				   (
				    {
				     arguments => [
						   '--verbose',
						   'debug',
						  ],
				     command => 'bin/genesis-g3',
				     command_tests => [
						       {
							description => "Is startup successful ?",
							read => "GENESIS 3 shell",
							timeout => 5,
						       },
						       {
							description => "Can we load the $model_name model ?",
							write => "ndf_load tests/cells/$model_name.ndf",
						       },
						       {
							comment => "These tests generate spurious characters in the output, maybe due to the presence of multiple I/O buffers for the same output stream.  I suspect readline, although not sure.  The 'Initiated' heccer output is not tested for as a work around.",
							description => "Can we run the $model_name model ?",
							disabled => ($model_name eq 'tensizesp' ? 'the tensizesp model needs improvements of the numerical_compare heuristic' : 0),
							numerical_compare => 1,
							read => (join '', `cat /usr/local/heccer/tests/specifications/strings/$model_name.txt | grep -v Initiated | perl -pe 's(unnamed test)(/$model_name)g'`),
							timeout => 50,
							write => "run /$model_name 0.0002",
						       },
						      ],
				     description => "passive $model_name test",
				     side_effects => "creates the $model_name model in the model container",
				    },
				   );
			       }
			       @$passive_models,
			      ],
       description => "simulations of passive models",
       name => 'passive.t',
      };


return $test;


