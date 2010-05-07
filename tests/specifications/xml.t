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
						   description => "Can we load a xml model ?",
						   read => 'genesis',
						   write => 'xml_load channels/gaba.xml',
						  },
						  {
						   description => "Can we export the model to an NDF file ?",
						   read => 'genesis',
						   wait => 1,
						   write => "ndf_save /** /tmp/1.ndf",
						  },
						  {
						   description => "Does the exported NDF file contain the correct model ?",
						   read => {
							    application_output_file => '/tmp/1.ndf',
							    expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  ATTACHMENT "Synapse_7_0"
    BINDABLES
      INPUT spike,
      OUTPUT activation,
    END BINDABLES
    ATTRIBUTES       weight,       delay, END ATTRIBUTES
  END ATTACHMENT
  CHILD "Synapse_7_0" "Synapse_7_1"
  END CHILD
  CHILD "Synapse_7_1" "synapse_7_2"
  END CHILD
  CHILD "synapse_7_2" "synapse_inserted_7"
  END CHILD
  EQUATION_EXPONENTIAL "exp2_11_0"
    BINDABLES
      INPUT activation,
      OUTPUT G,
    END BINDABLES
    BINDINGS
      INPUT ../synapse->activation,
    END BINDINGS
    PARAMETERS
      PARAMETER ( TAU1 = 0.00093 ),
      PARAMETER ( TAU2 = 0.0265 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "exp2_11_0" "exp2_inserted_11"
  END CHILD
  CHANNEL "Purk_GABA_9_0"
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 1.077 ),
      PARAMETER ( Erev = -0.08 ),
    END PARAMETERS
    CHILD "synapse_inserted_7" "synapse"
    END CHILD
    CHILD "exp2_11_0" "exp2"
    END CHILD
  END CHANNEL
  CHILD "Purk_GABA_9_0" "Purk_GABA_inserted_9"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "Purk_GABA_9_0" "Purk_GABA"
  END CHILD
END PUBLIC_MODELS
',
							   },
						  },
						  {
						   description => "Can we export the model to an XML file ?",
						   read => 'genesis',
						   wait => 1,
						   write => "xml_save /** /tmp/1.xml",
						  },
						  {
						   comment => 'xml to html conversion fails when converting this test to html',
						   description => "Does the exported XML file contain the correct model ?",
						   read => {
							    application_output_file => '/tmp/1.xml',
							    expected_output => '<neurospaces type="ndf"/>

<private_models>
  <ATTACHMENT> <name>Synapse_7_0</name>
    <bindables>
      <input> <name>spike</name> </input>
      <output> <name>activation</name> </output>
    </bindables>
    <attributes>       <name>weight</name>       <name>delay</name> </attributes>
  </ATTACHMENT>
  <child> <prototype>Synapse_7_0</prototype> <name>Synapse_7_1</name>
  </child>
  <child> <prototype>Synapse_7_1</prototype> <name>synapse_7_2</name>
  </child>
  <child> <prototype>synapse_7_2</prototype> <name>synapse_inserted_7</name>
  </child>
  <EQUATION_EXPONENTIAL> <name>exp2_11_0</name>
    <bindables>
      <input> <name>activation</name> </input>
      <output> <name>G</name> </output>
    </bindables>
    <bindings>
      <input> <name>../synapse->activation</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>TAU1</name><value>0.00093</value> </parameter>
      <parameter> <name>TAU2</name><value>0.0265</value> </parameter>
    </parameters>
  </EQUATION_EXPONENTIAL>
  <child> <prototype>exp2_11_0</prototype> <name>exp2_inserted_11</name>
  </child>
  <CHANNEL> <name>Purk_GABA_9_0</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>G_MAX</name><value>1.077</value> </parameter>
      <parameter> <name>Erev</name><value>-0.08</value> </parameter>
    </parameters>
    <child> <prototype>synapse_inserted_7</prototype> <name>synapse</name>
    </child>
    <child> <prototype>exp2_11_0</prototype> <name>exp2</name>
    </child>
  </CHANNEL>
  <child> <prototype>Purk_GABA_9_0</prototype> <name>Purk_GABA_inserted_9</name>
  </child>
</private_models>
<public_models>
  <child> <prototype>Purk_GABA_9_0</prototype> <name>Purk_GABA</name>
  </child>
</public_models>
',
							   },
						  },
						 ],
				description => "import and export of a model in xml",
			       },
			      ],
       description => "importing and processing of a model encoded in xml",
       name => 'xml.t',
      };


return $test;


