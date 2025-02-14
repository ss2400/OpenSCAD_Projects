
$pp1_colour = "BurlyWood";
$pp2_colour = "SlateGray";

include <NopSCADlib/core.scad>
include <NopSCADlib/lib.scad>

include <OpenSCAD_Libs/models/096OledDim.scad>
use <OpenSCAD_Libs/models/096Oled.scad>
use <OpenSCAD_Libs/096_oled_mnt.scad>
use <OpenSCAD_Libs/nano_mnt.scad>
use <OpenSCAD_Libs/hx711_mnt.scad>
use <OpenSCAD_Libs/models/batteries.scad>
use <OpenSCAD_Libs/mbox.scad>

/* Box dimensions */
Length = 110;
Width = 70;
Height = 42;
Thick = 2.4;
m = 0.4;

/* Arduino dimensions */
NanoPosX = 10;
NanoPosY = 10;
NanoPosZ = Thick-0.01;
NanoHeight = 6;

/* Amplifier dimensions */
HX711PosX = 60;
HX711PosY = 10;
HX711PosZ = Thick-0.01;
HX711Height = 6;

/* Display dimensions */
OledPosX = Length-Thick*2-m/2;  // Backside of face
OledPosY = Width/2;
OledPosZ = Height/2;

/* Battery dimensions */
BattPosX = 30;
BattPosY = 42;
BattPosZ = Thick-0.01;
BattLength = 60;
BattWidth  = 17;
BattHeight = 30;
BattPost = 6;
BattSlop = 2;

/* Switch dimensions */
SwPosX = Length-Thick*2-m/2; // Backside of face
SwPosY = Width*0.2;
SwPosZ = Height*0.62;
SwDia = 6.5;

/* Connector dimensions */
ConnPosX = Thick*1.5+m/2; // Backside of face (and a touch back)
ConnPosY = Width*0.7;
ConnPosZ = Height*0.5;
ConnDia = 15.8;
ConnFlat = 14.8;

box1 = mbox(name="box1", thick=Thick, vent=0, vent_w=1.5, filet=2, tolerance=m, size=[Length, Width, Height]);

module box1_bpanel_stl() {
  mbox_bpanel(box1) {
    bpanel_internal_additions();
    bpanel_holes();
    bpanel_external_additions();
  };
}

module box1_fpanel_stl() {
  mbox_fpanel(box1) {
    fpanel_internal_additions();
    fpanel_holes();
    fpanel_external_additions();
  };
 }
 
 module box1_bshell_stl() {
  mbox_bshell(box1) {
    bshell_internal_additions();
    bshell_holes();
    bshell_external_additions();
  };
}

module box1_tshell_stl() {
  mbox_tshell(box1) {
    //tshell_internal_additions();
    //tshell_holes();
    //tshell_external_additions();
  };
}

module bpanel_internal_additions() {
}

module bpanel_holes() {
    // Connector cutout
    translate([ConnPosX, ConnPosY, ConnPosZ])
      rotate([90,0,90])
        intersection() {
          cylinder(d=ConnDia, h=Thick*2, center=true);
          cube([ConnFlat, ConnDia, Thick*2], center=true);
        }
}

module bpanel_external_additions() {
}

module fpanel_internal_additions() {
  // OLED posts    
  stl_colour(pp2_colour) {
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([90,0,90])
        oled_mount(type=DORHEA);
  }
}

module fpanel_holes() {
  // OLED cutout
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([90,0,90])
      oled_cutout(type=DORHEA);
        
  // Switch cutout
  translate([SwPosX, SwPosY, SwPosZ])
    rotate([90,0,90])
      cylinder(d=SwDia, h=Thick*2);
  // Switch key
  translate([SwPosX, SwPosY, SwPosZ+6.5])
    rotate([90,0,90])
      cylinder(d=2.5, h=2);
}

module fpanel_external_additions() {
}

module bshell_internal_additions() {
  // Nano Mount
  translate([NanoPosX, NanoPosY, NanoPosZ]) {
    stl_colour(pp1_colour) nano_mount(h=NanoHeight);
    %nano_component(h=NanoHeight);
    }

  // HX711 Mount
  translate([HX711PosX, HX711PosY, HX711PosZ]) {
    stl_colour(pp1_colour) hx711_mount(h=HX711Height);
    %hx711_component(h=HX711Height);
  }

  // Battery Box
  translate([BattPosX, BattPosY, BattPosZ]) {
    BattBox();
    translate([BattPost,BattPost/2+BattSlop,BattHeight-2])
      rotate([0,90,0])
        %9V();
  }
}

module bshell_holes() {
}

module bshell_external_additions() {
}

module BattBox() {
  stl_colour(pp1_colour) {
    translate([0, BattWidth*0.5+BattPost, 0])
      rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
    hull() {
      translate([BattLength*0.25, 0, 0])
        rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
        
      translate([BattLength*0.75, 0, 0])
        rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
    }
    translate([BattLength, BattWidth*0.5+BattPost, 0])
      rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
  }
}

module box_assembly() {
  assembly("box1") {
    explode(50, true) {
      render() box1_bpanel_stl();
      render() box1_fpanel_stl();
      render() box1_bshell_stl();
      render() box1_tshell_stl();
    }
  }
}

module main_assembly() {
  assembly("main") {
    // OLED Display
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([90,0,90])
        %DisplayModule(type=DORHEA, align=1, G_COLORS=true);
    
    // Toggle switch
    translate([SwPosX, SwPosY,SwPosZ])
      rotate([90,0,90])
        %toggle(CK7101,Thick);

    box_assembly();
  }
}

if($preview)
    main_assembly();

echo("Name: ",mbox_name(box1));
echo("Thickness: ", mbox_thick(box1));
echo("Vent: ", mbox_vent(box1));
echo("Vent width: ", mbox_ventW(box1));
echo("Filet: ", mbox_filet(box1));
echo("Tolerance: ", mbox_tolerance(box1));
echo("Length: ", mbox_length(box1));
echo("Width: ", mbox_width(box1));
echo("Height: ", mbox_height(box1));
