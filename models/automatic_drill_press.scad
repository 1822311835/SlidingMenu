// Automatic drill press model (OpenSCAD)
// Simple block-based approximation: base, column, head, spindle

// Base
translate([-50, -30, 0]) cube([100, 60, 10]);
// Column
translate([-10, -10, 10]) cube([20, 20, 70]);
// Head
translate([-30, -20, 80]) cube([60, 40, 20]);
// Spindle
translate([-2, -2, 60]) cube([4, 4, 20]);

// Export this to STL in OpenSCAD (`File -> Export -> Export as STL`) to get a higher-quality mesh.
