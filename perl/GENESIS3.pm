#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Commands;


sub add_input
{
    my $class_name = shift;

    my $component_name = shift;

    my $field = shift;

    my $options = { @_, };

    # find the input class

    if (!exists $GENESIS3::inputclasses->{$class_name})
    {
	return "*** Error: inputclass_template $class_name not found";
    }

    my $inputclass = $GENESIS3::inputclasses->{$class_name};

    # use it to create an actual input

    push
	@$GENESIS3::inputs,
	{
	 component_name => $component_name,
	 field => $field,
	 inputclass => $class_name,
	};

    return "*** Ok: add_input $component_name $field";
}


sub add_input_help
{
    print "description: connect an input with a model variable.
synopsis: add_input <class_name> <element_name> <field_name>
";

    return "*** Ok";
}


sub add_inputclass
{
    my $template_name = shift;

    my $class_name = shift;

    my $options = { @_, };

    # find the input class template

    if (!exists $GENESIS3::all_inputclass_templates->{$template_name})
    {
	return "*** Error: inputclass_template $template_name not found";
    }

    my $inputclass_template = $GENESIS3::all_inputclass_templates->{$template_name};

    # use it to create an actual input class and override the options

    $GENESIS3::inputclasses->{$class_name}
	= {
	   %$inputclass_template,
	   options => {
		       %{$inputclass_template->{options}},
		       %$options,
		      },
	  };

    return "*** Ok: add_inputclass $template_name";
}


sub add_inputclass_help
{
    print "description: define an input class for subsequent use in a simulation.
synopsis: add_inputclass <template_name> <class_name> <option> ...
";

    return "*** Ok";
}


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
    print "description: add a variable to the output file.
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

	if ($GENESIS3::verbose_level ne 'errors'
	    and $GENESIS3::verbose_level ne 'warnings')
	{
	    GENESIS3::Commands::pwe();
	}

	return "*** Ok: ce $path";
    }

    if ($path =~ /^\//)
    {
	$current_working_element = '';

	$path =~ s(^/)();
    }

    my $stack = [ split '/', $path, ];

    while (my $element = shift @$stack)
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
	    $current_working_element .= "/$element";

	    $current_working_element =~ s(//)(/)g;
	}
    }

    if ($current_working_element eq '')
    {
	$current_working_element = '/';
    }

    if (Neurospaces::exists_component($current_working_element))
    {
	$GENESIS3::current_working_element = $current_working_element;

	if ($GENESIS3::verbose_level ne 'errors'
	    and $GENESIS3::verbose_level ne 'warnings')
	{
	    GENESIS3::Commands::pwe();
	}

	return "*** Ok: ce $path";
    }
    else
    {
	if ($GENESIS3::verbose_level ne 'errors'
	    and $GENESIS3::verbose_level ne 'warnings')
	{
	    GENESIS3::Commands::pwe();
	}

	return "*** Error: element $path not found";
    }
}


sub ce_help
{
    print "description: change the current working element\n";

    print "synopsis: ce <element_name>\n";

    return "*** Ok";
}


sub check
{
    my $modelname = shift;

    if (!defined $modelname)
    {
	return '*** Error: <modelname> is required';
    }

    # define a scheduler for this model

    run($modelname, 0);

    # get scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    # analyze the schedule

    if (!$scheduler->analyze())
    {
	return "*** Error: scheduler analysis failed";
    }
    else
    {
	print "Simulation check ok\n";
	
	return "*** Ok";
    }
}


sub check_help
{
    print "description: check as much as we can\n";
    print "long_description: check the internal state of the software run-time environment, model consistency, solver consistency, I/O consistency and scheduler consistency\n";

    print "synopsis: check\n";

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

    print "description: create a model element\n";
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

    if ($GENESIS3::verbose_level ne 'errors'
	and $GENESIS3::verbose_level ne 'warnings')
    {
	print "delete: $name\n";
    }

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


sub delete_help
{
    print "description: delete parts of the model\n";

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
    print "description: echo to the terminal\n";

    print "synopsis: echo <arguments>\n";

    return "*** Ok";
}


sub explore
{
    require Neurospaces::GUI;

    Neurospaces::GUI::gui($0);

    return "*** Ok: explore";
}


sub explore_help
{
    print "description: graphically explore the models that have been loaded\n";

    print "synopsis: explore <arguments>\n";

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

    # for documentation

    elsif ($topic =~ m'^doc')
    {
	if (!defined $subtopic)
	{
	    print "description: general GENESIS3 documentation
synopsis: 'help documentation <document_name>'
";

	    return list("documentation");
	}
	else
	{
	    #t this should come from a query using neurospaces_build because
	    #t it is the only one that knows about the project layout.

	    my $userdocs_source = "$ENV{HOME}/neurospaces_project/userdocs/source/snapshots/0";

#     '/local_home/local_home/hugo/neurospaces_project/userdocs/source/snapshots/0/html/htdocs/neurospaces_project/userdocs/documentation-overview/documentation-overview.html'

	    my $filename = "$userdocs_source/html/htdocs/neurospaces_project/userdocs/$subtopic/$subtopic.html";

	    if (-e $filename)
	    {
	        my $os = $^O;
		
		my $command = "";

		if( $os eq "darwin")
		{
		  $command = "/Applications/Firefox.app/Contents/MacOS/firefox \"$filename\" &";
		}
		else
		{
		  $command = "firefox \"$filename\" &";
	        }

		my $error = `$command`;

		return "*** Ok: $command";
	    }
	    else
	    {
		my $error = "*** Error: document $subtopic not found\n";

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
    print "description: use the builtin help facility to explore self-documenting functions\n";

    print "synopsis: help <topic>\n";
    print "synopsis: <topic> must be one of commands, components, documentation, variables, libraries\n";

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

    print "description: list available items.\n";

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
    print "description: list model elements.\n";

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

    if ($solver_engine->deserialize_state($filename))
    {
	#t rewire the outputs

	return "*** Ok: model_state_load";
    }
    else
    {
	return "*** Error: model_state_load";
    }
}


sub model_state_load_help
{
    print "description: load the model state (solved variables) from a file.\n";

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

    if ($solver_engine->serialize_state($filename))
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
    print "description: save the model state (solved variables) to a file.\n";

    print "synopsis: model_state_save <element_name> <filename>\n";

    return "*** Ok";
}


sub npl_load
{
    my $filename = shift;

    print "Not implemented yet.  Please contribute by providing a use case.\n";

    return "*** Ok: npl_load $filename";
}


sub npl_load_help
{
    print "description: load a model encoded in Perl.\n";

    print "synopsis: npl_load\n";

    return "*** Ok";
}


sub npy_load
{
    my $filename = shift;

    GENESIS3::Python::npy_load($filename);

    return "*** Ok: npy_load $filename";
}


sub npy_load_help
{
    print "description: load a model encoded in Python.\n";

    print "synopsis: npy_load\n";

    return "*** Ok";
}


sub pwe
{
    print "$GENESIS3::current_working_element\n";

    return "*** Ok: pwd";
}


sub pwe_help
{
    print "description: print the current working element.\n";

    print "synopsis: pwe\n";

    return "*** Ok";
}


sub pynn_load
{
    my $filename = shift;

    print "Not implemented yet.  Please contribute by providing a use case.\n";

    return "*** Ok: pynn_load $filename";
}


sub pynn_load_help
{
    print "description: load a model encoded in PyNN.\n";

    print "synopsis: pynn_load\n";

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
    print "description: execute a model-container querymachine command.\n";

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
    print "description: quit the simulator.\n";

    print "synopsis: quit [ <exit_code> ]\n";

    return "*** Ok";
}


sub reset
{
    my $modelname = shift;

    if (!defined $modelname)
    {
	return '*** Error: <modelname> is required';
    }

    # define a scheduler for this model

    run($modelname, 0);

    # get scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    # reset the schedule

    if (!$scheduler->initiate())
    {
	return "*** Error: scheduler initiation failed";
    }
    else
    {
	return "*** Ok";
    }
}


sub reset_help
{
    print "description: reset an existing model.\n";

    print "synopsis: reset <modelname>\n";

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

	my $conceptual_parameters
	    = [
	       grep
	       {
		   $_->{component_name} =~ /::/
	       }
	       @$GENESIS3::runtime_parameters,
	      ];

	if (@$conceptual_parameters)
	{
	    print "warning: ignoring parameter settings that contain a namespace in their address\n";

	    print Dump( { conceptual_parameters => $conceptual_parameters, }, );
	}

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
		 grep
		 {
		     $_->{component_name} !~ /::/
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

	$schedule->{models}->[0]->{conceptual_parameters}
	    = [
	       grep
	       {
		   $_->{component_name} =~ /::/
	       }
	       @$GENESIS3::runtime_parameters,
	      ];

	$schedule->{models}->[0]->{granular_parameters}
	    = [
	       grep
	       {
		   $_->{component_name} !~ /::/
	       }
	       @$GENESIS3::runtime_parameters,
	      ];

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

	# fill in the intput classes and inputs

	$schedule->{inputclasses} = $GENESIS3::inputclasses;

	$schedule->{inputs} = $GENESIS3::inputs;

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
    print "description: run an existing model for a given amount of time.\n";

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
    print "description: set the verbosity level.\n";

    print "synopsis: set_verbose <level>\n";

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
    print "description: set a model parameter to a specific value.\n";

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
	if ($element =~ m(^/)
	    || $element =~ m(::))
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
    print "description: set a run-time parameter to a specific value.\n";

    print "synopsis: set_runtime_parameter <element_name> <parameter_name> <value> [ <value_type> ]\n";

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
    print "description: run a shell command.\n";

    print "synopsis: sh <command> [ <arguments> ... ]\n";

    return "*** Ok";
}


sub show_global_time
{
    print "---\nglobal_time: $GENESIS3::global_time\n";

    return "*** Ok: show_global_time";
}


sub show_global_time_help
{
    print "description: show the global simulation time.\n";

    print "synopsis: show_global_time\n";

    return "*** Ok";
}


sub show_inputs
{
    use YAML;

    print Dump(
	       $GENESIS3::inputs,
	      );

    return "*** Ok";
}


sub show_inputs_help
{
    print "description: show input applied to the model.\n";

    print "synopsis: show_inputs\n";

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
	       sort
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
    print "description: browse the online library of models\n";

    print "synopsis: show_library [ <library_type> ] [ <library_path> ]\n";

    return "*** Ok";
}


sub show_model_parameters
{
    my $element = shift;

    my $parameter = shift;

    if (defined $element
	and defined $parameter)
    {
	show_parameter($element, $parameter);
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


    my $query = "symbolparameters $element";

    if (querymachine($query))
    {
    }

    return "*** Ok: show_model_parameters $element $parameter";
}


sub show_model_parameters_help
{
    print "description: show the value of a series of model parameters.\n";

    print "synopsis: show_model_parameters [ <element_name> [ <parameter_name> ] ]\n";

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
    print "description: show the value of a model parameter.\n";

    print "synopsis: show_parameter <element_name> <parameter_name>\n";

    return "*** Ok";
}


sub show_parameter_scaled
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

    my $query = "printparameterscaled $element $parameter";

    if (querymachine($query))
    {
    }

    return "*** Ok: show_parameter_scaled $element $parameter";
}


sub show_parameter_scaled_help
{
    print "description: show the value of a model parameter.\n";

    print "synopsis: show_parameter_scaled <element_name> <parameter_name>\n";

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
    print "description: show the value of a run-time parameter.\n";

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
    print "description: show the verbosity level.\n";

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


sub sli_load
{
    my $filename = shift;

    SLI::include_model($filename, $GENESIS3::model_container);

    return "*** Ok: sli_load $filename";
}


sub sli_load_help
{
    print "description: load and extract models from a GENESIS 2 .g file.\n";

    print "synopsis: sli_load <filename.g>\n";

    return "*** Ok";
}


sub sli_run
{
    my $filename = shift;

    SLI::run_model($filename, $GENESIS3::model_container);

    return "*** Ok: sli_run $filename";
}


sub sli_run_help
{
    print "description: load and run a GENESIS 2 .g file.\n";

    print "synopsis: sli_run <filename>\n";

    return "*** Ok";
}


sub sli_script
{
    my $filename = shift;

    SLI::include_script($filename);

    return "*** Ok: sli_script $filename";
}


sub sli_script_help
{
    print "description: load and run a GENESIS 2 .g add-on.\n";

    print "synopsis: sli_script <filename>\n";

    return "*** Ok";
}


# sub ssp_load
# {
#     my $filename = shift;

#     my $scheduler = SSP->load($filename);

#     # extract the schedule name

#     my $schedulename = $scheduler->{name};

#     if (!$schedulename)
#     {
# 	return "*** Error: loading schedule failed: unable to determine a schedulename";
#     }

#     # register the scheduler

#     $GENESIS3::schedulers->{$modelname} = $scheduler;

#     return "*** Ok: ssp_load $filename";
# }


# sub ssp_load_help
# {
#     print "description: load an ssp file and reconstruct the model it describes.\n";

#     print "synopsis: ssp_load <filename.ssp>\n";

#     return "*** Ok";
# }


# sub ssp_save
# {
#     my $modelname = shift;

#     my $filename = shift;

#     run($modelname, 0);

#     # get scheduler for this model

#     my $scheduler = $GENESIS3::schedulers->{$modelname};

#     if (!$scheduler)
#     {
# 	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
#     }

#     # reset the schedule

#     if (!$scheduler->save())
#     {
# 	return "*** Error: saving schedule failed";
#     }
#     else
#     {
# 	print "Schedule saved ok\n";
	
# 	return "*** Ok";
#     }
#     return "*** Ok: ssp_save $filename";
# }


# sub ssp_save_help
# {
#     print "description: save a model to an ssp file.\n";

#     print "synopsis: ssp_save <element_name> <filename>\n";

#     return "*** Ok";
# }


sub swc_load
{
    print "Not implemented yet.  Please contribute by providing a use case.\n";

    return "*** Ok: pwd";
}


sub swc_load_help
{
    print "description: load a morphology from a SWC file.\n";

    print "synopsis: swc_load\n";

    return "*** Ok";
}


sub xml_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: xml_load $filename";
}


sub xml_load_help
{
    print "description: load an xml file and reconstruct the model it describes.\n";

    print "synopsis: xml_load <filename.xml>\n";

    return "*** Ok";
}


sub xml_save
{
    my $modelname = shift;

    my $filename = shift;

    $GENESIS3::model_container->write(undef, $modelname, 'xml', $filename, );

    return "*** Ok: xml_save $filename";
}


sub xml_save_help
{
    print "description: save a model to an xml file.\n";

    print "synopsis: xml_save <element_name> <filename>\n";

    return "*** Ok";
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


sub list_documentation
{
    use YAML;

    local $YAML::UseHeader = 0;

    #t this should come from a query using neurospaces_build because
    #t it is the only one that knows about the project layout.

    my $userdocs_source = "$ENV{HOME}/neurospaces_project/userdocs/source/snapshots/0";

    #t the userdocs-gui tag name should be configurable, using a
    #t variable accessible over 'help var'.

    my $gui_docs = "gui documentation:\n" . `userdocs-tag-filter gshell-interactive`;

    $gui_docs =~ s(---\n)();
    $gui_docs =~ s($userdocs_source/?)()g;
    $gui_docs =~ s((^|\n)-)($1  -)g;

    print $gui_docs;

    return "*** Ok: list_documentation";
}


sub list_functions
{
    print "all function tokens:\n";

    print foreach map { "  - $_\n" } "NERNST", "MGBLOCK", "RANDOMIZE", "FIXED", "SERIAL";

    return "*** Ok: list_functions";
}


sub list_inputclasses
{
    use YAML;

    local $YAML::UseHeader = 0;

    print Dump(
	       {
		"all input classes" => $GENESIS3::inputclasses,
	       },
	      );

    return "*** Ok: list_inputclass_templates";
}


sub list_inputclass_templates
{
    use YAML;

    local $YAML::UseHeader = 0;

    print Dump(
	       {
		"all input class templates" => $GENESIS3::all_inputclass_templates,
	       },
	      );

    return "*** Ok: list_inputclass_templates";
}


sub list_verbose
{
    use YAML;

    local $YAML::UseHeader = 0;

    print Dump( { 'verbosity levels' => $GENESIS3::all_verbose, } );

    return "*** Ok: list_verbose";
}


package GENESIS3::Configuration;


our $configuration
    = {
       symbols => {
		   directory => "/usr/local/neurospaces/instrumentor/hierarchy/",
		   filename => "symbols",
		  },
      };

my $filename = "$GENESIS3::Configuration::configuration->{symbols}->{directory}$GENESIS3::Configuration::configuration->{symbols}->{filename}";

our $symbols_definitions = do $filename;


#t subs from the model-container instrumentor, should be put in a
#t separate package and installed by the model-container or so.


sub assign_grammar_symbols
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};

    # initialize set of grammar symbols

    my $grammar_symbols = $definitions->{grammar_symbols} || {};

    # loop over all types

    foreach my $type (sort keys %$class_hierarchy)
    {
	my $class = $class_hierarchy->{$type};

	if (!defined $class->{grammar})
	{
	    next;
	}

	# create grammar symbol for this type

	my $name = identifier_perl_to_xml($type);

# 	print "Creating grammar_symbol for $name\n";

	$grammar_symbols->{$name} = $class->{grammar};

    }

    $definitions->{grammar_symbols} = $grammar_symbols;
}


sub assign_token_names
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    # loop over all grammar symbols

    my $grammar_symbols = $definitions->{grammar_symbols};

    foreach my $symbol_name (sort keys %$grammar_symbols)
    {
	my $grammar_symbol = $grammar_symbols->{$symbol_name};

	if (!defined $grammar_symbol->{specific_token})
	{
	    next;
	}

	# get the token information assigned to this symbol

# 	print "Creating lexical token for $symbol_name\n";

	my $specific_token = $grammar_symbol->{specific_token};

	# compute a token_name

	my $token_name = $specific_token->{lexical};

	$token_name =~ s/^TOKEN_//i;

	$token_name = lc($token_name);

	if (exists $tokens->{$token_name})
	{
	    die "$0: in hierarchy $definitions->{name}: trying to assign_token_names for $token_name but it already exists";
	}

	# add the token information to the token specs

	$tokens->{$token_name} = $specific_token;
    }

    # loop over all tokens

    foreach my $token_name (sort keys %$tokens)
    {
	my $token = $tokens->{$token_name};

	# assign token name to the class

	if ($token->{class})
	{
	    my $class = $token->{class};

	    $class_hierarchy->{$class}->{token_name} = $token->{lexical};
	}
    }
}


sub assign_type_numbers
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    # loop over all types

    my $count = 1;

    foreach my $type (sort keys %$class_hierarchy)
    {
	# assign type number

	my $class = $class_hierarchy->{$type};

	$class->{number} = $count;

	# increment type count

	$count++;
    }
}


sub build_indices
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    my $grammar_rules = $definitions->{grammar_rules};
    my $grammar_symbols = $definitions->{grammar_symbols};

    build_dimension_indices($definitions);

    build_forward_derivation_lists($definitions);

    build_isa_indices($definitions);

    build_object_methods_reversed($definitions);
}


sub build_dimension_indices
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    # loop over all types

    foreach my $type (sort keys %$class_hierarchy)
    {
	# loop over all dimensions for this type

	my $type_dimensions = $class_hierarchy->{$type}->{dimensions};

	foreach my $type_dimension (@$type_dimensions)
	{
	    # register this type for this dimension

	    $definitions->{dimensions}->{$type_dimension}->{$type} = 1;
	}
    }
}


sub build_forward_derivation_lists
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    # loop over all types

    foreach my $type (sort keys %$class_hierarchy)
    {
	# loop over all types

	my $forward_derivation_list = {};

	foreach my $subtype (sort keys %$class_hierarchy)
	{
	    # if this type is derived from the original

	    if (defined $class_hierarchy->{$subtype}->{isa}
		&& $class_hierarchy->{$subtype}->{isa} eq $type)
	    {
		# register the reverse (forward) relationship

		$forward_derivation_list->{$subtype}->{$type} = $subtype;
	    }
	}

	$class_hierarchy->{$type}->{forward_derivation_list} = $forward_derivation_list;
    }
}


sub build_isa_indices
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    # loop over all types

    foreach my $type (sort keys %$class_hierarchy)
    {
	my $count = 1;

	my $isas = { $type => $count++, };

	my $isa = $class_hierarchy->{$type}->{isa};

	while (defined $isa)
	{
	    if (exists $isas->{$isa})
	    {
		die "$0: in hierarchy $definitions->{name}: found a circular isa relationship for $type";
	    }

	    $isas->{$isa} = $count++;

	    # go to next class

	    if (!exists $class_hierarchy->{$isa})
	    {
		die "$0: in hierarchy $definitions->{name}: found a isa relationship for class $isa, but this class is not defined";
	    }

	    $isa = $class_hierarchy->{$isa}->{isa};
	}

	$class_hierarchy->{$type}->{isas} = $isas;
    }
}


sub build_object_methods_reversed
{
    my $definitions = shift;

    my $class_hierarchy = $definitions->{class_hierarchy};
    my $object_methods = $definitions->{object_methods};
    my $object_methods_return_types = $definitions->{object_methods_return_types};
    my $object_methods_signatures = $definitions->{object_methods_signatures};
    my $tokens = $definitions->{tokens};

    my $object_methods_reversed = { reverse %$object_methods, };

    $definitions->{object_methods_reversed} = $object_methods_reversed;
}


sub identifier_xml_to_perl
{
    my $identifier = shift;

    my $result = $identifier;

    $result =~ s/([A-Z]{2,})([A-Z])/_\L$1\E$2/g;

    $result =~ s/([A-Z])(?![A-Z])/_\l$1/g;

    return $result;
}


sub identifier_perl_to_xml
{
    my $identifier = shift;

    my $result = $identifier;

    $result =~ s/^([a-z])/\u$1/;

    $result =~ s/_([a-z0-9])/\u$1/g;

    return $result;
}


{
    my $definitions = $symbols_definitions;

    # assign type numbers

    assign_type_numbers($definitions);

    # construct grammar non-terminal symbols

    assign_grammar_symbols($definitions);

    # assign terminal token names if any

    assign_token_names($definitions);

    # build indices to speedup processing

    build_indices($definitions);
}


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
	      my $symbols_definitions = $GENESIS3::Configuration::symbols_definitions;

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


sub create_all_tokens
{
    eval "require Neurospaces::Tokens::Physical";

    if ($@ eq '')
    {
    }
    else
    {
	print STDERR "$0: warning: could not load Neurospaces::Tokens::Physical\n";
    }

    my $symbols_definitions = $GENESIS3::Configuration::symbols_definitions;

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
	       #! map the token to its lexical NDF ascii representation

	       my $token = $tokens->{$_};

	       $token->{lexical};
	   }
	   grep
	   {
	       #! note that not all tokens have a purpose that is defined
	       #! (which does not necessarily mean they don't have a
	       #! purpose).

	       defined $tokens->{$_}->{purpose}
		   and $tokens->{$_}->{purpose} eq 'physical';
	   }
	   keys %$tokens,
	  ];

    foreach my $token_name (@$token_names)
    {
	# construct a create function for this token

	no strict "refs";

	my $lc_token_name = lc($token_name);

	my $subname = "create_" . $lc_token_name;

	((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{$subname})
	    = sub
	      {
		  # get name of element to create

		  my $physical_name = shift;

		  # create the element in the model container

		  if ($GENESIS3::verbose_level ne 'errors'
		      and $GENESIS3::verbose_level ne 'warnings')
		  {
		      print "$subname: $physical_name\n";
		  }

		  my $physical = Neurospaces::Tokens::Physical::create($lc_token_name, $GENESIS3::model_container, $physical_name);

		  if (!$physical)
		  {
		      return "*** Error: creating $physical_name of type $lc_token_name";
		  }
		  else
		  {
		      return "*** Ok: creating $physical_name of type $lc_token_name";
		  }
	      };
    }
}


create_all_tokens();


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
		  disabled => 0,
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
			     integrator => 'Neurospaces::Integrators::Commands',
			     module => 'Neurospaces',
			    },
       sli => {
	       description => "GENESIS 2 backward compatible scripting interface",
	       module => "SLI",
	      },
       studio => {
		  description => "Graphical interface that allows to explore models",
		  module => "Neurospaces::Studio",
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
		  module => 'GENESIS3::Python',
		 },
      };


our $all_inputclass_templates
    = {
       perfectclamp => {
			module_name => 'Heccer',
			options => {
				    name => 'name of this inputclass',
				    command => 'command voltage',
				   },
			package => 'Heccer::PerfectClamp',
		       },
      };

our $all_verbose
    = {
       debug => {
		 description => 'used for software development and maintenance',
		},
       errors => {
		  description => 'display only error state information (an error state makes it impossible for an application to complete)',
		 },
       information => {
		       description => 'display information, warning and error messages (lists messages about important events generated by an application)',
		      },
       warnings => {
		    comment => 'this is the default',
		    description => 'display warning and error state information (a warning state allows an application to continue but you should thoroughly check any output)',
		   },
      };


our $current_working_element = '/';

our $global_time = 0;

our $heccer_time_step = 2e-05;

our $model_container;

our $inputclasses = {};

our $inputs = [];

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

    # if the python module was loaded successfully

    #t this test seems not to work under all circumstances, needs to
    #t be figured out some time.

    no strict "refs";

    if ($GENESIS3::Python::loaded)
    {
	# let the python module know about the model container

	#t not sure about error processing here

	GENESIS3::Python::initialize($GENESIS3::model_container);
    }

    # return result, seems to be always 1

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

	if ($component->{disabled})
	{
	    next;
	}

	eval
	{
	    local $SIG{__DIE__};

	    $component_module =~ s/::/\//g;

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

	if ($component->{integrator})
	{
	    eval "require $component->{integrator}";

	    if ($@)
	    {
		die "$0: *** Error: $component_name loaded, but its integrator cannot be loaded\n";
	    }

	    #! nicely based on Exporter

	    no strict "refs";

	    my $commands = eval "\$$component->{integrator}::g3_commands";

	    foreach my $command (@$commands)
	    {
		*{"GENESIS3::Commands::$command"} = \&{"$component->{integrator}\::$command"};
	    }
	}
    }

    eval "require GENESIS3::Python";

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
    my $version="gshell-python-7";

    return $version;
}


profile_environment()
    and initialize();


