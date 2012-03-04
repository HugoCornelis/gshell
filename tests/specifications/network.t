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
						   write => 'ndf_load_library Fibers fibers/mossyfiber.ndf',
						  },
						  {
						   description => "Can we load the Golgi cell population?",
						   write => 'ndf_load_library Golgi legacy/populations/golgi.ndf',
						  },
						  {
						   description => "Can we load the granule cell population?",
						   write => 'ndf_load_library Granule legacy/populations/granule.ndf',
						  },
						  {
						   description => "Can we load the Purkinje cell population?",
						   write => 'ndf_load_library Purkinje legacy/populations/purkinje.ndf',
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
						   description => "Can we create the main projection to hold the two subcomponents of the backward projection?",
						   write => "create projection /CerebellarCortex/BackwardProjection",
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
						   description => 'Do we find all the components of the created mossy fiber population?',
						   read => '
- /CerebellarCortex
- /CerebellarCortex/BackwardProjection
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
						   description => "Can we alias the imported Golgi cell population?",
						   write => 'insert_alias ::Golgi::/GolgiPopulation /CerebellarCortex/Golgis',
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
						    description => "What is the number of connections on the AMPA channel of the first Golgi cell ?",
						    read => 'Number of connections : 4452
',
						    write => "querymachine 'spikereceivercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse'",
						   },
						   {
						    description => "What is the number of connections on the domain translator of the second granule cell ?",
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


