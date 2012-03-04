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
						   write => 'insert_alias ::Fibers::/MossyFiberArray /CerebellarCortex',
						  },
						  {
						   description => 'Do we find all the components of the created mossy fiber population?',
						   read => '
- /CerebellarCortex
- /CerebellarCortex/BackwardProjection
- /CerebellarCortex
- /CerebellarCortex/MossyGrid
- /CerebellarCortex/0
- /CerebellarCortex/0/value
- /CerebellarCortex/0/spikegen
- /CerebellarCortex/1
- /CerebellarCortex/1/value
- /CerebellarCortex/1/spikegen
- /CerebellarCortex/2
- /CerebellarCortex/2/value
- /CerebellarCortex/2/spikegen
- /CerebellarCortex/3
- /CerebellarCortex/3/value
- /CerebellarCortex/3/spikegen
- /CerebellarCortex/4
- /CerebellarCortex/4/value
- /CerebellarCortex/4/spikegen
- /CerebellarCortex/5
- /CerebellarCortex/5/value
- /CerebellarCortex/5/spikegen
- /CerebellarCortex/6
- /CerebellarCortex/6/value
- /CerebellarCortex/6/spikegen
- /CerebellarCortex/7
- /CerebellarCortex/7/value
- /CerebellarCortex/7/spikegen
- /CerebellarCortex/8
- /CerebellarCortex/8/value
- /CerebellarCortex/8/spikegen
- /CerebellarCortex/9
- /CerebellarCortex/9/value
- /CerebellarCortex/9/spikegen
- /CerebellarCortex/10
- /CerebellarCortex/10/value
- /CerebellarCortex/10/spikegen
- /CerebellarCortex/11
- /CerebellarCortex/11/value
- /CerebellarCortex/11/spikegen
- /CerebellarCortex/12
- /CerebellarCortex/12/value
- /CerebellarCortex/12/spikegen
- /CerebellarCortex/13
- /CerebellarCortex/13/value
- /CerebellarCortex/13/spikegen
- /CerebellarCortex/14
- /CerebellarCortex/14/value
- /CerebellarCortex/14/spikegen
- /CerebellarCortex/15
- /CerebellarCortex/15/value
- /CerebellarCortex/15/spikegen
- /CerebellarCortex/16
- /CerebellarCortex/16/value
- /CerebellarCortex/16/spikegen
- /CerebellarCortex/17
- /CerebellarCortex/17/value
- /CerebellarCortex/17/spikegen
- /CerebellarCortex/18
- /CerebellarCortex/18/value
- /CerebellarCortex/18/spikegen
- /CerebellarCortex/19
- /CerebellarCortex/19/value
- /CerebellarCortex/19/spikegen
- /CerebellarCortex/20
- /CerebellarCortex/20/value
- /CerebellarCortex/20/spikegen
- /CerebellarCortex/21
- /CerebellarCortex/21/value
- /CerebellarCortex/21/spikegen
- /CerebellarCortex/22
- /CerebellarCortex/22/value
- /CerebellarCortex/22/spikegen
- /CerebellarCortex/23
- /CerebellarCortex/23/value
- /CerebellarCortex/23/spikegen
- /CerebellarCortex/24
- /CerebellarCortex/24/value
- /CerebellarCortex/24/spikegen
- /CerebellarCortex/25
- /CerebellarCortex/25/value
- /CerebellarCortex/25/spikegen
- /CerebellarCortex/26
- /CerebellarCortex/26/value
- /CerebellarCortex/26/spikegen
- /CerebellarCortex/27
- /CerebellarCortex/27/value
- /CerebellarCortex/27/spikegen
- /CerebellarCortex/28
- /CerebellarCortex/28/value
- /CerebellarCortex/28/spikegen
- /CerebellarCortex/29
- /CerebellarCortex/29/value
- /CerebellarCortex/29/spikegen
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
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/ForwardProjection /CerebellarCortex/Granules /CerebellarCortex/Golgis spikegen mf_AMPA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.0025 -0.0003 -0.0025 0.0025 0.0003 0.0025 weight 45.0 delay radial 0.0 velocity 0.5 1.0 1212.0',
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAA component?",
						   read => '
created a new projection with name /CerebellarCortex/BackwardProjection/GABAA',
						   timeout => 10,
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/Golgis /CerebellarCortex/Granules spikegen GABAA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 45.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAB component?",
						   read => '
created a new projection with name /CerebellarCortex/BackwardProjection/GABAB',
						   timeout => 10,
						   write => 'volumeconnect /CerebellarCortex /CerebellarCortex/BackwardProjection/GABAB /CerebellarCortex/Golgis /CerebellarCortex/Granules spikegen GABAB box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 9.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
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
						 ],
				description => "preparation commands for network simulations",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "The cerebellar network model (in preparation).",
       name => 'network.t',
      };


return $test;


