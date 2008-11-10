#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Commands;


our $current_working_element = '/';


my $example_schedule
    = "--- !!perl/hash:SSP
application_classes:
  analyzers:
    default:
      - method: analyze
    priority: 95
  finishers:
    default:
      - method: finish
    priority: 140
  initializers:
    default:
      - method: compile
      - method: instantiate_inputs
      - method: instantiate_outputs
      - method: initiate
    priority: 80
  modifiers:
    default: []
    priority: 50
  results:
    default: []
    priority: 170
  services:
    default:
      - method: instantiate_services
    priority: 20
  simulation:
    default: []
    priority: 110
apply:
  simulation:
    - arguments:
        - 2500
        - verbose: 2
      method: steps
models:
  - granular_parameters:
      - component_name: /purk_test/segments/soma
        field: INJECT
        value: 2e-09
    modelname: /purk_test
    solverclass: heccer
name: purk_test
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: /tmp/output
    package: Heccer::Output
outputs:
  - component_name: /purk_test/segments/soma
    field: Vm
    outputclass: double_2_ascii
  - component_name: /purk_test/segments/soma/ca_pool
    field: Ca
    outputclass: double_2_ascii
  - component_name: /purk_test/segments/soma/km
    field: state_n
    outputclass: double_2_ascii
services:
  neurospaces:
    initializers:
      - arguments:
          -
            - tests/perl/purk_test
            - -P
            - tests/cells/purk_test.ndf
        method: read
    module_name: Neurospaces
solverclasses:
  heccer:
    constructor_settings:
      configuration:
        reporting:
          granularity: 1000
          tested_things: 6225920
      dStep: 2e-05
    module_name: Heccer
    service_name: neurospaces
";


my $time_step = 2e-05;

my $outputs = [];

my $models = [];


sub compile
{
    my $schedule_yaml
	= "--- !!perl/hash:SSP
apply:
  simulation:
    - arguments:
        - 2500
        - verbose: 2
      method: steps
models:
  - granular_parameters:
      - component_name: /purk_test/segments/soma
        field: INJECT
        value: 2e-09
    modelname: /purk_test
    solverclass: heccer
name: GENESIS3 schedule
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: /tmp/output
    package: Heccer::Output
services:
  neurospaces:
    initializers:
      - arguments:
          -
            - GENESIS3
        method: empty
    module_name: Neurospaces
solverclasses:
  heccer:
    constructor_settings:
      dStep: $time_step
    module_name: Heccer
    service_name: neurospaces
";

    use YAML;

    my $schedule = Load($schedule_yaml);

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
	    $current_working_element =~ s((.*)/.*)($1);
	}
	else
	{
	    $current_working_element .= $element;
	}
    }
}


sub pwe
{
    print "$current_working_element\n";
}


sub help
{
    print "no help yet\n";
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
	    $name = "$current_working_element/$name";
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


sub list_elements
{
    my $elements = $GENESIS3::model_container->list_elements($current_working_element);

    use YAML;

    print Dump( { $current_working_element => $elements, }, );
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


sub output
{
    my $component_name = shift;

    my $field = shift;

#     my $context = SwiggableNeurospaces::PidinStackParse($component_name);

#     $context->PidinStackLookupTopSymbol();

#     my $serial = $context->PidinStackToSerial();
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

	      undef;
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

	      print "$subname: $physical_name\n";

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
    my $version="gshell-python-2";

    return $version;
}


profile_environment()
    && initialize();


