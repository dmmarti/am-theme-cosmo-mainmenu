////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// 10/11/2016 updated by DGM for the RetroPie Facebook group 
// Updated and enhanced to now include many new features and options
//
// Updated 9/08/2016 by omegaman                                                                      
// Attract-Mode "Robospin" layout. Thanks to verion for cleaning cab skins and to malfacine's for glogos                             
// Notes: Lots of changes...  
////////////////////////////////////////////////////////////////////////////////////////////////////////   





/////////////////////////////////////////////////////////////
//Options and modules
/////////////////////////////////////////////////////////////


class UserConfig {
</ label="Type of wheel", help="Select round wheel or vertical wheel", options="wheel,vert_wheel", order=1 /> enable_list_type="vert_wheel";
</ label="Select spinwheel art", help="The artwork to spin", options="marquee,wheel", order=2 /> orbit_art="wheel";
</ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=3 /> transition_ms="50"; 
</ label="Enable background animations", help="Enable background animations", options="Yes,No", order=4 /> enable_fanimate="No";  
</ label="Show character art", help="Show character at the left of the screen", options="Yes,No", order=5 /> enable_gcartart="Yes"; 
</ label="Show console art", help="Show consoles at the bottom of the screen", options="Yes,No", order=6 /> enable_gboxart="Yes";
</ label="Enable art animations", help="Enable box and cartidge art animations", options="Yes,No", order=7 /> enable_ganimate="Yes";
</ label="Select pointer", help="Select animated pointer", options="default,none", order=8 /> enable_pointer="default"; 
</ label="Enable game information", help="Show game information", options="Yes,No", order=9 /> enable_ginfo="No";
</ label="Enable text frame", help="Show text frame", options="Yes,No", order=10 /> enable_frame="No"; 
</ label="Enable random text colors", help=" Select random text colors.", options="Yes,No", order=11 /> enable_colors="No";
</ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=12 /> enable_static="Yes"; 
</ label="Mute Videos", help="Mute the sound of videos", options="Yes,No", order=13 /> sound="No";  
}  

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
//fe.layout.font="Roboto";

// modules
fe.load_module("fade");
fe.load_module( "animate" );





/////////////////////////////////////////////////////////
// Video Preview or static video if none available
///////////////////////////////////////////////////////
// remember to make both sections the same dimensions and size
/////////////////////////////////////////////////////////////////

// Video Preview or static video if none available
// remember to make both sections the same dimensions and size
if ( my_config["enable_static"] == "Yes" )
{
//adjust the values below for the static preview video snap
   const SNAPBG_ALPHA = 200;
   local snapbg=null;
   snapbg = fe.add_image( "static.mp4", flx*0.212, fly*0.31, flw*0.293, flh*0.38);
   snapbg.trigger = Transition.EndNavigation;
   snapbg.skew_y = 0;
   snapbg.skew_x = 0;
   snapbg.pinch_y = 0;
   snapbg.pinch_x = 0;
   snapbg.rotation = 0;
   snapbg.set_rgb( 155, 155, 155 );
   snapbg.alpha = SNAPBG_ALPHA;
}
 else
 {
 local temp = fe.add_text("", flx*0.092, fly*0.38, flw*0.226, flh*0.267 );
 temp.bg_alpha = SNAPBG_ALPHA;
 }

//create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = false;

//now position and pinch surface of snap
//adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.197, fly*0.31, flw*0.323, flh*0.38);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;

// mute the video
 if ( my_config["sound"] == "Yes" ){
     snap.video_flags = Vid.NoAudio;
 }



////////////////////////////////////////////
//Background
///////////////////////////////////
// Load background based up emulator
/////////////////////////////////////////

local b_art = fe.add_image("backgrounds/[DisplayName]", 0, 0, flw, flh );
b_art.alpha=255;

local flyer = fe.add_artwork("flyer", flx*0.0, fly*0.0 flw*1, flh*1 );

if ( my_config["enable_fanimate"] == "Yes" )
{
	local flyer_shrink_cfg = {
    	when = Transition.ToNewSelection,
    	property = "scale",
    	start = 1.4,
    	end = 1.0,
    	time = 1000
	}

	animation.add( PropertyAnimation( flyer, flyer_shrink_cfg ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//Cartart
/////////////////////////////////////////////
// Cartridge art to display, uses the emulator.cfg path for cartart image location
//////////////////////////////////////////////////////////////////////////////////////////////////


if ( my_config["enable_gcartart"] == "Yes" )
{
	local cartart = fe.add_artwork("cartart", flx*0.0, fly*0.0, flw*1, flh*1 );

	if ( my_config["enable_ganimate"] == "Yes" )
	{
		local move_transition1 = {
			when = Transition.ToNewSelection,
			property = "x",
			start = flx*-2,
			end = flx*0.0,
			time = 1500
		}

	animation.add( PropertyAnimation( cartart, move_transition1 ) );
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//Fanart
/////////////////////////////////////////////
// Fan art to display, uses the emulator.cfg path for fanart image location
/////////////////////////////////////////////////////////////////////////////////////////////

if ( my_config["enable_gboxart"] == "Yes" )
{
    local fanart = fe.add_artwork("fanart", flx*0, fly*0 flw*1, flh*1 );


    if ( my_config["enable_ganimate"] == "Yes" )
    {
        local move_transition1 = {
        when = Transition.ToNewSelection,
        property = "y",
        start = flx*2,
        end = flx*0.0, 
        time = 2000
        }

    animation.add( PropertyAnimation( fanart, move_transition1 ) );
    }
}


/////////////////////////////////////////////////////////
// Cabinet image
///////////////////////////////////////////////////////
// for wheel art and background
/////////////////////////////////////////////////////////////////


// Cabinet image used for displaying the conosle and controller image
if ( my_config["enable_list_type"] == "wheel" )
{
 local cab = fe.add_image( "wheel_art.png", 0, 0, flw, flh );
}

if ( my_config["enable_list_type"] == "vert_wheel" )
{
 local cab = fe.add_image( "wheel_vert.png", 0, 0, flw, flh );
}


///////////////////////////////////////
// Wheels
///////////////////////////////////////
// The following section sets up what type and wheel and displays the users choice
///////////////////////////////////////


//This enables vertical art instead of default wheel
if ( my_config["enable_list_type"] == "vert_wheel" )
{
fe.load_module( "conveyor" );
  local wheel_x = [ flx*0.78, flx*0.78, flx*0.78, flx*0.78, flx*0.78, flx*0.78, flx*0.76, flx*0.78, flx*0.78, flx*0.78, flx*0.78, flx*0.78, ]; 
  local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
  local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.22, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
  local wheel_a = [  80,  80,  80,  80,  150,  150, 255,  150,  150,  80,  80,  80, ];
  local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.15,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
  local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 8;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
	}
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

local conveyor = Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 50;
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}
 
if ( my_config["enable_list_type"] == "wheel" )
{
fe.load_module( "conveyor" );
local wheel_x = [ flx*0.80, flx*0.795, flx*0.756, flx*0.725, flx*0.70, flx*0.68, flx*0.64, flx*0.68, flx*0.70, flx*0.725, flx*0.756, flx*0.76, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.17,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
local wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
local num_arts = 8;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
	}
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
wheel_entries.insert( num_arts/2, WheelEntry() );

local conveyor = Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 50;
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}


/////////////////////////////////////////////////////////
// Pointers
/////////////////////////////////////////////////////////////////


// The following sets up which pointer to show on the wheel
//property animation - wheel pointers

//default pointer

if ( my_config["enable_pointer"] == "default") 
{
local point = fe.add_image("pointers/default.png", flx*0.88, fly*0.34, flw*0.2, flh*0.35);

local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 110,
    end = 255,
    time = 300
}
animation.add( PropertyAnimation( point, alpha_cfg ) );

local movey_cfg = {
    when = Transition.ToNewSelection,
    property = "y",
    start = point.y,
    end = point.y,
    time = 200
}
animation.add( PropertyAnimation( point, movey_cfg ) );

local movex_cfg = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*0.83,
    end = point.x,
    time = 200	
}	
animation.add( PropertyAnimation( point, movex_cfg ) );
}

//no pointer

if ( my_config["enable_pointer"] == "none") 
{
 local point = fe.add_image( "", 0, 0, 0, 0 );
}


/////////////////////////////////////////////////////////
// Game information and text frame
/////////////////////////////////////////////////////////////////


// Game information text box at bottom of screen
//add frame to make text standout 
if ( my_config["enable_frame"] == "Yes" )
{
local frame = fe.add_image( "frame.png", 0, fly*0.94, flw, flh*0.06 );
frame.alpha = 255;
}
// Game information to show inside text box frame
if ( my_config["enable_ginfo"] == "Yes" )
{
//Year text info
local texty = fe.add_text("[Year]", flx*0.18, fly*0.942, flw*0.13, flh*0.05 );
texty.set_rgb( 255, 255, 255 );
//texty.style = Style.Bold;
//texty.align = Align.Left;

//Title text info
local textt = fe.add_text( "[Title]", flx*0.315, fly*0.955, flw*0.6, flh*0.028  );
textt.set_rgb( 225, 255, 255 );
//textt.style = Style.Bold;
textt.align = Align.Left;
textt.rotation = 0;
textt.word_wrap = true;

//display filter info
local filter = fe.add_text( "[ListFilterName]: [ListEntry]-[ListSize]  [PlayedCount]", flx*0.7, fly*0.962, flw*0.3, flh*0.022 );
filter.set_rgb( 255, 255, 255 );
//filter.style = Style.Italic;
filter.align = Align.Right;
filter.rotation = 0;


/////////////////////////////////////////////////////////
// Random color text
/////////////////////////////////////////////////////////////////


// random number for the RGB levels
if ( my_config["enable_colors"] == "Yes" )
{
function brightrand() {
 return 255-(rand()/255);
}

local red = brightrand();
local green = brightrand();
local blue = brightrand();

// Color Transitions
fe.add_transition_callback( "color_transitions" );
function color_transitions( ttype, var, ttime ) {
 switch ( ttype )
 {
  case Transition.StartLayout:
  case Transition.ToNewSelection:
  red = brightrand();
  green = brightrand();
  blue = brightrand();
  //listbox.set_rgb(red,green,blue);
  texty.set_rgb (red,green,blue);
  textt.set_rgb (red,green,blue);
  break;
 }
 return false;
 }
}}




