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
						   description => "Can we load the mossy fiber population?",
						   write => 'ndf_namespace_load Fibers fibers/mossyfiber.ndf',
						  },
						  {
						   description => "Can we load the Golgi cell population?",
						   write => 'ndf_namespace_load Golgi legacy/populations/golgi.ndf',
						  },
						  {
						   description => "Can we load the granule cell population?",
						   write => 'ndf_namespace_load Granule legacy/populations/granule.ndf',
						  },
						  {
						   description => "Can we load the Purkinje cell population?",
						   write => 'ndf_namespace_load Purkinje legacy/populations/purkinje.ndf',
						  },
						  {
						   description => "Were the namespaces created (1)?",
						   read => 'File (/usr/local/neurospaces/models/library/fibers/mossyfiber.ndf) --> Namespace (Fibers::)
File (/usr/local/neurospaces/models/library/legacy/populations/golgi.ndf) --> Namespace (Golgi::)
File (/usr/local/neurospaces/models/library/legacy/populations/granule.ndf) --> Namespace (Granule::)
File (/usr/local/neurospaces/models/library/legacy/populations/purkinje.ndf) --> Namespace (Purkinje::)
',
						   write => 'list_namespaces ::',
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
						   write => "create network /CerebellarCortex",
						  },
						  {
						   comment => "This disabled command is only here to show how the createmap command works.  Because the populations have been imported from NDF files, this command is not necessary here.  Similar commands would be given to instantiate the other populations.",
						   description => "Can we create a first population of neurons?",
						   disabled => "This disabled command is only here to show how the createmap command works.  Because the populations have been imported from NDF files, this command is not necessary here.  Similar commands would be given to instantiate the other populations",
						   read => 'created a new private component with name /CerebellarCortex/MossyFibers',
						   write => 'createmap ::Fibers::/MossyFiber /CerebellarCortex/MossyFibers 10 3 0.00036 0.003',
						  },
						  {
						   description => "Can we alias the imported mossy fiber population?",
						   write => 'insert_alias ::Fibers::/MossyFiberArray /CerebellarCortex/MossyFibers',
						  },
						  {
						   description => "Can we set the coordinate of the mossy fiber population, X?",
						   write => 'model_parameter_add /CerebellarCortex/MossyFibers X -0.00012',
						  },
						  {
						   description => "Can we set the coordinate of the mossy fiber population, Y?",
						   write => 'model_parameter_add /CerebellarCortex/MossyFibers Y -0.000075',
						  },
						  {
						   description => "Can we set the coordinate of the mossy fiber population, Z?",
						   write => 'model_parameter_add /CerebellarCortex/MossyFibers Z -0.0001',
						  },
						  {
						   description => 'Do we find all the components of the created mossy fiber population?',
						   read => '
- /CerebellarCortex
- /CerebellarCortex/MossyFibers
- /CerebellarCortex/MossyFibers/MossyGrid
- /CerebellarCortex/MossyFibers/0
- /CerebellarCortex/MossyFibers/0/value
- /CerebellarCortex/MossyFibers/0/spikegen
- /CerebellarCortex/MossyFibers/1
- /CerebellarCortex/MossyFibers/1/value
- /CerebellarCortex/MossyFibers/1/spikegen
- /CerebellarCortex/MossyFibers/2
- /CerebellarCortex/MossyFibers/2/value
- /CerebellarCortex/MossyFibers/2/spikegen
- /CerebellarCortex/MossyFibers/3
- /CerebellarCortex/MossyFibers/3/value
- /CerebellarCortex/MossyFibers/3/spikegen
- /CerebellarCortex/MossyFibers/4
- /CerebellarCortex/MossyFibers/4/value
- /CerebellarCortex/MossyFibers/4/spikegen
- /CerebellarCortex/MossyFibers/5
- /CerebellarCortex/MossyFibers/5/value
- /CerebellarCortex/MossyFibers/5/spikegen
- /CerebellarCortex/MossyFibers/6
- /CerebellarCortex/MossyFibers/6/value
- /CerebellarCortex/MossyFibers/6/spikegen
- /CerebellarCortex/MossyFibers/7
- /CerebellarCortex/MossyFibers/7/value
- /CerebellarCortex/MossyFibers/7/spikegen
- /CerebellarCortex/MossyFibers/8
- /CerebellarCortex/MossyFibers/8/value
- /CerebellarCortex/MossyFibers/8/spikegen
- /CerebellarCortex/MossyFibers/9
- /CerebellarCortex/MossyFibers/9/value
- /CerebellarCortex/MossyFibers/9/spikegen
- /CerebellarCortex/MossyFibers/10
- /CerebellarCortex/MossyFibers/10/value
- /CerebellarCortex/MossyFibers/10/spikegen
- /CerebellarCortex/MossyFibers/11
- /CerebellarCortex/MossyFibers/11/value
- /CerebellarCortex/MossyFibers/11/spikegen
- /CerebellarCortex/MossyFibers/12
- /CerebellarCortex/MossyFibers/12/value
- /CerebellarCortex/MossyFibers/12/spikegen
- /CerebellarCortex/MossyFibers/13
- /CerebellarCortex/MossyFibers/13/value
- /CerebellarCortex/MossyFibers/13/spikegen
- /CerebellarCortex/MossyFibers/14
- /CerebellarCortex/MossyFibers/14/value
- /CerebellarCortex/MossyFibers/14/spikegen
- /CerebellarCortex/MossyFibers/15
- /CerebellarCortex/MossyFibers/15/value
- /CerebellarCortex/MossyFibers/15/spikegen
- /CerebellarCortex/MossyFibers/16
- /CerebellarCortex/MossyFibers/16/value
- /CerebellarCortex/MossyFibers/16/spikegen
- /CerebellarCortex/MossyFibers/17
- /CerebellarCortex/MossyFibers/17/value
- /CerebellarCortex/MossyFibers/17/spikegen
- /CerebellarCortex/MossyFibers/18
- /CerebellarCortex/MossyFibers/18/value
- /CerebellarCortex/MossyFibers/18/spikegen
- /CerebellarCortex/MossyFibers/19
- /CerebellarCortex/MossyFibers/19/value
- /CerebellarCortex/MossyFibers/19/spikegen
- /CerebellarCortex/MossyFibers/20
- /CerebellarCortex/MossyFibers/20/value
- /CerebellarCortex/MossyFibers/20/spikegen
- /CerebellarCortex/MossyFibers/21
- /CerebellarCortex/MossyFibers/21/value
- /CerebellarCortex/MossyFibers/21/spikegen
- /CerebellarCortex/MossyFibers/22
- /CerebellarCortex/MossyFibers/22/value
- /CerebellarCortex/MossyFibers/22/spikegen
- /CerebellarCortex/MossyFibers/23
- /CerebellarCortex/MossyFibers/23/value
- /CerebellarCortex/MossyFibers/23/spikegen
- /CerebellarCortex/MossyFibers/24
- /CerebellarCortex/MossyFibers/24/value
- /CerebellarCortex/MossyFibers/24/spikegen
- /CerebellarCortex/MossyFibers/25
- /CerebellarCortex/MossyFibers/25/value
- /CerebellarCortex/MossyFibers/25/spikegen
- /CerebellarCortex/MossyFibers/26
- /CerebellarCortex/MossyFibers/26/value
- /CerebellarCortex/MossyFibers/26/spikegen
- /CerebellarCortex/MossyFibers/27
- /CerebellarCortex/MossyFibers/27/value
- /CerebellarCortex/MossyFibers/27/spikegen
- /CerebellarCortex/MossyFibers/28
- /CerebellarCortex/MossyFibers/28/value
- /CerebellarCortex/MossyFibers/28/spikegen
- /CerebellarCortex/MossyFibers/29
- /CerebellarCortex/MossyFibers/29/value
- /CerebellarCortex/MossyFibers/29/spikegen
',
						   write => 'list_elements /**',
						  },
						  {
						   description => "Can we alias the imported granule cell population?",
						   write => 'insert_alias ::Granule::/GranulePopulation /CerebellarCortex/Granules',
						  },
						  {
						   description => "Can we set the coordinate of the granule cell population, X?",
						   write => 'model_parameter_add /CerebellarCortex/Granules X 2.5e-05',
						  },
						  {
						   description => "Can we set the coordinate of the granule cell population, Y?",
						   write => 'model_parameter_add /CerebellarCortex/Granules Y 1.875e-05',
						  },
						  {
						   description => "Can we set the coordinate of the granule cell population, Z?",
						   write => 'model_parameter_add /CerebellarCortex/Granules Z -0.00005',
						  },
						  {
						   description => "Can we alias the imported Golgi cell population?",
						   write => 'insert_alias ::Golgi::/GolgiPopulation /CerebellarCortex/Golgis',
						  },
						  {
						   description => "Can we set the coordinate of the Golgi cell population, X?",
						   write => 'model_parameter_add /CerebellarCortex/Golgis X 0.00015',
						  },
						  {
						   description => "Can we set the coordinate of the Golgi cell population, Y?",
						   write => 'model_parameter_add /CerebellarCortex/Golgis Y 0.00010',
						  },
						  {
						   description => "Can we set the coordinate of the Golgi cell population, Z?",
						   write => 'model_parameter_add /CerebellarCortex/Golgis Z 0.00005',
						  },
						  {
						   description => "Can we alias the imported purkinje cell population?",
						   write => 'insert_alias ::Purkinje::/PurkinjePopulation /CerebellarCortex/Purkinjes',
						  },
						  {
						   description => "Can we create a projection from the Granule cell population to the Golgi cell population?",
						   read => '
created a new projection with name /CerebellarCortex/ForwardProjection',
						   timeout => 10,
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/ForwardProjection ../Granules ../Golgis /CerebellarCortex/Granules /CerebellarCortex/Golgis spikegen mf_AMPA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.0025 -0.0003 -0.0025 0.0025 0.0003 0.0025 weight 45.0 delay radial 0.0 velocity 0.5 1.0 1212.0',
						  },
						  {
						   description => "Can we create the main projection to hold the two subcomponents of the backward projection?",
						   write => "create projection /CerebellarCortex/BackwardProjection",
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAA component?",
						   read => '
created a new projection with name /CerebellarCortex/BackwardProjection/GABAA',
						   timeout => 10,
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/BackwardProjection/GABAA ../../Golgis ../../Granules /CerebellarCortex/Golgis /CerebellarCortex/Granules spikegen GABAA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 45.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAB component?",
						   read => '
created a new projection with name /CerebellarCortex/BackwardProjection/GABAB',
						   timeout => 10,
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/BackwardProjection/GABAB ../../Golgis ../../Granules /CerebellarCortex/Golgis /CerebellarCortex/Granules spikegen GABAB box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 9.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
						  },

						  # copied and adapted from the network.t test in the model container.

						  (
						   {
						    description => "What is the xpower of the delayed rectifier channel in the first Golgi cell ?",
						    read => "value = 4
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Xpower'",
						   },
						   {
						    description => "What is the ypower of the delayed rectifier channel in the first Golgi cell ?",
						    read => "value = 1
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Ypower'",
						   },
						   {
						    description => "What is the zpower of the delayed rectifier channel in the first Golgi cell ?",
						    read => "value = 0
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Zpower'",
						   },
						   {
						    description => "What is the scaled conductance of the delayed rectifier channel in the first Golgi cell ?",
						    read => "scaled value = 1.91937e-07
",
						    write => "querymachine 'printparameterscaled /CerebellarCortex/Golgis/0/Golgi_soma/KDr G_MAX'",
						   },
						   {
						    description => "What is the unscaled conductance of the delayed rectifier channel in the first Golgi cell ?",
						    read => "value = 67.8839
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr G_MAX'",
						   },
						   {
						    description => "What is the reversal potential of the delayed rectifier channel in the first Golgi cell ?",
						    read => "value = -0.09
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Erev'",
						   },
						   {
						    description => "How does neurospaces react if we try to access parameters that are not defined ?",
						    read => "parameter not found in symbol
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax'",
						   },
						   {
						    description => "What is the diameter of the soma in the first Golgi cell ?",
						    read => "value = 3e-05
",
						    write => "querymachine 'printparameter /CerebellarCortex/Golgis/0/Golgi_soma DIA'",
						   },
						  ),

						  # copied from the connections.t test of the model-container

						  (
						   {
						    description => "What is the treespaces ID of a synaptic channel on a spine of the first Purkinje cell ?",
						    read => 'serial ID = 1141
',
						    write => "querymachine 'serialID /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par'",
						   },
						   {
						    description => "What is the treespaces ID of a synaptic channel on a spine of the second Purkinje cell ?",
						    read => "serial ID = 25523
",
						    write => "querymachine 'serialID /CerebellarCortex/Purkinjes/1 /CerebellarCortex/Purkinjes/1/segments/b3s46[15]/Purkinje_spine_0/head/par'",
						   },
						   {
						    description => "What is the number of connections in the feedforward projection",
						    read => "Number of connections : 98112
",
						    write => "querymachine 'connectioncount /CerebellarCortex/ForwardProjection'",
						   },
						   {
						    description => "What are the connections in the feedforward and feedback projections for the first Golgi cell's soma ?",
						    read => "Connection (00000)
        CCONN  pre(137382.000000) -> post(113.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00001)
        CCONN  pre(137382.000000) -> post(135.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00002)
        CCONN  pre(137382.000000) -> post(157.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00003)
        CCONN  pre(137382.000000) -> post(179.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00004)
        CCONN  pre(137382.000000) -> post(201.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00005)
        CCONN  pre(137382.000000) -> post(223.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00006)
        CCONN  pre(137382.000000) -> post(245.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00007)
        CCONN  pre(137382.000000) -> post(267.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00008)
        CCONN  pre(137382.000000) -> post(289.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00009)
        CCONN  pre(137382.000000) -> post(311.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00010)
        CCONN  pre(137382.000000) -> post(333.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00011)
        CCONN  pre(137382.000000) -> post(355.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00012)
        CCONN  pre(137382.000000) -> post(2753.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00013)
        CCONN  pre(137382.000000) -> post(2775.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00014)
        CCONN  pre(137382.000000) -> post(2797.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00015)
        CCONN  pre(137382.000000) -> post(2819.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00016)
        CCONN  pre(137382.000000) -> post(2841.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00017)
        CCONN  pre(137382.000000) -> post(2863.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00018)
        CCONN  pre(137382.000000) -> post(2885.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00019)
        CCONN  pre(137382.000000) -> post(2907.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00020)
        CCONN  pre(137382.000000) -> post(2929.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00021)
        CCONN  pre(137382.000000) -> post(2951.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00022)
        CCONN  pre(137382.000000) -> post(2973.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00023)
        CCONN  pre(137382.000000) -> post(2995.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00024)
        CCONN  pre(137382.000000) -> post(5393.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00025)
        CCONN  pre(137382.000000) -> post(5415.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00026)
        CCONN  pre(137382.000000) -> post(5437.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00027)
        CCONN  pre(137382.000000) -> post(5459.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00028)
        CCONN  pre(137382.000000) -> post(5481.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00029)
        CCONN  pre(137382.000000) -> post(5503.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00030)
        CCONN  pre(137382.000000) -> post(5525.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00031)
        CCONN  pre(137382.000000) -> post(5547.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00032)
        CCONN  pre(137382.000000) -> post(5569.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00033)
        CCONN  pre(137382.000000) -> post(5591.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00034)
        CCONN  pre(137382.000000) -> post(5613.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00035)
        CCONN  pre(137382.000000) -> post(5635.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00036)
        CCONN  pre(137382.000000) -> post(8033.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00037)
        CCONN  pre(137382.000000) -> post(8055.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00038)
        CCONN  pre(137382.000000) -> post(8077.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00039)
        CCONN  pre(137382.000000) -> post(8099.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00040)
        CCONN  pre(137382.000000) -> post(8121.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00041)
        CCONN  pre(137382.000000) -> post(8143.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00042)
        CCONN  pre(137382.000000) -> post(8165.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00043)
        CCONN  pre(137382.000000) -> post(8187.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00044)
        CCONN  pre(137382.000000) -> post(8209.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00045)
        CCONN  pre(137382.000000) -> post(8231.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00046)
        CCONN  pre(137382.000000) -> post(8253.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00047)
        CCONN  pre(137382.000000) -> post(8275.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00048)
        CCONN  pre(137382.000000) -> post(10673.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00049)
        CCONN  pre(137382.000000) -> post(10695.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00050)
        CCONN  pre(137382.000000) -> post(10717.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00051)
        CCONN  pre(137382.000000) -> post(10739.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00052)
        CCONN  pre(137382.000000) -> post(10761.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00053)
        CCONN  pre(137382.000000) -> post(10783.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00054)
        CCONN  pre(137382.000000) -> post(10805.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00055)
        CCONN  pre(137382.000000) -> post(10827.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00056)
        CCONN  pre(137382.000000) -> post(10849.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00057)
        CCONN  pre(137382.000000) -> post(10871.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00058)
        CCONN  pre(137382.000000) -> post(10893.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00059)
        CCONN  pre(137382.000000) -> post(10915.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00060)
        CCONN  pre(137382.000000) -> post(13313.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00061)
        CCONN  pre(137382.000000) -> post(13335.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00062)
        CCONN  pre(137382.000000) -> post(13357.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00063)
        CCONN  pre(137382.000000) -> post(13379.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00064)
        CCONN  pre(137382.000000) -> post(13401.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00065)
        CCONN  pre(137382.000000) -> post(13423.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00066)
        CCONN  pre(137382.000000) -> post(13445.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00067)
        CCONN  pre(137382.000000) -> post(13467.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00068)
        CCONN  pre(137382.000000) -> post(13489.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00069)
        CCONN  pre(137382.000000) -> post(13511.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00070)
        CCONN  pre(137382.000000) -> post(13533.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00071)
        CCONN  pre(137382.000000) -> post(13555.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00072)
        CCONN  pre(137382.000000) -> post(15953.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00073)
        CCONN  pre(137382.000000) -> post(15975.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00074)
        CCONN  pre(137382.000000) -> post(15997.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00075)
        CCONN  pre(137382.000000) -> post(16019.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00076)
        CCONN  pre(137382.000000) -> post(16041.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00077)
        CCONN  pre(137382.000000) -> post(16063.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00078)
        CCONN  pre(137382.000000) -> post(16085.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00079)
        CCONN  pre(137382.000000) -> post(16107.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00080)
        CCONN  pre(137382.000000) -> post(16129.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00081)
        CCONN  pre(137382.000000) -> post(16151.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00082)
        CCONN  pre(137382.000000) -> post(16173.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00083)
        CCONN  pre(137382.000000) -> post(16195.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00084)
        CCONN  pre(137382.000000) -> post(18593.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00085)
        CCONN  pre(137382.000000) -> post(18615.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00086)
        CCONN  pre(137382.000000) -> post(18637.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00087)
        CCONN  pre(137382.000000) -> post(18659.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00088)
        CCONN  pre(137382.000000) -> post(18681.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00089)
        CCONN  pre(137382.000000) -> post(18703.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00090)
        CCONN  pre(137382.000000) -> post(18725.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00091)
        CCONN  pre(137382.000000) -> post(18747.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00092)
        CCONN  pre(137382.000000) -> post(18769.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00093)
        CCONN  pre(137382.000000) -> post(18791.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00094)
        CCONN  pre(137382.000000) -> post(18813.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00095)
        CCONN  pre(137382.000000) -> post(18835.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00096)
        CCONN  pre(137382.000000) -> post(21233.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00097)
        CCONN  pre(137382.000000) -> post(21255.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00098)
        CCONN  pre(137382.000000) -> post(21277.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00099)
        CCONN  pre(137382.000000) -> post(21299.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00100)
        CCONN  pre(137382.000000) -> post(21321.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00101)
        CCONN  pre(137382.000000) -> post(21343.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00102)
        CCONN  pre(137382.000000) -> post(21365.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00103)
        CCONN  pre(137382.000000) -> post(21387.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00104)
        CCONN  pre(137382.000000) -> post(21409.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00105)
        CCONN  pre(137382.000000) -> post(21431.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00106)
        CCONN  pre(137382.000000) -> post(21453.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00107)
        CCONN  pre(137382.000000) -> post(21475.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00108)
        CCONN  pre(137382.000000) -> post(23873.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00109)
        CCONN  pre(137382.000000) -> post(23895.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00110)
        CCONN  pre(137382.000000) -> post(23917.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00111)
        CCONN  pre(137382.000000) -> post(23939.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00112)
        CCONN  pre(137382.000000) -> post(23961.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00113)
        CCONN  pre(137382.000000) -> post(23983.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00114)
        CCONN  pre(137382.000000) -> post(24005.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00115)
        CCONN  pre(137382.000000) -> post(24027.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00116)
        CCONN  pre(137382.000000) -> post(24049.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00117)
        CCONN  pre(137382.000000) -> post(24071.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00118)
        CCONN  pre(137382.000000) -> post(24093.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00119)
        CCONN  pre(137382.000000) -> post(24115.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00120)
        CCONN  pre(137382.000000) -> post(26513.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00121)
        CCONN  pre(137382.000000) -> post(26535.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00122)
        CCONN  pre(137382.000000) -> post(26557.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00123)
        CCONN  pre(137382.000000) -> post(26579.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00124)
        CCONN  pre(137382.000000) -> post(26601.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00125)
        CCONN  pre(137382.000000) -> post(26623.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00126)
        CCONN  pre(137382.000000) -> post(26645.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00127)
        CCONN  pre(137382.000000) -> post(26667.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00128)
        CCONN  pre(137382.000000) -> post(26689.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00129)
        CCONN  pre(137382.000000) -> post(26711.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00130)
        CCONN  pre(137382.000000) -> post(26733.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00131)
        CCONN  pre(137382.000000) -> post(26755.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00132)
        CCONN  pre(137382.000000) -> post(29153.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00133)
        CCONN  pre(137382.000000) -> post(29175.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00134)
        CCONN  pre(137382.000000) -> post(29197.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00135)
        CCONN  pre(137382.000000) -> post(29219.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00136)
        CCONN  pre(137382.000000) -> post(29241.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00137)
        CCONN  pre(137382.000000) -> post(29263.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00138)
        CCONN  pre(137382.000000) -> post(29285.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00139)
        CCONN  pre(137382.000000) -> post(29307.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00140)
        CCONN  pre(137382.000000) -> post(29329.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00141)
        CCONN  pre(137382.000000) -> post(29351.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00142)
        CCONN  pre(137382.000000) -> post(29373.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00143)
        CCONN  pre(137382.000000) -> post(29395.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00144)
        CCONN  pre(137382.000000) -> post(31793.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00145)
        CCONN  pre(137382.000000) -> post(31815.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00146)
        CCONN  pre(137382.000000) -> post(31837.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00147)
        CCONN  pre(137382.000000) -> post(31859.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00148)
        CCONN  pre(137382.000000) -> post(31881.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00149)
        CCONN  pre(137382.000000) -> post(31903.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00150)
        CCONN  pre(137382.000000) -> post(31925.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00151)
        CCONN  pre(137382.000000) -> post(31947.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00152)
        CCONN  pre(137382.000000) -> post(31969.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00153)
        CCONN  pre(137382.000000) -> post(31991.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00154)
        CCONN  pre(137382.000000) -> post(32013.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00155)
        CCONN  pre(137382.000000) -> post(32035.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00156)
        CCONN  pre(137382.000000) -> post(68753.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00157)
        CCONN  pre(137382.000000) -> post(68775.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00158)
        CCONN  pre(137382.000000) -> post(68797.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00159)
        CCONN  pre(137382.000000) -> post(68819.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00160)
        CCONN  pre(137382.000000) -> post(68841.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00161)
        CCONN  pre(137382.000000) -> post(68863.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00162)
        CCONN  pre(137382.000000) -> post(68885.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00163)
        CCONN  pre(137382.000000) -> post(68907.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00164)
        CCONN  pre(137382.000000) -> post(68929.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00165)
        CCONN  pre(137382.000000) -> post(68951.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00166)
        CCONN  pre(137382.000000) -> post(68973.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00167)
        CCONN  pre(137382.000000) -> post(68995.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00168)
        CCONN  pre(137382.000000) -> post(71393.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00169)
        CCONN  pre(137382.000000) -> post(71415.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00170)
        CCONN  pre(137382.000000) -> post(71437.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00171)
        CCONN  pre(137382.000000) -> post(71459.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00172)
        CCONN  pre(137382.000000) -> post(71481.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00173)
        CCONN  pre(137382.000000) -> post(71503.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00174)
        CCONN  pre(137382.000000) -> post(71525.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00175)
        CCONN  pre(137382.000000) -> post(71547.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00176)
        CCONN  pre(137382.000000) -> post(71569.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00177)
        CCONN  pre(137382.000000) -> post(71591.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00178)
        CCONN  pre(137382.000000) -> post(71613.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00179)
        CCONN  pre(137382.000000) -> post(71635.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00180)
        CCONN  pre(137382.000000) -> post(74033.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00181)
        CCONN  pre(137382.000000) -> post(74055.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00182)
        CCONN  pre(137382.000000) -> post(74077.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00183)
        CCONN  pre(137382.000000) -> post(74099.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00184)
        CCONN  pre(137382.000000) -> post(74121.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00185)
        CCONN  pre(137382.000000) -> post(74143.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00186)
        CCONN  pre(137382.000000) -> post(74165.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00187)
        CCONN  pre(137382.000000) -> post(74187.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00188)
        CCONN  pre(137382.000000) -> post(74209.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00189)
        CCONN  pre(137382.000000) -> post(74231.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00190)
        CCONN  pre(137382.000000) -> post(74253.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00191)
        CCONN  pre(137382.000000) -> post(74275.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00192)
        CCONN  pre(137382.000000) -> post(76673.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00193)
        CCONN  pre(137382.000000) -> post(76695.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00194)
        CCONN  pre(137382.000000) -> post(76717.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00195)
        CCONN  pre(137382.000000) -> post(76739.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00196)
        CCONN  pre(137382.000000) -> post(76761.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00197)
        CCONN  pre(137382.000000) -> post(76783.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00198)
        CCONN  pre(137382.000000) -> post(76805.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00199)
        CCONN  pre(137382.000000) -> post(76827.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00200)
        CCONN  pre(137382.000000) -> post(76849.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00201)
        CCONN  pre(137382.000000) -> post(76871.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00202)
        CCONN  pre(137382.000000) -> post(76893.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00203)
        CCONN  pre(137382.000000) -> post(76915.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00204)
        CCONN  pre(137382.000000) -> post(79313.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00205)
        CCONN  pre(137382.000000) -> post(79335.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00206)
        CCONN  pre(137382.000000) -> post(79357.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00207)
        CCONN  pre(137382.000000) -> post(79379.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00208)
        CCONN  pre(137382.000000) -> post(79401.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00209)
        CCONN  pre(137382.000000) -> post(79423.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00210)
        CCONN  pre(137382.000000) -> post(79445.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00211)
        CCONN  pre(137382.000000) -> post(79467.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00212)
        CCONN  pre(137382.000000) -> post(79489.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00213)
        CCONN  pre(137382.000000) -> post(79511.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00214)
        CCONN  pre(137382.000000) -> post(79533.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00215)
        CCONN  pre(137382.000000) -> post(79555.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00216)
        CCONN  pre(137382.000000) -> post(81953.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00217)
        CCONN  pre(137382.000000) -> post(81975.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00218)
        CCONN  pre(137382.000000) -> post(81997.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00219)
        CCONN  pre(137382.000000) -> post(82019.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00220)
        CCONN  pre(137382.000000) -> post(82041.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00221)
        CCONN  pre(137382.000000) -> post(82063.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00222)
        CCONN  pre(137382.000000) -> post(82085.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00223)
        CCONN  pre(137382.000000) -> post(82107.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00224)
        CCONN  pre(137382.000000) -> post(82129.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00225)
        CCONN  pre(137382.000000) -> post(82151.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00226)
        CCONN  pre(137382.000000) -> post(82173.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00227)
        CCONN  pre(137382.000000) -> post(82195.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00228)
        CCONN  pre(137382.000000) -> post(84593.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00229)
        CCONN  pre(137382.000000) -> post(84615.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00230)
        CCONN  pre(137382.000000) -> post(84637.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00231)
        CCONN  pre(137382.000000) -> post(84659.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00232)
        CCONN  pre(137382.000000) -> post(84681.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00233)
        CCONN  pre(137382.000000) -> post(84703.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00234)
        CCONN  pre(137382.000000) -> post(84725.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00235)
        CCONN  pre(137382.000000) -> post(84747.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00236)
        CCONN  pre(137382.000000) -> post(84769.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00237)
        CCONN  pre(137382.000000) -> post(84791.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00238)
        CCONN  pre(137382.000000) -> post(84813.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00239)
        CCONN  pre(137382.000000) -> post(84835.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00240)
        CCONN  pre(137382.000000) -> post(87233.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00241)
        CCONN  pre(137382.000000) -> post(87255.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00242)
        CCONN  pre(137382.000000) -> post(87277.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00243)
        CCONN  pre(137382.000000) -> post(87299.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00244)
        CCONN  pre(137382.000000) -> post(87321.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00245)
        CCONN  pre(137382.000000) -> post(87343.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00246)
        CCONN  pre(137382.000000) -> post(87365.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00247)
        CCONN  pre(137382.000000) -> post(87387.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00248)
        CCONN  pre(137382.000000) -> post(87409.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00249)
        CCONN  pre(137382.000000) -> post(87431.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00250)
        CCONN  pre(137382.000000) -> post(87453.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00251)
        CCONN  pre(137382.000000) -> post(87475.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00252)
        CCONN  pre(137382.000000) -> post(89873.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00253)
        CCONN  pre(137382.000000) -> post(89895.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00254)
        CCONN  pre(137382.000000) -> post(89917.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00255)
        CCONN  pre(137382.000000) -> post(89939.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00256)
        CCONN  pre(137382.000000) -> post(89961.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00257)
        CCONN  pre(137382.000000) -> post(89983.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00258)
        CCONN  pre(137382.000000) -> post(90005.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00259)
        CCONN  pre(137382.000000) -> post(90027.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00260)
        CCONN  pre(137382.000000) -> post(90049.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00261)
        CCONN  pre(137382.000000) -> post(90071.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00262)
        CCONN  pre(137382.000000) -> post(90093.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00263)
        CCONN  pre(137382.000000) -> post(90115.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00264)
        CCONN  pre(137382.000000) -> post(92513.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00265)
        CCONN  pre(137382.000000) -> post(92535.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00266)
        CCONN  pre(137382.000000) -> post(92557.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00267)
        CCONN  pre(137382.000000) -> post(92579.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00268)
        CCONN  pre(137382.000000) -> post(92601.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00269)
        CCONN  pre(137382.000000) -> post(92623.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00270)
        CCONN  pre(137382.000000) -> post(92645.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00271)
        CCONN  pre(137382.000000) -> post(92667.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00272)
        CCONN  pre(137382.000000) -> post(92689.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00273)
        CCONN  pre(137382.000000) -> post(92711.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00274)
        CCONN  pre(137382.000000) -> post(92733.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00275)
        CCONN  pre(137382.000000) -> post(92755.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00276)
        CCONN  pre(137382.000000) -> post(95153.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00277)
        CCONN  pre(137382.000000) -> post(95175.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00278)
        CCONN  pre(137382.000000) -> post(95197.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00279)
        CCONN  pre(137382.000000) -> post(95219.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00280)
        CCONN  pre(137382.000000) -> post(95241.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00281)
        CCONN  pre(137382.000000) -> post(95263.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00282)
        CCONN  pre(137382.000000) -> post(95285.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00283)
        CCONN  pre(137382.000000) -> post(95307.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00284)
        CCONN  pre(137382.000000) -> post(95329.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00285)
        CCONN  pre(137382.000000) -> post(95351.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00286)
        CCONN  pre(137382.000000) -> post(95373.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00287)
        CCONN  pre(137382.000000) -> post(95395.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00288)
        CCONN  pre(137382.000000) -> post(97793.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00289)
        CCONN  pre(137382.000000) -> post(97815.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00290)
        CCONN  pre(137382.000000) -> post(97837.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00291)
        CCONN  pre(137382.000000) -> post(97859.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00292)
        CCONN  pre(137382.000000) -> post(97881.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00293)
        CCONN  pre(137382.000000) -> post(97903.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00294)
        CCONN  pre(137382.000000) -> post(97925.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00295)
        CCONN  pre(137382.000000) -> post(97947.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00296)
        CCONN  pre(137382.000000) -> post(97969.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00297)
        CCONN  pre(137382.000000) -> post(97991.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00298)
        CCONN  pre(137382.000000) -> post(98013.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00299)
        CCONN  pre(137382.000000) -> post(98035.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00300)
        CCONN  pre(137382.000000) -> post(100433.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00301)
        CCONN  pre(137382.000000) -> post(100455.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00302)
        CCONN  pre(137382.000000) -> post(100477.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00303)
        CCONN  pre(137382.000000) -> post(100499.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00304)
        CCONN  pre(137382.000000) -> post(100521.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00305)
        CCONN  pre(137382.000000) -> post(100543.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00306)
        CCONN  pre(137382.000000) -> post(100565.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00307)
        CCONN  pre(137382.000000) -> post(100587.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00308)
        CCONN  pre(137382.000000) -> post(100609.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00309)
        CCONN  pre(137382.000000) -> post(100631.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00310)
        CCONN  pre(137382.000000) -> post(100653.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00311)
        CCONN  pre(137382.000000) -> post(100675.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00312)
        CCONN  pre(137382.000000) -> post(116.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00313)
        CCONN  pre(137382.000000) -> post(138.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00314)
        CCONN  pre(137382.000000) -> post(160.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00315)
        CCONN  pre(137382.000000) -> post(182.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00316)
        CCONN  pre(137382.000000) -> post(204.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00317)
        CCONN  pre(137382.000000) -> post(226.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00318)
        CCONN  pre(137382.000000) -> post(248.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00319)
        CCONN  pre(137382.000000) -> post(270.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00320)
        CCONN  pre(137382.000000) -> post(292.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00321)
        CCONN  pre(137382.000000) -> post(314.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00322)
        CCONN  pre(137382.000000) -> post(336.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00323)
        CCONN  pre(137382.000000) -> post(358.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00324)
        CCONN  pre(137382.000000) -> post(2756.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00325)
        CCONN  pre(137382.000000) -> post(2778.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00326)
        CCONN  pre(137382.000000) -> post(2800.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00327)
        CCONN  pre(137382.000000) -> post(2822.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00328)
        CCONN  pre(137382.000000) -> post(2844.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00329)
        CCONN  pre(137382.000000) -> post(2866.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00330)
        CCONN  pre(137382.000000) -> post(2888.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00331)
        CCONN  pre(137382.000000) -> post(2910.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00332)
        CCONN  pre(137382.000000) -> post(2932.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00333)
        CCONN  pre(137382.000000) -> post(2954.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00334)
        CCONN  pre(137382.000000) -> post(2976.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00335)
        CCONN  pre(137382.000000) -> post(2998.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00336)
        CCONN  pre(137382.000000) -> post(5396.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00337)
        CCONN  pre(137382.000000) -> post(5418.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00338)
        CCONN  pre(137382.000000) -> post(5440.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00339)
        CCONN  pre(137382.000000) -> post(5462.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00340)
        CCONN  pre(137382.000000) -> post(5484.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00341)
        CCONN  pre(137382.000000) -> post(5506.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00342)
        CCONN  pre(137382.000000) -> post(5528.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00343)
        CCONN  pre(137382.000000) -> post(5550.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00344)
        CCONN  pre(137382.000000) -> post(5572.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00345)
        CCONN  pre(137382.000000) -> post(5594.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00346)
        CCONN  pre(137382.000000) -> post(5616.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00347)
        CCONN  pre(137382.000000) -> post(5638.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00348)
        CCONN  pre(137382.000000) -> post(8036.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00349)
        CCONN  pre(137382.000000) -> post(8058.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00350)
        CCONN  pre(137382.000000) -> post(8080.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00351)
        CCONN  pre(137382.000000) -> post(8102.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00352)
        CCONN  pre(137382.000000) -> post(8124.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00353)
        CCONN  pre(137382.000000) -> post(8146.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00354)
        CCONN  pre(137382.000000) -> post(8168.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00355)
        CCONN  pre(137382.000000) -> post(8190.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00356)
        CCONN  pre(137382.000000) -> post(8212.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00357)
        CCONN  pre(137382.000000) -> post(8234.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00358)
        CCONN  pre(137382.000000) -> post(8256.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00359)
        CCONN  pre(137382.000000) -> post(8278.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00360)
        CCONN  pre(137382.000000) -> post(10676.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00361)
        CCONN  pre(137382.000000) -> post(10698.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00362)
        CCONN  pre(137382.000000) -> post(10720.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00363)
        CCONN  pre(137382.000000) -> post(10742.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00364)
        CCONN  pre(137382.000000) -> post(10764.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00365)
        CCONN  pre(137382.000000) -> post(10786.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00366)
        CCONN  pre(137382.000000) -> post(10808.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00367)
        CCONN  pre(137382.000000) -> post(10830.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00368)
        CCONN  pre(137382.000000) -> post(10852.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00369)
        CCONN  pre(137382.000000) -> post(10874.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00370)
        CCONN  pre(137382.000000) -> post(10896.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00371)
        CCONN  pre(137382.000000) -> post(10918.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00372)
        CCONN  pre(137382.000000) -> post(13316.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00373)
        CCONN  pre(137382.000000) -> post(13338.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00374)
        CCONN  pre(137382.000000) -> post(13360.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00375)
        CCONN  pre(137382.000000) -> post(13382.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00376)
        CCONN  pre(137382.000000) -> post(13404.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00377)
        CCONN  pre(137382.000000) -> post(13426.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00378)
        CCONN  pre(137382.000000) -> post(13448.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00379)
        CCONN  pre(137382.000000) -> post(13470.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00380)
        CCONN  pre(137382.000000) -> post(13492.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00381)
        CCONN  pre(137382.000000) -> post(13514.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00382)
        CCONN  pre(137382.000000) -> post(13536.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00383)
        CCONN  pre(137382.000000) -> post(13558.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00384)
        CCONN  pre(137382.000000) -> post(15956.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00385)
        CCONN  pre(137382.000000) -> post(15978.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00386)
        CCONN  pre(137382.000000) -> post(16000.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00387)
        CCONN  pre(137382.000000) -> post(16022.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00388)
        CCONN  pre(137382.000000) -> post(16044.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00389)
        CCONN  pre(137382.000000) -> post(16066.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00390)
        CCONN  pre(137382.000000) -> post(16088.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00391)
        CCONN  pre(137382.000000) -> post(16110.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00392)
        CCONN  pre(137382.000000) -> post(16132.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00393)
        CCONN  pre(137382.000000) -> post(16154.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00394)
        CCONN  pre(137382.000000) -> post(16176.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00395)
        CCONN  pre(137382.000000) -> post(16198.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00396)
        CCONN  pre(137382.000000) -> post(18596.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00397)
        CCONN  pre(137382.000000) -> post(18618.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00398)
        CCONN  pre(137382.000000) -> post(18640.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00399)
        CCONN  pre(137382.000000) -> post(18662.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00400)
        CCONN  pre(137382.000000) -> post(18684.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00401)
        CCONN  pre(137382.000000) -> post(18706.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00402)
        CCONN  pre(137382.000000) -> post(18728.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00403)
        CCONN  pre(137382.000000) -> post(18750.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00404)
        CCONN  pre(137382.000000) -> post(18772.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00405)
        CCONN  pre(137382.000000) -> post(18794.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00406)
        CCONN  pre(137382.000000) -> post(18816.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00407)
        CCONN  pre(137382.000000) -> post(18838.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00408)
        CCONN  pre(137382.000000) -> post(21236.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00409)
        CCONN  pre(137382.000000) -> post(21258.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00410)
        CCONN  pre(137382.000000) -> post(21280.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00411)
        CCONN  pre(137382.000000) -> post(21302.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00412)
        CCONN  pre(137382.000000) -> post(21324.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00413)
        CCONN  pre(137382.000000) -> post(21346.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00414)
        CCONN  pre(137382.000000) -> post(21368.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00415)
        CCONN  pre(137382.000000) -> post(21390.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00416)
        CCONN  pre(137382.000000) -> post(21412.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00417)
        CCONN  pre(137382.000000) -> post(21434.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00418)
        CCONN  pre(137382.000000) -> post(21456.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00419)
        CCONN  pre(137382.000000) -> post(21478.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00420)
        CCONN  pre(137382.000000) -> post(23876.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00421)
        CCONN  pre(137382.000000) -> post(23898.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00422)
        CCONN  pre(137382.000000) -> post(23920.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00423)
        CCONN  pre(137382.000000) -> post(23942.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00424)
        CCONN  pre(137382.000000) -> post(23964.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00425)
        CCONN  pre(137382.000000) -> post(23986.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00426)
        CCONN  pre(137382.000000) -> post(24008.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00427)
        CCONN  pre(137382.000000) -> post(24030.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00428)
        CCONN  pre(137382.000000) -> post(24052.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00429)
        CCONN  pre(137382.000000) -> post(24074.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00430)
        CCONN  pre(137382.000000) -> post(24096.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00431)
        CCONN  pre(137382.000000) -> post(24118.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00432)
        CCONN  pre(137382.000000) -> post(26516.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00433)
        CCONN  pre(137382.000000) -> post(26538.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00434)
        CCONN  pre(137382.000000) -> post(26560.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00435)
        CCONN  pre(137382.000000) -> post(26582.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00436)
        CCONN  pre(137382.000000) -> post(26604.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00437)
        CCONN  pre(137382.000000) -> post(26626.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00438)
        CCONN  pre(137382.000000) -> post(26648.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00439)
        CCONN  pre(137382.000000) -> post(26670.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00440)
        CCONN  pre(137382.000000) -> post(26692.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00441)
        CCONN  pre(137382.000000) -> post(26714.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00442)
        CCONN  pre(137382.000000) -> post(26736.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00443)
        CCONN  pre(137382.000000) -> post(26758.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00444)
        CCONN  pre(137382.000000) -> post(29156.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00445)
        CCONN  pre(137382.000000) -> post(29178.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00446)
        CCONN  pre(137382.000000) -> post(29200.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00447)
        CCONN  pre(137382.000000) -> post(29222.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00448)
        CCONN  pre(137382.000000) -> post(29244.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00449)
        CCONN  pre(137382.000000) -> post(29266.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00450)
        CCONN  pre(137382.000000) -> post(29288.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00451)
        CCONN  pre(137382.000000) -> post(29310.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00452)
        CCONN  pre(137382.000000) -> post(29332.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00453)
        CCONN  pre(137382.000000) -> post(29354.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00454)
        CCONN  pre(137382.000000) -> post(29376.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00455)
        CCONN  pre(137382.000000) -> post(29398.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00456)
        CCONN  pre(137382.000000) -> post(31796.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00457)
        CCONN  pre(137382.000000) -> post(31818.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00458)
        CCONN  pre(137382.000000) -> post(31840.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00459)
        CCONN  pre(137382.000000) -> post(31862.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00460)
        CCONN  pre(137382.000000) -> post(31884.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00461)
        CCONN  pre(137382.000000) -> post(31906.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00462)
        CCONN  pre(137382.000000) -> post(31928.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00463)
        CCONN  pre(137382.000000) -> post(31950.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00464)
        CCONN  pre(137382.000000) -> post(31972.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00465)
        CCONN  pre(137382.000000) -> post(31994.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00466)
        CCONN  pre(137382.000000) -> post(32016.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00467)
        CCONN  pre(137382.000000) -> post(32038.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00468)
        CCONN  pre(137382.000000) -> post(68756.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00469)
        CCONN  pre(137382.000000) -> post(68778.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00470)
        CCONN  pre(137382.000000) -> post(68800.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00471)
        CCONN  pre(137382.000000) -> post(68822.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00472)
        CCONN  pre(137382.000000) -> post(68844.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00473)
        CCONN  pre(137382.000000) -> post(68866.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00474)
        CCONN  pre(137382.000000) -> post(68888.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00475)
        CCONN  pre(137382.000000) -> post(68910.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00476)
        CCONN  pre(137382.000000) -> post(68932.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00477)
        CCONN  pre(137382.000000) -> post(68954.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00478)
        CCONN  pre(137382.000000) -> post(68976.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00479)
        CCONN  pre(137382.000000) -> post(68998.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00480)
        CCONN  pre(137382.000000) -> post(71396.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00481)
        CCONN  pre(137382.000000) -> post(71418.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00482)
        CCONN  pre(137382.000000) -> post(71440.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00483)
        CCONN  pre(137382.000000) -> post(71462.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00484)
        CCONN  pre(137382.000000) -> post(71484.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00485)
        CCONN  pre(137382.000000) -> post(71506.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00486)
        CCONN  pre(137382.000000) -> post(71528.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00487)
        CCONN  pre(137382.000000) -> post(71550.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00488)
        CCONN  pre(137382.000000) -> post(71572.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00489)
        CCONN  pre(137382.000000) -> post(71594.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00490)
        CCONN  pre(137382.000000) -> post(71616.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00491)
        CCONN  pre(137382.000000) -> post(71638.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00492)
        CCONN  pre(137382.000000) -> post(74036.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00493)
        CCONN  pre(137382.000000) -> post(74058.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00494)
        CCONN  pre(137382.000000) -> post(74080.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00495)
        CCONN  pre(137382.000000) -> post(74102.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00496)
        CCONN  pre(137382.000000) -> post(74124.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00497)
        CCONN  pre(137382.000000) -> post(74146.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00498)
        CCONN  pre(137382.000000) -> post(74168.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00499)
        CCONN  pre(137382.000000) -> post(74190.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00500)
        CCONN  pre(137382.000000) -> post(74212.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00501)
        CCONN  pre(137382.000000) -> post(74234.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00502)
        CCONN  pre(137382.000000) -> post(74256.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00503)
        CCONN  pre(137382.000000) -> post(74278.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00504)
        CCONN  pre(137382.000000) -> post(76676.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00505)
        CCONN  pre(137382.000000) -> post(76698.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00506)
        CCONN  pre(137382.000000) -> post(76720.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00507)
        CCONN  pre(137382.000000) -> post(76742.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00508)
        CCONN  pre(137382.000000) -> post(76764.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00509)
        CCONN  pre(137382.000000) -> post(76786.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00510)
        CCONN  pre(137382.000000) -> post(76808.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00511)
        CCONN  pre(137382.000000) -> post(76830.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00512)
        CCONN  pre(137382.000000) -> post(76852.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00513)
        CCONN  pre(137382.000000) -> post(76874.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00514)
        CCONN  pre(137382.000000) -> post(76896.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00515)
        CCONN  pre(137382.000000) -> post(76918.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00516)
        CCONN  pre(137382.000000) -> post(79316.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00517)
        CCONN  pre(137382.000000) -> post(79338.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00518)
        CCONN  pre(137382.000000) -> post(79360.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00519)
        CCONN  pre(137382.000000) -> post(79382.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00520)
        CCONN  pre(137382.000000) -> post(79404.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00521)
        CCONN  pre(137382.000000) -> post(79426.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00522)
        CCONN  pre(137382.000000) -> post(79448.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00523)
        CCONN  pre(137382.000000) -> post(79470.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00524)
        CCONN  pre(137382.000000) -> post(79492.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00525)
        CCONN  pre(137382.000000) -> post(79514.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00526)
        CCONN  pre(137382.000000) -> post(79536.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00527)
        CCONN  pre(137382.000000) -> post(79558.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00528)
        CCONN  pre(137382.000000) -> post(81956.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00529)
        CCONN  pre(137382.000000) -> post(81978.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00530)
        CCONN  pre(137382.000000) -> post(82000.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00531)
        CCONN  pre(137382.000000) -> post(82022.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00532)
        CCONN  pre(137382.000000) -> post(82044.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00533)
        CCONN  pre(137382.000000) -> post(82066.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00534)
        CCONN  pre(137382.000000) -> post(82088.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00535)
        CCONN  pre(137382.000000) -> post(82110.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00536)
        CCONN  pre(137382.000000) -> post(82132.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00537)
        CCONN  pre(137382.000000) -> post(82154.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00538)
        CCONN  pre(137382.000000) -> post(82176.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00539)
        CCONN  pre(137382.000000) -> post(82198.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00540)
        CCONN  pre(137382.000000) -> post(84596.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00541)
        CCONN  pre(137382.000000) -> post(84618.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00542)
        CCONN  pre(137382.000000) -> post(84640.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00543)
        CCONN  pre(137382.000000) -> post(84662.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00544)
        CCONN  pre(137382.000000) -> post(84684.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00545)
        CCONN  pre(137382.000000) -> post(84706.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00546)
        CCONN  pre(137382.000000) -> post(84728.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00547)
        CCONN  pre(137382.000000) -> post(84750.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00548)
        CCONN  pre(137382.000000) -> post(84772.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00549)
        CCONN  pre(137382.000000) -> post(84794.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00550)
        CCONN  pre(137382.000000) -> post(84816.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00551)
        CCONN  pre(137382.000000) -> post(84838.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00552)
        CCONN  pre(137382.000000) -> post(87236.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00553)
        CCONN  pre(137382.000000) -> post(87258.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00554)
        CCONN  pre(137382.000000) -> post(87280.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00555)
        CCONN  pre(137382.000000) -> post(87302.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00556)
        CCONN  pre(137382.000000) -> post(87324.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00557)
        CCONN  pre(137382.000000) -> post(87346.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00558)
        CCONN  pre(137382.000000) -> post(87368.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00559)
        CCONN  pre(137382.000000) -> post(87390.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00560)
        CCONN  pre(137382.000000) -> post(87412.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00561)
        CCONN  pre(137382.000000) -> post(87434.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00562)
        CCONN  pre(137382.000000) -> post(87456.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00563)
        CCONN  pre(137382.000000) -> post(87478.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00564)
        CCONN  pre(137382.000000) -> post(89876.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00565)
        CCONN  pre(137382.000000) -> post(89898.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00566)
        CCONN  pre(137382.000000) -> post(89920.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00567)
        CCONN  pre(137382.000000) -> post(89942.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00568)
        CCONN  pre(137382.000000) -> post(89964.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00569)
        CCONN  pre(137382.000000) -> post(89986.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00570)
        CCONN  pre(137382.000000) -> post(90008.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00571)
        CCONN  pre(137382.000000) -> post(90030.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00572)
        CCONN  pre(137382.000000) -> post(90052.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00573)
        CCONN  pre(137382.000000) -> post(90074.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00574)
        CCONN  pre(137382.000000) -> post(90096.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00575)
        CCONN  pre(137382.000000) -> post(90118.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00576)
        CCONN  pre(137382.000000) -> post(92516.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00577)
        CCONN  pre(137382.000000) -> post(92538.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00578)
        CCONN  pre(137382.000000) -> post(92560.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00579)
        CCONN  pre(137382.000000) -> post(92582.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00580)
        CCONN  pre(137382.000000) -> post(92604.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00581)
        CCONN  pre(137382.000000) -> post(92626.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00582)
        CCONN  pre(137382.000000) -> post(92648.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00583)
        CCONN  pre(137382.000000) -> post(92670.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00584)
        CCONN  pre(137382.000000) -> post(92692.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00585)
        CCONN  pre(137382.000000) -> post(92714.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00586)
        CCONN  pre(137382.000000) -> post(92736.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00587)
        CCONN  pre(137382.000000) -> post(92758.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00588)
        CCONN  pre(137382.000000) -> post(95156.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00589)
        CCONN  pre(137382.000000) -> post(95178.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00590)
        CCONN  pre(137382.000000) -> post(95200.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00591)
        CCONN  pre(137382.000000) -> post(95222.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00592)
        CCONN  pre(137382.000000) -> post(95244.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00593)
        CCONN  pre(137382.000000) -> post(95266.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00594)
        CCONN  pre(137382.000000) -> post(95288.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00595)
        CCONN  pre(137382.000000) -> post(95310.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00596)
        CCONN  pre(137382.000000) -> post(95332.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00597)
        CCONN  pre(137382.000000) -> post(95354.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00598)
        CCONN  pre(137382.000000) -> post(95376.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00599)
        CCONN  pre(137382.000000) -> post(95398.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00600)
        CCONN  pre(137382.000000) -> post(97796.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00601)
        CCONN  pre(137382.000000) -> post(97818.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00602)
        CCONN  pre(137382.000000) -> post(97840.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00603)
        CCONN  pre(137382.000000) -> post(97862.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00604)
        CCONN  pre(137382.000000) -> post(97884.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00605)
        CCONN  pre(137382.000000) -> post(97906.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00606)
        CCONN  pre(137382.000000) -> post(97928.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00607)
        CCONN  pre(137382.000000) -> post(97950.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00608)
        CCONN  pre(137382.000000) -> post(97972.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00609)
        CCONN  pre(137382.000000) -> post(97994.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00610)
        CCONN  pre(137382.000000) -> post(98016.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00611)
        CCONN  pre(137382.000000) -> post(98038.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00612)
        CCONN  pre(137382.000000) -> post(100436.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00613)
        CCONN  pre(137382.000000) -> post(100458.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00614)
        CCONN  pre(137382.000000) -> post(100480.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00615)
        CCONN  pre(137382.000000) -> post(100502.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00616)
        CCONN  pre(137382.000000) -> post(100524.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00617)
        CCONN  pre(137382.000000) -> post(100546.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00618)
        CCONN  pre(137382.000000) -> post(100568.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00619)
        CCONN  pre(137382.000000) -> post(100590.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00620)
        CCONN  pre(137382.000000) -> post(100612.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00621)
        CCONN  pre(137382.000000) -> post(100634.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00622)
        CCONN  pre(137382.000000) -> post(100656.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00623)
        CCONN  pre(137382.000000) -> post(100678.000000)
        CCONN  Delay, Weight (0.000000,9.000000)
",
						    timeout => 20,
						    write => "querymachine 'projectionquery c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB'",
						   },
						   {
						    description => "How many connections in the feedforward and feedback projections can be found for the first Golgi cell's soma ?",
						    read => "#connections = 624
",
						    write => "querymachine 'projectionquerycount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB'",
						   },
						   {
						    description => "How many connections in the feedforward and feedback projections can be found ?",
						    read => "first symbol is not attachment, will be used as part of projectionquery
#connections = 110592
",
						    write => "querymachine 'projectionquerycount c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB'",
						   },
						   {
						    description => "What are the forestspace IDs for the spine neck ?",
						    read => "Traversal serial ID = 1141
Principal serial ID = 1141 of 153157 Principal successors
",
# Mechanism serial ID = 656 of 77484 Mechanism successors
# Segment  serial  ID = 73 of 27288  Segment  successors
						    write => "querymachine 'serialMapping /CerebellarCortex/Purkinjes /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/neck'",
						   },
						   {
						    comment => 'note that in the model-container this mapping is different, because there algorithm symbols have been inserted at the top level',
						    description => "Can the mossy fiber forestspace IDs be found ?",
						    read => "serial id /CerebellarCortex,22 -> /CerebellarCortex/MossyFibers/6/value
",
						    write => "querymachine 'serial2context /CerebellarCortex 22'",
						   },
						   {
						    description => "Can we define a caching projection query for the feedforward, feedback and mossy fiber projections ?",
						    disabled => "copied from the model-container tests, but not all the projections have been instantiated in this test.",
						    read => "caching = yes
",
						    write => "querymachine 'pqset c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB /CerebellarCortex/MossyFiberProjection/GranuleComponent/NMDA /CerebellarCortex/MossyFiberProjection/GranuleComponent/AMPA /CerebellarCortex/MossyFiberProjection/GolgiComponent'",
						   },
						   {
						    description => "What is the number of connections in the defined projectionquery, caching mode ?",
						    disabled => "copied from the model-container tests, but not all the projections have been instantiated in this test.",
						    read => "#connections = 148660
",
#memory used by projection query = 2378760
#memory used by connection cache = 1189292
#memory used by ordered cache 1  = 594660
#memory used by ordered cache 2  = 594660
						    write => "pqcount c",
						   },
						   {
						    description => "What is the number of connections in the defined projectionquery, non-caching mode ?",
						    disabled => "copied from the model-container tests, but not all the projections have been instantiated in this test.",
						    read => "#connections = 148660
",
#memory used by projection query = 2378760
#memory used by connection cache = 1189292
#memory used by ordered cache 1  = 594660
#memory used by ordered cache 2  = 594660
						    write => "pqcount n",
						   },
						   {
						    description => "What is the number of connections on the AMPA channel of the first Golgi cell ?",
						    disabled => "copied from the model-container tests, but not all the projections have been instantiated in this test.",
						    read => 'Number of connections : 4452
',
						    write => "querymachine 'spikereceivercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse'",
						   },
						   {
						    description => "What is the number of connections on the domain translator of the second granule cell ?",
						    disabled => "copied from the model-container tests, but not all the projections have been instantiated in this test.",
						    read => 'Number of connections : 8
',
						    write => "querymachine 'spikesendercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Granules/1/Granule_soma/spikegen'",
						   },
						  ),
						 ],
				description => "preparation commands for network simulations",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "The cerebellar network model (in preparation).",
       name => 'network.t',
      };


return $test;


