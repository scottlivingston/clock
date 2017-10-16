module ring(d1, d2, h, fn = 20) {
  difference() {
  	$fn = fn;
    cylinder(d = d1, h = h);
    translate([ 0, 0, -1 ]) cylinder(d = d2, h = h+2);
  }
}
