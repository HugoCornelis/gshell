#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--version',
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   # $Format: "description => \"Does the version information match with ${package}-${label} ?\","$
description => "Does the version information match with gshell-e441e00ce82838764e57f49e8b31784deeb56863-0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "gshell-e441e00ce82838764e57f49e8b31784deeb56863-0",
						   write => "version",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


