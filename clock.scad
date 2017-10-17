use <ring.scad>;

//Globals
//Show the motors or not, really used for final render.
renderMotors = false;
//all screw holes will fit this size.
screwHoles = 3.08; //M3
//Generic default resolution for circles.
$fa = 1;
//Used for hole precision, needed to be high to allow for smooth spinning of the hands.
smallFn = 64;

//Hands
handWidth = 8;
handLength = 38;
handThickness = 2;
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


//clock hands
outerClockHand();
innerClockHand();
//mounting plate
motorAssembly();
//gear
color([1,0,0,0.2]) translate([0,0,30]) cylinder(d=gearD, h=2);

//     ____ _            _      _   _                 _
//    / ___| | ___   ___| | __ | | | | __ _ _ __   __| |___ 
//   | |   | |/ _ \ / __| |/ / | |_| |/ _` | '_ \ / _` / __|
//   | |___| | (_) | (__|   <  |  _  | (_| | | | | (_| \__ \
//    \____|_|\___/ \___|_|\_\ |_| |_|\__,_|_| |_|\__,_|___/
//
module outerClockHand() {
  $fn = smallFn;
  union() {
    ring(handWidth, handWidth-2, blockSize);
    translate([0,0,-blockSize]) ring(handWidth, handWidth-2, blockSize);
    translate([0,0,-blockSize]) rotate(180) clockHand();
  }
}
module innerClockHand() {
  $fn = smallFn;
  union() {
    innerHandWidth = handWidth - 2.5;
    ring(innerHandWidth, innerHandWidth-2, 34);
    translate([0,0,-blockSize-3])
      cylinder(h=blockSize+3, d=innerHandWidth);
    translate([0,0,-blockSize-1])
      cylinder(h=1, d=handWidth);
    translate([0,0,-blockSize-3])
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
  ringWidth = 7;
  outerRingD = outerRingRadius * 2;
  innerRingD = innerRingRadius * 2;
  bracketHeight = 2;
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
          translate([-outerRingD/2,-ringWidth/2,0]) cube([outerRingD,ringWidth,2]);
          cylinder(d=handWidth+2.5, h=holderH);
        }
        translate([0,0,-1]) cylinder(d=handWidth+0.5, h=holderH+2);
      }
      //end crosshair beams
      
      //outer ring
      ring(outerRingD+ringWidth, outerRingD-ringWidth, bracketHeight);
      //inner ring
      ring(innerRingD+ringWidth, innerRingD-ringWidth, bracketHeight);
      
      //motor mounts.
      translate([-motorXOffset,motorYOffset,0]) rotate(rotationAmount) motorWithMounts();
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
module motorWithMounts() {
  mountArms();
  if (renderMotors) translate([0,0,4]) motor();
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
module motor() {
  color([1,1,1,0.2]) import("motor.stl");
  color([0.5,1,1,0.2]) translate([0,8,20]) cylinder(d=gearD, h=2);
}
