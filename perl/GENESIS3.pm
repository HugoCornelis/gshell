#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Commands;


my $heccer_time_step = 2e-05;

my $outputs = [];

my $models = [];


sub add_output
{
    my $component_name = shift;

    my $field = shift;

    push
	@$GENESIS3::outputs,
	{
	 component_name => $component_name,
	 field => $field,
	 outputclass => "double_2_ascii",
	};

    return "*** Ok: add_output $component_name $field";
}


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
	    $GENESIS3::current_working_element =~ s((.*)/.*)($1);
	}
	else
	{
	    $GENESIS3::current_working_element .= $element;
	}
    }

    return "*** Ok: ce $path";
}


sub create
{
    my $type = shift;

    my $name = shift;

    # if the creator function exists

    $type = lc($type);

    no strict "refs";

    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{"create_$type"}))
#     if (exists \&{"GENESIS3::Help::list_$type"})
    {
	# current working element logic

	if ($name !~ m(^/))
	{
	    $name = "$GENESIS3::current_working_element/$name";
	}

	# some path logic, remove double // etc

	$name =~ s(/\./)(/)g;

	$name =~ s(/\.$)()g;

	$name =~ s([^/]/\.\.)()g;

	$name =~ s(/\.\./)(/)g;

	$name =~ s(//)(/)g;

	my $sub_name = "GENESIS3::Tokens::Physical::create_$type";

	no strict "refs";

	my $sub = (\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{"create_$type"};

	&$sub($name);

# 	# doesnot work for some reason

# 	eval "$sub_name(\$name)";

# 	print $@;

	return "*** Ok: create $type $name";
    }
    else
    {
	my $subs
	    = [
	       sort
	       map { s/^create_// ; lc }
	       grep { /^create_/ }
	       keys %{(\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}},
	      ];

	print "synopsis: create <type>\n";
	print "synopsis: <type> must be one of " . (join ', ', @$subs) . "\n";
	print "synopsis: (you gave $type)\n";

	return '*** Error: incorrect usage';
    }

}


sub echo
{
    print join " ", @_;

    return "*** Ok: echo";
}


sub help
{
    print "no help yet\n";

    return "*** Error: no help yet";
}


sub list
{
    my $type = shift;

    no strict "refs";

    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Help::"}->{"list_$type"}))
#     if (exists \&{"GENESIS3::Help::list_$type"})
    {
	my $sub_name = "GENESIS3::Help::list_$type";

	no strict "refs";

	my $sub = (\%{"::"})->{"GENESIS3::"}->{"Help::"}->{"list_$type"};

	&$sub();

# 	# doesnot work for some reason

# 	eval "$sub_name()";

# 	print $@;
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
	print "synopsis: <type> must be one of " . (join ', ', sort @$subs) . "\n";
	print "synopsis: (you gave $type)\n";

	return '*** Error: incorrect usage';
    }

    return '*** Ok: list';
}


sub list_elements
{
#     my $elements = $GENESIS3::model_container->list_elements($GENESIS3::current_working_element);

#     use YAML;

#     print Dump( { $GENESIS3::current_working_element => $elements, }, );

    my $element = shift;

    if (!defined $element)
    {
	$element = $GENESIS3::current_working_element;
    }
    else
    {
	if ($element =~ m(^/))
	{
	}
	else
	{
	    $element = "$GENESIS3::current_working_element/$element";
	}
    }

    my $query = "expand $element/*";

    querymachine($query);

    return "*** Ok: list_elements $element";
}


sub ndf_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: ndf_load $filename";
}


sub pwe
{
    print "$GENESIS3::current_working_element\n";

    return "*** Ok: pwd";
}


sub querymachine
{
    my $query = join ' ', @_;

    #t return value indicates user wants to quit ?

    #t good mechanism for error propagation is missing here

    $GENESIS3::model_container->querymachine($query);

    return "*** Ok: querymachine $query";
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

    my $schedule
	= {
	   name => "GENESIS3 schedule for $model_name, $time",
	  };

    # tell ssp that the model-container service has been initialized

    $schedule->{services}->{neurospaces}->{backend} = $GENESIS3::model_container;

    # fill in runtime_parameters

    $schedule->{models}->[0]->{granular_parameters} = $GENESIS3::runtime_parameters;

    # fill in model name

    $schedule->{models}->[0]->{modelname} = $model_name;

    #t only heccer supported for the moment

    $schedule->{models}->[0]->{solverclass} = 'heccer';

    # fill in the solverclasses

    #t make this configurable

    my $solverclasses
	= {
	   heccer => {
		      constructor_settings => {
					       dStep => $heccer_time_step,
					      },
		      module_name => 'Heccer',
		      service_name => 'neurospaces',
		     },
	  };

    $schedule->{solverclasses} = $solverclasses;

    # fill in the outputclasses

    #t make this configurable

    my $outputclasses
	= {
	   double_2_ascii => {
			      module_name => 'Heccer',
			      options => {
					  filename => '/tmp/output',
					 },
			      package => 'Heccer::Output',
			     },
	  };

    $schedule->{outputclasses} = $outputclasses;

    # fill in the outputs

    if (!@$GENESIS3::outputs)
    {
	# default is the soma Vm of a 'segments' group

	$schedule->{outputs}
	    = [
	       {
		component_name => "$model_name/segments/soma",
		field => "Vm",
		outputclass => "double_2_ascii",

		# but we are tolerant if this output cannot be found

		warn_only => "the default output ($model_name/segments/soma) was generated automatically and is not always available",
	       },
	      ];
    }

    # or

    else
    {
	# from the user settings

	$schedule->{outputs} = $GENESIS3::outputs;
    }

    # application configuration

    #t for the tests, should be configurable such that it can use the 'steps' method to.

    my $simulation
	= [
	   {
	    arguments => [ $time, { verbose => 2 }, ],
	    arguments => [ $time, ],
	    method => 'advance',
	   },
	   {
	    method => 'pause',
	   },
	  ];

    if ($GENESIS3::verbose_level
	and $GENESIS3::verbose_level eq 'debug')
    {
	$simulation->[0]->{arguments}->[1]->{verbose} = 2;
    }

    #! finishers are set empty to preserve interactivity.
    #! the pause method is assumed to flush buffers where applicable.

    $schedule->{apply}
	= {
	   simulation => $simulation,
	   finishers => [],
	  };

    # run the schedule

    my $scheduler = SSP->new($schedule);

    my $result = $scheduler->run();

    # if successful

    if (!$result)
    {
	# get the simulation time from the schedule

	$GENESIS3::global_time = $scheduler->{simulation_time}->{time};

	# return success

	return "*** Ok: done running $scheduler->{name}";
    }
    else
    {
	if (defined $scheduler->{simulation_time}->{time})
	{
	    $GENESIS3::global_time = $scheduler->{simulation_time}->{time};
	}

	return "*** Error: running $scheduler->{name} returned $result";
    }
}


sub set_verbose
{
    my $level = shift;

    if (exists $GENESIS3::all_verbose->{$level})
    {
	$GENESIS3::verbose_level = $level;

	return "*** Ok: setting verbosity to $level";
    }
    else
    {
	if (!exists $GENESIS3::all_verbose->{$GENESIS3::verbose_level})
	{
	    #! fall back to a default that makes sense to the current messy situation

	    set_verbose('debug');
	}

	return "*** Error: verbosity $level does not exist in the current environment";
    }
}


sub sh
{
    system @_;

    if ($?)
    {
	return "*** Error: sh ", @_, " returned $?";
    }
    else
    {
	return "*** Ok: sh ", @_;
    }
}


sub set_model_parameter
{
    my $element = shift;

    my $parameter = shift;

    my $value = shift;

    my $value_type = shift;

    if (ref $parameter =~ /HASH/)
    {
	foreach my $parameter_name (keys %$parameter)
	{
	    my $parameter_value = $parameter->{$parameter_name};

	    my $result = set_model_parameter($element, $parameter_name, $parameter_value);

	    if ($result =~ /error/i)
	    {
		return "*** Error: set_model_parameter $element $parameter_name $parameter_value";
	    }
	}

	return "*** ok: set_model_parameter $element $parameter $value_type $value";
    }
    else
    {
	if (!$value_type)
	{
	    if ($value =~ /->/)
	    {
		$value_type = 'field';
	    }
	    elsif ($value =~ /\//)
	    {
		$value_type = 'symbolic';
	    }
	    elsif ($value =~ /^(\+|-)?([0-9]+)(\.[0-9]+)?(e(\+|-)?([0-9]+))?$/)
	    {
		$value_type = 'number';
	    }
	    else
	    {
		$value_type = 'string';
	    }
	}

	if (!defined $element)
	{
	    $element = $GENESIS3::current_working_element;
	}
	else
	{
	    if ($element =~ m(^/))
	    {
	    }
	    else
	    {
		$element = "$GENESIS3::current_working_element/$element";
	    }
	}

	my $query = "setparameterconcept $element $parameter $value_type $value";

	querymachine($query);

	return "*** ok: set_model_parameter $element $parameter $value_type $value";
    }
}


sub set_runtime_parameter
{
    my $element = shift;

    my $parameter = shift;

    my $value = shift;

    my $value_type = shift;

    if (!$value_type)
    {
	if ($value =~ /->/)
	{
	    $value_type = 'field';
	}
	elsif ($value =~ /\//)
	{
	    $value_type = 'symbolic';
	}
	elsif ($value =~ /^(\+|-)?([0-9]+)(\.[0-9]+)?(e(\+|-)?([0-9]+))?$/)
	{
	    $value_type = 'number';
	}
	else
	{
	    $value_type = 'string';
	}
    }

    if (!defined $element)
    {
	$element = $GENESIS3::current_working_element;
    }
    else
    {
	if ($element =~ m(^/))
	{
	}
	else
	{
	    $element = "$GENESIS3::current_working_element/$element";
	}
    }

#     my $query = "setparameter / $element $parameter $value_type $value";

#     querymachine($query);

    push
	@$GENESIS3::runtime_parameters,
	{
	 component_name => $element,
	 field => $parameter,
	 value => $value,

	 #t note that value_type is ignored right now

	 value_type => $value_type,
	};

    return "*** Ok: set_runtime_parameter $element $parameter $value_type $value";
}


sub show_global_time
{
    print "---\nglobal_time: $GENESIS3::global_time\n";

    return "*** Ok: show_global_time";
}


sub show_library
{
    my $type = shift || 'ndf';

    my $path = shift || '.';

    if ($type =~ /^ndf$/i)
    {
	my $result
	    = [
	       map
	       {
		   chomp ; $_
	       }
	       `ls -1F "/usr/local/neurospaces/models/library/$path"`,
	      ];

	use YAML;

	print Dump( { ndf_library => { $path => $result, }, }, );
    }

    return "*** Ok: show_library $type $path";
}


sub show_parameter
{
    my $element = shift;

    my $parameter = shift;

    if (!defined $element)
    {
	$element = $GENESIS3::current_working_element;
    }
    else
    {
	if ($element =~ m(^/))
	{
	}
	else
	{
	    $element = "$GENESIS3::current_working_element/$element";
	}
    }

    my $query = "printparameter $element $parameter";

    if (querymachine($query))
    {
    }

    return "*** Ok: show_parameter $element $parameter";
}


sub show_runtime_parameters
{
    use YAML;

    print Dump( { runtime_parameters => $GENESIS3::runtime_parameters, }, );

    return "*** Ok: show_runtime_parameters";
}


sub show_verbose
{
    print "---\nverbose_level: $GENESIS3::verbose_level\n";

    return "*** Ok: show_verbose";
}


{
    # import all command subs into the main namespace

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


sub list_components
{
    use Data::Dumper;

    use YAML;

    print Dump(
	       {
		"Core components" => $GENESIS3::all_components,
		"Other components" => $GENESIS3::all_cpan_components,
	       },
	      );
}


sub list_functions
{
    print "all function tokens:\n";

    print foreach map { "  - $_\n" } "NERNST", "MGBLOCK", "RANDOMIZE", "FIXED", "SERIAL";

    undef;
}


sub list_verbose
{
    use YAML;

    print Dump( { 'verbosity levels' => $GENESIS3::all_verbose, } );

    return "*** Ok: list_verbose";
}


package GENESIS3;


our $configuration
    = {
       symbols => {
		   directory => "/usr/local/neurospaces/instrumentor/hierarchy/",
		   filename => "symbols",
		  },
      };


package GENESIS3::Help;


# loop over all lexical purposes

foreach my $purpose qw(
		       physical
		       sections
		       structure
		      )
{
    # construct a list function for this lexical purpose

    no strict "refs";

    ((\%{"::"})->{"GENESIS3::"}->{"Help::"}->{"list_$purpose"})
	= sub
	  {
	      my $filename = "$GENESIS3::configuration->{symbols}->{directory}$GENESIS3::configuration->{symbols}->{filename}";

	      my $symbols_definitions = do $filename;

	      my $tokens = $symbols_definitions->{tokens};

	      my $token_names
		  = [
		     sort
		     map
		     {
			 s/^TOKEN_// ; $_
		     }
		     map
		     {
			 my $token = $tokens->{$_};

			 $token->{lexical};
		     }
		     grep
		     {
			 $tokens->{$_}->{purpose} eq $purpose
		     }
		     keys %$tokens,
		    ];

	      print "all $purpose tokens:\n";

	      print foreach map { "  - $_\n" } @$token_names;

	      return "*** Ok: list_$purpose";
	  };
}


package GENESIS3::Tokens::Physical;


use Neurospaces::Tokens::Physical;


my $filename = "$GENESIS3::configuration->{symbols}->{directory}$GENESIS3::configuration->{symbols}->{filename}";

my $symbols_definitions = do $filename;

my $tokens = $symbols_definitions->{tokens};

my $token_names
    = [
       sort
       map
       {
	   s/^TOKEN_// ; $_
       }
       map
       {
	   my $token = $tokens->{$_};

	   $token->{lexical};
       }
       grep
       {
	   $tokens->{$_}->{purpose} eq 'physical'
       }
       keys %$tokens,
      ];

foreach my $token_name (@$token_names)
{
    # construct an create function for this token

    no strict "refs";

    my $lc_token_name = lc($token_name);

    my $subname = "create_" . $lc_token_name;

    ((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{$subname})
	= sub
	  {
	      # get name

	      my $physical_name = shift;

	      if ($GENESIS3::verbose_level ne 'errors')
	      {
		  print "$subname: $physical_name\n";
	      }

	      my $physical = Neurospaces::Tokens::Physical::create($lc_token_name, $GENESIS3::model_container, $physical_name);

	      if (!$physical_name)
	      {
		  return "*** Error: creating $physical_name of type $lc_token_name";
	      }
	      else
	      {
		  return "*** Ok: creating $physical_name of type $lc_token_name";
	      }
	  };
}


package GENESIS3;


#t this info should be coming from the installer script.

our $all_components
    = {
       gshell => {
		  description => 'the GENESIS 3 shell allows convenient interaction with other components',
		  module => 'GENESIS3',
		  status => 'loaded',
# 		  variables => {
# 				verbose => $GENESIS3::verbose_level,
# 			       },
		 },
       heccer => {
		  description => 'single neuron equation solver',
		  module => 'Heccer',
		 },
       'model-container' => {
			     description => 'internal storage for neuronal models',
			     module => 'Neurospaces',
			    },
       ssp => {
	       description => 'binds the software components of a simulation together',
	       module => 'SSP',
	      },
      };


our $all_cpan_components
    = {
       python => {
		  description => 'interface to python scripting',
		 },
      };


our $all_verbose
    = {
       errors => {
		  comment => 'this is the default',
		  description => 'displays only error state information',
		 },
       warnings => {
		    description => 'displays warning and error state information',
		   },
       information => {
		       description => 'displays information, warning and error messages',
		      },
       debug => {
		 description => 'used for software development and maintenance',
		},
      };


our $current_working_element = '/';

our $global_time = 0;

our $model_container;

our $outputs = [];

our $runtime_parameters = [];

our $verbose_level;


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
	die "$0: *** Error: cannot instantiate a model container\n";
    }

    my $args = [ "$0", "utilities/empty_model.ndf" ];

    my $success = $model_container->read(undef, $args);

    if (!$success)
    {
	die "$0: *** Error: cannot initialize the model container\n";
    }

    return $result;
}


sub profile_environment
{
    foreach my $component_name (keys %$all_components)
    {
	my $component = $all_components->{$component_name};

	my $component_module = $component->{module} || $component_name;

	if ($component->{status} eq 'loaded')
	{
	    next;
	}

	eval
	{
	    local $SIG{__DIE__};

	    require "$component_module.pm";
	};

	if ($@ eq '')
	{
	    $component->{status} = 'loaded';
	}
	else
	{
	    $component->{status} = $@;
	}
    }

    eval
    {
	require GENESIS3::Python;
    };

    if ($@)
    {
	$all_cpan_components->{python}->{status} = $@;
    }
    else
    {
	$all_cpan_components->{python}->{status} = 'loaded';
    }

    return 1;
}


sub version
{
    # $Format: "    my $version=\"${package}-${label}\";"$
    my $version="gshell-ed79d228eb561e5df70bd37e97b4dfb047c45277-0";

    return $version;
}


profile_environment()
    && initialize();


