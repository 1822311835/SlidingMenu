// Parametric countersunk (flat) head screw - OpenSCAD
// Units: mm

$fn = 128; // circle resolution (higher = smoother)
thread_slices_per_turn = 96; // increase for smoother threads when rendering locally

// Default parameters (change via -D in command line or edit here)
major_d = 6;          // 公称直径 (mm)
pitch = 1.0;          // 螺距 (mm)
thread_length = 20;   // 螺纹长度 (mm)
thread_height = 0.5;  // 近似牙高 (mm)

head_diameter = 12;   // 沉头直径 (mm)
head_angle_deg = 90;  // 沉角（包含角）
top_thickness = 0.6;  // 沉头顶部的平板厚度 (mm)

lead_in_len = 2;      // 导入倒角长度 (mm)

turns = thread_length / pitch;
shaft_root_d = major_d - 2*thread_height;
shaft_radius = shaft_root_d / 2;
thread_outer_r = major_d / 2;

// compute cone height from head_diameter and included angle
head_outer_r = head_diameter / 2;
head_half_angle = head_angle_deg / 2;
head_height = head_outer_r / tan(head_half_angle * PI / 180);

// Shaft (extends through head region so head unions cleanly)
module shaft(total_length) {
  translate([0,0,0])
    cylinder(h=total_length, r=shaft_radius, $fn=$fn);
}

// Thread made by linear_extrude with twist (approx triangular ridge)
module helical_thread() {
  base = thread_height * 2;
  tri_points = [
    [0, -base/2],
    [thread_height, 0],
    [0,  base/2]
  ];
  translate([thread_outer_r - thread_height, 0, 0])
    linear_extrude(height=thread_length, twist=turns*360, slices = ceil(turns*thread_slices_per_turn))
      polygon(points = tri_points);
}

// Lead-in chamfer (cone)
module lead_in() {
  translate([0,0,-lead_in_len])
    cylinder(h=lead_in_len, r1=thread_outer_r, r2=shaft_radius, $fn=$fn);
}

// Countersunk head: cone (with tip toward shaft) + thin top plate
module countersunk_head() {
  // place cone so its base (largest radius) is at z = thread_length
  translate([0,0, thread_length - head_height])
    // bottom radius r1 = 0 (tip), top radius r2 = head_outer_r
    // OpenSCAD cylinder: r1 = bottom, r2 = top
    cylinder(h = head_height, r1 = 0, r2 = head_outer_r, $fn=$fn);

  // flat top plate sitting on top of cone
  translate([0,0, thread_length])
    cylinder(h = top_thickness, r = head_outer_r, $fn=$fn);
}

// Build union: shaft + thread + head + lead-in
union() {
  // keep shaft a bit longer to fully intersect head
  shaft(thread_length + head_height + top_thickness);
  helical_thread();
  countersunk_head();
  lead_in();
}
