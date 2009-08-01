#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Python;


BEGIN
{
    if (defined $ENV{PYTHONPATH})
    {
	$ENV{PYTHONPATH} .= ":/usr/local/glue/swig/python";
    }
    else
    {
	$ENV{PYTHONPATH} = "/usr/local/glue/swig/python";
    }
}


use Inline Python => <<'END';
import Neurospaces
import SwiggableNeurospaces
import yaml

nmcGlobal = None

def set_model_container(void):
    backend = SwiggableNeurospaces.NeurospacesSetObject(void)
    global nmcGlobal
    nmcGlobal = Neurospaces.ModelContainer(backend)

def npy_load(path):
    global nmcGlobal
    nmcGlobal.read_python(path)

def nmcDiagnose(path):
    global nmcGlobal
    nmcGlobal.query("serialMapping /")

class Foo(object):
   def __init__(self):
      print "new Foo object being created"
      self.data = {}
   def get_data(self): return self.data
   def set_data(self,dat): 
      self.data = dat
END


our $loaded = 1;


print "Python loaded\n";


sub initialize
{
    my $model_container = shift;

    my $backend = $model_container->backend();

#     use YAML;

#     print Dump($model_container);

    my $void = $backend->NeurospacesGetObject();

    set_model_container($void);
}


1;


