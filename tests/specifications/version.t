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
description => "Does the version information match with gshell-ed79d228eb561e5df70bd37e97b4dfb047c45277-0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "gshell-ed79d228eb561e5df70bd37e97b4dfb047c45277-0",
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


