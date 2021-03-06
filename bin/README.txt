                          G3Plot ver. 0.55
                          ----------------

This is a preliminary version of a collection of stand-alone python-based
graphical utilities for plotting the output of GENESIS 3 simulations.  The
simulations use the asc_file object to write simulation variables to a
file, with one line per step of the output clock.  These scripts may also
be useful as prototypes of graphical objects that could be more directly
incorporated into the GENESIS 3 GUI.

They are based on the short script fplot.py, written by Karthikeyan
Subramanian for plotting the membrane potential from the GENESIS 3
implementation of tutorial4.  All of these scripts make use of the powerful
scientific graphics capability of Matplotlib, which easily generates a
wide variety of plots, accompanied by a Navigation Toolbar that allows
for panning and zooming of plots, and saving to publication quality
PNG format images.

In order to run these scripts, you will need python version 2.5 or later,
and the Matplotlib library for python, which can be downloaded from
http://sourceforge.net/projects/matplotlib.  The installation instructions
explain other requirememts, such as NumPy (numerical libraries for python)
that are usually installed along with python on most Linux systems.

The main script of this package, G3Plot.py also requires wxPython, the
python implemention of the wxWidgets widget set used by GENESIS 3.

The use of these python libraries is described in the Frontiers in
Neuroinformatics special issue on Python in Neuroscience
at http://frontiersin.org/neuroscience/neuroinformatics/specialtopics/8/.
More information and documentation for Matplotlib can be found at
http://matplotlib.sourceforge.net/.

Python scripts
--------------

Here is a brief description of the scripts and their usage:

fplot.py - Karthik's original verion to plot files of one (x,y) pair,
or (time,Vm) pair per line from a single file given as the argument, e.g.

    fplot.py Vm.out

plotVm.py - An extended version of fplot.py that uses the Matplotlib
object-oriented classes, instead of the Matlab-like pylab commands.  It
takes multiple wildcarded filenames as a argumments, and plots them in
different colors on the same axes, e.g.

    plotVm.py Vm.out pyr4*.out

It has labels and scales specific for membrane potenntial plots, and is
handy for quickly comparing the results of current injection simulations.
The (x,y) coordinates of a point on the graph can be displayed in the
Navigation Toolbat by positioning the cursor over it.

rasterplot.py - Similar to plotVm, but specialized for creating raster
plots of firing times for a group of neurons.  It takes a single filename
as argument, with a line for each cell containing the spike times separated
by spaces.  The times are plotted as dots with the time on the x-axis and
the cell number (the line number) on the y-axis.

The image [rasterplot.png] shows the plot generated with

        rasterplot.py spike_times.txt


G3Plot.py - This is an enhanced version of plotVm that wraps Matplotlib
plots within a wxPhython GUI.  This has several fancy Help menu features
and plotting options to illustrate (and for me to learn about) the
capabilities of wxWidgets as a GUI for displaying simulation results in
Python.  It can either take the filename list as arguments, or to be
entered in a dialog from the File/Open menu selection.

It addition to the usual Menu bar with File and Help menus, it has a
Control Panel of colored buttons and toggles for clearing the plot,
plotting, setting overlay ON or OFF, and toggling the Legend display.
The Legend identifies each colored line on the graph with the filename in
the same color.

The HTML Usage help describes the use of the Matplotlib Toolbar that is
used in all these programs, as well as Menu choices and Control Panel
buttons.  The Program Info scrolling message dialog gives information
obtained from program documentation strings about the objects and
functions, and the wxPython and matplotlib classes that are used here.

The image [G3Plot-demo.png] shows a screen dump of the GUI with Usage
and About help displayed with the plot produced by

        G3Plot.py pyr4*.out Vm.out

rowrateplot.py - This is a utility for analyzing network activity by
displaying a filled contour map of spike frequency vs. simulation time for
groups of neurons.  It takes a single filename as argument, with a line for
each time step containing the simulation time, followed by the average
spike frequency (firing rate) during that time step for each group of
cells.  Typically each cell group is a horizontal row of cells in the
network that are receiving auditory input.  Time is plotted on the x-axis,
cell group (row) on the y-axis, with the average firing frequency of cells
in that row at that time represented by a colored filled contour plot.

The image [freqplot-HD2500-11p.png] shows the contour plot generated from

        rowrateplot.py spike_freq_HD2500-11p.txt

The data file was produced from asc_file output of a GENESIS 2 layer 4
auditory cortex simulation.  The parameters used for the connection weights
in this run provided strong response to the random background input, and to
a 220 Hz tone pulse with thalamic input to row 25 and nearby rows, lasting
from 0.25 to 0.75 seconds.  rowrateplot.py will be useful for tuning
parameters to balance excitation and inhibition.


Other related files
-------------------

Vm.out - Typical membrane potential from simplecell current injection.

pyr4_Vm.out, pyr4a_Vm.out - Membrane potential from 0.5 nA injection to
soma of symmetric and asymmetric layer 4 pyramidal cell models.

spike_times.txt - Sample output for a raster plot, produced by raster_data.g

raster_data.g - A GENESIS 2 script to generate sample spike time data for
rasterplot.py.	It creates an array of 128 unconnected single compartment
cells based on basic-cell.p.  The setrandfield command is used to provide
injection randomly distributed from 0.27 to 0.33 nA.  It uses XODUS
graphics (which is optional) and some features of the table object
that have not yet been implemented in G3 to produce the output file
"spike_times.txt".

spike_freq_HD2500-11p.txt - Output of network simulation run HD2500-11p
    for average spike frequency of each row vs. time.

basic-cell.p -  The cell parameter file for the single compartment neuron.

BUGS and "features"
-------------------

Under Fedora 12 Linux, the scripts plotVm.py and rasterplot.py produce the
warning message:

/usr/lib64/python2.6/site-packages/matplotlib/backends/backend_gtk.py:621:
DeprecationWarning: Use the new widget gtk.Tooltip
  self.tooltips = gtk.Tooltips()

G3Plot.py does not produce this warning, but does not show the (x,y)
coordinates of the cursor in the Navigation Toolbar.  This is a very handy
feature of plotVm.py, when measuring action potential times and amplitudes.

Note that G3Plot uses the Matplotlib backend API for embedding in wxPython,
matplotlib.backends.backend_wxagg NavigationToolbar2WxAgg.  The other
scripts, which do not use wxPython, use matplotlib.pyplot.figure, which has
the Toolbar built in.  Possibly, there is a setting to enable this feature
hidden somewhere in NavigationToolbar2WxAgg.

Dave Beeman
Mon May 24 14:45:35 MDT 2010
