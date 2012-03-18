#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--help',
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Do we get an informative help message when the help command line option is given?",
						   read => "GENESIS 3 shell.

options:
    --batch-mode         batch mode, means that interactive mode is disabled.
    --execute            execute this string, may be given multiple times.
    --help               print usage information.
    --output-tags        Adds XML-like tags to diagnostic messages.
    --verbose            set verbosity level ('errors', 'warnings', 'information', 'debug', default is 'warnings').
    --version            give version information.
",
						   timeout => 5,
						  },
						 ],
				description => "the help command line option",
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we find the top level help topics ?",
						   read => "synopsis: help <topic>
synopsis: <topic> must be one of commands, components, documentation, variables, libraries
",
						   write => "help",
						  },
						  {
						   description => "Can we find the command help subtopics ?",
						   read => "
description: help on a specific command
synopsis: 'help command <command_name>'
all commands:
",
						   write => "help command",
						  },
						  {
						   description => "Can we find the command help for a specific command ?",
						   read => "
description: add a variable to the output file.
synopsis: output_add <element_name> <field_name>
",
						   write => "help command output_add",
						  },
						  {
						   description => "Can we find the component help subtopics ?",
						   read => "
description: help on a specific software component
synopsis: 'help component <component_name>'
Core components:
",
						   write => "help component",
						  },
						  {
						   description => "Can we find the component help for a specific component ?",
						   read => "
    description: simple scheduler in perl
    usage: |-
      The simple scheduler in perl binds together software components for
      running simulations.  It is based on services and solvers: services
      provide functionality to assist the solvers to construct an
      efficient simulation run-time environment, solvers apply algorithms
      to solve the problem posed, numerically or otherwise.
",
						   write => "help component ssp",
						  },
						 ],
				description => "the help command and its topics",
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   timeout => 5,
						  },
						  {
						   description => "Can we get a useful synopsis for the list command ?",
						   read => "synopsis: list <type>
synopsis: <type> must be one of commands, components, documentation, functions, inputclass_templates, inputclasses, physical, section, structure, verbose
synopsis: (you gave )
",
						   write => 'list',
						  },
						  {
						   description => "Can we find commands ?",
						   read => "all commands:
  - ce
  - check
  - chemesis3_set_timestep
  - component_load
  - create
  - createmap
  - delete
  - echo
  - exit
  - explore
  - heccer_set_config
  - heccer_set_timestep
  - help
  - input_add
  - input_delete
  - input_show
  - inputbinding_add
  - inputclass_add
  - inputclass_delete
  - inputclass_show
  - inputclass_template_show
  - insert_alias
  - library_show
  - list
  - list_elements
  - list_namespaces
  - model_parameter_add
  - model_parameter_show
  - model_state_load
  - model_state_save
  - morphology_list_spine_heads
  - morphology_summarize
  - ndf_load
  - ndf_load_library
  - ndf_save
  - npl_load
  - npy_load
  - output_add
  - output_filename
  - output_format
  - output_mode
  - output_resolution
  - output_show
  - parameter_scaled_show
  - parameter_show
  - pwe
  - py_diagnose
  - pynn_load
  - querymachine
  - quit
  - reset
  - run
  - runtime_parameter_add
  - runtime_parameter_delete
  - runtime_parameters_show
  - set_verbose
  - sh
  - show_global_time
  - show_verbose
  - sli_listcommands
  - sli_listobjects
  - sli_load
  - sli_printcommandlist
  - sli_run
  - sli_script
  - solverset
  - ssp_load
  - ssp_save
  - swc_load
  - tabulate
  - volumeconnect
  - xml_load
  - xml_save
",
						   write => 'list commands',
						  },
						  {
						   description => "Can we find the loaded software components ?",
						   read => "Core components:
  chemesis3:
    description: biochemical pathway solver
    disabled: 'experimental, working on it'
    module: Chemesis3
    status: 'disabled (experimental, working on it)'
    type:
      description: simulation object
      layer: 1
  exchange:
    description: NeuroML and NineML exchange
    disabled: immature and by default not loaded
    integrator: Neurospaces::Exchange::Commands
    module: Neurospaces::Exchange
    status: disabled (immature and by default not loaded)
    type:
      description: 'intermediary, model-container interface'
      layer: 2
  experiment:
    description: Simulation objects implementing experiments
    disabled: immature and by default not loaded
    module: Experiment
    status: disabled (immature and by default not loaded)
    type:
      description: simulation objects for I/O
      layer: 1
  gshell:
    description: the GENESIS 3 shell allows convenient interaction with other components
    disabled: 0
    module: GENESIS3
    status: loaded
    type:
      description: scriptable user interface
      layer: 3
  heccer:
    description: single neuron equation solver
    module: Heccer
    status: loaded
    type:
      description: simulation object
      layer: 1
  model-container:
    description: internal storage for neuronal models
    integrator: Neurospaces::Integrators::Commands
    module: Neurospaces
    status: loaded
    type:
      description: intermediary
      layer: 2
  sli:
    description: GENESIS 2 backward compatible scripting interface
    integrator: SLI::Integrators::Commands
    module: SLI
    status: loaded
    type:
      description: scriptable user interface
      layer: 2
  ssp:
    description: binds the software components of a simulation together
    integrator: SSP::Integrators::Commands
    module: SSP
    status: loaded
    type:
      description: simulation controller
      layer: 1
  studio:
    description: Graphical interface that allows to explore models
    disabled: \"the Neurospaces studio is an experimental feature, try loading it with the 'component_load' command\"
    module: Neurospaces::Studio
    status: \"disabled (the Neurospaces studio is an experimental feature, try loading it with the 'component_load' command)\"
    type:
      description: graphical user interface
      layer: 4
Other components:
  python:
    description: interface to python scripting
    module: GENESIS3::Python
",
						   write => 'list components',
						  },
						  {
						   description => "Can we find functions ?",
						   read => "NERNST",
						   write => 'list functions',
						  },
						  {
						   description => "Can we find physical tokens ?",
						   read => "all physical tokens:
  - ALGORITHM
  - ATTACHMENT
  - AXON_HILLOCK
  - CELL
  - CHANNEL
  - CONCENTRATION_GATE_KINETIC
  - CONNECTION
  - CONNECTION_GROUP
  - CONTOUR_GROUP
  - CONTOUR_POINT
  - EM_CONTOUR
  - EQUATION_EXPONENTIAL
  - FIBER
  - GATE_KINETIC
  - GROUP
  - GROUPED_PARAMETERS
  - HH_GATE
  - IZHIKEVICH
  - KINETICS
  - NETWORK
  - NEURON
  - POOL
  - POPULATION
  - PROJECTION
  - PULSE_GEN
  - RANDOMVALUE
  - REACTION
  - SEGMENT
  - SEGMENT_GROUP
",
						   write => 'list physical',
						  },
						  {
						   description => "Can we find section tokens ?",
						   read => "all section tokens:
  - IMPORT
  - PRIVATE_MODELS
  - PUBLIC_MODELS
",
						   write => 'list section',
						  },
						 ],
				description => "list commands",
			       },
			       {
				arguments => [
					     ],
				command => 'bin/genesis-g3',
				command_tests => [
						  {
						   description => "Is startup successful ?",
						   read => "GENESIS 3 shell",
						   wait => 1,
						  },
						  {
						   description => "Can we list avaialable GENESIS 2 commands?",
						   write => 'sli_listcommands',
						   read => '
Available commands:
abort               abs                 acos                addaction           
addalias            addclass            addescape           addfield            
addforwmsg          addglobal           addjob              addmsg              
addmsgdef           addobject           addtask             argc                
arglist             argv                asin                atan                
call                cd                  ce                  check               
chr                 clearerrors         closefile           copy                
cos                 countchar           countelementlist    cpu                 
create              createmap           debug               debugfunc           
delete              deleteaction        deleteall           deleteclass         
deletefield         deleteforwmsg       deletejob           deletemsg           
deletemsgdef        deletetasks         disable             echo                
el                  enable              enddump             eof                 
error               exists              exit                exp                 
findchar            findsolvefield      floatformat         flushfile           
gaussian            gctrace             getarg              getclock            
getdate             getdefault          getelementlist      getenv              
getfield            getfieldnames       getglobal           getmsg              
getpath             getstat             gftrace             h                   
help                initdump            input               isa                 
le                  listactions         listclasses         listcommands        
listescape          listfiles           listglobals         listobjects         
log                 logfile             max                 maxerrors           
maxwarnings         min                 mkdir               move                
msgsubstitute       notes               objsubstitute       openfile            
pope                position            pow                 printargs           
printenv            pushe               putevent            pwe                 
quit                rand                randseed            readcell            
readfile            reclaim             resched             reset               
restore             round               save                set_nsintegrator_verbose_level
setclock            setdefault          setenv              setfield            
setfieldprot        setglobal           setmethod           setpriority         
setprompt           setrand             setupalpha          sh                  
showclocks          showcommand         showfield           showjobs            
showmsg             showobject          showsched           showstat            
silent              simdump             simobjdump          simundump           
sin                 sqrt                stack               step                
stop                strcat              strcmp              strlen              
strncmp             strsub              substituteinfo      substring           
swapdump            tan                 trunc               tset                
tweakalpha          tweaktau            useclock            version             
volumeconnect       warning             where               writefile           
',
						  },
						  {
						   description => "Can we get a list of available GENESIS 2 objects?",
						   write => 'sli_listobjects',
						   read => 'AVAILABLE OBJECTS:
asc_file            hsolve              neurospaces         neutral             
nsintegrator',
						  },
						 ],
				description => "backward compatibility list commands",
			       },
			      ],
       description => "help commands",
       name => 'help.t',
      };


return $test;


