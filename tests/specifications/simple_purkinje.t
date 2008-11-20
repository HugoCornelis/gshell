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
						   description => "Can we find the library ?",
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
    - segments/
    - tests/
    - utilities/
",
						   write => "show_library",
						  },
						  {
						   description => "Can we find the single neurons in the library ?",
						   read => "
ndf_library:
  cells:
    - cell1.ndf
    - hodgkin-huxley/
    - Purk2M9s.p
    - purk2m9s.tex
    - purk2m9.tex
    - purkinje/
    - stand_alone.ndf
",
						   write => "show_library ndf cells",
						  },
						  {
						   description => "Can we find the purkinje cell models in the single neuron library ?",
						   read => "
ndf_library:
  cells/purkinje:
    - edsjb1994.ndf
    - edsjb1994_partitioned.ndf
",
						   write => "show_library ndf cells/purkinje",
						  },
						  {
						   description => "Can we load the standard purkinje cell model ?",
						   write => "ndf_load cells/purkinje/edsjb1994.ndf",
						  },
						  {
						   description => "Can we find the root element of the model ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we find the segments and spines algorithm instance inside the root element ?",
						   read => "
- /Purkinje/segments
- /Purkinje/SpinesNormal_13_1
",
						   write => "list_elements /Purkinje",
						  },
						  {
						   description => "Can we load the version of the purkinje cell with the partitioned dendritic tree ?",
						   write => "ndf_load cells/purkinje/edsjb1994_partitioned.ndf",
						  },
						  {
						   description => "Can we find the root element of the model (2) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we find the segments and spines algorithm instance inside the root element ?",
						   read => "
- /Purkinje/segments
- /Purkinje/SpinesNormal_13_1
",
						   write => "list_elements /Purkinje",
						  },
						  {
						   description => "Can we find the segments in /Purkinje/segments ?",
						   read => "
- /Purkinje/segments/soma
- /Purkinje/segments/main
- /Purkinje/segments/branches
- /Purkinje/segments/branchlets
",
						   write => "list_elements /Purkinje/segments",
						  },
						  {
						   description => "Can we find the segments in /Purkinje/segments/main ?",
						   read => "
- /Purkinje/segments/main/main[0]
- /Purkinje/segments/main/main[1]
- /Purkinje/segments/main/main[2]
- /Purkinje/segments/main/main[3]
- /Purkinje/segments/main/main[4]
- /Purkinje/segments/main/main[5]
- /Purkinje/segments/main/main[6]
- /Purkinje/segments/main/main[7]
- /Purkinje/segments/main/main[8]
",
						   write => "list_elements /Purkinje/segments/main",
						  },
						  {
						   description => "Can we find the segments in /Purkinje/segments/branches ?",
						   read => "
- /Purkinje/segments/branches/br1
- /Purkinje/segments/branches/br2
- /Purkinje/segments/branches/br3
",
						   write => "list_elements /Purkinje/segments/branches",
						  },
						  {
						   description => "Can we find the segments in /Purkinje/segments/branchlets ?",
						   read => "
- /Purkinje/segments/branchlets/b0s01
- /Purkinje/segments/branchlets/b0s02
- /Purkinje/segments/branchlets/b0s03
- /Purkinje/segments/branchlets/b0s04
- /Purkinje/segments/branchlets/b1s05
- /Purkinje/segments/branchlets/b1s06
- /Purkinje/segments/branchlets/b1s07
- /Purkinje/segments/branchlets/b1s08
- /Purkinje/segments/branchlets/b1s09
- /Purkinje/segments/branchlets/b1s10
- /Purkinje/segments/branchlets/b1s11
- /Purkinje/segments/branchlets/b1s12
- /Purkinje/segments/branchlets/b1s13
- /Purkinje/segments/branchlets/b1s14
- /Purkinje/segments/branchlets/b1s15
- /Purkinje/segments/branchlets/b1s16
- /Purkinje/segments/branchlets/b1s17
- /Purkinje/segments/branchlets/b1s18
- /Purkinje/segments/branchlets/b1s19
- /Purkinje/segments/branchlets/b1s20
- /Purkinje/segments/branchlets/b2s21
- /Purkinje/segments/branchlets/b2s22
- /Purkinje/segments/branchlets/b2s23
- /Purkinje/segments/branchlets/b2s24
- /Purkinje/segments/branchlets/b2s25
- /Purkinje/segments/branchlets/b2s26
- /Purkinje/segments/branchlets/b2s27
- /Purkinje/segments/branchlets/b2s28
- /Purkinje/segments/branchlets/b2s29
- /Purkinje/segments/branchlets/b2s30
- /Purkinje/segments/branchlets/b2s31
- /Purkinje/segments/branchlets/b2s32
- /Purkinje/segments/branchlets/b2s33
- /Purkinje/segments/branchlets/b2s34
- /Purkinje/segments/branchlets/b3s35
- /Purkinje/segments/branchlets/b3s36
- /Purkinje/segments/branchlets/b3s37
- /Purkinje/segments/branchlets/b3s38
- /Purkinje/segments/branchlets/b3s39
- /Purkinje/segments/branchlets/b3s40
- /Purkinje/segments/branchlets/b3s41
- /Purkinje/segments/branchlets/b3s42
- /Purkinje/segments/branchlets/b3s43
- /Purkinje/segments/branchlets/b3s44
- /Purkinje/segments/branchlets/b3s45
- /Purkinje/segments/branchlets/b3s46
",
						   write => "list_elements /Purkinje/segments/branchlets",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /Purkinje 0.001",
						  },
						  {
						   description => "Can we find the output file in the file system ?",
						   read => " output
",
						   timeout => 100,
						   write => "sh ls -l /tmp",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0678441
",
						   timeout => 100,
						   write => "sh cat /tmp/output",
						  },
						 ],
       description => "simple simulations of purkinje cell models",
       name => 'simple_purkinje.t',
      };


return $test;


