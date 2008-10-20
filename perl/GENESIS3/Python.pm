#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package GENESIS3::Python;


use Inline Python => <<'END';
class Foo(object):
   def __init__(self):
      print "new Foo object being created"
      self.data = {}
   def get_data(self): return self.data
   def set_data(self,dat): 
      self.data = dat
END


1;


