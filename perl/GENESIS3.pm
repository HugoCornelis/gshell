#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package main;


sub help
{
    print "no help yet\n";
}


package GENESIS3;


#t this info should be coming from the installer script.

our $all_packages
    = {
       SSP => 0,
       'model-container' => 0,
       heccer => 0,
      }


sub profile_environment
{
    foreach my $package_name (keys %$all_packages)
    {
	my $package = $all_packages->{$package_name};

	my $loaded = eval "require $package_name";

	$package->{loaded} = $loaded;
    }

    return 1;
}


profile_environment();


