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
description => "Does the version information match with gshell-alpha ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "gshell-alpha",
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


