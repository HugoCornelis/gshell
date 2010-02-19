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
						   description => "Can we show the root of the library with the backward compatibility scripts?",
						   read => 'PurkM9_model',
						   write => 'show_library sli',
						  },
						  {
						   description => "Can we show the purkinje cell model subdirectory of the library with the backward compatibility scripts?",
						   read => '
    - ACTIVE-main1.g
    - ACTIVE-soma1.g
    - CLIMB9.g
    - CLIMBSPINE9.g
    - CURRENT9.g
    - ISPINE9.g
    - PASSIVE9-current.g
    - PASSIVE9-current1.g
    - PASSIVE9-current2.g
    - Purk2M0.p
    - Purk2M0s.p
    - Purk2M0sA.p
    - Purk2M9.p
    - Purk2M9_main1.p
    - Purk2M9_soma.p
    - Purk2M9s.p
    - Purk2M9s1.p
    - Purk2M9s10.p
    - Purk2M9s14.p
    - Purk2M9s19.p
    - Purk2M9s2.p
    - Purk2M9s25.p
    - Purk2M9s29.p
    - Purk2M9s3.p
    - Purk2M9s37.p
    - Purk2M9s4.p
    - Purk2M9s44.p
    - Purk2M9s45.p
    - Purk2M9s6.p
    - Purk2M9s8b.p
    - Purk2M9sA.p
    - Purk_chan.g
    - Purk_chanload.g
    - Purk_chansave.g
    - Purk_cicomp.g
    - Purk_cicomp_passive.g
    - Purk_comp.g
    - Purk_const.g
    - Purk_icomp.g
    - Purk_spicomp.g
    - Purk_syn.g
    - SYNCHRONORM9.g
    - SYNCHROPASS9.g
    - defaults.g
    - purkinje_simplifying.g
    - schedule.g
',
						   write => 'show_library sli PurkM9_model',
						  },
						 ],
				comment => 'Likely this test needs to be reworked a little bit because some features of the backward compatibility module are still under development.',
				description => "exploring the GENESIS 2 backward compatibility library",
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we run the current injection script?",
						   write => 'sli_run /usr/local/ns-sli/tests/scripts/PurkM9_model/CURRENT9.g',
						  },
						  (
						   {
						    description => "Can the morphology be read ?",
						    read => 'tests/scripts/PurkM9_model/Purk2M9.p read: 1600 compartments',
						    timeout => 10,
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total volume ?",
						    read => "value = 5.37774e-14
",
						    write => "printparameter /Purkinje TOTALVOLUME",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total surface ?",
						    read => "value = 2.61092e-07
",
						    write => "printparameter /Purkinje TOTALSURFACE",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: segment count ?",
						    read => "Number of segments : 1600
",
						    write => "segmentcount /Purkinje",
						   },
						   {
						    description => "quit the querymachine",
						    write => "quit",
						   },
						   {
						    description => 'Do we see the simulation time after the simulation has finished ?',
						    read => 'time = 0.500060 ; step = 25003',
						    timeout => 200,
						   },
						   {
						    comment => "The output file is taken from the ns-sli installation.",
						    description => "Is the generated output correct ?",
						    numerical_compare => 'small differences between the output of different architectures',
						    read => {
							     application_output_file => "$::config->{core_directory}/results/PurkM9_soma_1.5nA",
							     expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_soma_1.5nA.g3",
							    },
						    wait => 1,
						   },
						  ),
						 ],
				comment => 'This test uses the original scripts of the Purkinje cell model',
				description => "running a GENESIS 2 script",
				preparation => {
						description => "Create the results directory",
						preparer =>
						sub
						{
						    `mkdir results`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
 						   `rm "$::config->{core_directory}/results/PurkM9_soma_1.5nA"`;
						   `rmdir results`;
					       },
					      },
				side_effects => 'loads a model into the model-contaier',
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Can we load the model of the current injection script into the model container without running the simulation?",
						   write => 'sli_load /usr/local/ns-sli/tests/scripts/PurkM9_model/CURRENT9.g',
						  },
						  (
						   {
						    description => "Can the morphology be read ?",
						    read => 'tests/scripts/PurkM9_model/Purk2M9.p read: 1600 compartments',
						    timeout => 10,
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total volume ?",
						    read => "value = 5.37774e-14
",
						    write => "printparameter /Purkinje TOTALVOLUME",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: total surface ?",
						    read => "value = 2.61092e-07
",
						    write => "printparameter /Purkinje TOTALSURFACE",
						   },
						   {
						    description => "Can we query the resulting model using the querymachine: segment count ?",
						    read => "Number of segments : 1600
",
						    write => "segmentcount /Purkinje",
						   },
						   {
						    comment => 'without the wait command, the quit command is not executed, dont know why',
						    description => "quit the querymachine",
						    wait => 1,
						    write => "quit",
						   },
						   {
						    description => 'Do we see the simulation time after the simulation has finished ?',
						    disabled => 'the sli_load command prevents the simulation from being run',
						    read => 'time = 0.500060 ; step = 25003',
						    timeout => 200,
						   },
						   {
						    comment => "The output file is taken from the ns-sli installation.",
						    description => "Is the generated output correct ?",
						    disabled => 'the sli_load command prevents the simulation from being run, so no output has been produced',
						    numerical_compare => 'small differences between the output of different architectures',
						    read => {
							     application_output_file => "$::config->{core_directory}/results/PurkM9_soma_1.5nA",
							     expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_soma_1.5nA.g3",
							    },
						    wait => 1,
						   },
						  ),
						  {
						   description => "Can we export a channel of the model to NDF format?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  ALIAS Purk_NaF NaF
    PARAMETERS
      PARAMETER ( G_MAX = 74999.9 ),
    END PARAMETERS
  END ALIAS
END PUBLIC_MODELS
',
						   write => 'ndf_save /Purkinje/soma/NaF/** STDOUT',
						  },
						  {
						   description => "Can we export a channel of the model to XML format?",
						   read => '<import>
</import>

<private_models>
</private_models>

<public_models>
  <alias> <prototype>Purk_NaF</prototype> <name>NaF</name>
    <parameters>
      <parameter> <name>G_MAX</name><value>74999.9</value> </parameter>
    </parameters>
  </alias>
</public_models>
',
						   write => 'xml_save /Purkinje/soma/NaF/** STDOUT',
						  },


						 ],
				comment => 'This test uses the original scripts of the Purkinje cell model',
				description => "loading a model inside a GENESIS 2 script",
# 				preparation => {
# 						description => "Create the results directory",
# 						preparer =>
# 						sub
# 						{
# 						    `mkdir results`;
# 						},
# 					       },
# 				reparation => {
# 					       description => "Remove the generated output files in the results directory",
# 					       reparer =>
# 					       sub
# 					       {
#  						   `rm "$::config->{core_directory}/results/PurkM9_soma_1.5nA"`;
# 						   `rmdir results`;
# 					       },
# 					      },
				side_effects => 'loads a model into the model-contaier',
			       },
			      ],
       description => "running GENESIS 2 scripts and importing their models",
       name => 'sli.t',
      };


return $test;


