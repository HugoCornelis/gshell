//genesis - simplenet0.g
/*======================================================================

  RSnet.g is a customizeable script for creating a network of simplified
  Regular Spiking neocortical neurons with local excitatory connections.
  The simulation script is analyzed and explained in the GENESIS Neural
  Modeling Tutorials (http://www.genesis-sim.org/GENESIS/Tutorials/)

  This version RSnet2.g has been reorganized and modularized for
  eventual use under GENESIS 3.

  ======================================================================*/

str script_name = "network-4x4-steady.g"
str RUNID = "4x4_refract_004"	    // default ID string for output file names

int connect_network = 1	 // Set to 0 for debugging with unconnected cells
int write_asc_header = 1 // write a header to the output file with params
                         // not used in this version

/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "RScell.p"  // name of the cell parameter file
str cellname = "/cell"     // name of the root element of the cell
str synpath = "soma/Ex_channel" // compartment-name/synchan-name

str net_efile = "RSnet_Vm"  // filename prefix for netview data

float tmax = 0.2		// simulation time

float dt = 20e-6		// simulation time step
setclock 0 {dt}           // Main simulation clock
float out_dt = 0.0002
setclock 1 {out_dt}       // ascii file output clock

int NX = 4  // number of cells = NX*NY
int NY = 4

/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   For details of the createmap and volumeconnect syntax and RSnet model
   implementation, see:

   http://www.genesis-sim.org/GENESIS/UGTD/Tutorials/genprog/net-tut.html

*/

float SEP_X = 0.001 // 1 mm
float SEP_Y = 0.001


/* parameters for synaptic connections */

float syn_weight = 10 // synaptic weight, effectively multiplies gmax

// Typical conduction velocity for myelinated pyramidal cell axon
float cond_vel = 0.5 // m/sec
// With these separations, there is 2 msec delay between nearest neighbors
float prop_delay = SEP_X/cond_vel

float gmax = 1.5e-9
// float gmax = 50e-9

/* parameters for injection pulse */

// index of middle cell (or approximately, if NX, NY are even)

int InjCell = 0  // default current injection point
// In this case, it was set to match the G-3 script
// rsnet-4x4-volumeconnect-refract010-db

float injcurrent = 1.0e-9

// float pulse_width = 0.05 // 50 msec
float pulse_width = {tmax}
// for constant stimulation, use pulse_width >= tmax
float pulse_delay = 0
float pulse_interval = 1


// =============================
//   Function definitions
// =============================

function set_weights(weight)
    float weight
    syn_weight = weight
    volumeweight /RSnet/cell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
   float delay
   prop_delay = delay
   volumedelay /RSnet/cell[]/soma/spike -fixed {delay}
//   volumedelay /network/cell[]/soma/spike -radial {cond_vel}
end

function do_network_out
    create asc_file /RSnet_out
    str filename = {net_efile}  @ "_" @ {RUNID} @ ".txt"
    setfield /RSnet_out leave_open 1 flush 0 filename {filename}
    // setfield /RSnet_out float_format %.3g
    str name
    foreach name ({getelementlist /RSnet/cell[]/soma})
        addmsg {name} /RSnet_out SAVE Vm
    end
    useclock /RSnet_out 1
end

// Avoid use of a pulsgen to provide a pulse of injection

// In this case just do a normal injection and run
function pulse_hack
        setfield /RSnet/cell[{InjCell}]/soma inject {injcurrent}
        step {tmax} -time
end


function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{tmax}
    echo "RUNID = " {RUNID}
    pulse_hack
end

//=============================================================
//    Functions to set up the network
//=============================================================

function make_prototypes

  /* Step 1: Assemble the components to build the prototype cell under the
     neutral element /library.	This is done by including "prododefs.g"
     before using the function make_prototypes.
  */

// Now /library contains prototype channels, compartments, spikegen

  /* Step 2: Create the prototype cell specified in 'cellfile', using readcell.
     This should set up the apropriate synchans in specified compartments,
     with a spikegen element "spike" attached to the soma.  This will be
     done in /library, where it will be available to be copied into a network
  */

  readcell {cellfile} /library/cell
  setfield /library/cell/{synpath} gmax {gmax}
  setfield /library/cell/{synpath} Ek 0 // more realistic reversal potential

//  Change to a smaller value than the default 0.010 sec abs_refract
  setfield /library/cell/soma/spike thresh 0  abs_refract 0.004  output_amp 1
end

function make_network

  /* Step 3 - make a 2D array of cells with copies of /library/cell */
  // usage: createmap source dest Nx Ny -delta dx dy [-origin x y]

  /* There will be NX cells along the x-direction, separated by SEP_X,
     and  NY cells along the y-direction, separated by SEP_Y.
     The default origin is (0, 0).  This will be the coordinates of cell[0].
     The last cell, cell[{NX*NY-1}], will be at (NX*SEP_X -1, NY*SEP_Y-1).
  */
  create neutral /RSnet
  createmap /library/cell /RSnet {NX} {NY} -delta {SEP_X} {SEP_Y}
end // function make_network

function connect_cells
  /* Step 4: Now connect each cell to the four nearest neighbors.  Although
     the network is two-dimensional, the more general volumeconnect command
     is used here instead of planarconnect.
     Usage:
   
     volumeconnect source-path destination-path
         [-relative]
         [-sourcemask {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-sourcehole {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-destmask   {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-desthole   {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-probability p]
   */

  /* Connect each source spike generator to target synchans within the
     specified range.  Set the ellipse axes or box size just higher than the
     cell spacing, to be sure cells are included.  To connect to nearest
     neighbors and the 4 diagonal neighbors, use a box:
       -destmask box {-SEP_X*1.01} {-SEP_Y*1.01} {SEP_X*1.01} {SEP_Y*1.01}
     For all-to-all connections with a 10% probability, set both the sourcemask
     and the destmask to have a range much greater than NX*SEP_X using options
       -destmask box -1 -1  1  1 \
       -probability 0.1
     Set desthole to exclude the source cell, to prevent self-connections.
  */

  float SEP_Z = 1.0e-6 // give it a tiny z range in case of round off errors

  volumeconnect /RSnet/cell[]/soma/spike /RSnet/cell[]/{synpath} \
    -relative \	    // Destination coordinates are measured relative to source
    -sourcemask box -1 -1 -1 1 1 1 \   // Larger than source area ==> all cells
    -destmask ellipsoid 0 0 0 {SEP_X*1.2}  {SEP_Y*1.2} {SEP_Z*0.5} \
    -desthole box {-SEP_X*0.5} {-SEP_Y*0.5} {-SEP_Z*0.5} \
         {SEP_X*0.5} {SEP_Y*0.5} {SEP_Z*0.5} \
    -probability 1.1	// set probability > 1 to connect to all in destmask


  /* Step 5: Set the axonal propagation delay and weight fields of the target
     synchan synapses for all spikegens.  To scale the delays according to
     distance instead of using a fixed delay, use
       volumedelay /network/cell[]/soma/spike -radial {cond_vel}
     and change dialogs in graphics.g to set cond_vel.  This would be
     appropriate when connections are made to more distant cells.  Other
     options of planardelay and planarweight allow some randomized variations
     in the delay and weight.
  */

  set_delays {prop_delay}
  set_weights {syn_weight}
end // function connect_cells

//===============================
//    Main Simulation Section
//===============================

setclock  0  {dt}		// set the simulation clock


// create prototype definitions used by the cell parameter file 'cellfile'
include protodefs.g  // This creates /library with the cell components

make_prototypes // This adds the prototype cells to /library

make_network    // Copy cells into network layers

if (connect_network)
    connect_cells   // Make the network connections
end

do_network_out

reset

echo "Network of "{NX}" by "{NY}" cells with separations "{SEP_X}" by "{SEP_Y}

step_tmax
