use <ring.scad>;
use <parametric_involute_gear_v5.0.scad>; //from https://www.thingiverse.com/thing:3575

// assembly will render the whole assembly positioned together. This makes it easy
// to change things about the device and see the changes to the whole system
assembly();

//each individual part can be rendered at the center of the screen using their 
//individule modules
//outerClockHand();
//innerClockHand();
//motorAssembly();
//driveGear("motor"); //need 2 of these
//driveGear("inner");
//driveGear("outer");
//outerClockHandLockWasher();

//debugging
//hollowSquare(8,8,5);
//lockCylinder(8,7,7,5);

//Globals
//Show the motors or not, really used for final render.
renderMotors = true;
//all screw holes will fit this size.
screwHoles = 3.08; //M3
//to compensate for the expansion or contraction of the plastic
expansion = 0.2; 
expansion2 = expansion * 2;
expansion4 = expansion * 4;
//Generic default resolution for circles.
$fa = 1;
//Used for hole precision, needed to be high to allow for smooth spinning of the hands.
smallFn = 64;

//Hands
handWidth = 8;
innerHandWidth = handWidth - 2 - expansion4;
handLength = 38;
handThickness = 2;
innerHandZOffset = 3;
blockSize = 30;
gearD = 28;

//DONT CHANGE. CONSTANTS FOR REUSE, BUT PROBABLY NOT EDITING
motorMountSpacing = 35;
rotationAmount = 25;
motorXOffset = 20;
motorYOffset = 5;
y = sin(rotationAmount)*motorMountSpacing;
x = cos(rotationAmount)*motorMountSpacing;
innerX = (-x/2)+motorXOffset;
innerY = (-y/2)-motorYOffset;
outerX = (-x/2)+motorXOffset + x;
outerY = (-y/2)-motorYOffset + y;
outerRingRadius = sqrt(pow(outerX,2) + pow(outerY,2));
innerRingRadius = sqrt(pow(innerX,2) + pow(innerY,2));
outerRingD = outerRingRadius * 2;
innerRingD = innerRingRadius * 2;
ringWidth = 7;
bracketHeight = 2;
//Gear
hub_thickness = 3;

module assembly() {
  //clock hands
  translate([0,0,-blockSize]) rotate(180) outerClockHand();
  translate([0,0,-blockSize-innerHandZOffset]) innerClockHand();
  translate([0,0,14.2]) outerClockHandLockWasher();
  //mounting plate
  motorAssembly();
  //ledMount();
  //gear
  color([0,0.5,0,0.2]) translate([0,0,blockSize-hub_thickness]) driveGear("outer");
  color([0.5,0.5,0.5,0.5]) translate([0,0,blockSize+hub_thickness]) rotate([0,180,0]) driveGear("inner");
}

//     ____ _            _      _   _                 _
//    / ___| | ___   ___| | __ | | | | __ _ _ __   __| |___ 
//   | |   | |/ _ \ / __| |/ / | |_| |/ _` | '_ \ / _` / __|
//   | |___| | (_) | (__|   <  |  _  | (_| | | | | (_| \__ \
//    \____|_|\___/ \___|_|\_\ |_| |_|\__,_|_| |_|\__,_|___/
//
module outerClockHand() {
  $fn = smallFn;
  union() {
    //upper shaft
    difference() {
      difference() {
        b = handWidth-1;
        h = blockSize*2-hub_thickness;
        translate([0,0,blockSize]) ring(handWidth, handWidth-2, blockSize);
        translate([0,0,h]) hollowSquare(b,b,hub_thickness+1);
      }
      //lock cutout
      translate([0.75,0,44.2]) hollowSquare(handWidth,handWidth-1,1);
    }

    //lower shaft
    ring(handWidth, handWidth-2, blockSize);
    difference() {
      clockHand();
      translate([0,0,-1]) cylinder(d=handWidth-2, h=handThickness+2);
    }
    
  }
}
module outerClockHandLockWasher() {
  difference() {
    w = handWidth-1+expansion4;
    c = handWidth-1.5+expansion4;
    hollowSquare(w,w,1,2);
    translate([-(c+0.25),-c/2,-1]) cube(c);
  }
}
module innerClockHand() {
  $fn = smallFn;
  union() {
    //upper shaft
    difference() {
      translate([0,0,blockSize+innerHandZOffset]) ring(innerHandWidth, innerHandWidth-2, 33);
      lockW = innerHandWidth-1;
      translate([0,0,blockSize*2+innerHandZOffset]) hollowSquare(lockW,lockW,hub_thickness+1);
    }
    //lower shaft
    cylinder(h=blockSize+innerHandZOffset, d=innerHandWidth);
    //spacing ring
    translate([0,0,2]) cylinder(h=innerHandZOffset-handThickness-0.3, d=handWidth);
    clockHand();
  }
}
module clockHand() {
  union() {
    translate([0,-handWidth/2,0]) cube([handLength,handWidth,handThickness]);
    cylinder(h=handThickness, d=handWidth);
  }
}

//    __  __                   _   _               ____  _       _
//   |  \/  | ___  _   _ _ __ | |_(_)_ __   __ _  |  _ \| | __ _| |_ ___ 
//   | |\/| |/ _ \| | | | '_ \| __| | '_ \ / _` | | |_) | |/ _` | __/ _ \
//   | |  | | (_) | |_| | | | | |_| | | | | (_| | |  __/| | (_| | ||  __/
//   |_|  |_|\___/ \__,_|_| |_|\__|_|_| |_|\__, | |_|   |_|\__,_|\__\___|
//
module motorAssembly() {
  crosshairTranslate = (innerRingD/2);
  crosshairL = outerRingD/2 - innerRingD/2;
  difference() {
    union() {
      //start crosshair beams
      for (i=[0:2]) {
        rotate(i*180+90) translate([crosshairTranslate,-ringWidth/2,0]) cube([crosshairL,ringWidth,2]);
      }
      difference() {
        holderH = 14;
        $fn = smallFn;
        union() {
          //middle crosshair beam
          translate([-outerRingD/2,-ringWidth/2,0]) cube([outerRingD,ringWidth,2]);
          //hand holder outter
          cylinder(d=handWidth+2+expansion4, h=holderH);
        }
        //hand holder cutout
        translate([0,0,-1]) cylinder(d=handWidth+expansion*4, h=holderH+2);
      }
      //end crosshair beams
      
      //outer ring
      ring(outerRingD+ringWidth, outerRingD-ringWidth, bracketHeight);
      //inner ring
      ring(innerRingD+ringWidth, innerRingD-ringWidth, bracketHeight);

      //motor mounts.
      translate([-motorXOffset,motorYOffset,0]) rotate(rotationAmount) motorWithMounts("left");
      translate([motorXOffset,-motorYOffset,0]) rotate(180+rotationAmount) motorWithMounts();
    }
    
    //screw holes
    for (i=[0:3]) {
      $fn=smallFn;
      //outer screw holes
      rotate((i*90)+45) translate([0,outerRingD/2,-1]) cylinder(d=screwHoles, h=4);
      //inner screw holes
      if (i%2 == 1) {
        rotate((i*90)) translate([0,innerRingD/2,-1]) cylinder(d=screwHoles, h=4);
      }
    }
  } 
}

module ledMount() {
  translate([-3,-(outerRingD-innerRingD+ringWidth),0]) 
    rotate([90,0,90]) 
      rotate_extrude(angle=43, convexity = 2)
        translate([outerRingRadius, 0, 0])
          square([1,6]);
  translate([-3,0,0]) rotate([0,90,0]) ring(outerRingD+1,outerRingD-1,6);
  //translate([-3,-(outerRingD-innerRingD+ringWidth),0]) rotate([0,90,0]) ring(outerRingD+1,outerRingD-1,6);
}
module motorWithMounts(side) {
  mountArms();
  if (renderMotors) translate([0,0,4]) motor(side);
}
module mountArms() {
  translate([motorMountSpacing/2, 0,0]) motorMountArm();
  translate([-motorMountSpacing/2,0,0]) motorMountArm();
}
module motorMountArm() {
  difference() {
    $fn=smallFn;
    cylinder(h=22, d=6);
    translate([0,0,4]) cylinder(h=22, d=screwHoles);
  }
}
module hollowSquare(x, y, h, o=max(x,y)) {
  difference(){
    ox = o+x;
    oy = o+y;
    translate([-ox/2,-oy/2,0]) cube([ox, oy, h]);
    translate([-x/2,-y/2,-1]) cube([x, y, h+2]);
  }
}
module lockCylinder(d, x, y, h) {
  difference() {
    cylinder(d=d, h=h, $fn = smallFn);
    translate([0,0,-1]) hollowSquare(x, y, h+2, max(x,y));
  }
}
module driveGear(mount) {
  circular_pitch=195;
  number_of_teeth = 24;
  thickness = 2;
  if (mount == "inner") {
    compensatedHandWidth = innerHandWidth + expansion4;
    difference() {
      gear (circular_pitch = circular_pitch,
        number_of_teeth = number_of_teeth,
        gear_thickness = thickness,
        rim_thickness = thickness,
        hub_thickness = hub_thickness,
        hub_diameter = 10,
        bore_diameter = 0);
      lockW = compensatedHandWidth-1;
      translate([0,0,-1]) lockCylinder(compensatedHandWidth, lockW, lockW, hub_thickness+2);
    }
  } else if (mount == "outer") {
    compensatedHandWidth = handWidth + expansion4;
    difference() {
      gear (circular_pitch = circular_pitch,
        number_of_teeth = number_of_teeth,
        gear_thickness = thickness,
        rim_thickness = thickness,
        hub_thickness = hub_thickness,
        hub_diameter = 10,
        bore_diameter = 0);
      lockW = compensatedHandWidth-1;
      translate([0,0,-1]) lockCylinder(compensatedHandWidth, lockW, lockW, hub_thickness+2);
    }
  } else if (mount == "motor"){
    difference() {
      ht = 6;
      gear (circular_pitch = circular_pitch,
        number_of_teeth = number_of_teeth,
        gear_thickness = thickness,
        rim_thickness = thickness,
        hub_thickness = ht,
        hub_diameter = 7,
        bore_diameter = 0);
      translate([0,0,-1]) lockCylinder(5+expansion4, 5+expansion4, 3+expansion4, ht+2);
    }

  }
}
module motor(side) {
  if (side == "left") {
    color([0.5,1,1,0.2]) translate([0,8,29]) rotate([0,180,0]) driveGear("motor");
  } else {
    color([0.5,1,1,0.2]) translate([0,8,23]) driveGear("motor");
  }
  color([1,1,1,0.5]) import("motor.stl");
}
