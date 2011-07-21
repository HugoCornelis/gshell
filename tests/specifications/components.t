#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
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
						   description => "Can we find the component help subtopics ?",
						   read => "
description: help on a specific software component
synopsis: 'help component <component_name>'
Core components:
",
						   write => "help component",
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
						   write => 'help components',
						  },
						  {
						   description => "Can we find the component help for a specific component that is already loaded ?",
						   read => "
ssp:
  description: binds the software components of a simulation together
  integrator: SSP::Integrators::Commands
  module: SSP
  status: loaded
  type:
    description: simulation controller
    layer: 1
  inline_help:
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
						  {
						   description => "Can we load a component that was already loaded ?",
						   write => "component_load ssp",
						  },
						  {
						   description => "Is the status of the component still correct ?",
						   read => "
ssp:
  description: binds the software components of a simulation together
  integrator: SSP::Integrators::Commands
  module: SSP
  status: loaded
  type:
    description: simulation controller
    layer: 1
  inline_help:
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
						  {
						   description => "Can we find the component help for a specific component that is not yet loaded ?",
						   read => "
exchange:
  description: NeuroML and NineML exchange
  disabled: immature and by default not loaded
  integrator: Neurospaces::Exchange::Commands
  module: Neurospaces::Exchange
  status: disabled (immature and by default not loaded)
  type:
    description: 'intermediary, model-container interface'
    layer: 2
  inline_help: no further help found
",
						   write => "help component exchange",
						  },
						  {
						   description => "Can we load the component ?",
						   write => "component_load exchange",
						  },
						  {
						   description => "Has the status of the component been updated?",
						   read => "
exchange:
  description: NeuroML and NineML exchange
  disabled: immature and by default not loaded
  integrator: Neurospaces::Exchange::Commands
  module: Neurospaces::Exchange
  status: loaded
  type:
    description: 'intermediary, model-container interface'
    layer: 2
  inline_help: no further help found

",
						   write => "help component exchange",
						  },
						  {
						   description => "Have the commands of the components been inserted in the command list?",
						   read => "
  - neuroml_load
  - nineml_load
",
						   write => "help commands",
						  },
						  {
						   description => "Can we ask for help for the new commands (neuroml_load)?",
						   read => "
description: load a neuroml / nineml model description file.
synopsis: neuroml_load <filename>
",
						   write => "help command neuroml_load",
						  },
						  {
						   description => "Can we ask for help for the new commands (nineml_load)?",
						   read => "
description: load a neuroml / nineml model description file.
synopsis: nineml_load <filename>
",
						   write => "help command nineml_load",
						  },
						 ],
				description => "inspecting and loading external software components",
			       },
			      ],
       description => "inspecting and loading external software components",
       name => 'components.t',
      };


return $test;


