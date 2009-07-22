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

nmcGlobal = None

def set_model_container(backend):
    global nmcGlobal
    nmcGlobal = Neurospaces.ModelContainer(backend)

def npy_load(path):
    global nmcGlobal
    nmcGlobal.read_python(path)

class Foo(object):
   def __init__(self):
      print "new Foo object being created"
      self.data = {}
   def get_data(self): return self.data
   def set_data(self,dat): 
      self.data = dat
END


our $loaded = 0;


sub initialize
{
    my $model_container = shift;

    set_model_container($model_container->backend());

    $loaded = 1;
}


1;


