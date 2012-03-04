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
						   write => "create network /network",
						  },
						  {
						   description => "Can we create the main projection to hold the two subcomponents of the backward projection?",
						   write => "create projection /network/BackwardProjection",
						  },
						  {
						   comment => "This disabled command is only here to show how the createmap command works.  Because the populations have been imported from NDF files, this command is not necessary here.  Similar commands would be given to instantiate the other populations.",
						   description => "Can we create a first population of neurons?",
						   disabled => "This disabled command is only here to show how the createmap command works.  Because the populations have been imported from NDF files, this command is not necessary here.  Similar commands would be given to instantiate the other populations",
						   read => 'created a new private component with name /network/MossyFibers',
						   write => 'createmap ::Fibers::/MossyFiber /network/MossyFibers 10 3 0.00036 0.003',
						  },
						  {
						   description => "Can we alias the imported mossy fiber population?",
						   write => 'insert_alias ::Fibers::/MossyFiberArray /network',
						  },
						  {
						   description => 'Do we find all the components of the created mossy fiber population?',
						   read => '
- /network
- /network/BackwardProjection
- /network
- /network/MossyGrid
- /network/0
- /network/0/value
- /network/0/spikegen
- /network/1
- /network/1/value
- /network/1/spikegen
- /network/2
- /network/2/value
- /network/2/spikegen
- /network/3
- /network/3/value
- /network/3/spikegen
- /network/4
- /network/4/value
- /network/4/spikegen
- /network/5
- /network/5/value
- /network/5/spikegen
- /network/6
- /network/6/value
- /network/6/spikegen
- /network/7
- /network/7/value
- /network/7/spikegen
- /network/8
- /network/8/value
- /network/8/spikegen
- /network/9
- /network/9/value
- /network/9/spikegen
- /network/10
- /network/10/value
- /network/10/spikegen
- /network/11
- /network/11/value
- /network/11/spikegen
- /network/12
- /network/12/value
- /network/12/spikegen
- /network/13
- /network/13/value
- /network/13/spikegen
- /network/14
- /network/14/value
- /network/14/spikegen
- /network/15
- /network/15/value
- /network/15/spikegen
- /network/16
- /network/16/value
- /network/16/spikegen
- /network/17
- /network/17/value
- /network/17/spikegen
- /network/18
- /network/18/value
- /network/18/spikegen
- /network/19
- /network/19/value
- /network/19/spikegen
- /network/20
- /network/20/value
- /network/20/spikegen
- /network/21
- /network/21/value
- /network/21/spikegen
- /network/22
- /network/22/value
- /network/22/spikegen
- /network/23
- /network/23/value
- /network/23/spikegen
- /network/24
- /network/24/value
- /network/24/spikegen
- /network/25
- /network/25/value
- /network/25/spikegen
- /network/26
- /network/26/value
- /network/26/spikegen
- /network/27
- /network/27/value
- /network/27/spikegen
- /network/28
- /network/28/value
- /network/28/spikegen
- /network/29
- /network/29/value
- /network/29/spikegen
',
						   write => 'list_elements /**',
						  },
						  {
						   description => "Can we alias the imported granule cell population?",
						   write => 'insert_alias ::Granule::/GranulePopulation /network/Granules',
						  },
						  {
						   description => "Can we alias the imported Golgi cell population?",
						   write => 'insert_alias ::Golgi::/GolgiPopulation /network/Golgis',
						  },
						  {
						   description => "Can we alias the imported purkinje cell population?",
						   write => 'insert_alias ::Purkinje::/PurkinjePopulation /network/Purkinjes',
						  },
						  {
						   description => "Can we create a projection from the Granule cell population to the Golgi cell population?",
						   read => '
created a new projection with name /network/ForwardProjection',
						   timeout => 10,
						   write => 'volumeconnect /network /network/ForwardProjection /network/Granules /network/Golgis spikegen mf_AMPA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.0025 -0.0003 -0.0025 0.0025 0.0003 0.0025 weight 45.0 delay radial 0.0 velocity 0.5 1.0 1212.0',
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAA component?",
						   read => '
created a new projection with name /network/BackwardProjection/GABAA',
						   timeout => 10,
						   write => 'volumeconnect /network /network/BackwardProjection/GABAA /network/Golgis /network/Granules spikegen GABAA box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 45.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
						  },
						  {
						   description => "Can we create a projection from the Golgi cell population to the Granule cell population, GABAB component?",
						   read => '
created a new projection with name /network/BackwardProjection/GABAB',
						   timeout => 10,
						   write => 'volumeconnect /network /network/BackwardProjection/GABAB /network/Golgis /network/Granules spikegen GABAB box -1e10 -1e10 -1e10 1e10 1e10 1e10 box -0.00015 -0.00015 -0.00015 0.00015 0.00015 0.00015 weight 9.0 delay fixed 0.0 velocity 0.0 1.0 1212.0',
						  },
						 ],
				description => "preparation commands for network simulations",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "The cerebellar network model (in preparation).",
       name => 'network.t',
      };


return $test;


