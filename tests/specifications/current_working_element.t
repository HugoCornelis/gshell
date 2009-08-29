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
						   description => "Can we get info on the current working element ?",
						   read => "/
",
						   write => "pwe",
						  },
						  {
						   description => "Can we change path to a non existing element ?",
						   disabled => "something related to buffering, the test does not work",
						   read => "Error",
						   write => "ce /c",
						  },
						  {
						   description => "Can we get info on the current working element (2) ?",
						   read => "/
",
						   write => "pwe",
						  },
						  {
						   description => "Can we load a cell with many components ?",
						   write => "ndf_load cells/purkinje/edsjb1994.ndf",
						  },
						  {
						   description => "Can we find the top level elements in the model ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to a non existing element ?",
						   read => "Error",
						   write => "ce /c",
						  },
						  {
						   description => "Can we change path to an existing element ?",
						   write => "ce /Purkinje",
						  },
						  {
						   description => "Can we find the 2nd level elements in the model ?",
						   read => "
- /Purkinje/SpinesNormal_13_1
- /Purkinje/segments
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change back to the root element ?",
						   write => "ce /",
						  },
						  {
						   description => "Can we find the top level elements in the model (2) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to an existing element (2) ?",
						   write => "ce /Purkinje",
						  },
						  {
						   description => "Can we find the 2nd level elements in the model (2) ?",
						   read => "
- /Purkinje/SpinesNormal_13_1
- /Purkinje/segments
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change back to the root element (2) ?",
						   write => "ce /////",
						  },
						  {
						   description => "Can we find the top level elements in the model (3) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to something slightly weird (1) ?",
						   write => "ce /../../../",
						  },
						  {
						   description => "Can we find the top level elements in the model (4) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to something slightly weird (2) ?",
						   write => "ce /../../..",
						  },
						  {
						   description => "Can we find the top level elements in the model (5) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to something slightly weird (3) ?",
						   write => "ce /./././",
						  },
						  {
						   description => "Can we find the top level elements in the model (6) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						  {
						   description => "Can we change path to something slightly weird (4) ?",
						   write => "ce /././.",
						  },
						  {
						   description => "Can we find the top level elements in the model (7) ?",
						   read => "
- /Purkinje
",
						   write => "list_elements",
						  },
						 ],
				description => "current working element",
			       },
			      ],
       description => "current working element",
       name => 'current_working_element.t',
      };


return $test;


