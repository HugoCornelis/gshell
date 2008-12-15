#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Commands;


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


sub add_output_help
{
    print "description: add a variable to the output file
synopsis: add_output <element_name> <field_name>
";

    return "*** Ok";
}


sub ce
{
    my $path = shift;

    my $current_working_element = $GENESIS3::current_working_element;

    $path =~ s/\s*//g;

    if ($path =~ m(^/+$))
    {
	$GENESIS3::current_working_element = "/";

	return "*** Ok: ce $path";
    }

    my $stack = [ split '/', $path, ];

    while (my $element = pop @$stack)
    {
	if ($element eq '.'
	    or $element eq '')
	{
	}
	elsif ($element eq '..')
	{
	    $current_working_element =~ s((.*)/.*)($1);
	}
	else
	{
	    $current_working_element .= $element;
	}
    }

    if (Neurospaces::exists_component($current_working_element))
    {
	$GENESIS3::current_working_element = $current_working_element;

	return "*** Ok: ce $path";
    }
    else
    {
	return "*** Error: element $path not found";
    }
}


sub ce_help
{
    print "synopsis: ce <element_name>\n";

    return "*** Ok";
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

	my $result = &$sub($name);

# 	# doesnot work for some reason

# 	eval "$sub_name(\$name)";

# 	print $@;

	return $result;
    }
    else
    {
	create_help( { type => $type, }, );

	return '*** Error: incorrect usage';
    }

}


sub create_help
{
    my $topic = shift;

    no strict "refs";

    my $subs
	= [
	   sort
	   map { s/^create_// ; lc }
	   grep { /^create_/ }
	   keys %{(\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}},
	  ];

    print "synopsis: create <type> <element_name>\n";
    print "synopsis: <type> must be one of " . (join ', ', @$subs) . "\n";

    if ($topic =~ /HASH/)
    {
	my $type = $topic->{type};

	print "synopsis: (you gave $type)\n";
    }

    return "*** Ok";
}


sub delete
{
    my $name = shift;

    no strict "refs";

    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{"delete"}))
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

	eval
	{
	    $GENESIS3::model_container->delete_component($name);
	};

	if ($@)
	{
	    return "*** Error: delete $name";
	}
	else
	{
	    return "*** Ok: delete $name";
	}
    }
    else
    {
	return '*** Error: incorrect usage';
    }
}


sub delete_help
{
    print "synopsis: delete <element_name>\n";

    return "*** Ok";
}


sub echo
{
    print join " ", @_;

    return "*** Ok: echo";
}


sub echo_help
{
    print "synopsis: echo <arguments>\n";

    return "*** Ok";
}


sub help
{
    my $topic = shift;

    my $subtopic = shift;

    my $subsubtopic = shift;

    if (!defined $topic)
    {
	return help_help();
    }

    print "---\n";

    # for commands

    if ($topic =~ m'^comm')
    {
# 	foreach my $command (keys %{(\%{"::"})->{"GENESIS3::"}->{"Commands::"}})
# 	{
# 	    (\%{"::"})->{$command} = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{$command};
# 	}

	if (!defined $subtopic)
	{
	    print "description: help on a specific command
synopsis: 'help command <command_name>'
";

	    return list("commands");
	}
	else
	{
	    no strict "refs";

	    if (exists ((\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{"${subtopic}_help"}))
	    {
		my $sub_name = "GENESIS3::Commands::help_$subtopic";

		no strict "refs";

		my $sub = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{"${subtopic}_help"};

		return &$sub($topic, $subtopic, $subsubtopic, );
	    }
	    else
	    {
		my $error = "*** Error: no help found for command $subtopic\n";

		return $error;
	    }
	}
    }

    # for components

    elsif ($topic =~ m'^comp')
    {
	if (!defined $subtopic)
	{
	    print "description: help on a specific software component
synopsis: 'help component <component_name>'
";

	    return list("components");
	}
	else
	{
	    my $component_module = exists $GENESIS3::all_components->{$subtopic} ? $GENESIS3::all_components->{$subtopic}->{module} : '';

	    no strict "refs";

	    my $sub_name = "${component_module}::help";

	    if ($component_module
		and exists &$sub_name)
	    {
		no strict "refs";

# 		my $sub = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{"${subtopic}_help"};

		return &$sub_name($topic, $subtopic, $subsubtopic, );
	    }
	    else
	    {
		my $error = "*** Error: no help found for command $subtopic\n";

		return $error;
	    }
	}
    }

    # for variables

    elsif ($topic =~ m'^var')
    {
    }

    # for libraries

    elsif ($topic =~ m'^lib')
    {
    }

    return "*** Error: no help for topic $topic yet";
}


sub help_help
{
    print "synopsis: help <topic>\n";
    print "synopsis: <topic> must be one of commands, components, variables, libraries\n";

    return "*** Ok";
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
	list_help( { type => $type, }, );

	return '*** Error: incorrect usage';
    }

    return '*** Ok: list';
}


sub list_help
{
    my $topic = shift;

    no strict "refs";

    my $subs
	= [
	   map { s/^list_// ; $_ }
	   grep { /^list_/ }
	   keys %{(\%{"::"})->{"GENESIS3::"}->{"Help::"}},
	  ];

    print "synopsis: list <type>\n";
    print "synopsis: <type> must be one of " . (join ', ', sort @$subs) . "\n";

    if ($topic =~ m/HASH/)
    {
	my $type = $topic->{type};

	print "synopsis: (you gave $type)\n";
    }

    return "*** Ok";
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


sub list_elements_help
{
    print "synopsis: list_elements [ <element_name> ]\n";

    return "*** Ok";
}


sub model_state_load
{
    my $modelname = shift;

    my $filename = shift;

    if (!defined $modelname || !defined $filename)
    {
	return '*** Error: <modelname> and <filename> are required';
    }

    # define a scheduler for this model

    run($modelname, 0);

    # if we have a scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    my $model = $scheduler->lookup_model($modelname);

    my $solverclasses = $scheduler->{solverclasses};

    my $solverclass = $model->{solverclass};

    my $service = $scheduler->{services}->{$solverclasses->{$solverclass}->{service_name}}->{ssp_service};

    #t not sure if we should make field obligatory ?

    my $solverinfo = $service->input_2_solverinfo( { component_name => $modelname, }, );

    my $solver_engine = $scheduler->lookup_solver_engine($solverinfo->{solver});

    if ($solver_engine->deserialize($filename))
    {
	return "*** Ok: model_state_load";
    }
    else
    {
	return "*** Error: model_state_load";
    }
}


sub model_state_load_help
{
    print "synopsis: model_state_load <element_name> <filename>\n";

    return "*** Ok";
}


sub model_state_save
{
    my $modelname = shift;

    my $filename = shift;

    if (!defined $modelname || !defined $filename)
    {
	return '*** Error: <modelname> and <filename> are required';
    }

    # define a scheduler for this model

    run($modelname, 0);

    # if we have a scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    my $model = $scheduler->lookup_model($modelname);

    my $solverclasses = $scheduler->{solverclasses};

    my $solverclass = $model->{solverclass};

    my $service = $scheduler->{services}->{$solverclasses->{$solverclass}->{service_name}}->{ssp_service};

    #t not sure if we should make field obligatory ?

    my $solverinfo = $service->input_2_solverinfo( { component_name => $modelname, }, );

    my $solver_engine = $scheduler->lookup_solver_engine($solverinfo->{solver});

    if ($solver_engine->serialize($filename))
    {
	return "*** Ok: model_state_save";
    }
    else
    {
	return "*** Error: model_state_save";
    }
}


sub model_state_save_help
{
    print "synopsis: model_state_save <element_name> <filename>\n";

    return "*** Ok";
}


sub ndf_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: ndf_load $filename";
}


sub ndf_load_help
{
    print "synopsis: ndf_load <filename>\n";

    return "*** Ok";
}


sub ndf_save
{
    my $modelname = shift;

    my $filename = shift;

    $GENESIS3::model_container->write(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: ndf_save $filename";
}


sub ndf_save_help
{
    print "synopsis: ndf_save <element_name> <filename>\n";

    return "*** Ok";
}


sub pwe
{
    print "$GENESIS3::current_working_element\n";

    return "*** Ok: pwd";
}


sub pwe_help
{
    print "synopsis: pwe\n";

    return "*** Ok";
}


sub querymachine
{
    my $query = join ' ', @_;

    #t return value indicates user wants to quit ?

    #t good mechanism for error propagation is missing here

    $GENESIS3::model_container->querymachine($query);

    return "*** Ok: querymachine $query";
}


sub querymachine_help
{
    print "synopsis: querymachine <command> [ <arguments> ... ]\n";

    return "*** Ok";
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


sub quit_help
{
    print "synopsis: quit <element_name>\n";

    return "*** Ok";
}


sub run
{
    my $modelname = shift;

    my $time = shift;

    if (!defined $modelname || !defined $time)
    {
	return '*** Error: <modelname> and <time> are required';
    }

    if ($time !~ /^[0-9]*(\.[0-9]+)?(e(\+|-)?[0-9]+)?$/
	|| $time eq '')
    {
	return '*** Error: <time> must be numeric';
    }

    # if we have a scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if ($scheduler)
    {
	# apply run time settings

	#! we check the run time parameters if they apply to the model
	#! we are running, if so, we set ->{modelname} because SSP
	#! expects it if we apply run time settings on a schedule (SSP
	#! does not expect it when applying run time settings during
	#! compilation)

	my $result
	    = $scheduler->apply_granular_parameters
		(
		 $scheduler,
		 map
		 {
		     {
			 modelname => $modelname,
			 %$_,
		     };
		 }
		 grep
		 {
		     $_->{component_name} =~ /^$modelname/
		 }
		 @$GENESIS3::runtime_parameters,
		);

	if (!$result)
	{
	    return "*** Error: apply_granular_parameters() for $scheduler->{name} failed";
	}

	# use the scheduler

	$result = $scheduler->advance($scheduler, $time, ); # { verbose => 2 } );

	$result &&= $scheduler->pause();

	# get the simulation time from the schedule

	$GENESIS3::global_time = $scheduler->{simulation_time}->{time};

	if (!$result)
	{
	    return "*** Error: advance() for $scheduler->{name} failed";
	}

	# return success

	return "*** Ok: done running $scheduler->{name}";
    }
    else
    {
	my $schedule
	    = {
	       name => "GENESIS3 SSP schedule initiated for $modelname, $time",
	      };

	# tell ssp that the model-container service has been initialized

	$schedule->{services}->{neurospaces}->{backend} = $GENESIS3::model_container;

	# fill in runtime_parameters

	$schedule->{models}->[0]->{granular_parameters} = $GENESIS3::runtime_parameters;

	# fill in model name

	$schedule->{models}->[0]->{modelname} = $modelname;

	#t only heccer supported for the moment

	$schedule->{models}->[0]->{solverclass} = 'heccer';

	# fill in the solverclasses

	#t make this configurable

	my $solverclasses
	    = {
	       heccer => {
			  constructor_settings => {
						   dStep => $GENESIS3::heccer_time_step,
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
		    component_name => "$modelname/segments/soma",
		    field => "Vm",
		    outputclass => "double_2_ascii",

		    # but we are tolerant if this output cannot be found

		    warn_only => "the default output ($modelname/segments/soma) was generated automatically and is not always available",
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

	# register the scheduler

	$GENESIS3::schedulers->{$modelname} = $scheduler;

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
}


sub run_help
{
    print "synopsis: run <element_name> <time>\n";

    return "*** Ok";
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


sub set_verbose_help
{
    print "synopsis: set_verbose <level>\n";

    return "*** Ok";
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


sub sh_help
{
    print "synopsis: sh <command> [ <arguments> ... ]\n";

    return "*** Ok";
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

	return "*** Ok: set_model_parameter $element $parameter $value_type $value";
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

	return "*** Ok: set_model_parameter $element $parameter $value_type $value";
    }
}


sub set_model_parameter_help
{
    print "synopsis: set_model_parameter <element_name> <parameter_name> <value> [ <value_type> ]\n";

    return "*** Ok";
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


sub set_runtime_parameter_help
{
    print "synopsis: set_runtime_parameter <element_name> <parameter_name> <value> [ <value_type> ]\n";

    return "*** Ok";
}


sub show_global_time
{
    print "---\nglobal_time: $GENESIS3::global_time\n";

    return "*** Ok: show_global_time";
}


sub show_global_time_help
{
    print "synopsis: show_global_time\n";

    return "*** Ok";
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


sub show_library_help
{
    print "synopsis: show_library [ <library_type> ] [ <library_path> ]\n";

    return "*** Ok";
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


sub show_parameter_help
{
    print "synopsis: show_parameter <element_name> <parameter_name>\n";

    return "*** Ok";
}


sub show_runtime_parameters
{
    use YAML;

    print Dump( { runtime_parameters => $GENESIS3::runtime_parameters, }, );

    return "*** Ok: show_runtime_parameters";
}


sub show_runtime_parameters_help
{
    print "synopsis: show_runtime_parameters <element_name>\n";

    return "*** Ok";
}


sub show_verbose
{
    print "---\nverbose_level: $GENESIS3::verbose_level\n";

    return "*** Ok: show_verbose";
}


sub show_verbose_help
{
    print "synopsis: show_verbose\n";

    return "*** Ok";
}


{
    # check if all command subs have associated help subs

    no strict "refs";

    foreach my $command (keys %{(\%{"::"})->{"GENESIS3::"}->{"Commands::"}})
    {
# 	(\%{"::"})->{$command} = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{$command};

	if ($command =~ /_help$/)
	{
	    next;
	}
	elsif ($command eq 'BEGIN'
	       or $command eq 'Dump'
	       or $command eq 'Load')
	{
	    next;
	}

	if (!exists  ((\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{"${command}_help"}))
	{
	    print "*** Warning: command $command found, but no help available for it\n";
	}
    }
}


package GENESIS3::Help;


sub list_commands
{
    no strict "refs";

    my $commands = [ grep { /^[a-z_0-9]+$/ } (keys %{(\%{"::"})->{"GENESIS3::"}->{"Commands::"}}), ];

    print "all commands:\n";

    print foreach sort map { "  - $_\n" } grep { $_ !~ /_help$/ } @$commands;

    return "*** Ok: list_commands";
}


sub list_components
{
    use YAML;

    local $YAML::UseHeader = 0;

    print Dump(
	       {
		"Core components" => $GENESIS3::all_components,
		"Other components" => $GENESIS3::all_cpan_components,
	       },
	      );

    return "*** Ok: list_components";
}


sub list_functions
{
    print "all function tokens:\n";

    print foreach map { "  - $_\n" } "NERNST", "MGBLOCK", "RANDOMIZE", "FIXED", "SERIAL";

    return "*** Ok: list_functions";
}


sub list_verbose
{
    use YAML;

    local $YAML::UseHeader = 0;

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
	   #! note that not all tokens have a purposed that is defined
	   #! (which does not necessarily mean they don't have a
	   #! purpose).

	   defined $tokens->{$_}->{purpose}
	       and $tokens->{$_}->{purpose} eq 'physical'
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


package GENESIS3::Objects;


my $genesis2_objects
    = "
Ca_concen
Kpores
Mg_block
Napores
PID
RC
asc_file
autocorr
axon
axonlink
calculator
channelA
channelB
channelC
channelC2
channelC3
compartment
concchan
concpool
crosscorr
ddsyn
defsynapse
dif2buffer
difbuffer
diffamp
difshell
disk_in
disk_out
diskio
efield
enz
event_tofile
expthresh
facsynchan
fixbuffer
freq_monitor
funcgen
fura2
ghk
graded
gsolve
hebbsynchan
hh_channel
hillpump
hsolve
interspike
leakage
linear
manuelconduct
metadata
mmpump
nernst
neutral
par_asc_file
par_disk_out
paramtableBF
paramtableCG
paramtableGA
paramtableSA
paramtableSS
passive_buffer
periodic
peristim
playback
pool
print_out
pulsegen
random
randomspike
reac
receptor
receptor2
res_asc_file
script_out
sigmoid
site
spike
spikegen
spikehistory
symcompartment
synapse
synapseA
synapseB
synchan
synchan2
tab2Dchannel
tabchannel
tabcurrent
tabgate
table
table2D
taupump
text
timetable
unit
variable
vdep_channel
vdep_gate
x1button
x1cell
x1dialog
x1draw
x1form
x1graph
x1image
x1label
x1shape
x1text
x1toggle
x1view
xaxis
xbutton
xcell
xcoredraw
xdialog
xdraw
xdumbdraw
xfastplot
xform
xgif
xgraph
ximage
xlabel
xpix
xplot
xshape
xsphere
xtext
xtoggle
xtree
xvar
xview
xviewdata
";


my $genesis2_commands
    = "
abort
abs
acos
addaction
addalias
addclass
addescape
addfield
addforwmsg
addglobal
addjob
addmsg
addmsgdef
addobject
addtask
affdelay
affweight
argc
arglist
argv
asciidata
asin
atan
balanceEm
calcCm
calcRm
call
callfunc
cd
ce
cellsheet
check
chr
clearbuffer
clearerrors
clonemsgs
closefile
connect
copy
copyleft_kin
cos
countchar
countelementlist
cpu
create
createmap
cstat
dd3dmsg
debug
debugfunc
delete
delete_connection
deleteaction
deleteall
deleteclass
deletefield
deleteforwmsg
deletejob
deletemsg
deletemsgdef
deletetasks
dirlist
disable
duplicatetable
echo
egg
el
enable
enddump
eof
error
exists
exit
exp
expsum
expweight
file2tab
fileconnect
fileexists
findchar
findsolvefield
floatformat
flushfile
gaussian
gctrace
gen2spk
gen3dmsg
getarg
getclock
getconn
getdate
getdefault
getelementlist
getenv
getfield
getfieldnames
getglobal
getinput
getmsg
getparamGA
getpath
getsolvechildname
getsolvecompname
getstat
getsyncount
getsyndest
getsynindex
getsynsrc
gftrace
h
help
initdump
initparamBF
initparamCG
initparamGA
initparamSA
initparamSS
input
isa
le
listactions
listclasses
listcommands
listescape
listfiles
listglobals
listobjects
loadtab
log
logfile
max
maxerrors
maxfileversion
maxwarnings
min
mkdir
move
msgsubstitute
normalize_synapses
normalizeweights
notes
objsubstitute
openfile
pastechannel
pixflags
planarconnect
planardelay
planardelay2
planarweight
planarweight2
plane
pope
position
pow
printargs
printenv
pushe
putevent
pwe
quit
radialdelay
rallcalcRm
rand
randcomp
randcoord
randseed
randseed2
readcell
readfile
reclaim
region_connect
relposition
remarg
resched
reset
resetfastmsg
resetsynchanbuffers
restore
rotcoord
round
save
scaletabchan
scaleweight
setclock
setconn
setdefault
setenv
setfield
setfieldprot
setglobal
setmethod
setparamGA
setpostscript
setpriority
setprompt
setrand
setrandfield
setsearch
setspatialfield
setupNaCa
setupalpha
setupgate
setupghk
setuptau
sh
shapematch
shiftarg
showclocks
showcommand
showconn
showfield
showjobs
showmsg
showobject
showsched
showstat
silent
simdump
simobjdump
simundump
sin
spkcmp
sqrt
stack
step
stop
strcat
strcmp
strlen
strncmp
strsub
substituteinfo
substring
swapdump
syndelay
tab2file
tan
trunc
tset
tweakalpha
tweaktau
useclock
version
volume_connect
volumeconnect
volumedelay
volumedelay2
volumeweight
volumeweight2
warning
where
writecell
writefile
xcolorscale
xflushevents
xgetstat
xhide
xinit
xlower
xmap
xpixflags
xps
xraise
xshow
xshow_on_top
xshowontop
xsimplot
xtextload
xupdate
";


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

our $heccer_time_step = 2e-05;

our $model_container;

our $outputs = [];

our $runtime_parameters = [];

our $schedulers = {};

our $verbose_level;


sub header
{
    print "Welcome to the GENESIS 3 shell\n";
}


sub initialize
{
    my $result = 1;

    $GENESIS3::model_container = Neurospaces->new();

    if (!$GENESIS3::model_container)
    {
	die "$0: *** Error: cannot instantiate a model container\n";
    }

    my $args = [ "$0", "utilities/empty_model.ndf" ];

    my $success = $GENESIS3::model_container->read(undef, $args);

    if (!$success)
    {
	die "$0: *** Error: cannot initialize the model container\n";
    }

    return $result;
}


sub profile_environment
{
    foreach my $component_name (keys %$GENESIS3::all_components)
    {
	my $component = $GENESIS3::all_components->{$component_name};

	my $component_module = $component->{module} || $component_name;

	if (defined $component->{status}
	    and $component->{status} eq 'loaded')
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
	$GENESIS3::all_cpan_components->{python}->{status} = $@;
    }
    else
    {
	$GENESIS3::all_cpan_components->{python}->{status} = 'loaded';
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


