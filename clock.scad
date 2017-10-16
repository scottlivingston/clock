use <ring.scad>;



gearD = 28;
color([1,0,0]) translate([0,0,30]) cylinder(d=gearD, h=2);







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





//MOTOR AND MOUNTING PLATE
motorAssembly();

module motorAssembly() {
  union() {
    for (i=[0:3]) {
      rotate(i*90) translate([15,-3.5,0]) cube([20,7,2]);
    }
    ring(79,65,2, 100);
    ring(33,20,2, 100);
    rotationAmount = 25;
    translate([-20,5,0]) rotate(rotationAmount) motorWithMounts();
    translate([20,-5,0]) rotate(180+rotationAmount) motorWithMounts();
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
  color([0.5,1,1,0.5]) translate([0,8,20]) cylinder(d=gearD, h=2);
}
