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
description => "Does the version information match with gshell-35c7a77346427a1a59e24269179b0b4dc83094b5.0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "gshell-35c7a77346427a1a59e24269179b0b4dc83094b5.0",
# 						   write => "version",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


