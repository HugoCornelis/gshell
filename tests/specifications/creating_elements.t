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
						   description => "Can we create a second channel in the segment ?",
						   write => 'create channel /c/s/k',
						  },
						  {
						   description => "Can we delete the first channel from the segment ?",
						   disabled => (`cat /usr/local/include/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'the model-container was not configured to include the delete operation'),
						   write => 'delete /c/s/na',
						  },
						  {
						   description => "Can we find the first channel in the segment (should not) ?",
						   disabled => (`cat /usr/local/include/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'the model-container was not configured to include the delete operation'),
						   read => '
- /c
- /c/s
- /c/s/k
',
						   write => 'querymachine expand /**',
						  },
						  {
						   description => "Can we find the second channel in the segment ?",
						   disabled => (`cat /usr/local/include/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'the model-container was not configured to include the delete operation'),
						   read => '
- /c
- /c/s
- /c/s/k
',
						   write => 'querymachine expand /**',
						  },
						  {
						   description => "Can we delete the segment and its remaining channel?",
						   disabled => (`cat /usr/local/include/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'the model-container was not configured to include the delete operation'),
						   write => 'delete /c/s',
						  },
						  {
						   comment => 'Note that for some reason this test always succeeds, likely a problem with the regular expression of the test.',
						   description => "Has the segment been removed ?",
						   disabled => (`cat /usr/local/include/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'the model-container was not configured to include the delete operation'),
						   read => [
							    '-re',
							    '/c
(?!/c/s).',
							   ],
# 						   read => '
# - /c
# - /c/s
# - /c/s/k
# ',
						   write => 'querymachine expand /**',
						  },
						  {
						   description => "Can we create a new segment ?",
						   write => 'create segment /c/s',
						  },
						  {
						   description => "Can we find the second channel in the segment ?",
						   read => '
- /c
- /c/s
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
						  {
						   description => "Can we obtain the value of the parameters of the segment ?",
						   read => 'value = 0.0164
',
						   write => 'show_parameter /c/s CM',
						  },
						 ],
				description => "commands for creating a model",
			       },
			      ],
       description => "creating and deleting elements",
       name => 'creating_elements.t',
      };


return $test;


