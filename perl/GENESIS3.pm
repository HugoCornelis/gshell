#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package main;


sub help
{
    print "no help yet\n";
}


sub list
{
    my $type = shift;

    no strict "refs";

    my $types
	= {
	   commands => 1,
	   tokens => 1,
	  };

    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Help::"}->{"list_$type"}))
    {
	my $sub_name = "GENESIS3::Help::list_$type";

	no strict "refs";

	&$sub_name();
    }
    else
    {
	print "synopsis: list <type>\n";
	print "synopsis: <type> must be one of 'commands' or 'tokens'\n";

	return 'incorrect usage';
    }

    return undef;
}


sub packages
{
    GENESIS3::packages();
}


package GENESIS3::Help;


sub list_commands
{
    my $commands = [ 'blabla', ];

    print "all commands\n";

    print foreach map { "$_\n" } @$commands;
}


sub list_tokens
{
    my $filename = "$GENESIS3::configuration->{symbols}->{directory}$GENESIS3::configuration->{symbols}->{filename}";

    my $symbols_definitions = do $filename;

    my $class_hierarchy = $symbols_definitions->{class_hierarchy};

    my $tokens
	= [
	   sort
	   map
	   {
	       s/^TOKEN_// ; $_
	   }
	   grep
	   {
	       defined
	   }
	   map
	   {
	       my $class = $class_hierarchy->{$_};

	       $class->{token_name};
	   }
	   keys %$class_hierarchy,
	  ];

    print "all tokens:\n";

    print foreach map { "  - $_\n" } @$tokens;
}


package GENESIS3;


our $configuration
    = {
       symbols => {
		   directory => "/usr/local/neurospaces/instrumentor/hierarchy/",
		   filename => "symbols",
		  },
      };


#t this info should be coming from the installer script.

our $all_packages
    = {
       SSP => {},
       'model-container' => {
			     module => 'Neurospaces',
			    },
       heccer => {
		  module => 'Heccer',
		 },
      };


our $all_cpan_packages
    = {
       python => {},
      };

sub header
{
    print "Welcome to the GENESIS 3 shell\n";
}


sub packages
{
    use Data::Dumper;

    print "Core packages:\n" . Dumper($all_packages);
    print "Other packages:\n" . Dumper($all_cpan_packages);
}


sub profile_environment
{
    foreach my $package_name (keys %$all_packages)
    {
	my $package = $all_packages->{$package_name};

	my $package_module = $package->{module} || $package_name;

	eval
	{
	    local $SIG{__DIE__};

	    require "$package_module.pm";
	};

	if ($@ eq '')
	{
	    $package->{status} = 'loaded';
	}
	else
	{
	    $package->{status} = $@;
	}
    }

    eval
    {
	require GENESIS3::Python;
    };

    if ($@)
    {
	$all_cpan_packages->{python}->{status} = $@;
    }
    else
    {
	$all_cpan_packages->{python}->{status} = 'loaded';
    }

    return 1;
}


sub version
{
    # $Format: "    my $version=\"${package}-${label}\";"$
    my $version="gshell-python-2";

    return $version;
}


profile_environment();


