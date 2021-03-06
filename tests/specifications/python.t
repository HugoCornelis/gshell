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
						   description => "Can we find a python based model in the model library?",
						   read => '#! /usr/bin/env python

print "import\n"

import Neurospaces

print "initialize\n"

nmc = Neurospaces.getModelContainer()

print "construct\n"

c = nmc.Channel("/k")

gka = nmc.GateKinetic("/k/a")

gka.parameter("HH_AB_Add_Num", -600.0 )
gka.parameter("HH_AB_Mult", -10000 )
gka.parameter("HH_AB_Factor_Flag", -1.0 )
gka.parameter("HH_AB_Add_Den", -1.0 )
gka.parameter("HH_AB_Offset_E", 60e-3 )
gka.parameter("HH_AB_Div_E", -10.0e-3 )

gkb = nmc.GateKinetic("/k/b")

gkb.parameter("HH_AB_Add_Num", 125.0 )
gkb.parameter("HH_AB_Mult", 0.0 )
gkb.parameter("HH_AB_Factor_Flag", -1.0 )
gkb.parameter("HH_AB_Add_Den", 0.0 )
gkb.parameter("HH_AB_Offset_E", 70e-3 )
gkb.parameter("HH_AB_Div_E", 80e-3 )
',
						   write => "sh cat /usr/local/neurospaces/models/library/channels/hodgkin-huxley/k.npy",
						  },
						  {
						   description => "Can we load a npy model ?",
						   write => 'npy_load channels/hodgkin-huxley/k.npy',
						  },
						  {
						   description => "Can we export the model to an NDF file ?",
						   mac_report => "This test reads in the data correctly, however the NDF output it produces is in a different order than the expected on linux. Most likely needs a more strict preservation of order when traversing the model.",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GATE_KINETIC "a_2_2"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.06 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -10000 ),
      PARAMETER ( HH_AB_Add_Num = -600 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "a_2_2" "a_inserted_2"
  END CHILD
  GATE_KINETIC "b_3_3"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = 0.08 ),
      PARAMETER ( HH_AB_Offset_E = 0.07 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Add_Num = 125 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "b_3_3" "b_inserted_3"
  END CHILD
  CHANNEL "k_1_1"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( POWER = 4 ),
    END PARAMETERS
    CHILD "a_2_2" "a"
    END CHILD
    CHILD "b_3_3" "b"
    END CHILD
  END CHANNEL
  CHILD "k_1_1" "k_inserted_1"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "k_1_1" "k"
  END CHILD
END PUBLIC_MODELS
',
						   write => "ndf_save /** STDOUT",
						  },
						 ],
				description => "import and export of a model in python",
			       },
			      ],
       description => "importing and processing of a model in python",
       disabled => ((`perl -e 'use Inline::Python' 2>&1`)
		    ? 'the perl environment cannot load the module Inline::Python'
		    : ''),
       name => 'python.t',
      };


return $test;


