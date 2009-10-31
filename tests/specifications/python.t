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
						   read => 'Welcome to the GENESIS 3 shell',
						  },
						  {
						   description => "Can we load a npy model ?",
						   write => 'npy_load channels/hodgkin-huxley/k.npy',
						  },
						  {
						   description => "Can we export the model to an NDF file ?",
						   read => "#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL k
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    gate_kinetic a
      PARAMETERS
        PARAMETER ( HH_AB_Tau = -0.01 ),
        PARAMETER ( HH_AB_Offset_E = 0.06 ),
        PARAMETER ( HH_AB_Add = -1 ),
        PARAMETER ( HH_AB_Factor_Flag = -1 ),
        PARAMETER ( HH_AB_Mult = 10000 ),
        PARAMETER ( HH_AB_Scale = -600 ),
      END PARAMETERS
    END gate_kinetic
    gate_kinetic b
      PARAMETERS
        PARAMETER ( HH_AB_Tau = 0.08 ),
        PARAMETER ( HH_AB_Offset_E = 0.07 ),
        PARAMETER ( HH_AB_Add = 0 ),
        PARAMETER ( HH_AB_Factor_Flag = -1 ),
        PARAMETER ( HH_AB_Mult = 0 ),
        PARAMETER ( HH_AB_Scale = 125 ),
      END PARAMETERS
    END gate_kinetic
  END CHANNEL
END PUBLIC_MODELS
",
						   write => "ndf_save /** STDOUT",
						  },
						 ],
				description => "import and export of a model in python",
			       },
			      ],
       description => "importing and processing of a model in python",
       name => 'python.t',
      };


return $test;


