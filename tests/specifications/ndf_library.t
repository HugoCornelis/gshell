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
						   write => undef,
						  },
						  {
						   description => "Can we find the NDF library ?",
						   read => "
ndf_library:
  .:
    - algorithm_data/
    - cells/
    - channels/
    - contours/
    - conversions/
    - event_data/
    - examples/
    - fibers/
    - gates/
    - legacy/
    - mappers/
    - morphologies/
    - networks/
    - pools/
    - populations/
    - projectionqueries/
    - projections/
    - pulsegen/
    - segments/
    - tests/
    - utilities/
",
						   write => 'show_library',
						  },
						  {
						   description => "Can we find the NDF library ?",
						   read => "
ndf_library:
  .:
    - algorithm_data/
    - cells/
    - channels/
    - contours/
    - conversions/
    - event_data/
    - examples/
    - fibers/
    - gates/
    - legacy/
    - mappers/
    - morphologies/
    - networks/
    - pools/
    - populations/
    - projectionqueries/
    - projections/
    - pulsegen/
    - segments/
    - tests/
    - utilities/
",
						   write => 'show_library ndf',
						  },
						  {
						   description => "Can we find the examples in the library ?",
						   read => "
ndf_library:
  examples:
    - hh_neuron.ndf
    - hh_soma.ndf
    - hh_soma_syns.ndf
    - nmda.ndf
",
						   write => 'show_library ndf examples',
						  },
						  {
						   description => "Can we find the channel library ?",
						   read => "
ndf_library:
  channels:
    - gaba.ndf
    - gaba.xml
    - golgi_ampa.ndf
    - golgi_gabaa.ndf
    - golgi_gabab.ndf
    - golgi_nmda.ndf
    - granule_ampa.ndf
    - granule_gabaa.ndf
    - granule_gabab.ndf
    - granule_nmda.ndf
    - hodgkin-huxley.ndf
    - hodgkin-huxley/
    - nmda.ndf
    - non_nmda.ndf
    - purkinje/
    - purkinje_basket.ndf
    - purkinje_climb.ndf
",
						   write => 'show_library ndf channels',
						  },
						  {
						   description => "Can we find the segment library ?",
						   read => "
ndf_library:
  segments:
    - hodgkin_huxley.ndf
    - micron2.ndf
    - purkinje/
    - purkinje_maind_passive.ndf
    - purkinje_soma_passive.ndf
    - purkinje_spinyd_passive.ndf
    - purkinje_thickd_passive.ndf
    - spines/
",
						   write => 'show_library ndf segments',
						  },
						  {
						   description => "Can we find the purkinje cell segment library ?",
						   read => "
ndf_library:
  segments/purkinje:
    - maind.ndf
    - soma.ndf
    - spinyd.ndf
    - thickd.ndf
",
						   write => 'show_library ndf segments/purkinje',
						  },
						  {
						   description => "Can we find the single neuron library ?",
						   read => "
ndf_library:
  cells:
    - cell1.ndf
    - purkinje/
    - stand_alone.ndf
",
						   write => 'show_library ndf cells',
						  },
						 ],
				description => "ndf library",
			       },
			      ],
       description => "ndf library",
       name => 'ndf_library.t',
      };


return $test;


