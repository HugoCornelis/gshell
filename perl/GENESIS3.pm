#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Commands;


our $working_element = '/';


sub ce
{
    my $path = shift;

    $path =~ s/\s*//g;

    my $stack = [ split '/', $path, ];

    while (my $element = pop @$stack)
    {
	if ($element eq '.'
	    or $element eq '')
	{
	}
	elsif ($element eq '..')
	{
	    $working_element =~ s((.*)/.*)($1);
	}
	else
	{
	    $working_element .= $element;
	}
    }
}


sub pwe
{
    print "$working_element\n";
}


sub help
{
    print "no help yet\n";
}


sub list_elements
{
    my $elements = $GENESIS3::model_container->list_elements($working_element);

    use YAML;

    print Dump( { $working_element => $elements, }, );
}


sub list
{
    my $type = shift;

    no strict "refs";

    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Help::"}->{"list_$type"}))
    {
	my $sub_name = "GENESIS3::Help::list_$type";

	no strict "refs";

	&$sub_name();
    }
    else
    {
	my $subs
	    = [
	       map { s/^list_// ; $_ }
	       grep { /^list_/ }
	       keys %{(\%{"::"})->{"GENESIS3::"}->{"Help::"}},
	      ];

	print "synopsis: list <type>\n";
	print "synopsis: <type> must be one of " . (join ', ', @$subs) . "\n";
	print "synopsis: (you gave $type)\n";

	return '*** Error: incorrect usage';
    }

    return '*** Ok';
}


sub ndf_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );
}


sub run
{
    my $model_name = shift;

    my $time = shift;

    if (!$model_name || !$time)
    {
	return '*** Error: <model_name> and <time> are required';
    }

    if ($time !~ /[0-9]*(\.[0-9]+)?(e(\+|-)?[0-9]+)?/
	|| $time eq '')
    {
	return '*** Error: <time> must be numeric';
    }

    #t construct ssp schedule based on the cell buitin.
}


sub sh
{
    return system @_;
}


sub quit
{
    my $exit_code = shift;

    if (!defined $exit_code)
    {
	$exit_code = 0;
    }

    exit $exit_code;
}


{
    no strict "refs";

    foreach my $command (keys %{(\%{"::"})->{"GENESIS3::"}->{"Commands::"}})
    {
	(\%{"::"})->{$command} = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{$command};
    }
}


package GENESIS3::Help;


sub list_commands
{
    no strict "refs";

    my $commands = [ grep { /^[a-z_0-9]+$/ } (keys %{(\%{"::"})->{"GENESIS3::"}->{"Commands::"}}), ];

    print "all commands:\n";

    print foreach sort map { "  - $_\n" } @$commands;
}


sub list_packages
{
    use Data::Dumper;

    use YAML;

    print Dump(
	       {
		"Core packages" => $GENESIS3::all_packages,
		"Other packages" => $GENESIS3::all_cpan_packages,
	       },
	      );
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


our $model_container;


sub header
{
    print "Welcome to the GENESIS 3 shell\n";
}


sub initialize
{
    my $result = 1;

    $model_container = Neurospaces->new();

    if (!$model_container)
    {
	print "Cannot instantiate a model container\n";

	$result = 0;
    }

    return $result;
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


profile_environment()
    && initialize();


