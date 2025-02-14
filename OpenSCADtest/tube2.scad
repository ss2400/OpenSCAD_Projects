//
// NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/sweep.scad>
use <NopSCADlib/utils/maths.scad>
use <NopSCADlib/utils/bezier.scad>
use <list-comprehension-demos/extrusion.scad>

//K_points = [[0, 5, 0], [ 2, 5, 0],  [2, 2, 0], [10, 2, 0], [10, 0, 0], [0, 0, 0]];
K_points = [[12,10,0],
            [10,12,0],
            [0,12,0],
            [-10,12,0],
            [-12,10,0],
            [-12,0,0],
            [-12,-10,0],
            [-10,-12,0],
            [0,-12,0],
            [10,-12,0],
            [12,-10,0],
            [12,0,0],
            [12,10,0]];
//L_points = K_points;
L_points = bezier_path(K_points, steps=100);
                                        
rad = 90;
loop = circle_points(rad, $fn = 180);

loop_x = transform_points(loop, rotate([90, -90, $t * 360]));

loop_y = transform_points(loop, rotate([0, -90, $t * 360]));

loop_z = transform_points(loop, rotate([$t * 360, 0, 0]));

!sweep(loop_z, L_points, loop = true);

sweep(loop_x, L_points, loop = true);

sweep(loop_y, L_points, loop = true);


knot = [ for(i=[0:.2:359])
         [ (19*cos(3*i) + 40)*cos(2*i),
           (19*cos(3*i) + 40)*sin(2*i),
            19*sin(3*i) ] ];

sweep(knot, L_points, loop = true);

p = transform_points([[0,0,0], [20,0,5], [10,30,4], [0,0,0], [0,0,20]], scale(10));
n = 100;
path = bezier_path(p, n);

rotate(45) sweep(path, circle_points(5, $fn = 64));