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
						   description => "Can we create a cell ?",
						   write => 'create cell /c',
						  },
						  {
						   description => "Can we create a segment ?",
						   write => 'create segment /c/s',
						  },
						  {
						   description => "Can we create a channel in the segment ?",
						   write => 'create channel /c/s/na',
						  },
						  {
						   description => "Can we find the channel in the segment ?",
						   read => '
- /c
- /c/s
- /c/s/na
',
						   write => 'querymachine expand /**',
						  },
						  {
						   description => "Can we set parameter CM of the segment ?",
						   write => 'set_model_parameter /c/s CM 0.0164',
						  },
						  {
						   description => "Can we find the parameters of the segment ?",
						   read => '    Name, index (s,-1)
    Type (T_sym_segment)
    segmenName, index (s,-1)
        PARA  Name (CM)
        PARA  Type (TYPE_PARA_NUMBER), Value(1.640000e-02)
',
						   write => 'querymachine printinfo /c/s',
						  },
						 ],
				description => "commands for creating a model",
			       },
			      ],
       description => "creating elements",
       name => 'creating_elements.t',
      };


return $test;


