#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


BEGIN
{
    if (!$ENV{NEUROSPACES_NMC_USER_MODELS}
	and !$ENV{NEUROSPACES_NMC_PROJECT_MODELS}
	and !$ENV{NEUROSPACES_NMC_SYSTEM_MODELS}
	and !$ENV{NEUROSPACES_NMC_MODELS})
    {
	$ENV{NEUROSPACES_NMC_MODELS} = '/usr/local/neurospaces/models/library';
    }
}


package GENESIS3::Commands;


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

    my $error = $scheduler->analyze();

    if ($error)
    {
	return "*** Error: scheduler analysis failed ($error)";
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


sub chemesis3_set_timestep
{
    my $timestep = shift;

    if ($timestep =~ /-?[0-9\.e]+/)
    {
	$GENESIS3::chemesis3_time_step = $timestep;

	$GENESIS3::global_solver = 'chemesis3';

	return "*** Ok: chemesis3_set_timestep";
    }
    else
    {
	return "*** Error: timestep must be numeric";
    }
}


sub chemesis3_set_timestep_help
{
    print "description: set the time step for use by the chemesis3 reaction-diffusion solver\n";

    print "synopsis: chemesis3_set_timestep_help <arguments>\n";

    return "*** Ok";
}


sub component_load
{
    my $component_name = shift;

    return GENESIS3::component_load($component_name);
}


sub component_load_help
{
    print "description: load a software component\n";

    print "synopsis: component_load <component-name>\n";

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

	return "*** Error: incorrect usage (create_$type does not exist)";
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


# sub delete_input
# {
#     my $class_name = shift;

#     my $component_name = shift;

#     my $field = shift;

#     my $options = { @_, };

#     # find the input class

#     if (!exists $GENESIS3::inputclasses->{$class_name})
#     {
# 	return "*** Error: inputclass_template $class_name not found";
#     }

#     my $inputclass = $GENESIS3::inputclasses->{$class_name};

#     # use it to create an actual input

#     push
# 	@$GENESIS3::inputs,
# 	{
# 	 component_name => $component_name,
# 	 field => $field,
# 	 inputclass => $class_name,
# 	};

#     return "*** Ok: delete_input $component_name $field";
# }


# sub delete_input_help
# {
#     print "description: connect an input with a model variable.
# synopsis: delete_input <class_name> <element_name> <field_name>
# ";

#     return "*** Ok";
# }


sub echo
{
    my $output = (join " ", @_);

    # note: without a newline, so the output may get buffered
    # add the newline to the arguments if you need it.

    print "$output";

    return "*** Ok: echo";
}


sub echo_help
{
    print "description: echo to the terminal\n";

    print "synopsis: echo <arguments>\n";

    return "*** Ok";
}


sub element_type
{
    my $element = shift;

    my $original = shift;

    if (!defined $element
        || $element eq '.')
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

    my $type = $GENESIS3::model_container->component_type($element);

    if ($type =~ /not found/)
    {
	return "*** Error: element_type $original";
    }
    else
    {
	print "$element: $type\n";

	return "*** Ok: element_type $original";
    }
}


sub element_type_help
{
    print "description: determine the type of a created model component\n";

    print "synopsis: element_type <modelname>\n";

    return "*** Ok: element_type_help";
}


sub exit
{
    my $exit_code = shift;

    if (!defined $exit_code)
    {
	$exit_code = 0;
    }

    exit $exit_code;
}


sub exit_help
{
    print "description: exit the simulator.\n";

    print "synopsis: exit [ <exit_code> ]\n";

    return "*** Ok: exit_help";
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


sub heccer_set_config
{
    my $config_name = shift;

    my $heccer_configs
	= {
	   disassem_simple => {
			       configuration => {
						 reporting => {
							       granularity => 100,
							       tested_things => (
										 $SwiggableHeccer::HECCER_DUMP_VM_COMPARTMENT_MATRIX
										 | $SwiggableHeccer::HECCER_DUMP_VM_COMPARTMENT_MATRIX_DIAGONALS
										 | $SwiggableHeccer::HECCER_DUMP_VM_COMPARTMENT_OPERATIONS
										 | $SwiggableHeccer::HECCER_DUMP_VM_MECHANISM_DATA
										 | $SwiggableHeccer::HECCER_DUMP_VM_MECHANISM_OPERATIONS
										 | $SwiggableHeccer::HECCER_DUMP_VM_SUMMARY
										),
							      },
						},
			      },
	   };

    if (! exists $heccer_configs->{$config_name})
    {
	print STDERR "*** Error: $config_name is not a heccer configuration";

	return "*** Error: $config_name is not a heccer configuration";
    }

    $GENESIS3::registered_solverclasses->{heccer}->{constructor_settings}->{configuration}
	= $heccer_configs->{$config_name}->{configuration};

    return "*** Ok: heccer_set_config $config_name";
}


sub heccer_set_config_help
{
    print "description: set the configuration for use by the heccer compartmental solver\n";

    print "synopsis: heccer_set_config <config_name>\n";

    return "*** Ok: heccer_set_config_help";
}


sub heccer_set_timestep
{
    my $timestep = shift;

    if ($timestep =~ /-?[0-9\.e]+/)
    {
	$GENESIS3::heccer_time_step = $timestep;

	$GENESIS3::global_solver = 'heccer';

	return "*** Ok: heccer_set_timestep";
    }
    else
    {
	return "*** Error: timestep must be numeric";
    }
}


sub heccer_set_timestep_help
{
    print "description: set the time step for use by the heccer compartmental solver\n";

    print "synopsis: heccer_set_timestep_help <arguments>\n";

    return "*** Ok: heccer_set_timestep_help";
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
	    my $component_module = exists $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$subtopic} ? $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$subtopic}->{module} : '';

	    {
		use YAML;

		local $YAML::UseHeader = 0;

		if (exists $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$subtopic})
		{
		    print Dump(
			       {
				"$subtopic" => $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$subtopic},
			       },
			      );
		}

		if (exists $GENESIS3::Configuration::configuration->{software_components}->{other_components}->{$subtopic})
		{
		    print Dump(
			       {
				"$subtopic" => $GENESIS3::Configuration::configuration->{software_components}->{other_components}->{$subtopic},
			       },
			      );
		}
	    }

	    no strict "refs";

	    my $sub_name = "${component_module}::help";

	    if ($component_module
		and exists &$sub_name)
	    {
		no strict "refs";

# 		my $sub = (\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{"${subtopic}_help"};

		print "  inline_help:\n";

		return &$sub_name($topic, $subtopic, $subsubtopic, );
	    }
	    else
	    {
		print "  inline_help: no further help found\n";

		return undef;
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

		if ($os eq "darwin")
		{
		    $command = "/Applications/Firefox.app/Contents/MacOS/firefox \"$filename\" &";
		}
		else
		{
		    $command = "firefox -new-window \"$filename\" &";
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


sub input_add
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

    return "*** Ok: input_add $component_name $field";
}


sub input_add_help
{
    print "description: connect an input with a model variable.
synopsis: input_add <class_name> <element_name> <field_name>
";

    return "*** Ok";
}


sub input_delete
{
    my $input_name = shift;

#     delete $GENESIS3::inputs->{$input_name};

    return "*** Error: input_delete $input_name";
}


sub input_delete_help
{
    print "description: delete an input.
synopsis: input_delete [ <input_name> [ <option> ... ] ]
";

    return "*** Ok";
}


sub input_show
{
    my $component_name = shift;

    use YAML;

    print Dump(
	       [
		grep
		{
		    my $result = 1;

		    if (defined $component_name)
		    {
			$result = $_->{component_name} =~ /$component_name/;
		    }

		    $result;
		}
		@{ $GENESIS3::inputs, },
	       ],
	      );

    return "*** Ok: input_show";
}


sub input_show_help
{
    print "description: show input applied to the model.\n";

    print "synopsis: input_show\n";

    return "*** Ok";
}


sub inputbinding_add
{
    my $element = shift;

    my $binding = shift;

    my $type = shift;

    if (!defined $element
        || $element eq '.')
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

    my $error = Neurospaces::Bindings::input_add($element, $binding, $type);

    if ($error)
    {
	return "*** Error: $error";
    }
    else
    {
	return "*** Ok: inputbinding_add $element, $binding, $type";
    }
}


sub inputbinding_add_help
{
    print "description: add a binding to the given element (. for the current working element)\n";

    print "synopsis: binding_add <element_name> <field_name> [ <binding_type> ]\n";

    return "*** Ok";
}


sub inputclass_add
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

    return "*** Ok: inputclass_add $template_name";
}


sub inputclass_add_help
{
    print "description: define an input class for subsequent use in a simulation.
synopsis: inputclass_add <template_name> <class_name> <option> ...
";

    return "*** Ok";
}


sub inputclass_delete
{
    my $inputclass_name = shift;

    delete $GENESIS3::inputclasses->{$inputclass_name};

    return "*** Ok: inputclass_delete $inputclass_name";
}


sub inputclass_delete_help
{
    print "description: delete an inputclass.
synopsis: inputclass_delete [ <class_name> [ <option> ... ] ]
";

    return "*** Ok";
}


sub inputclass_show
{
    my $inputclass_name = shift;

    if ( GENESIS3::Help::list_inputclasses($inputclass_name, @_) =~ /error/i )
    {
	return "*** Error: inputclass_show $inputclass_name";
    }
    else
    {
	return "*** Ok: inputclass_show $inputclass_name";
    }
}


sub inputclass_show_help
{
    print "description: show the available inputclasses.
synopsis: inputclass_show [ <class_name> [ <option> ... ] ]
";

    return "*** Ok";
}


# sub inputclass_template_delete
# {
#     my $inputclass_template_name = shift;

#     delete $GENESIS3::all_inputclass_templates->{$inputclass_template_name};

#     return "*** Ok: inputclass_template_delete $inputclass_template_name";
# }


# sub inputclass_template_delete_help
# {
#     print "description: delete an inputclass templates.
# synopsis: inputclass_template_delete [ <template_name> [ <option> ... ] ]
# ";

#     return "*** Ok";
# }


sub inputclass_template_show
{
    my $inputclass_template_name = shift;

    if ( GENESIS3::Help::list_inputclass_templates($inputclass_template_name, @_) =~ /error/i )
    {
	return "*** Error: inputclass_template_show $inputclass_template_name";
    }
    else
    {
	return "*** Ok: inputclass_template_show $inputclass_template_name";
    }
}


sub inputclass_template_show_help
{
    print "description: show the available inputclass templates.
synopsis: inputclass_template_show [ <template_name> [ <option> ... ] ]
";

    return "*** Ok";
}


sub library_show
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
    elsif ($type =~ /^sli$/i
	   || $type =~ /^g2$/i)
    {
	my $result
	    = [
	       sort
	       map
	       {
		   chomp ; $_
	       }
	       `ls -1F "/usr/local/ns-sli/tests/scripts/$path"`,
	      ];

	use YAML;

	print Dump( { g2_library => { $path => $result, }, }, );
    }

    return "*** Ok: library_show $type $path";
}


sub library_show_help
{
    print "description: browse the online library of models\n";

    print "synopsis: library_show [ <library_type> ] [ <library_path> ]\n";

    print "synopsis: <library_type> is one of 'ndf', 'sli', 'g2'\n";

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

	return "*** Error: incorrect usage (list_$type does not exist)";
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

    if (!defined $element
        || $element eq '.')
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

    my $query = "expand $element";

    if ($element !~ /\*/)
    {
	$query .= "/*";
    }

    querymachine($query);

    return "*** Ok: list_elements $element";
}


sub list_elements_help
{
    print "description: list model elements.\n";

    print "synopsis: list_elements [ <element_name> ]\n";

    return "*** Ok";
}


sub list_namespaces
{
#     my $namespaces = $GENESIS3::model_container->list_namespaces($GENESIS3::current_working_namespace);

#     use YAML;

#     print Dump( { $GENESIS3::current_working_namespace => $namespaces, }, );

    my $namespace = shift;

    if (!defined $namespace)
    {
	$namespace = $GENESIS3::current_working_namespace;
    }
    else
    {
# 	if ($namespace =~ m(^/))
# 	{
# 	}
# 	else
# 	{
# 	    $namespace = "$GENESIS3::current_working_namespace::$namespace";
# 	}
    }

    my $query = "namespaces $namespace";

    if ($namespace !~ /\*/)
    {
	$query .= "/*";
    }

    querymachine($query);

    return "*** Ok: list_namespaces $namespace";
}


sub list_namespaces_help
{
    print "description: list model namespaces.\n";

    print "synopsis: list_namespaces [ <namespace_name> ]\n";

    return "*** Ok: list_namespaces_help";
}


sub manager_gui
{
    require Neurospaces::Developer;

    my $packages_tags = Neurospaces::Developer::package_tags();

    Neurospaces::Developer::Manager::GUI::create($packages_tags);

    return "*** Ok: manager_gui";
}


sub manager_gui_help
{
    print "description: show the manager_gui window (currently blocks further command execution).\n";

    print "synopsis: manager_gui\n";

    return "*** Ok: manager_gui_help";
}


sub model_parameter_add
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

	    my $result = model_parameter_add($element, $parameter_name, $parameter_value);

	    if ($result =~ /error/i)
	    {
		return "*** Error: model_parameter_add $element $parameter_name $parameter_value";
	    }
	}

	return "*** Ok: model_parameter_add $element $parameter $value_type $value";
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
	    elsif ($value =~ /^(\+|-)?([0-9]+)(\.[0-9]+)?(e(\+|-)?([0-9]+))?$/i)
	    {
		$value_type = 'number';
	    }
	    else
	    {
		$value_type = 'string';
	    }
	}

	if (!defined $element
	    || $element eq '.')
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

	my $query = "setparameterconcept $element $parameter $value_type $value";

	if (querymachine($query))
	{
	}

	return "*** Ok: model_parameter_add $element $parameter $value_type $value";
    }
}


sub model_parameter_add_help
{
    print "description: set a model parameter to a specific value.\n";

    print "synopsis: model_parameter_add <element_name> <parameter_name> <value> [ <value_type> ]\n";

    return "*** Ok: model_parameter_add_help";
}


sub model_parameter_show
{
    my $element = shift;

    my $parameter = shift;

    my $all = shift;

    if (!defined $element
        || $element eq '.')
    {
	$element = $GENESIS3::current_working_element;

	$parameter = '*';
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

    if ($parameter eq '*')
    {
	$all = 'true';
    }

    if (defined $element
	and defined $parameter)
    {
	parameter_show($element, $parameter);
    }

    if ($all)
    {
	my $query = "symbolparameters $element";

	if (querymachine($query))
	{
	}
    }

    return "*** Ok: model_parameter_show $element $parameter";
}


sub model_parameter_show_help
{
    print "description: show the value of a series of model parameters.\n";

    print "synopsis: model_parameter_show [ <element_name> [ <parameter_name> ] ]\n";

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


sub output_add
{
    my $component_name = shift;

    if (!defined $component_name
        || $component_name eq '.')
    {
	$component_name = $GENESIS3::current_working_element;
    }
    else
    {
	if ($component_name =~ m(^/)
	    || $component_name =~ m(::))
	{
	}
	else
	{
	    $component_name = "$GENESIS3::current_working_element/$component_name";
	}
    }

    my $field = shift;

    if (!defined $field)
    {
	return "*** Error: <field> is required";
    }

    push
	@$GENESIS3::outputs,
	{
	 component_name => $component_name,
	 field => $field,
	 outputclass => "double_2_ascii",
	};

    return "*** Ok: output_add $component_name $field";
}


sub output_add_help
{
    print "description: add a variable to the output file.
synopsis: output_add <element_name> <field_name>
";

    return "*** Ok";
}


sub output_emit_time
{
    my $output_emit_time = shift;

    $GENESIS3::output_emit_time = $output_emit_time;

    return "*** Ok: output_emit_time $output_emit_time";
}


sub output_emit_time_help
{
    print "description: specify whether to emit time in the output files, 1 for yes.
synopsis: output_emit_time <output_emit_time>
";

    return "*** Ok: output_emit_time_help";
}


sub output_filename
{
    my $filename = shift;

    $GENESIS3::output_filename = $filename;

    return "*** Ok: output_filename $filename";
}


sub output_filename_help
{
    print "description: set the output filename
synopsis: output_filename <filename>
";

    return "*** Ok";
}


sub output_format
{
    my $output_format = shift;

    $GENESIS3::output_format = " $output_format";

    return "*** Ok: output_format $output_format";
}


sub output_format_help
{
    print "description: set the output format to a printf type of format eg \" %.5f\"
synopsis: output_format <output_format>
";

    return "*** Ok";
}


sub output_mode
{
    my $output_mode = shift;

    $GENESIS3::output_mode = $output_mode;

    return "*** Ok: output_mode $output_mode";
}


sub output_mode_help
{
    print "description: set the output mode to one of \"steps\" or the empty string \"\"
synopsis: output_mode <output_mode>
";

    return "*** Ok: output_mode_help";
}


sub output_resolution
{
    my $output_resolution = shift;

    $GENESIS3::output_resolution = $output_resolution;

    return "*** Ok: output_resolution $output_resolution";
}


sub output_resolution_help
{
    print "description: reduce the output resolution with the specified (integer) amount
synopsis: output_resolution <output_resolution>
";

    return "*** Ok: output_resolution_help";
}


sub output_show
{
#     my $component_name = shift;

#     my $field = shift;

    print Dump( { outputs => $GENESIS3::outputs, }, );

    return "*** Ok: output_show";

#     return "*** Ok: output_show $component_name $field";
}


sub output_show_help
{
#     print "description: show what variables are in the output file.
# synopsis: output_show <element_name>
# ";

    print "description: show what variables are in the output file.
synopsis: output_show
";

    return "*** Ok: output_show_help";
}


sub output_time_step
{
    my $output_time_step = shift;

    $GENESIS3::output_time_step = $output_time_step;

    return "*** Ok: output_time_step $output_time_step";
}


sub output_time_step_help
{
    print "description: specify the time step for emitting output to the output files.
synopsis: output_time_step <output_time_step>
";

    return "*** Ok: output_time_step_help";
}


# sub plot_data
# {
#     fplot.py Vm.out
#     plotVm.py Vm.out pyr4*.out
#         rasterplot.py spike_times.txt
#         G3Plot.py pyr4*.out Vm.out
#         rowrateplot.py spike_freq_HD2500-11p.txt

# }


# sub plot_data_help
# {
#     print "description: plot a signal trace of a file.
# synopsis: plot_data <filename>
# ";

#     return "*** Ok";
# }


sub parameter_show
{
    my $element = shift;

    my $parameter = shift;

    if (!defined $element
        || $element eq '.')
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

    my $query = "printparameter $element $parameter";

    if (querymachine($query))
    {
    }

    return "*** Ok: parameter_show $element $parameter";
}


sub parameter_show_help
{
    print "description: show the value of a model parameter.\n";

    print "synopsis: parameter_show <element_name> <parameter_name>\n";

    return "*** Ok";
}


sub parameter_scaled_show
{
    my $element = shift;

    my $parameter = shift;

    if (!defined $element
        || $element eq '.')
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

    my $query = "printparameterscaled $element $parameter";

    if (querymachine($query))
    {
    }

    return "*** Ok: parameter_scaled_show $element $parameter";
}


sub parameter_scaled_show_help
{
    print "description: show the value of a model parameter.\n";

    print "synopsis: show_parameter_scaled <element_name> <parameter_name>\n";

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


sub py_diagnose
{
    my $path = shift;

    GENESIS3::Python::nmcDiagnose($path);

    return "*** Ok: py_diagnose $path";
}


sub py_diagnose_help
{
    print "description: diagnosis on the python interface.\n";

    print "synopsis: py_diagnose\n";

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

    CORE::exit $exit_code;
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

    my $error = $scheduler->initiate();

    if ($error)
    {
	return "*** Error: scheduler initiation failed ($error)";
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

    return "*** Ok: reset";
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

	my $runtime_parameters
	    = [
	       grep
	       {
		   $_->{component_name} =~ /::/
	       }
	       @$GENESIS3::runtime_parameters,
	      ];

	if (@$runtime_parameters)
	{
	    print STDERR "*** Warning: ignoring parameter settings that contain a namespace in their address\n";

	    print Dump( { runtime_parameters => $runtime_parameters, }, );
	}

	# construct a hash that maps component_names of
	# runtime_parameters to modelnames that are mapped to solvers.

	my $component_names_2_solved_models
	    = {
	       map
	       {
		   # access the runtime_parameter

		   my $runtime_parameter = $_;

		   # construct a list of solved models that match with this runtime_parameter

		   my $models = $scheduler->{models} || [];

		   my $matching_models
		       = [
			  grep
			  {
			      my $model = $_;

			      $runtime_parameter->{component_name} =~ $model->{modelname};
			  }
			  @$models,
			 ];

		   if (scalar @$matching_models ne 1)
		   {
		       print STDERR "$0: *** Warning: runtime_parameter found that applies to more than one solver: $runtime_parameter->{component_name}\n";
		   }

		   # use the first model in this list

		   my $solved_model = $matching_models->[0];

		   # construct a mapping from the runtime_parameter component_name to the solved model name.

		   {
		       $runtime_parameter->{component_name} => $solved_model->{modelname},
		   };
	       }
	       @$GENESIS3::runtime_parameters,
	      };

	my $result
	    = $scheduler->apply_runtime_parameters
		(
		 $scheduler,
		 map
		 {
		     # convert the name of the schedule to the target model

		     #t breaks current_injection.t

		     my $target_model = $component_names_2_solved_models->{$modelname};

		     $target_model = $modelname;

		     # construct a valid runtime_parameter for the target model in this schedule

		     {
			 modelname => $target_model,
			 %$_,
		     };
		 }
		 grep
		 {
		     # only those runtime_parameters that apply to this schedule

		     $_->{component_name} =~ /^$modelname/
		 }
		 grep
		 {
		     # ignore namespaced parameters

		     $_->{component_name} !~ /::/
		 }
		 @$GENESIS3::runtime_parameters,
		);

	if ($result)
	{
	    return "*** Error: apply_runtime_parameters() for $scheduler->{name} failed ($result)";
	}

	# if the scheduler was constructed using the run call, it has already been compiled.
	# if the scheduler was constructed using the solverset command, it is not compiled yet.

	my $schedulees = $scheduler->{schedule} || [];

	if (!@$schedulees)
	{
	    # I assume that the default application_classes will compile, connect and optimize, but not run.

	    $scheduler->run();
	}

	# use the scheduler

	$result = $scheduler->advance($scheduler, $time, ); # { verbose => 2 } );

	if ($result)
	{
	    return "*** Error: advance() for $scheduler->{name} failed ($result)";
	}

	$result = $scheduler->pause();

	# get the simulation time from the schedule

	$GENESIS3::global_time = $scheduler->{simulation_time}->{time};

	if ($result)
	{
	    return "*** Error: pause() for $scheduler->{name} failed ($result)";
	}

	# return success

	return "*** Ok: done running $scheduler->{name}";
    }

    # else

    else
    {
	# construct a simulation schedule

	my $schedule
	    = {
	       name => "GENESIS-3 SSP schedule initialized for $modelname, $time",
	      };

	# tell ssp that the model-container service has been initialized

	$schedule->{services}->{model_container}->{backend} = $GENESIS3::model_container;

	# fill in runtime_parameters

	$schedule->{models}->[0]->{runtime_parameters}
	    = [
	       @$GENESIS3::runtime_parameters,
	      ];

	# fill in model name

	$schedule->{models}->[0]->{modelname} = $modelname;

	# fill in the solverclasses

	$schedule->{models}->[0]->{solverclass} = $GENESIS3::global_solver;

	#t make this configurable

	my $solverclasses
	    = {
	       $GENESIS3::global_solver eq 'chemesis3'
	       ? (
		  chemesis3 => {
				constructor_settings => {
							 dStep => $GENESIS3::chemesis3_time_step,
							},
				module_name => 'Chemesis3',
				service_name => 'model_container',
			       },
		 )
	       : (
		  heccer => {
			     constructor_settings => {
						      ($GENESIS3::registered_solverclasses->{heccer}->{constructor_settings}->{configuration}
						       ? (configuration => $GENESIS3::registered_solverclasses->{heccer}->{constructor_settings}->{configuration})
						       : ()),
						      dStep => $GENESIS3::heccer_time_step,
						     },
			     module_name => 'Heccer',
			     service_name => 'model_container',
			    },
		 ),
	      };

	$schedule->{solverclasses} = $solverclasses;

	# fill in the outputclasses

	#t make this configurable

	my $outputclasses
	    = {
	       double_2_ascii => {
				  module_name => 'Experiment',
				  options => {
					      emit_time => $GENESIS3::output_emit_time,
					      filename => $GENESIS3::output_filename,
					      format => $GENESIS3::output_format,
					      output_mode => $GENESIS3::output_mode,
					      resolution => $GENESIS3::output_resolution,
					      time_step => $GENESIS3::output_time_step,
					     },
				  package => 'Experiment::Output',
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


sub runtime_parameter_add
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

    if (!defined $element
        || $element eq '.')
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

    return "*** Ok: runtime_parameter_add $element $parameter $value_type $value";
}


sub runtime_parameter_add_help
{
    print "description: set a run-time parameter to a specific value.\n";

    print "synopsis: runtime_parameter_add <element_name> <parameter_name> <value> [ <value_type> ]\n";

    return "*** Ok";
}


sub runtime_parameter_delete
{
    my $runtime_parameter_name = shift;

#     delete $GENESIS3::inputs->{$runtime_parameter_name};

    return "*** Error: runtime_parameter_delete $runtime_parameter_name";
}


sub runtime_parameter_delete_help
{
    print "description: delete an input.
synopsis: runtime_parameter_delete [ <runtime_parameter_name> [ <option> ... ] ]
";

    return "*** Ok";
}


sub runtime_parameters_show
{
    use YAML;

    print Dump( { runtime_parameters => $GENESIS3::runtime_parameters, }, );

    return "*** Ok: runtime_parameters_show";
}


sub runtime_parameters_show_help
{
    print "description: show the value of a run-time parameter.\n";

    print "synopsis: runtime_parameters_show <element_name>\n";

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


sub solverset
{
    my $modelname = shift;

    my $solverclass = shift;

    my $schedule_name = shift;

    if (!defined $modelname
        || $modelname eq '.')
    {
	$modelname = $GENESIS3::current_working_element;
    }
    else
    {
	if ($modelname =~ m(^/)
	    || $modelname =~ m(::))
	{
	}
	else
	{
	    $modelname = "$GENESIS3::current_working_element/$modelname";
	}
    }

    if ($modelname =~ m((.*)/(.*)))
    {
	if (! defined $schedule_name)
	{
	    $schedule_name = $1;
	}

	my $component_type = $GENESIS3::model_container->component_type($modelname);

	# get access to the scheduler to use

	my $scheduler;

	# if there is a scheduler with this name

	if (defined $GENESIS3::schedulers->{$schedule_name})
	{
	    $scheduler = $GENESIS3::schedulers->{$schedule_name};
	}

	# if there is no scheduler with this name

	else
	{
	    # construct a simulation schedule from scratch

	    my $schedule
		= {
		   name => "GENESIS-3 SSP schedule initialized for $modelname",
		  };

	    if ($GENESIS3::verbose_level eq 'debug')
	    {
		$schedule->{verbose} = 'gshell debug enabled';
	    }

	    # tell ssp that the model-container service has been initialized

	    $schedule->{services}->{model_container}->{backend} = $GENESIS3::model_container;

# 	    # fill in / copy runtime_parameters

# 	    $schedule->{models}->[0]->{runtime_parameters}
# 		= [
# 		   @$GENESIS3::runtime_parameters,
# 		  ];

	    $scheduler = SSP->new($schedule);
	}

	# add the mapping of the model

	my $models = $scheduler->{models} || [];

	push
	    @$models,
	    {
	     modelname => $modelname,
	     solverclass => $solverclass,
	    };

	$scheduler->{models} = $models;

	# if the solverclass does not exist yet

	if (! defined $scheduler->{solverclasses}->{$solverclass})
	{
	    use Clone;

	    # add the solver class to the scheduler

	    $scheduler->{solverclasses}->{$solverclass}
		= Clone::clone($GENESIS3::registered_solverclasses->{$solverclass});
	}

	# fill in the outputclasses

	#t make this configurable

	my $outputclasses
	    = {
	       double_2_ascii => {
				  module_name => 'Experiment',
				  options => {
					      emit_time => $GENESIS3::output_emit_time,
					      filename => $GENESIS3::output_filename,
					      format => $GENESIS3::output_format,
					      output_mode => $GENESIS3::output_mode,
					      resolution => $GENESIS3::output_resolution,
					      time_step => $GENESIS3::output_time_step,
					     },
				  package => 'Experiment::Output',
				 },
	      };

	$scheduler->{outputclasses} = $outputclasses;

	# fill in the intput classes and inputs

	$scheduler->{inputclasses} = $GENESIS3::inputclasses;

	$scheduler->{inputs} = $GENESIS3::inputs;

	# fill in the outputs

	if (!@$GENESIS3::outputs)
	{
	    # default is the soma Vm of a 'segments' group

	    $scheduler->{outputs}
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

	    $scheduler->{outputs} = $GENESIS3::outputs;
	}

	# application configuration

	#t for the tests, should be configurable such that it can use the 'steps' method to.

	my $time = 0;

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

	$scheduler->{apply}
	    = {
	       simulation => $simulation,
	       finishers => [],
	      };

	# register the created scheduler

	$GENESIS3::schedulers->{$schedule_name} = $scheduler;

# 	$GENESIS3::solvermapping->{$modelname} = $solverclass;

	return "*** Ok: solverset $modelname $solverclass $schedule_name";
    }
    else
    {
	return "*** Ok: error: $modelname not recognized as a modelcomponent";
    }
}


sub solverset_help
{
    print "description: associate a solverclass with the selected components of a model.\n";

    print "synopsis: solverset <modelname> <solverclass> [ <schedule_name> ]\n";

    return "*** Ok: solverset_help";
}


sub swc_load
{
    print "Not implemented yet.  Please contribute by providing a use case.\n";

    return "*** Ok: swc_load";
}


sub swc_load_help
{
    print "description: load a morphology from a SWC file.\n";

    print "synopsis: swc_load\n";

    return "*** Ok";
}


sub tabulate
{
    my $modelname = shift;

# 					  format => 'alpha-beta',
# 					  format => 'steadystate-tau',
# 					  format => 'A-B',
# 					  format => 'internal',

    my $source = shift;

    my $format = shift || 'steadystate-tau';

    my $increment = shift || 50;

    if (!defined $modelname || !defined $format)
    {
	return '*** Error: <modelname> and <format> are required';
    }

    # define a scheduler for this model

    run($modelname, 0);

    # get scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    # construct the tabulator interface

    my $tabulator = Heccer::Tabulator->new();

    my $ssp_analyzer = SSP::Analyzer->new( { backend => $tabulator, scheduler => $scheduler, }, );

    $tabulator->serve( $ssp_analyzer, { source => "model_container::$modelname", }, );

    my $error
	= $tabulator->dump
	    (
	     $ssp_analyzer,
	     {
	      format => $format,
	      increment => $increment,
	      output => 'file:///tmp/tabulator-A.out',
	      output => 'stdout',
	      source => "$modelname/$source/A",
	     },
	     {
	      format => $format,
	      increment => $increment,
	      output => 'file:///tmp/tabulator-B.out',
	      output => 'stdout',
	      source => "$modelname/$source/B",
	     },
	    );

    if ($error)
    {
	return "*** Error: exporting tables failed ($error)";
    }
    else
    {
	print "Simulation check ok\n";

	return "*** Ok";
    }
}


sub tabulate_help
{
    print "description: export the tabulated form of the kinetics of a model's channel.\n";

    print "synopsis: tabulate <modelname> <source> <format> <increment>\n";

    print "comment: format is one of 'alpha-beta', 'steadystate-tau', 'A-B', 'internal'\n";

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
		"Core components" => $GENESIS3::Configuration::configuration->{software_components}->{core_components},
		"Other components" => $GENESIS3::Configuration::configuration->{software_components}->{other_components},
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
    my $inputclass_name = shift;

    my $inputclasses = { %{ $GENESIS3::inputclasses, }, };

    foreach (%$inputclasses)
    {
	delete $inputclasses->{$_} if not /$inputclass_name/;
    }

    use YAML;

    local $YAML::UseHeader = 0;

    print Dump(
	       {
		"all input classes" => $inputclasses,
	       },
	      );

    return "*** Ok: list_inputclasses";
}


sub list_inputclass_templates
{
    my $inputclass_template_name = shift;

    my $inputclass_templates = { %{ $GENESIS3::all_inputclass_templates, }, };

    foreach (%$inputclass_templates)
    {
	delete $inputclass_templates->{$_} if not /$inputclass_template_name/;
    }

    use YAML;

    local $YAML::UseHeader = 0;

    print Dump(
	       {
		"all input class templates" => $inputclass_templates,
	       },
	      );

    return "*** Ok: list_inputclass_templates";
}


sub list_section
{
#     my $symbols_definitions = $GENESIS3::Configuration::symbols_definitions;

#     my $tokens = $symbols_definitions->{tokens};

#     my $token_names
# 	= [
# 	   sort
# 	   map
# 	   {
# 	       s/^TOKEN_// ; $_
# 	   }
# 	   map
# 	   {
# 	       my $token = $tokens->{$_};

# 	       $token->{lexical};
# 	   }
# 	   grep
# 	   {
# 	       $tokens->{$_}->{purpose} eq $purpose
# 	   }
# 	   keys %$tokens,
# 	  ];

    my $purpose = 'section';

    my $token_names
	= [
	   'IMPORT',
	   'PRIVATE_MODELS',
	   'PUBLIC_MODELS',
	  ];

    print "all $purpose tokens:\n";

    print foreach map { "  - $_\n" } @$token_names;

    return "*** Ok: list_$purpose";
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
		   directory => "/usr/local/neurospaces/instrumentor/hierarchy/output/symbols/",
		   filename => "dump_annotated_class_hierarchy.yml",
		  },
       software_components => {
			       core_components => {
						   chemesis3 => {
								 description => 'biochemical pathway solver',
								 disabled => 'experimental, working on it',
								 module => 'Chemesis3',
								 type => {
									  description => 'simulation object',
									  layer => 1,
									 },
								},
						   exchange => {
								description => 'NeuroML and NineML exchange',
								disabled => 'immature and by default not loaded',
								integrator => 'Neurospaces::Exchange::Commands',
								module => 'Neurospaces::Exchange',
								type => {
									 description => 'intermediary, model-container interface',
									 layer => 2,
									},
							       },
						   experiment => {
								  description => 'Simulation objects implementing experiments',
								  disabled => 'immature and by default not loaded',
								  # 		      integrator => 'Neurospaces::Exchange::Commands',
								  module => 'Experiment',
								  type => {
									   description => 'simulation objects for I/O',
									   layer => 1,
									  },
								 },
						   gshell => {
							      description => 'the GENESIS 3 shell allows convenient interaction with other components',
							      disabled => 0,
							      module => 'GENESIS3',
							      status => 'loaded',
							      type => {
								       description => 'scriptable user interface',
								       layer => 3,
								      },
							      # 		  variables => {
							      # 				verbose => $GENESIS3::verbose_level,
							      # 			       },
							     },
						   heccer => {
							      description => 'single neuron equation solver',
							      module => 'Heccer',
							      type => {
								       description => 'simulation object',
								       layer => 1,
								      },
							     },
						   'model-container' => {
									 description => 'internal storage for neuronal models',
									 integrator => 'Neurospaces::Integrators::Commands',
									 module => 'Neurospaces',
									 type => {
										  description => 'intermediary',
										  layer => 2,
										 },
									},
						   sli => {
							   description => "GENESIS 2 backward compatible scripting interface",
							   integrator => 'SLI::Integrators::Commands',
							   module => "SLI",
							   type => {
								    description => 'scriptable user interface',
								    layer => 2,
								   },
							  },
						   studio => {
							      disabled => "the Neurospaces studio is an experimental feature, try loading it with the 'component_load' command",
							      description => "Graphical interface that allows to explore models",
							      module => "Neurospaces::Studio",
							      type => {
								       description => 'graphical user interface',
								       layer => 4,
								      },
							     },
						   ssp => {
							   description => 'binds the software components of a simulation together',
							   integrator => 'SSP::Integrators::Commands',
							   module => 'SSP',
							   type => {
								    description => 'simulation controller',
								    layer => 1,
								   },
							  },
						  },
			       other_components => {
						    python => {
							       description => 'interface to python scripting',
							       disabled => "this component is currently unused, it will be interfaced with SSPy which is still under development.",
							       module => 'GENESIS3::Python',
							       type => {
									description => 'scriptable user interface',
									layer => 2,
								       },
							      },
						   },
			      },
      };

{
    my $fs_configuration;

    use YAML;

    if (-f '/etc/neurospaces/gshell/software_components.yml')
    {
	eval
	{
	    $fs_configuration = YAML::LoadFile('/etc/neurospaces/gshell/software_components.yml');
	};

	if ($@)
	{
	    die "$0: *** Error: reading file /etc/neurospaces/gshell/software_components.yml ($@)";
	}
    }


    # if there is a local package configuration

    if ($fs_configuration)
    {
	# merge

	require Data::Utilities;

	my $merged_configuration = Data::Merger::merger($configuration, $fs_configuration);
    }
}


my $filename = "$GENESIS3::Configuration::configuration->{symbols}->{directory}$GENESIS3::Configuration::configuration->{symbols}->{filename}";

use YAML;

our $symbols_definitions = YAML::LoadFile($filename);


package GENESIS3::Help;


# loop over all lexical purposes

foreach my $purpose (
		     qw(
			   physical
			   structure
		      )
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


package GENESIS3::Interactive;


use Term::ReadLine;

use Text::ParseWords;


sub interprete
{
    my $line = shift ;

    $line =~ s/^\s*//g;

    $line =~ s/\s*$//g;

    $line =~ s/\s+/ /g;

    my @args = quotewords(" ", 1, $line);

    if ($#args == -1)
    {
      return;
    }

    chomp @args;

    my $arguments = \@args;

#    my $arguments = [ split /\s/, $line, ];

    #t join hash and array arguments

    # create a perl function call

    my $quoted_line = $arguments->[0];

    if ($arguments->[1])
    {
	$quoted_line
	    .= (
		join
		' ',
		"(",
		(
		 map
		 {
		     (
		      /^('|")/
		      ? "$_, "
		      : "'$_',"
		     )
		  }
		 (@$arguments)[1 .. $#$arguments]
		),
		")"
	       );

	$quoted_line =~ s/\\n/\n/g;
    }

    if ($quoted_line =~ /^\s*(#.*)?$/)
    {
	return;
    }

    # start to prepare to execute of the command

    my $genesis_command;

    {
	$genesis_command = $arguments->[0];

	if ($::option_output_tags)
	{
	    print "<" .  $genesis_command . ">\n";

	    my @args = @$arguments;

	    shift @args;

	    my $genesis_command_args = join " ", @args;

	    print "<args>\n" . $genesis_command_args . "\n</args>\n"
	}

	no strict "refs";

	if (!exists ((\%{"::"})->{"GENESIS3::"}->{"Commands::"}->{$genesis_command}))
	{
	    print "*** Error: command $genesis_command not found,\n*** Error: use 'list commands' to get a list of available commands,\n*** Error: use the help function to obtain help about each command\n";

	    if ($::option_output_tags)
	    {
		print "</" .  $genesis_command . ">\n";
	    }

	    return;
	}
    }

    my $package = "GENESIS3::Commands::";

    $quoted_line =~ s/^\s*/$package/;

    my $result = eval($quoted_line);

    if ($@)
    {
	warn $@;

	print Data::Dumper->Dump( [ $result, ], [ 'Result', ]);
    }

    if ($result =~ /^\*\*\* Ok/)
    {

    }
    else
    {
	print "$result\n";
    }

    if ($::option_output_tags)
    {
	print "</" .  $genesis_command . ">\n";
    }
}


sub loop
{
    my $historyfile = $ENV{HOME} . '/.phistory';

    my $term = Term::ReadLine->new('genesis > ');

    if (open H, $historyfile)
    {
	my %h;

	my @h = <H>;
	chomp @h;
	close H;

	$h{$_} = 1 foreach @h;
	$term->addhistory($_) foreach keys %h;
    }

    if ($::option_output_tags)
    {
	my $line;

	while(<>)
	{
	    $line = $_;

	    interprete($line);

	    {
		open H, ">>$historyfile";
		print H "$line\n";
		close H;
	    }

	    $term->addhistory($line) if /\S/;
	}
    }


    while ( defined ($_ = $term->readline("genesis > ")) )
    {
	my $line = $_;

	interprete($line);

	{
	    open H, ">>$historyfile";
	    print H "$line\n";
	    close H;
	}

	$term->addhistory($line) if /\S/;
    }
}


package GENESIS3::Tokens::Physical;


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


#t some of this info should be coming from the installer script.

our $all_inputclass_templates
    = {
       perfectclamp => {
			module_name => 'Experiment',
			options => {
				    name => 'name of this inputclass',
				    command => 'command value',
				   },
			package => 'Experiment::PerfectClamp',
		       },
       pulsegen => {
			module_name => 'Experiment',
			options => {
				    name => 'name of this inputclass',
				    width1 => 'First pulse width',
				    level1 => 'First pulse level',
				    delay1 => 'First pulse delay',
				    width2 => 'Second pulse width',
				    level2 => 'Second pulse level',
				    delay2 => 'Second pulse delay',
				    baselevel => 'The pulse base level',
				    triggermode => 'The pulse triggermode, 0 - freerun, 1 - ext trig, 2 - ext gate',
				   },
			package => 'Experiment::PulseGen',
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


our $chemesis3_time_step = 2e-02;

our $current_working_element = '/';

our $current_working_namespace = '::';

our $global_solver = 'heccer';

our $global_time = 0;

our $heccer_time_step = 2e-05;

our $model_container;

our $inputclasses = {};

our $inputs = [];

our $outputs = [];

our $output_emit_time = 1;

our $output_filename = '/tmp/output';

our $output_format = '';

our $output_mode = '';

our $output_resolution = '';

our $output_time_step;

our $runtime_parameters = [];

our $schedulers = {};

# our $solvermapping = {};

our $registered_solverclasses
    = {
       chemesis3 => {
		     constructor_settings => {
					      dStep => $GENESIS3::chemesis3_time_step,
					     },
		     module_name => 'Chemesis3',
		     service_name => 'model_container',
		    },
       heccer => {
		  constructor_settings => {
					   dStep => $GENESIS3::heccer_time_step,
					  },
		  module_name => 'Heccer',
		  service_name => 'model_container',
		 },
       des => {
	       constructor_settings => {
					configuration => {
							  reporting => {
									granularity => 10000,
									tested_things => (
											  $SwiggableHeccer::DES_DUMP_ALL
# 											  | $SwiggableHeccer::HECCER_DUMP_VM_COMPARTMENT_DATA
											 ),
								       },
							 },
				       },
	       module_name => 'Heccer',
	       package => 'Heccer::DES',
	       service_name => 'model_container',
	      },
      };

our $verbose_level = 0;


sub check_runtime_environment
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
	    print STDERR "$0: *** Warning: command $command found, but no help available for it\n";
	}
    }

    return 1;
}


sub create_all_tokens
{
    eval "require Neurospaces::Tokens::Physical";

    if ($@ eq '')
    {
    }
    else
    {
	print STDERR "$0: Warning: could not load Neurospaces::Tokens::Physical\n";
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

# 	print "Checking for the creation of a constructor alias for $subname\n";

	my $duplicates
	    = {
	       create_connection_symbol => 'create_single_connection',
	       create_connection_symbol_group => 'create_single_connection_group',
	      };

	if ($duplicates->{$subname})
	{
# 	    print "Create a constructor alias $duplicates->{$subname} for $subname\n";

	    ((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{$duplicates->{$subname}})
		= ((\%{"::"})->{"GENESIS3::"}->{"Tokens::"}->{"Physical::"}->{$subname});
	}
    }
}


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

	eval
	{
	    GENESIS3::Python::initialize($GENESIS3::model_container);
	};

	if ($@)
	{
	    print STDERR "$0: *** Warning: GENESIS3::Python loaded, but its initialize() method failed ($@)\n";
	}
    }

    # create all tokens

    create_all_tokens();

    # return result, seems to be always 1

    return $result;
}


sub component_load
{
    my $component_name = shift;

    my $component = $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$component_name};

    my $component_module = $component->{module} || $component_name;

    my $errors;

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

	$errors = 1;
    }

    if ($component->{integrator})
    {
	eval "require $component->{integrator}";

	if ($@)
	{
	    $component->{status} = "$0: *** Error: $component_name loaded, but its integrator cannot be loaded ($@)\n";

	    $errors = 1;
	}

	#! nicely based on Exporter

	no strict "refs";

	my $commands = eval "\$$component->{integrator}::g3_commands";

	foreach my $command (@$commands)
	{
	    *{"GENESIS3::Commands::$command"} = \&{"$component->{integrator}\::$command"};
	}
    }

    if ($errors)
    {
	return "*** Error: failed to load $component_name";
    }
    else
    {
	return "*** Ok: loading $component_name";
    }
}


sub profile_environment
{
    foreach my $component_name (keys %{$GENESIS3::Configuration::configuration->{software_components}->{core_components}})
    {
	my $component = $GENESIS3::Configuration::configuration->{software_components}->{core_components}->{$component_name};

	if (defined $component->{status}
	    and $component->{status} eq 'loaded')
	{
	    next;
	}

	if ($component->{disabled})
	{
	    $component->{status} = "disabled ($component->{disabled})";

	    next;
	}

	component_load($component_name);
    }

#     eval "require GENESIS3::Python";

#     if ($@)
#     {
# 	$GENESIS3::Configuration::configuration->{software_components}->{other_components}->{python}->{status} = $@;
#     }
#     else
#     {
# 	$GENESIS3::Configuration::configuration->{software_components}->{other_components}->{python}->{status} = 'loaded';
#     }

    return 1;
}


sub version
{
    # $Format: "    my $version = \"${package}-${label}\";"$
    my $version = "gshell-alpha";

    return $version;
}


profile_environment()
    and initialize()
    and check_runtime_environment();


