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
						   description => "Can we load a simple cell model?",
						   write => 'ndf_load cells/RScell-nolib.ndf',
						  },
						  {
						   description => "Can we create a current clamp circuitry object?",
						   write => "inputclass_add perfectclamp current_injection_protocol name current_injection command 1e-9",
						  },
						  {
						   description => "Can we connect the current clamp circuitry to the simple cell's soma?",
						   write => "input_add current_injection_protocol /cell/soma INJECT",
						  },
						  {
						   description => "Can we add an output to the soma's Vm?",
						   write => "output_add /cell/soma Vm",
						  },
						  {
						   description => "Can we set the output mode to \"steps\"?",
						   write => 'output_mode steps',
						  },
						  {
						   description => "Can we set the output resolution to 10?",
						   write => 'output_resolution 10',
						  },
						  {
						   description => "Can we run the simulation for a limited amount of time?",
						   write => "run /cell 0.2",
						  },
						  {
						   description => "Can we quit the simulator?",
						   write => "quit",
						  },
						  {
						   description => "Do we see the expected output?",
						   numerical_compare => "small rounding differences on the tester",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-simple.txt",
							   },
						   wait => 1,
						  },
						 ],
				description => "preparation commands for network simulations, basic sanity of the cell of the RScell model",
				side_effects => "creates a model in the model container",
			       },
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
						   description => "Can we load a simple cell model?",
						   write => 'ndf_namespace_load rscell1 cells/RScell-nolib.ndf',
						  },
						  {
						   description => "Was the namespace created (1)?",
						   read => '
- ::rscell1::/cell',
						   write => 'list_elements ::rscell1::',
						  },
						  {
						   comment => "The loaded file does not show up because EXPORTER_FLAG_LIBRARY is not turned on during ndf_save.",
						   description => "Do we still see clean public models in the NDF?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
END PRIVATE_MODELS
PUBLIC_MODELS
END PUBLIC_MODELS
',
						   write => 'ndf_save /** STDOUT',
						  },
						  {
						   description => "Can we create the top level network component?",
						   write => "create network /network",
						  },
						  {
						   description => "Can we create a first population of neurons?",
						   read => 'created a new private component with name /network/population1',
						   write => 'createmap ::rscell1::/cell /network/population1 2 2 0.002 0.002',
						  },
						  {
						   description => 'Do we find all the components of the population in the created population?',
						   read => '
- /network
- /network/population1
- /network/population1/createmap__network_population1
- /network/population1/0
- /network/population1/0/soma
- /network/population1/0/soma/Na_pyr_dp
- /network/population1/0/soma/Na_pyr_dp/HH_activation
- /network/population1/0/soma/Na_pyr_dp/HH_activation/A
- /network/population1/0/soma/Na_pyr_dp/HH_activation/B
- /network/population1/0/soma/Na_pyr_dp/HH_inactivation
- /network/population1/0/soma/Na_pyr_dp/HH_inactivation/A
- /network/population1/0/soma/Na_pyr_dp/HH_inactivation/B
- /network/population1/0/soma/Kdr_pyr_dp
- /network/population1/0/soma/Kdr_pyr_dp/HH_activation
- /network/population1/0/soma/Kdr_pyr_dp/HH_activation/A
- /network/population1/0/soma/Kdr_pyr_dp/HH_activation/B
- /network/population1/0/soma/KM_pyr_dp
- /network/population1/0/soma/KM_pyr_dp/HH_activation
- /network/population1/0/soma/KM_pyr_dp/HH_activation/A
- /network/population1/0/soma/KM_pyr_dp/HH_activation/B
- /network/population1/0/soma/Ex_channel
- /network/population1/0/soma/Ex_channel/eq2
- /network/population1/0/soma/Ex_channel/synapse
- /network/population1/0/soma/spike
- /network/population1/1
- /network/population1/1/soma
- /network/population1/1/soma/Na_pyr_dp
- /network/population1/1/soma/Na_pyr_dp/HH_activation
- /network/population1/1/soma/Na_pyr_dp/HH_activation/A
- /network/population1/1/soma/Na_pyr_dp/HH_activation/B
- /network/population1/1/soma/Na_pyr_dp/HH_inactivation
- /network/population1/1/soma/Na_pyr_dp/HH_inactivation/A
- /network/population1/1/soma/Na_pyr_dp/HH_inactivation/B
- /network/population1/1/soma/Kdr_pyr_dp
- /network/population1/1/soma/Kdr_pyr_dp/HH_activation
- /network/population1/1/soma/Kdr_pyr_dp/HH_activation/A
- /network/population1/1/soma/Kdr_pyr_dp/HH_activation/B
- /network/population1/1/soma/KM_pyr_dp
- /network/population1/1/soma/KM_pyr_dp/HH_activation
- /network/population1/1/soma/KM_pyr_dp/HH_activation/A
- /network/population1/1/soma/KM_pyr_dp/HH_activation/B
- /network/population1/1/soma/Ex_channel
- /network/population1/1/soma/Ex_channel/eq2
- /network/population1/1/soma/Ex_channel/synapse
- /network/population1/1/soma/spike
- /network/population1/2
- /network/population1/2/soma
- /network/population1/2/soma/Na_pyr_dp
- /network/population1/2/soma/Na_pyr_dp/HH_activation
- /network/population1/2/soma/Na_pyr_dp/HH_activation/A
- /network/population1/2/soma/Na_pyr_dp/HH_activation/B
- /network/population1/2/soma/Na_pyr_dp/HH_inactivation
- /network/population1/2/soma/Na_pyr_dp/HH_inactivation/A
- /network/population1/2/soma/Na_pyr_dp/HH_inactivation/B
- /network/population1/2/soma/Kdr_pyr_dp
- /network/population1/2/soma/Kdr_pyr_dp/HH_activation
- /network/population1/2/soma/Kdr_pyr_dp/HH_activation/A
- /network/population1/2/soma/Kdr_pyr_dp/HH_activation/B
- /network/population1/2/soma/KM_pyr_dp
- /network/population1/2/soma/KM_pyr_dp/HH_activation
- /network/population1/2/soma/KM_pyr_dp/HH_activation/A
- /network/population1/2/soma/KM_pyr_dp/HH_activation/B
- /network/population1/2/soma/Ex_channel
- /network/population1/2/soma/Ex_channel/eq2
- /network/population1/2/soma/Ex_channel/synapse
- /network/population1/2/soma/spike
- /network/population1/3
- /network/population1/3/soma
- /network/population1/3/soma/Na_pyr_dp
- /network/population1/3/soma/Na_pyr_dp/HH_activation
- /network/population1/3/soma/Na_pyr_dp/HH_activation/A
- /network/population1/3/soma/Na_pyr_dp/HH_activation/B
- /network/population1/3/soma/Na_pyr_dp/HH_inactivation
- /network/population1/3/soma/Na_pyr_dp/HH_inactivation/A
- /network/population1/3/soma/Na_pyr_dp/HH_inactivation/B
- /network/population1/3/soma/Kdr_pyr_dp
- /network/population1/3/soma/Kdr_pyr_dp/HH_activation
- /network/population1/3/soma/Kdr_pyr_dp/HH_activation/A
- /network/population1/3/soma/Kdr_pyr_dp/HH_activation/B
- /network/population1/3/soma/KM_pyr_dp
- /network/population1/3/soma/KM_pyr_dp/HH_activation
- /network/population1/3/soma/KM_pyr_dp/HH_activation/A
- /network/population1/3/soma/KM_pyr_dp/HH_activation/B
- /network/population1/3/soma/Ex_channel
- /network/population1/3/soma/Ex_channel/eq2
- /network/population1/3/soma/Ex_channel/synapse
- /network/population1/3/soma/spike
',
						   write => 'list_elements /**',
						  },
						  {
						   comment => "This needs to be simplified",
						   description => "Do we see the created population in the NDF?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GATE_KINETIC "A_7_7_5_5"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = -0.004 ),
      PARAMETER ( HH_AB_Offset_E = 0.05 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -320000 ),
      PARAMETER ( HH_AB_Add_Num = -16000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_7_7_5_5" "A_5_10"
  END CHILD
  CHILD "A_5_10" "A_inserted_10"
  END CHILD
  GATE_KINETIC "B_8_8_7_7"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = 0.005 ),
      PARAMETER ( HH_AB_Offset_E = 0.023 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 280000 ),
      PARAMETER ( HH_AB_Add_Num = 6440 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_8_8_7_7" "B_7_11"
  END CHILD
  CHILD "B_7_11" "B_inserted_11"
  END CHILD
  HH_GATE "HH_activation_6_6_9_9"
    PARAMETERS
      PARAMETER ( POWER = 3 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_inserted_10" "A"
    END CHILD
    CHILD "B_inserted_11" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_6_6_9_9" "HH_activation_9_22"
  END CHILD
  CHILD "HH_activation_9_22" "HH_activation_inserted_22"
  END CHILD
  GATE_KINETIC "A_10_10_13_13"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = 0.018 ),
      PARAMETER ( HH_AB_Offset_E = 0.056 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Add_Num = 128 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_10_10_13_13" "A_13_18"
  END CHILD
  CHILD "A_13_18" "A_inserted_18"
  END CHILD
  GATE_KINETIC "B_11_11_15_15"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = -0.005 ),
      PARAMETER ( HH_AB_Offset_E = 0.033 ),
      PARAMETER ( HH_AB_Add_Den = 1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Add_Num = 4000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_11_11_15_15" "B_15_19"
  END CHILD
  CHILD "B_15_19" "B_inserted_19"
  END CHILD
  HH_GATE "HH_inactivation_9_9_17_17"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_inserted_18" "A"
    END CHILD
    CHILD "B_inserted_19" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_inactivation_9_9_17_17" "HH_inactivation_17_23"
  END CHILD
  CHILD "HH_inactivation_17_23" "HH_inactivation_inserted_23"
  END CHILD
  CHANNEL "Na_pyr_dp_5_5_21_21"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = 0.05 ),
    END PARAMETERS
    CHILD "HH_activation_inserted_22" "HH_activation"
    END CHILD
    CHILD "HH_inactivation_inserted_23" "HH_inactivation"
    END CHILD
  END CHANNEL
  CHILD "Na_pyr_dp_5_5_21_21" "Na_pyr_dp_5_26_21_24"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
  END CHILD
  CHILD "Na_pyr_dp_5_26_21_24" "Na_pyr_dp_inserted_26_21_25"
  END CHILD
  CHILD "Na_pyr_dp_inserted_26_21_25" "Na_pyr_dp_21_63"
  END CHILD
  CHILD "Na_pyr_dp_21_63" "Na_pyr_dp_inserted_63"
  END CHILD
  GATE_KINETIC "A_14_14_26_26"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = -0.005 ),
      PARAMETER ( HH_AB_Offset_E = 0.048 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -32000 ),
      PARAMETER ( HH_AB_Add_Num = -1536 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_14_14_26_26" "A_26_31"
  END CHILD
  CHILD "A_26_31" "A_inserted_31"
  END CHILD
  GATE_KINETIC "B_15_15_28_28"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = 0.04 ),
      PARAMETER ( HH_AB_Offset_E = 0.053 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Add_Num = 500 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_15_15_28_28" "B_28_32"
  END CHILD
  CHILD "B_28_32" "B_inserted_32"
  END CHILD
  HH_GATE "HH_activation_13_13_30_30"
    PARAMETERS
      PARAMETER ( POWER = 4 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_inserted_31" "A"
    END CHILD
    CHILD "B_inserted_32" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_13_13_30_30" "HH_activation_30_35"
  END CHILD
  CHILD "HH_activation_30_35" "HH_activation_inserted_35"
  END CHILD
  CHANNEL "Kdr_pyr_dp_12_12_34_34"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = -0.09 ),
    END PARAMETERS
    CHILD "HH_activation_inserted_35" "HH_activation"
    END CHILD
  END CHANNEL
  CHILD "Kdr_pyr_dp_12_12_34_34" "Kdr_pyr_dp_12_27_34_36"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
  END CHILD
  CHILD "Kdr_pyr_dp_12_27_34_36" "Kdr_pyr_dp_inserted_27_34_37"
  END CHILD
  CHILD "Kdr_pyr_dp_inserted_27_34_37" "Kdr_pyr_dp_34_64"
  END CHILD
  CHILD "Kdr_pyr_dp_34_64" "Kdr_pyr_dp_inserted_64"
  END CHILD
  GATE_KINETIC "A_18_18_38_38"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = -0.009 ),
      PARAMETER ( HH_AB_Offset_E = 0.03 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -100 ),
      PARAMETER ( HH_AB_Add_Num = -3 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_18_18_38_38" "A_38_43"
  END CHILD
  CHILD "A_38_43" "A_inserted_43"
  END CHILD
  GATE_KINETIC "B_19_19_40_40"
    PARAMETERS
      PARAMETER ( HH_AB_Div_E = 0.009 ),
      PARAMETER ( HH_AB_Offset_E = 0.03 ),
      PARAMETER ( HH_AB_Add_Den = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 100 ),
      PARAMETER ( HH_AB_Add_Num = 3 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_19_19_40_40" "B_40_44"
  END CHILD
  CHILD "B_40_44" "B_inserted_44"
  END CHILD
  HH_GATE "HH_activation_17_17_42_42"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_inserted_43" "A"
    END CHILD
    CHILD "B_inserted_44" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_17_17_42_42" "HH_activation_42_47"
  END CHILD
  CHILD "HH_activation_42_47" "HH_activation_inserted_47"
  END CHILD
  CHANNEL "KM_pyr_dp_16_16_46_46"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = -0.09 ),
    END PARAMETERS
    CHILD "HH_activation_inserted_47" "HH_activation"
    END CHILD
  END CHANNEL
  CHILD "KM_pyr_dp_16_16_46_46" "KM_pyr_dp_16_28_46_48"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
  END CHILD
  CHILD "KM_pyr_dp_16_28_46_48" "KM_pyr_dp_inserted_28_46_49"
  END CHILD
  CHILD "KM_pyr_dp_inserted_28_46_49" "KM_pyr_dp_46_65"
  END CHILD
  CHILD "KM_pyr_dp_46_65" "KM_pyr_dp_inserted_65"
  END CHILD
  EQUATION_EXPONENTIAL "eq2_21_21_50_50"
    PARAMETERS
      PARAMETER ( TAU1 = ..->TAU1 ),
      PARAMETER ( TAU2 = ..->TAU2 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "eq2_21_21_50_50" "eq2_50_55"
  END CHILD
  CHILD "eq2_50_55" "eq2_inserted_55"
  END CHILD
  ATTACHMENT "synapse_22_22_52_52"
  END ATTACHMENT
  CHILD "synapse_22_22_52_52" "synapse_52_56"
  END CHILD
  CHILD "synapse_52_56" "synapse_inserted_56"
  END CHILD
  CHANNEL "Ex_channel_20_20_54_54"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 5e-08 ),
          ), ),
      PARAMETER ( TAU2 = 0.003 ),
      PARAMETER ( TAU1 = 0.003 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "eq2_inserted_55" "eq2"
    END CHILD
    CHILD "synapse_inserted_56" "synapse"
    END CHILD
  END CHANNEL
  CHILD "Ex_channel_20_20_54_54" "Ex_channel_20_29_54_57"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( G_MAX = 50 ),
    END PARAMETERS
  END CHILD
  CHILD "Ex_channel_20_29_54_57" "Ex_channel_inserted_29_54_58"
  END CHILD
  CHILD "Ex_channel_inserted_29_54_58" "Ex_channel_54_66"
  END CHILD
  CHILD "Ex_channel_54_66" "Ex_channel_inserted_66"
  END CHILD
  ATTACHMENT "spike_23_23_59_59"
    PARAMETERS
      PARAMETER ( output_amp = "1" ),
      PARAMETER ( REFRACTORY = 0.01 ),
      PARAMETER ( THRESHOLD = 0 ),
    END PARAMETERS
  END ATTACHMENT
  CHILD "spike_23_23_59_59" "spike_23_30_59_60"
  END CHILD
  CHILD "spike_23_30_59_60" "spike_inserted_30_59_61"
  END CHILD
  CHILD "spike_inserted_30_59_61" "spike_59_67"
  END CHILD
  CHILD "spike_59_67" "spike_inserted_67"
  END CHILD
  SEGMENT "compartment_4_4_62_62"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_4_4_62_62" "soma_4_25_62_68"
    BINDINGS
      INPUT Na_pyr_dp->Vm,
      INPUT Kdr_pyr_dp->Vm,
      INPUT KM_pyr_dp->Vm,
      INPUT Ex_channel->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 2.2 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 3.46361e-08 ),
      PARAMETER ( rel_Z = 0.000105 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 0 ),
      PARAMETER ( LENGTH = 0.000105 ),
      PARAMETER ( DIA = 0.000105 ),
      PARAMETER ( RA = 2.5 ),
    END PARAMETERS
    CHILD "Na_pyr_dp_inserted_63" "Na_pyr_dp"
    END CHILD
    CHILD "Kdr_pyr_dp_inserted_64" "Kdr_pyr_dp"
    END CHILD
    CHILD "KM_pyr_dp_inserted_65" "KM_pyr_dp"
    END CHILD
    CHILD "Ex_channel_inserted_66" "Ex_channel"
    END CHILD
    CHILD "spike_inserted_67" "spike"
    END CHILD
  END CHILD
  CHILD "soma_4_25_62_68" "soma_inserted_25_62_69"
  END CHILD
  CHILD "soma_inserted_25_62_69" "soma_62_71"
  END CHILD
  CHILD "soma_62_71" "soma_inserted_71"
  END CHILD
  SEGMENT "compartment_4_4_62_62"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_4_4_62_62" "soma_4_25_62_68"
    BINDINGS
      INPUT Na_pyr_dp->Vm,
      INPUT Kdr_pyr_dp->Vm,
      INPUT KM_pyr_dp->Vm,
      INPUT Ex_channel->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 2.2 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 3.46361e-08 ),
      PARAMETER ( rel_Z = 0.000105 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 0 ),
      PARAMETER ( LENGTH = 0.000105 ),
      PARAMETER ( DIA = 0.000105 ),
      PARAMETER ( RA = 2.5 ),
    END PARAMETERS
    CHILD "Na_pyr_dp_inserted_63" "Na_pyr_dp"
    END CHILD
    CHILD "Kdr_pyr_dp_inserted_64" "Kdr_pyr_dp"
    END CHILD
    CHILD "KM_pyr_dp_inserted_65" "KM_pyr_dp"
    END CHILD
    CHILD "Ex_channel_inserted_66" "Ex_channel"
    END CHILD
    CHILD "spike_inserted_67" "spike"
    END CHILD
  END CHILD
  CHILD "soma_4_25_62_68" "soma_inserted_25_62_69"
  END CHILD
  CHILD "soma_inserted_25_62_69" "soma_62_71"
  END CHILD
  CHILD "soma_62_71" "soma_inserted_71"
  END CHILD
  SEGMENT "compartment_4_4_62_62"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_4_4_62_62" "soma_4_25_62_68"
    BINDINGS
      INPUT Na_pyr_dp->Vm,
      INPUT Kdr_pyr_dp->Vm,
      INPUT KM_pyr_dp->Vm,
      INPUT Ex_channel->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 2.2 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 3.46361e-08 ),
      PARAMETER ( rel_Z = 0.000105 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 0 ),
      PARAMETER ( LENGTH = 0.000105 ),
      PARAMETER ( DIA = 0.000105 ),
      PARAMETER ( RA = 2.5 ),
    END PARAMETERS
    CHILD "Na_pyr_dp_inserted_63" "Na_pyr_dp"
    END CHILD
    CHILD "Kdr_pyr_dp_inserted_64" "Kdr_pyr_dp"
    END CHILD
    CHILD "KM_pyr_dp_inserted_65" "KM_pyr_dp"
    END CHILD
    CHILD "Ex_channel_inserted_66" "Ex_channel"
    END CHILD
    CHILD "spike_inserted_67" "spike"
    END CHILD
  END CHILD
  CHILD "soma_4_25_62_68" "soma_inserted_25_62_69"
  END CHILD
  CHILD "soma_inserted_25_62_69" "soma_62_71"
  END CHILD
  CHILD "soma_62_71" "soma_inserted_71"
  END CHILD
  SEGMENT "compartment_4_4_62_62"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_4_4_62_62" "soma_4_25_62_68"
    BINDINGS
      INPUT Na_pyr_dp->Vm,
      INPUT Kdr_pyr_dp->Vm,
      INPUT KM_pyr_dp->Vm,
      INPUT Ex_channel->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 2.2 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 3.46361e-08 ),
      PARAMETER ( rel_Z = 0.000105 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 0 ),
      PARAMETER ( LENGTH = 0.000105 ),
      PARAMETER ( DIA = 0.000105 ),
      PARAMETER ( RA = 2.5 ),
    END PARAMETERS
    CHILD "Na_pyr_dp_inserted_63" "Na_pyr_dp"
    END CHILD
    CHILD "Kdr_pyr_dp_inserted_64" "Kdr_pyr_dp"
    END CHILD
    CHILD "KM_pyr_dp_inserted_65" "KM_pyr_dp"
    END CHILD
    CHILD "Ex_channel_inserted_66" "Ex_channel"
    END CHILD
    CHILD "spike_inserted_67" "spike"
    END CHILD
  END CHILD
  CHILD "soma_4_25_62_68" "soma_inserted_25_62_69"
  END CHILD
  CHILD "soma_inserted_25_62_69" "soma_62_71"
  END CHILD
  CHILD "soma_62_71" "soma_inserted_71"
  END CHILD
  POPULATION "population1_77_77"
    ALGORITHM "Grid3D" "createmap__network_population1"
      PARAMETERS
        PARAMETER ( Z_COUNT = 1 ),
        PARAMETER ( Y_COUNT = 2 ),
        PARAMETER ( X_COUNT = 2 ),
        PARAMETER ( Z_DISTANCE = 0 ),
        PARAMETER ( Y_DISTANCE = 0.002 ),
        PARAMETER ( X_DISTANCE = 0.002 ),
        PARAMETER ( PROTOTYPE = "cell" ),
      END PARAMETERS
    END ALGORITHM
  END POPULATION
  CHILD "population1_77_77" "population1_inserted_77"
  END CHILD
  NETWORK "network_74_74"
    CHILD "population1_77_77" "population1"
    END CHILD
  END NETWORK
  CHILD "network_74_74" "network_inserted_74"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "network_74_74" "network"
  END CHILD
END PUBLIC_MODELS
',
						   write => "ndf_save /** STDOUT",
						  },
						  {
						   description => "Can we load a simple cell model?",
						   write => 'ndf_namespace_load rscell2 cells/RScell-nolib.ndf',
						  },
						  {
						   description => "Was the namespace created (2)?",
						   read => '
- ::rscell2::/cell',
						   write => 'list_elements ::rscell2::',
						  },
						  {
						   description => "Can we create a second population of neurons?",
						   read => 'created a new private component with name /network/population2',
						   write => 'createmap ::rscell2::/cell /network/population2 2 2 0.002 0.002',
						  },
						  {
						   description => "Can we create a third population of neurons?",
						   read => 'created a new private component with name /network/population3',
						   write => 'createmap ::rscell2::/cell /network/population3 2 2 0.002 0.002',
						  },
						  {
						   description => "Can we create a projection between the first and the second population?",
						   read => 'created a new projection with name /network/projection12',
						   write => 'volumeconnect /network /network/projection12 ../population1 ../population2 /network/population1 /network/population2 spikegen mf_AMPA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -5.0 -5.0 -5.0 5.0 5.0 5.0 weight 45.0 delay radial 0.0 velocity 0.5 1.0 1212.0',
						  },
						  {
						   description => "Can we create a current clamp circuitry object?",
						   write => "inputclass_add perfectclamp current_injection_protocol name current_injection command 1e-9",
						  },
						  {
						   comment => 'There is an efferent connection from /network/population1/3/soma/spike to /network/population2/0/soma/Ex_channel/synapse.',
						   description => "Can we connect the current clamp circuitry to the simple cell's soma?",
						   write => "input_add current_injection_protocol /network/population1/3/soma INJECT",
						  },
						  {
						   description => "Can we add an output to the soma's Vm?",
						   write => "output_add /network/population1/3/soma Vm",
						  },
						  {
						   description => "Can we add an output to the soma's Vm?",
						   write => "output_add /network/population2/0/soma Vm",
						  },
# 						  {
# 						   description => "Can we set the output mode to \"steps\"?",
# 						   write => 'output_mode steps',
# 						  },
# 						  {
# 						   description => "Can we set the output resolution to 10?",
# 						   write => 'output_resolution 10',
# 						  },
						  {
						   description => "Can we assign a solver to the source neuron?",
						   write => 'solverset /network/population1/3 heccer /network',
						  },
						  {
						   description => "Can we assign a solver to the target neuron?",
						   write => 'solverset /network/population2/0 heccer /network',
						  },
						  {
						   description => "Can assign a solver to the projection?",
						   write => 'solverset /network/projection12 DES /network',
						  },
						  {
						   description => "Can we run the simulation for a limited amount of time?",
						   write => "run /network 0.2",
						  },
						  {
						   description => "Can we quit the simulator?",
						   write => "quit",
						  },
						  {
						   description => "Do we see the expected output?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/network-simple.txt",
							   },
						   wait => 2,
						  },
						 ],
				description => "preparation commands for network simulations",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "A simple network model (in preparation).",
       name => 'network-simple.t',
      };


return $test;


