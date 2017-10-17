use <ring.scad>;

gearD = 28;







//HANDS
handWidth = 8;
handLength = 38;
handThickness = 2;
handFn = 30;
blockSize = 30;

outerClockHand();
innerClockHand();

module outerClockHand() {
  union() {
    ring(handWidth, handWidth-2, blockSize, handFn);
    translate([0,0,-blockSize]) ring(handWidth, handWidth-2, blockSize, handFn);
    translate([0,0,-blockSize]) rotate(180) clockHand();
  }
}
module innerClockHand() {
  union() {
    $fn = handFn;
    innerHandWidth = handWidth - 2.5;
    ring(innerHandWidth, innerHandWidth-2, 34, handFn);
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
    $fn = handFn;
    translate([0,-handWidth/2,0]) cube([handLength,handWidth,handThickness]);
    cylinder(h=handThickness, d=handWidth);
  }
}


//difference() {
//  translate([-3.5,0,0]) rotate([0,90,0]) ring(78,76,7, 100);
//  translate([-5,-50,-100]) cube([10,100,100]);
//}


//MOTOR AND MOUNTING PLATE
motorAssembly();
color([1,0,0,0.2]) translate([0,0,30]) cylinder(d=gearD, h=2);

module motorAssembly() {
  ringWidth = 7;
  outterRingD = 72;
  innerRingD = 26;
  bracketHeight = 2;
  ringFn = 100;
  crosshairTranslate = (innerRingD/2);
  crosshairL = outterRingD/2 - innerRingD/2;
  difference() {
    union() {
      for (i=[0:2]) {
        rotate(i*180+90) translate([crosshairTranslate,-ringWidth/2,0]) cube([crosshairL,ringWidth,2]);
      }
      difference() {
        $fn = 40;
        holderH = 14;
        union() {
          translate([-outterRingD/2,-ringWidth/2,0]) cube([outterRingD,ringWidth,2]);
          cylinder(d=10.5, h=holderH);
        }
        translate([0,0,-1]) cylinder(d=8.5, h=holderH+2);
      }
      
      ring(outterRingD+ringWidth, outterRingD-ringWidth, bracketHeight, ringFn);
      ring(innerRingD+ringWidth, innerRingD-ringWidth, bracketHeight, ringFn);
      
      rotationAmount = 25;
      translate([-20,5,0]) rotate(rotationAmount) motorWithMounts();
      translate([20,-5,0]) rotate(180+rotationAmount) motorWithMounts();
    }
    for (i=[0:3]) {
      rotate((i*90)+45) translate([0,outterRingD/2,-1]) cylinder(d=3, h=4, $fn=20);
      if (i%2 == 1) {
        rotate((i*90)) translate([0,innerRingD/2,-1]) cylinder(d=3, h=4, $fn=20);
      }
    }
  } 
}
module motorWithMounts() {
  mountArms();
  translate([0,0,4]) motor();
}
module mountArms() {
  translate([17.5, 0,0]) motorMountArm();
  translate([-17.5,0,0]) motorMountArm();
}
module motorMountArm() {
  difference() {
    $fn=20;
    cylinder(h=22, d=6);
    translate([0,0,4]) cylinder(h=22, d=3);
  }
}
module motor() {
  color([1,1,1,0.2]) import("motor.stl");
  color([0.5,1,1,0.2]) translate([0,8,20]) cylinder(d=gearD, h=2);
}
