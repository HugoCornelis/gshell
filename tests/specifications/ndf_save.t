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
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we load the traub91 model (1)?",
						   read => "Using hsolve",
						   timeout => 15,
						   write => "sli_load test-traub91-v0/traub91.g",
						  },
						  {
						   description => "Can we write the traub91 model to an NDF file ?",
						   wait => 2,
						   write => "ndf_save /** /tmp/traub91.ndf",
						  },
						 ],
				description => "commands to load and save the traub91 model",
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      '--time',
					      '0.15',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/traub91.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub91.ndf ?',
						   read => '
Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-05)
Intermediary (iCompartments) : (19)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (0)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (2)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (3)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (4)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (5)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (6)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (7)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (8)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (9)
Compartment (dCm) : (9.96669e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (2e-10)
Compartment (dRa) : (2.22372e+06)
Compartment (dRm) : (3.01003e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (10)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (11)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (12)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (13)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (14)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (15)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (16)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (17)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
MinimumDegree (iEntries) : (19)
MinimumDegree (piChildren[0]) : (1)
MinimumDegree (piChildren[0][0]) : (1)
MinimumDegree (piChildren[1]) : (1)
MinimumDegree (piChildren[1][0]) : (2)
MinimumDegree (piChildren[2]) : (1)
MinimumDegree (piChildren[2][0]) : (3)
MinimumDegree (piChildren[3]) : (1)
MinimumDegree (piChildren[3][0]) : (4)
MinimumDegree (piChildren[4]) : (1)
MinimumDegree (piChildren[4][0]) : (5)
MinimumDegree (piChildren[5]) : (1)
MinimumDegree (piChildren[5][0]) : (6)
MinimumDegree (piChildren[6]) : (1)
MinimumDegree (piChildren[6][0]) : (7)
MinimumDegree (piChildren[7]) : (1)
MinimumDegree (piChildren[7][0]) : (8)
MinimumDegree (piChildren[8]) : (1)
MinimumDegree (piChildren[8][0]) : (9)
MinimumDegree (piChildren[9]) : (1)
MinimumDegree (piChildren[9][0]) : (10)
MinimumDegree (piChildren[10]) : (1)
MinimumDegree (piChildren[10][0]) : (11)
MinimumDegree (piChildren[11]) : (1)
MinimumDegree (piChildren[11][0]) : (12)
MinimumDegree (piChildren[12]) : (1)
MinimumDegree (piChildren[12][0]) : (13)
MinimumDegree (piChildren[13]) : (1)
MinimumDegree (piChildren[13][0]) : (14)
MinimumDegree (piChildren[14]) : (1)
MinimumDegree (piChildren[14][0]) : (15)
MinimumDegree (piChildren[15]) : (1)
MinimumDegree (piChildren[15][0]) : (16)
MinimumDegree (piChildren[16]) : (1)
MinimumDegree (piChildren[16][0]) : (17)
MinimumDegree (piChildren[17]) : (1)
MinimumDegree (piChildren[17][0]) : (18)
MinimumDegree (piChildren[18]) : (0)
MinimumDegree (piForward[0]) : (18)
MinimumDegree (piForward[1]) : (17)
MinimumDegree (piForward[2]) : (16)
MinimumDegree (piForward[3]) : (15)
MinimumDegree (piForward[4]) : (14)
MinimumDegree (piForward[5]) : (13)
MinimumDegree (piForward[6]) : (12)
MinimumDegree (piForward[7]) : (11)
MinimumDegree (piForward[8]) : (10)
MinimumDegree (piForward[9]) : (9)
MinimumDegree (piForward[10]) : (8)
MinimumDegree (piForward[11]) : (7)
MinimumDegree (piForward[12]) : (6)
MinimumDegree (piForward[13]) : (5)
MinimumDegree (piForward[14]) : (4)
MinimumDegree (piForward[15]) : (3)
MinimumDegree (piForward[16]) : (2)
MinimumDegree (piForward[17]) : (1)
MinimumDegree (piForward[18]) : (0)
MinimumDegree (piBackward[0]) : (18)
MinimumDegree (piBackward[1]) : (17)
MinimumDegree (piBackward[2]) : (16)
MinimumDegree (piBackward[3]) : (15)
MinimumDegree (piBackward[4]) : (14)
MinimumDegree (piBackward[5]) : (13)
MinimumDegree (piBackward[6]) : (12)
MinimumDegree (piBackward[7]) : (11)
MinimumDegree (piBackward[8]) : (10)
MinimumDegree (piBackward[9]) : (9)
MinimumDegree (piBackward[10]) : (8)
MinimumDegree (piBackward[11]) : (7)
MinimumDegree (piBackward[12]) : (6)
MinimumDegree (piBackward[13]) : (5)
MinimumDegree (piBackward[14]) : (4)
MinimumDegree (piBackward[15]) : (3)
MinimumDegree (piBackward[16]) : (2)
MinimumDegree (piBackward[17]) : (1)
MinimumDegree (piBackward[18]) : (0)
Tables (iTabulatedGateCount) : (10)
Tabulated gate 0, interval (dStart) : (-0.1)
Tabulated gate 0, interval (dEnd) : (0.05)
Tabulated gate 0, interval (dStep) : (5e-05)
Tabulated gate 0, interpolation (iShape) : (0)
Tabulated gate 0, (iEntries) : (3000)
Tabulated gate 1, interval (dStart) : (-0.1)
Tabulated gate 1, interval (dEnd) : (0.05)
Tabulated gate 1, interval (dStep) : (5e-05)
Tabulated gate 1, interpolation (iShape) : (0)
Tabulated gate 1, (iEntries) : (3000)
Tabulated gate 2, interval (dStart) : (0)
Tabulated gate 2, interval (dEnd) : (1000)
Tabulated gate 2, interval (dStep) : (0.333333)
Tabulated gate 2, interpolation (iShape) : (0)
Tabulated gate 2, (iEntries) : (3000)
Tabulated gate 3, interval (dStart) : (-0.1)
Tabulated gate 3, interval (dEnd) : (0.05)
Tabulated gate 3, interval (dStep) : (5e-05)
Tabulated gate 3, interpolation (iShape) : (0)
Tabulated gate 3, (iEntries) : (3000)
Tabulated gate 4, interval (dStart) : (0)
Tabulated gate 4, interval (dEnd) : (1000)
Tabulated gate 4, interval (dStep) : (0.333333)
Tabulated gate 4, interpolation (iShape) : (0)
Tabulated gate 4, (iEntries) : (3000)
Tabulated gate 5, interval (dStart) : (-0.1)
Tabulated gate 5, interval (dEnd) : (0.05)
Tabulated gate 5, interval (dStep) : (5e-05)
Tabulated gate 5, interpolation (iShape) : (0)
Tabulated gate 5, (iEntries) : (3000)
Tabulated gate 6, interval (dStart) : (-0.1)
Tabulated gate 6, interval (dEnd) : (0.05)
Tabulated gate 6, interval (dStep) : (5e-05)
Tabulated gate 6, interpolation (iShape) : (0)
Tabulated gate 6, (iEntries) : (3000)
Tabulated gate 7, interval (dStart) : (-0.1)
Tabulated gate 7, interval (dEnd) : (0.05)
Tabulated gate 7, interval (dStep) : (5e-05)
Tabulated gate 7, interpolation (iShape) : (0)
Tabulated gate 7, (iEntries) : (3000)
Tabulated gate 8, interval (dStart) : (-0.1)
Tabulated gate 8, interval (dEnd) : (0.05)
Tabulated gate 8, interval (dStep) : (5e-05)
Tabulated gate 8, interpolation (iShape) : (0)
Tabulated gate 8, (iEntries) : (3000)
Tabulated gate 9, interval (dStart) : (-0.1)
Tabulated gate 9, interval (dEnd) : (0.05)
Tabulated gate 9, interval (dStep) : (5e-05)
Tabulated gate 9, interpolation (iShape) : (0)
Tabulated gate 9, (iEntries) : (3000)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: SET_DIAGONAL
00002 :: FORWARD_ELIMINATION    2
00003 :: SET_DIAGONAL
00004 :: FORWARD_ELIMINATION    4
00005 :: SET_DIAGONAL
00006 :: FORWARD_ELIMINATION    6
00007 :: SET_DIAGONAL
00008 :: FORWARD_ELIMINATION    8
00009 :: SET_DIAGONAL
00010 :: FORWARD_ELIMINATION   10
00011 :: SET_DIAGONAL
00012 :: FORWARD_ELIMINATION   12
00013 :: SET_DIAGONAL
00014 :: FORWARD_ELIMINATION   14
00015 :: SET_DIAGONAL
00016 :: FORWARD_ELIMINATION   16
00017 :: SET_DIAGONAL
00018 :: FORWARD_ELIMINATION   18
00019 :: SET_DIAGONAL
00020 :: FORWARD_ELIMINATION   20
00021 :: SET_DIAGONAL
00022 :: FORWARD_ELIMINATION   22
00023 :: SET_DIAGONAL
00024 :: FORWARD_ELIMINATION   24
00025 :: SET_DIAGONAL
00026 :: FORWARD_ELIMINATION   26
00027 :: SET_DIAGONAL
00028 :: FORWARD_ELIMINATION   28
00029 :: SET_DIAGONAL
00030 :: FORWARD_ELIMINATION   30
00031 :: SET_DIAGONAL
00032 :: FORWARD_ELIMINATION   32
00033 :: SET_DIAGONAL
00034 :: FORWARD_ELIMINATION   34
00035 :: FINISH
00036 :: BACKWARD_SUBSTITUTION   36
00037 :: FINISH_ROW
00038 :: BACKWARD_SUBSTITUTION   34
00039 :: FINISH_ROW
00040 :: BACKWARD_SUBSTITUTION   32
00041 :: FINISH_ROW
00042 :: BACKWARD_SUBSTITUTION   30
00043 :: FINISH_ROW
00044 :: BACKWARD_SUBSTITUTION   28
00045 :: FINISH_ROW
00046 :: BACKWARD_SUBSTITUTION   26
00047 :: FINISH_ROW
00048 :: BACKWARD_SUBSTITUTION   24
00049 :: FINISH_ROW
00050 :: BACKWARD_SUBSTITUTION   22
00051 :: FINISH_ROW
00052 :: BACKWARD_SUBSTITUTION   20
00053 :: FINISH_ROW
00054 :: BACKWARD_SUBSTITUTION   18
00055 :: FINISH_ROW
00056 :: BACKWARD_SUBSTITUTION   16
00057 :: FINISH_ROW
00058 :: BACKWARD_SUBSTITUTION   14
00059 :: FINISH_ROW
00060 :: BACKWARD_SUBSTITUTION   12
00061 :: FINISH_ROW
00062 :: BACKWARD_SUBSTITUTION   10
00063 :: FINISH_ROW
00064 :: BACKWARD_SUBSTITUTION    8
00065 :: FINISH_ROW
00066 :: BACKWARD_SUBSTITUTION    6
00067 :: FINISH_ROW
00068 :: BACKWARD_SUBSTITUTION    4
00069 :: FINISH_ROW
00070 :: BACKWARD_SUBSTITUTION    2
00071 :: FINISH_ROW
00072 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.00355e-10 0 498232 1.08417
00001 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00002 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00003 :: INITIALIZECHANNEL 0.08 8.36292e-08
00004 :: LOADVOLTAGETABLE
00005 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00006 :: CONCEPTGATE 1 1 (nil)							 0.973086
00007 :: UPDATECOMPARTMENTCURRENT
00008 :: REGISTERCHANNELCURRENT
00009 :: FLUXPOOL							 0
00010 :: INITIALIZECHANNEL -0.075 1.33807e-08
00011 :: CONCEPTGATE 2 1 (0)							 0
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.075 8.36292e-08
00014 :: LOADVOLTAGETABLE
00015 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00016 :: CONCEPTGATE 4 -1 (0)							 0
00017 :: UPDATECOMPARTMENTCURRENT
00018 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00019 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00020 :: INITIALIZECHANNEL 0.08 8.36292e-08
00021 :: LOADVOLTAGETABLE
00022 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00023 :: CONCEPTGATE 1 1 (nil)							 0.973086
00024 :: UPDATECOMPARTMENTCURRENT
00025 :: REGISTERCHANNELCURRENT
00026 :: FLUXPOOL							 0
00027 :: INITIALIZECHANNEL -0.075 1.33807e-08
00028 :: CONCEPTGATE 2 1 (0)							 0
00029 :: UPDATECOMPARTMENTCURRENT
00030 :: INITIALIZECHANNEL -0.075 8.36292e-08
00031 :: LOADVOLTAGETABLE
00032 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00033 :: CONCEPTGATE 4 -1 (0)							 0
00034 :: UPDATECOMPARTMENTCURRENT
00035 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00036 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00037 :: INITIALIZECHANNEL 0.08 2.0071e-07
00038 :: LOADVOLTAGETABLE
00039 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00040 :: CONCEPTGATE 1 1 (nil)							 0.973086
00041 :: UPDATECOMPARTMENTCURRENT
00042 :: REGISTERCHANNELCURRENT
00043 :: FLUXPOOL							 0
00044 :: INITIALIZECHANNEL -0.075 1.33807e-08
00045 :: CONCEPTGATE 2 1 (0)							 0
00046 :: UPDATECOMPARTMENTCURRENT
00047 :: INITIALIZECHANNEL -0.075 1.67258e-07
00048 :: LOADVOLTAGETABLE
00049 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00050 :: CONCEPTGATE 4 -1 (0)							 0
00051 :: UPDATECOMPARTMENTCURRENT
00052 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00053 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00054 :: INITIALIZECHANNEL 0.08 2.0071e-07
00055 :: LOADVOLTAGETABLE
00056 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00057 :: CONCEPTGATE 1 1 (nil)							 0.973086
00058 :: UPDATECOMPARTMENTCURRENT
00059 :: REGISTERCHANNELCURRENT
00060 :: FLUXPOOL							 0
00061 :: INITIALIZECHANNEL -0.075 1.33807e-08
00062 :: CONCEPTGATE 2 1 (0)							 0
00063 :: UPDATECOMPARTMENTCURRENT
00064 :: INITIALIZECHANNEL -0.075 1.67258e-07
00065 :: LOADVOLTAGETABLE
00066 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00067 :: CONCEPTGATE 4 -1 (0)							 0
00068 :: UPDATECOMPARTMENTCURRENT
00069 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00070 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00071 :: INITIALIZECHANNEL 0.055 3.34517e-07
00072 :: LOADVOLTAGETABLE
00073 :: CONCEPTGATE 5 2 (nil)							 0.014457
00074 :: CONCEPTGATE 6 1 (nil)							 0.995941
00075 :: UPDATECOMPARTMENTCURRENT
00076 :: INITIALIZECHANNEL 0.08 2.0071e-07
00077 :: LOADVOLTAGETABLE
00078 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00079 :: CONCEPTGATE 1 1 (nil)							 0.973086
00080 :: UPDATECOMPARTMENTCURRENT
00081 :: REGISTERCHANNELCURRENT
00082 :: FLUXPOOL							 0
00083 :: INITIALIZECHANNEL -0.075 3.34517e-07
00084 :: LOADVOLTAGETABLE
00085 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00086 :: UPDATECOMPARTMENTCURRENT
00087 :: INITIALIZECHANNEL -0.075 1.33807e-08
00088 :: CONCEPTGATE 2 1 (0)							 0
00089 :: UPDATECOMPARTMENTCURRENT
00090 :: INITIALIZECHANNEL -0.075 1.67258e-07
00091 :: LOADVOLTAGETABLE
00092 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00093 :: CONCEPTGATE 4 -1 (0)							 0
00094 :: UPDATECOMPARTMENTCURRENT
00095 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00096 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00097 :: INITIALIZECHANNEL 0.08 8.36292e-08
00098 :: LOADVOLTAGETABLE
00099 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00100 :: CONCEPTGATE 1 1 (nil)							 0.973086
00101 :: UPDATECOMPARTMENTCURRENT
00102 :: REGISTERCHANNELCURRENT
00103 :: FLUXPOOL							 0
00104 :: INITIALIZECHANNEL -0.075 1.33807e-08
00105 :: CONCEPTGATE 2 1 (0)							 0
00106 :: UPDATECOMPARTMENTCURRENT
00107 :: INITIALIZECHANNEL -0.075 8.36292e-08
00108 :: LOADVOLTAGETABLE
00109 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00110 :: CONCEPTGATE 4 -1 (0)							 0
00111 :: UPDATECOMPARTMENTCURRENT
00112 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00113 :: EXPONENTIALDECAY 1.7265e+09 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00114 :: INITIALIZECHANNEL 0.055 2.50888e-07
00115 :: LOADVOLTAGETABLE
00116 :: CONCEPTGATE 5 2 (nil)							 0.014457
00117 :: CONCEPTGATE 6 1 (nil)							 0.995941
00118 :: UPDATECOMPARTMENTCURRENT
00119 :: INITIALIZECHANNEL 0.08 1.33807e-07
00120 :: LOADVOLTAGETABLE
00121 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00122 :: CONCEPTGATE 1 1 (nil)							 0.973086
00123 :: UPDATECOMPARTMENTCURRENT
00124 :: REGISTERCHANNELCURRENT
00125 :: FLUXPOOL							 0
00126 :: INITIALIZECHANNEL -0.075 8.36292e-08
00127 :: LOADVOLTAGETABLE
00128 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00129 :: UPDATECOMPARTMENTCURRENT
00130 :: INITIALIZECHANNEL -0.075 1.33807e-08
00131 :: CONCEPTGATE 2 1 (0)							 0
00132 :: UPDATECOMPARTMENTCURRENT
00133 :: INITIALIZECHANNEL -0.075 3.34517e-07
00134 :: LOADVOLTAGETABLE
00135 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00136 :: CONCEPTGATE 4 -1 (0)							 0
00137 :: UPDATECOMPARTMENTCURRENT
00138 :: COMPARTMENT							 -1.99334e-10 2e-10 250836 1.15559
00139 :: EXPONENTIALDECAY 8.701e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00140 :: INITIALIZECHANNEL 0.055 9.9667e-07
00141 :: LOADVOLTAGETABLE
00142 :: CONCEPTGATE 5 2 (nil)							 0.014457
00143 :: CONCEPTGATE 6 1 (nil)							 0.995941
00144 :: UPDATECOMPARTMENTCURRENT
00145 :: INITIALIZECHANNEL 0.08 1.32889e-07
00146 :: LOADVOLTAGETABLE
00147 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00148 :: CONCEPTGATE 1 1 (nil)							 0.973086
00149 :: UPDATECOMPARTMENTCURRENT
00150 :: REGISTERCHANNELCURRENT
00151 :: FLUXPOOL							 0
00152 :: INITIALIZECHANNEL -0.075 4.98335e-07
00153 :: LOADVOLTAGETABLE
00154 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00155 :: UPDATECOMPARTMENTCURRENT
00156 :: INITIALIZECHANNEL -0.075 2.65779e-08
00157 :: CONCEPTGATE 2 1 (0)							 0
00158 :: UPDATECOMPARTMENTCURRENT
00159 :: INITIALIZECHANNEL -0.075 3.32223e-07
00160 :: LOADVOLTAGETABLE
00161 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00162 :: CONCEPTGATE 4 -1 (0)							 0
00163 :: UPDATECOMPARTMENTCURRENT
00164 :: INITIALIZECHANNEL -0.075 1.66112e-07
00165 :: LOADVOLTAGETABLE
00166 :: CONCEPTGATE 8 1 (nil)							 0.119301
00167 :: CONCEPTGATE 9 1 (nil)							 0.117152
00168 :: UPDATECOMPARTMENTCURRENT
00169 :: COMPARTMENT							 -1.30741e-10 0 382437 1.25644
00170 :: EXPONENTIALDECAY 1.3202e+09 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00171 :: INITIALIZECHANNEL 0.055 3.26851e-07
00172 :: LOADVOLTAGETABLE
00173 :: CONCEPTGATE 5 2 (nil)							 0.014457
00174 :: CONCEPTGATE 6 1 (nil)							 0.995941
00175 :: UPDATECOMPARTMENTCURRENT
00176 :: INITIALIZECHANNEL 0.08 1.74321e-07
00177 :: LOADVOLTAGETABLE
00178 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00179 :: CONCEPTGATE 1 1 (nil)							 0.973086
00180 :: UPDATECOMPARTMENTCURRENT
00181 :: REGISTERCHANNELCURRENT
00182 :: FLUXPOOL							 0
00183 :: INITIALIZECHANNEL -0.075 1.0895e-07
00184 :: LOADVOLTAGETABLE
00185 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00186 :: UPDATECOMPARTMENTCURRENT
00187 :: INITIALIZECHANNEL -0.075 1.74321e-08
00188 :: CONCEPTGATE 2 1 (0)							 0
00189 :: UPDATECOMPARTMENTCURRENT
00190 :: INITIALIZECHANNEL -0.075 4.35802e-07
00191 :: LOADVOLTAGETABLE
00192 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00193 :: CONCEPTGATE 4 -1 (0)							 0
00194 :: UPDATECOMPARTMENTCURRENT
00195 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00196 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00197 :: INITIALIZECHANNEL 0.08 1.0895e-07
00198 :: LOADVOLTAGETABLE
00199 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00200 :: CONCEPTGATE 1 1 (nil)							 0.973086
00201 :: UPDATECOMPARTMENTCURRENT
00202 :: REGISTERCHANNELCURRENT
00203 :: FLUXPOOL							 0
00204 :: INITIALIZECHANNEL -0.075 1.74321e-08
00205 :: CONCEPTGATE 2 1 (0)							 0
00206 :: UPDATECOMPARTMENTCURRENT
00207 :: INITIALIZECHANNEL -0.075 1.0895e-07
00208 :: LOADVOLTAGETABLE
00209 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00210 :: CONCEPTGATE 4 -1 (0)							 0
00211 :: UPDATECOMPARTMENTCURRENT
00212 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00213 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00214 :: INITIALIZECHANNEL 0.055 4.35802e-07
00215 :: LOADVOLTAGETABLE
00216 :: CONCEPTGATE 5 2 (nil)							 0.014457
00217 :: CONCEPTGATE 6 1 (nil)							 0.995941
00218 :: UPDATECOMPARTMENTCURRENT
00219 :: INITIALIZECHANNEL 0.08 3.70431e-07
00220 :: LOADVOLTAGETABLE
00221 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00222 :: CONCEPTGATE 1 1 (nil)							 0.973086
00223 :: UPDATECOMPARTMENTCURRENT
00224 :: REGISTERCHANNELCURRENT
00225 :: FLUXPOOL							 0
00226 :: INITIALIZECHANNEL -0.075 4.35802e-07
00227 :: LOADVOLTAGETABLE
00228 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00229 :: UPDATECOMPARTMENTCURRENT
00230 :: INITIALIZECHANNEL -0.075 1.74321e-08
00231 :: CONCEPTGATE 2 1 (0)							 0
00232 :: UPDATECOMPARTMENTCURRENT
00233 :: INITIALIZECHANNEL -0.075 3.26851e-07
00234 :: LOADVOLTAGETABLE
00235 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00236 :: CONCEPTGATE 4 -1 (0)							 0
00237 :: UPDATECOMPARTMENTCURRENT
00238 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00239 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00240 :: INITIALIZECHANNEL 0.08 3.70431e-07
00241 :: LOADVOLTAGETABLE
00242 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00243 :: CONCEPTGATE 1 1 (nil)							 0.973086
00244 :: UPDATECOMPARTMENTCURRENT
00245 :: REGISTERCHANNELCURRENT
00246 :: FLUXPOOL							 0
00247 :: INITIALIZECHANNEL -0.075 1.74321e-08
00248 :: CONCEPTGATE 2 1 (0)							 0
00249 :: UPDATECOMPARTMENTCURRENT
00250 :: INITIALIZECHANNEL -0.075 3.26851e-07
00251 :: LOADVOLTAGETABLE
00252 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00253 :: CONCEPTGATE 4 -1 (0)							 0
00254 :: UPDATECOMPARTMENTCURRENT
00255 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00256 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00257 :: INITIALIZECHANNEL 0.08 3.70431e-07
00258 :: LOADVOLTAGETABLE
00259 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00260 :: CONCEPTGATE 1 1 (nil)							 0.973086
00261 :: UPDATECOMPARTMENTCURRENT
00262 :: REGISTERCHANNELCURRENT
00263 :: FLUXPOOL							 0
00264 :: INITIALIZECHANNEL -0.075 1.74321e-08
00265 :: CONCEPTGATE 2 1 (0)							 0
00266 :: UPDATECOMPARTMENTCURRENT
00267 :: INITIALIZECHANNEL -0.075 3.26851e-07
00268 :: LOADVOLTAGETABLE
00269 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00270 :: CONCEPTGATE 4 -1 (0)							 0
00271 :: UPDATECOMPARTMENTCURRENT
00272 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00273 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00274 :: INITIALIZECHANNEL 0.08 2.17901e-07
00275 :: LOADVOLTAGETABLE
00276 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00277 :: CONCEPTGATE 1 1 (nil)							 0.973086
00278 :: UPDATECOMPARTMENTCURRENT
00279 :: REGISTERCHANNELCURRENT
00280 :: FLUXPOOL							 0
00281 :: INITIALIZECHANNEL -0.075 1.74321e-08
00282 :: CONCEPTGATE 2 1 (0)							 0
00283 :: UPDATECOMPARTMENTCURRENT
00284 :: INITIALIZECHANNEL -0.075 3.26851e-07
00285 :: LOADVOLTAGETABLE
00286 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00287 :: CONCEPTGATE 4 -1 (0)							 0
00288 :: UPDATECOMPARTMENTCURRENT
00289 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00290 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00291 :: INITIALIZECHANNEL 0.08 2.17901e-07
00292 :: LOADVOLTAGETABLE
00293 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00294 :: CONCEPTGATE 1 1 (nil)							 0.973086
00295 :: UPDATECOMPARTMENTCURRENT
00296 :: REGISTERCHANNELCURRENT
00297 :: FLUXPOOL							 0
00298 :: INITIALIZECHANNEL -0.075 1.74321e-08
00299 :: CONCEPTGATE 2 1 (0)							 0
00300 :: UPDATECOMPARTMENTCURRENT
00301 :: INITIALIZECHANNEL -0.075 3.26851e-07
00302 :: LOADVOLTAGETABLE
00303 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00304 :: CONCEPTGATE 4 -1 (0)							 0
00305 :: UPDATECOMPARTMENTCURRENT
00306 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00307 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00308 :: INITIALIZECHANNEL 0.08 1.0895e-07
00309 :: LOADVOLTAGETABLE
00310 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00311 :: CONCEPTGATE 1 1 (nil)							 0.973086
00312 :: UPDATECOMPARTMENTCURRENT
00313 :: REGISTERCHANNELCURRENT
00314 :: FLUXPOOL							 0
00315 :: INITIALIZECHANNEL -0.075 1.74321e-08
00316 :: CONCEPTGATE 2 1 (0)							 0
00317 :: UPDATECOMPARTMENTCURRENT
00318 :: INITIALIZECHANNEL -0.075 1.0895e-07
00319 :: LOADVOLTAGETABLE
00320 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00321 :: CONCEPTGATE 4 -1 (0)							 0
00322 :: UPDATECOMPARTMENTCURRENT
00323 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00324 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00325 :: INITIALIZECHANNEL 0.08 1.0895e-07
00326 :: LOADVOLTAGETABLE
00327 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00328 :: CONCEPTGATE 1 1 (nil)							 0.973086
00329 :: UPDATECOMPARTMENTCURRENT
00330 :: REGISTERCHANNELCURRENT
00331 :: FLUXPOOL							 0
00332 :: INITIALIZECHANNEL -0.075 1.74321e-08
00333 :: CONCEPTGATE 2 1 (0)							 0
00334 :: UPDATECOMPARTMENTCURRENT
00335 :: INITIALIZECHANNEL -0.075 1.0895e-07
00336 :: LOADVOLTAGETABLE
00337 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00338 :: CONCEPTGATE 4 -1 (0)							 0
00339 :: UPDATECOMPARTMENTCURRENT
00340 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00341 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08417)
VM Diagonals (pdDiagonals[1]) : (1.1675)
VM Diagonals (pdDiagonals[2]) : (1.1675)
VM Diagonals (pdDiagonals[3]) : (1.1675)
VM Diagonals (pdDiagonals[4]) : (1.1675)
VM Diagonals (pdDiagonals[5]) : (1.1675)
VM Diagonals (pdDiagonals[6]) : (1.1675)
VM Diagonals (pdDiagonals[7]) : (1.1675)
VM Diagonals (pdDiagonals[8]) : (1.15559)
VM Diagonals (pdDiagonals[9]) : (1.25644)
VM Diagonals (pdDiagonals[10]) : (1.16808)
VM Diagonals (pdDiagonals[11]) : (1.16808)
VM Diagonals (pdDiagonals[12]) : (1.16808)
VM Diagonals (pdDiagonals[13]) : (1.16808)
VM Diagonals (pdDiagonals[14]) : (1.16808)
VM Diagonals (pdDiagonals[15]) : (1.16808)
VM Diagonals (pdDiagonals[16]) : (1.16808)
VM Diagonals (pdDiagonals[17]) : (1.16808)
VM Diagonals (pdDiagonals[18]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0833335)
VM Axial Resistances (pdAxres[1]) : (-0.0833335)
VM Axial Resistances (pdAxres[2]) : (-0.0833335)
VM Axial Resistances (pdAxres[3]) : (-0.0833335)
VM Axial Resistances (pdAxres[4]) : (-0.0833335)
VM Axial Resistances (pdAxres[5]) : (-0.0833335)
VM Axial Resistances (pdAxres[6]) : (-0.0833335)
VM Axial Resistances (pdAxres[7]) : (-0.0833335)
VM Axial Resistances (pdAxres[8]) : (-0.0833335)
VM Axial Resistances (pdAxres[9]) : (-0.0833335)
VM Axial Resistances (pdAxres[10]) : (-0.0833335)
VM Axial Resistances (pdAxres[11]) : (-0.0833335)
VM Axial Resistances (pdAxres[12]) : (-0.0833335)
VM Axial Resistances (pdAxres[13]) : (-0.0833335)
VM Axial Resistances (pdAxres[14]) : (-0.0419543)
VM Axial Resistances (pdAxres[15]) : (-0.0833335)
VM Axial Resistances (pdAxres[16]) : (-0.171981)
VM Axial Resistances (pdAxres[17]) : (-0.1128)
VM Axial Resistances (pdAxres[18]) : (-0.0836226)
VM Axial Resistances (pdAxres[19]) : (-0.0836226)
VM Axial Resistances (pdAxres[20]) : (-0.0836226)
VM Axial Resistances (pdAxres[21]) : (-0.0836226)
VM Axial Resistances (pdAxres[22]) : (-0.0836226)
VM Axial Resistances (pdAxres[23]) : (-0.0836226)
VM Axial Resistances (pdAxres[24]) : (-0.0836226)
VM Axial Resistances (pdAxres[25]) : (-0.0836226)
VM Axial Resistances (pdAxres[26]) : (-0.0836226)
VM Axial Resistances (pdAxres[27]) : (-0.0836226)
VM Axial Resistances (pdAxres[28]) : (-0.0836226)
VM Axial Resistances (pdAxres[29]) : (-0.0836226)
VM Axial Resistances (pdAxres[30]) : (-0.0836226)
VM Axial Resistances (pdAxres[31]) : (-0.0836226)
VM Axial Resistances (pdAxres[32]) : (-0.0836226)
VM Axial Resistances (pdAxres[33]) : (-0.0836226)
VM Axial Resistances (pdAxres[34]) : (-0.0836226)
VM Axial Resistances (pdAxres[35]) : (-0.0836226)
VM Axial Resistances (pdAxres[36]) : (-0.0836226)
VM Axial Resistances (pdAxres[37]) : (-0.0836226)
VM Axial Resistances (pdAxres[38]) : (-0.0836226)
VM Axial Resistances (pdAxres[39]) : (-0.0836226)
VM Axial Resistances (pdAxres[40]) : (-0.0836226)
VM Axial Resistances (pdAxres[41]) : (-0.0836226)
VM Axial Resistances (pdAxres[42]) : (-0.0836226)
VM Axial Resistances (pdAxres[43]) : (-0.0836226)
VM Axial Resistances (pdAxres[44]) : (-0.0836226)
VM Axial Resistances (pdAxres[45]) : (-0.1128)
VM Axial Resistances (pdAxres[46]) : (-0.0833335)
VM Axial Resistances (pdAxres[47]) : (-0.0833335)
VM Axial Resistances (pdAxres[48]) : (-0.0833335)
VM Axial Resistances (pdAxres[49]) : (-0.0833335)
VM Axial Resistances (pdAxres[50]) : (-0.0833335)
VM Axial Resistances (pdAxres[51]) : (-0.0833335)
VM Axial Resistances (pdAxres[52]) : (-0.0833335)
VM Axial Resistances (pdAxres[53]) : (-0.0833335)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Axial Resistances (pdResults[2]) : (0)
VM Axial Resistances (pdResults[3]) : (0)
VM Axial Resistances (pdResults[4]) : (0)
VM Axial Resistances (pdResults[5]) : (0)
VM Axial Resistances (pdResults[6]) : (0)
VM Axial Resistances (pdResults[7]) : (0)
VM Axial Resistances (pdResults[8]) : (0)
VM Axial Resistances (pdResults[9]) : (0)
VM Axial Resistances (pdResults[10]) : (0)
VM Axial Resistances (pdResults[11]) : (0)
VM Axial Resistances (pdResults[12]) : (0)
VM Axial Resistances (pdResults[13]) : (0)
VM Axial Resistances (pdResults[14]) : (0)
VM Axial Resistances (pdResults[15]) : (0)
VM Axial Resistances (pdResults[16]) : (0)
VM Axial Resistances (pdResults[17]) : (0)
VM Axial Resistances (pdResults[18]) : (0)
VM Axial Resistances (pdResults[19]) : (0)
VM Axial Resistances (pdResults[20]) : (0)
VM Axial Resistances (pdResults[21]) : (0)
VM Axial Resistances (pdResults[22]) : (0)
VM Axial Resistances (pdResults[23]) : (0)
VM Axial Resistances (pdResults[24]) : (0)
VM Axial Resistances (pdResults[25]) : (0)
VM Axial Resistances (pdResults[26]) : (0)
VM Axial Resistances (pdResults[27]) : (0)
VM Axial Resistances (pdResults[28]) : (0)
VM Axial Resistances (pdResults[29]) : (0)
VM Axial Resistances (pdResults[30]) : (0)
VM Axial Resistances (pdResults[31]) : (0)
VM Axial Resistances (pdResults[32]) : (0)
VM Axial Resistances (pdResults[33]) : (0)
VM Axial Resistances (pdResults[34]) : (0)
VM Axial Resistances (pdResults[35]) : (0)
VM Axial Resistances (pdResults[36]) : (0)
VM Axial Resistances (pdResults[37]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.06)
VM Membrane Potentials (pdVms[1]) : (-0.06)
VM Membrane Potentials (pdVms[2]) : (-0.06)
VM Membrane Potentials (pdVms[3]) : (-0.06)
VM Membrane Potentials (pdVms[4]) : (-0.06)
VM Membrane Potentials (pdVms[5]) : (-0.06)
VM Membrane Potentials (pdVms[6]) : (-0.06)
VM Membrane Potentials (pdVms[7]) : (-0.06)
VM Membrane Potentials (pdVms[8]) : (-0.06)
VM Membrane Potentials (pdVms[9]) : (-0.06)
VM Membrane Potentials (pdVms[10]) : (-0.06)
VM Membrane Potentials (pdVms[11]) : (-0.06)
VM Membrane Potentials (pdVms[12]) : (-0.06)
VM Membrane Potentials (pdVms[13]) : (-0.06)
VM Membrane Potentials (pdVms[14]) : (-0.06)
VM Membrane Potentials (pdVms[15]) : (-0.06)
VM Membrane Potentials (pdVms[16]) : (-0.06)
VM Membrane Potentials (pdVms[17]) : (-0.06)
VM Membrane Potentials (pdVms[18]) : (-0.06)
',
						   timeout => 10,
						  },
						  {
						   description => 'Does the simulation produce the correct output (1)?',
						   numerical_compare => "arithmetic differences on the automated tester",
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "/usr/local/ns-sli/tests/specifications/strings/traub91_asym.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 1,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
# 						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we load the traub91 model (2)?",
						   read => "Using hsolve",
						   timeout => 15,
						   write => "sli_load test-traub94cell-v0/traub94cell1.g",
						  },
						  {
						   description => "Can we write the traub94 model to an NDF file ?",
						   wait => 2,
						   write => "ndf_save /** /tmp/traub94cell1.ndf",
						  },
						 ],
				description => "commands to load and save the traub94 model",
				disabled => "this script does not work from the gshell because the include mechanism of G-2 depends on the current working directory.",
				side_effects => "creates a model in the model container",
				todo => "talk to Dave about this disabled test",
			       },
			       {
				arguments => [
					      '--time',
					      '0.5',
					      '--time-step',
					      '0.00002',
					      '--cell',
					      '/tmp/traub94cell1.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
# 					      '--verbose',
# 					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub94cell1.ndf ?',
						   disabled => "this test was not implemented",
						   read => 'Done',
						   timeout => 30,
						  },
						  {
						   description => 'Does the simulation produce the correct output (2)?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "/usr/local/ns-sli/tests/specifications/strings/traub94_Vm.out.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 20,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				disabled => "this test is disabled because the script that saves the traub94 only works from the ns-sli executable, but not from the gshell.  This is due to the broken include mechanism of G-2",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
# 						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we load the purkinje cell model and wait for the querymachine prompt ?",
						   read => 'tests/scripts/PurkM9_model/Purk2M9.p read: 1600 compartments',
						   timeout => 20,
						   write => "sli_load /usr/local/ns-sli/tests/scripts/PurkM9_model/CURRENT9.g",
						  },
						  {
						   description => "quit the querymachine",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Can we write the purkinje cell model to an NDF file ?",
						   wait => 2,
						   write => "ndf_save /** /tmp/purkinje.ndf",
						  },
						 ],
				description => "commands to load and save the purkinje cell model",
				side_effects => "creates a model in the model container",
			       },
			       {
				arguments => [
					      '--time',
					      '0.5',
					      '--time-step',
					      '0.00002',
					      '--cell',
					      '/tmp/purkinje.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
# 					      '--verbose',
# 					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, purkinje.ndf ?',
						   disabled => "this test was not implemented",
						   read => 'Done',
						   timeout => 30,
						  },
						  {
						   description => 'Does the simulation produce the correct output (3)?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "/usr/local/ns-sli/tests/specifications/strings/PurkM9_soma_1.5nA.g3",
							   },
						   wait => 40,
						  },
						 ],
				description => "running the converted model with SSP to see if the conversion was done correctly",
				disabled => "this test is disabled because the script that saves the purkinje cell model is disabled.  The model-container parser does not parse the generated output because bison does not like so big input files.",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
# 						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
				todo => "talk to Dave about this test",
			       },
			      ],
       description => "various tests of the ndf_save command",
       name => 'ndf_save.t',
       mac_report => 'Some of these tests will fail if the machine is under heavy load. Test cases are fine',
      };


return $test;


