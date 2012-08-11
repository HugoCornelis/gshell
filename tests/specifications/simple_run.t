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
						   description => "Can we create a cell ?",
						   write => 'create cell /c',
						  },
						  {
						   description => "Can we create a segment ?",
						   write => 'create segment /c/s',
						  },
						  {
						   description => "Can we set parameter CM of the segment ?",
						   write => 'model_parameter_add /c/s CM 0.0164',
						  },
						  {
						   description => "Can we set parameter Vm_init of the segment ?",
						   write => 'model_parameter_add /c/s Vm_init -0.0680',
						  },
						  {
						   description => "Can we set parameter RM of the segment ?",
						   write => 'model_parameter_add /c/s RM 1.000',
						  },
						  {
						   description => "Can we set parameter RA of the segment ?",
						   write => 'model_parameter_add /c/s RA 2.50',
						  },
						  {
						   description => "Can we set parameter ELEAK of the segment ?",
						   write => 'model_parameter_add /c/s ELEAK -0.080',
						  },
						  {
						   description => "Can we set parameter DIA of the segment ?",
						   write => 'model_parameter_add /c/s DIA 2e-05',
						  },
						  {
						   description => "Can we set parameter LENGTH of the segment ?",
						   write => 'model_parameter_add /c/s LENGTH 4.47e-05',
						  },
						  {
						   description => "Can we define the output ?",
						   write => "output_add /c/s Vm",
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /c",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /c 0.001",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands for a single passive compartment created from the shell",
				side_effects => "creates a model in the model container",
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
						   write => undef,
						  },
						  {
						   description => "Can we load the purkinje cell model ?",
						   write => 'ndf_load cells/purkinje/edsjb1994.ndf',
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /Purkinje",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /Purkinje 0.001",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0678441
",
						   timeout => 100,
						   write => "sh cat /tmp/output",
						  },
						 ],
				description => "commands to run the purkinje cell from an ndf file",
				side_effects => "creates a model in the model container",
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
						   write => undef,
						  },
						  {
						   description => "Can we load a single passive compartment model ?",
						   write => 'ndf_load tests/cells/singlep.ndf',
						  },
						  {
						   description => "Can we save the simulation ?",
						   write => 'ssp_save /singlep /tmp/singlep.ssp',
						  },
						  {
						   description => "Has the simulation been saved correctly ?",
						   read => "
apply:
  analyzers:
    - method: analyze
  initializers:
    - method: compile
    - method: instantiate_inputs
    - method: instantiate_outputs
    - method: connect
    - method: initiate
    - method: optimize
  services:
    - method: instantiate_services
  simulation:
    - arguments: &2
        - 0
      method: advance
    - method: pause
history:
  - arguments: []
    method: instantiate_services
  - arguments: []
    method: compile
  - arguments: []
    method: instantiate_inputs
  - arguments: []
    method: instantiate_outputs
  - arguments: []
    method: connect
  - arguments: []
    method: initiate
  - arguments: []
    method: optimize
  - arguments: []
    method: analyze
  - arguments: *2
    method: advance
  - arguments: []
    method: pause
models:
  - modelname: /singlep
    solverclass: heccer
name: 'GENESIS-3 SSP schedule initialized for /singlep, 0'
optimize: 'by default turned on, ignored when running in verbose mode'
outputclasses:
  double_2_ascii:
    module_name: Experiment
    options: &3
      emit_time: 1
      filename: /tmp/output
      format: ''
      output_mode: ''
      resolution: ''
      time_step: ~
    package: Experiment::Output
    ssp_outputclass: &4 !!perl/hash:SSP::Output
      backend: !!perl/hash:Experiment::Output
        backend: !!perl/hash:SwiggableExperiment::OutputGenerator {}
        emit_time: 1
        filename: /tmp/output
        format: ''
        module_name: Experiment
        name: double_2_ascii
        options: *3
        output_mode: ''
        package: Experiment::Output
        resolution: ''
        scheduler: *1
        time_step: ~
      module_name: Experiment
      name: double_2_ascii
      options: *3
      package: Experiment::Output
      scheduler: *1
outputs:
  - component_name: /singlep/segments/soma
    field: Vm
    outputclass: double_2_ascii
    warn_only: the default output (/singlep/segments/soma) was generated automatically and is not always available
schedule:
  - !!perl/hash:SSP::Engine
    backend: !!perl/hash:Heccer
      heccer: !!perl/hash:SwiggableHeccer::simobj_Heccer {}
      model_source:
        modelname: /singlep
        service_backend: &5 !!perl/hash:Neurospaces
          neurospaces: !!perl/hash:SwiggableNeurospaces::Neurospaces {}
        service_name: model_container
    compilation_priority: numerical
    constructor_settings: &6
      dStep: 2e-05
    modelname: /singlep
    module_name: Heccer
    name: /singlep
    scheduler: *1
    service: &7
      backend: *5
      ssp_service: !!perl/hash:SSP::Service
        backend: *5
        scheduler: *1
    service_name: model_container
    solverclass: heccer
  - *4
services:
  model_container: *7
simulation_time:
  steps: 0
  time: 0
solverclasses:
  heccer:
    compilation_priority: numerical
    constructor_settings: *6
    module_name: Heccer
    service_name: model_container
",
						   write => 'sh cat /tmp/singlep.ssp',
						  },
						  {
						   description => 'Can we reload the saved simulation ?',
						   disabled => 'ssp_load works, but "run /singlep 1" fails because Heccer is not initialized correctly (must be recompiled from the model)',
						   todo => 'ssp_load works, but "run /singlep 1" fails because Heccer is not initialized correctly (must be recompiled from the model)',
						   write => 'ssp_load /singlep /tmp/singlep.ssp',
						  },
						  {
						   description => "Can we check the simulation ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we run the simulation ?",
						   write => "run /singlep 0.001",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Can we determine the size of the output ?",
						   read => "50 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Can we find the output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						  {
						   description => "Can we check the simulation again ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we reset the simulation ?",
						   write => "reset /singlep",
						  },
						  {
						   description => "Is the output file empty ?",
						   read => "0 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   description => "Can we rerun the simulation ?",
						   write => "run /singlep 0.001",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Has output been reproduced again?",
						   read => "50 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						  {
						   comment => "only testing the last line of output",
						   description => "Do we find the same output ?",
						   read => "
0.001 -0.0687098
",
						   write => "sh cat /tmp/output",
						  },
						  {
						   description => "Can we check the simulation once more ?",
						   write => "check /singlep",
						  },
						  {
						   description => "Can we reset the simulation once more ?",
						   write => "reset /singlep",
						  },
						  {
						   comment => 'note that the expected output is badly anchored, so the test can possibly succeed in circumstances were we would really like it to fail',
						   description => "Is the output file again empty ?",
						   read => "0 /tmp/output
",
						   write => "sh wc -l /tmp/output",
						  },
						 ],
				description => "running, checking, saving, loading and resetting a simulation",
				side_effects => "creates a model in the model container",
			       },
			      ],
       description => "simple simulations of models, checking and resetting a simulation",
       name => 'simple_run.t',
      };


return $test;


