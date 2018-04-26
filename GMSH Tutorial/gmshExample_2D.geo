// Gmsh project created on Fri Oct  6 11:34:10 2017
circleSize = 1;
edgeSize = 4;
//+
Point(1) = {0, 0, 0, edgeSize};
//+
Point(2) = {100, 0, 0, edgeSize};
//+
Point(3) = {100, 100, 0, edgeSize};
//+
Point(4) = {0, 100, 0, edgeSize};
//+
Point(5) = {50, 50, 0, circleSize};
//+
Point(6) = {25, 50, 0, circleSize};
//+
Line(1) = {1, 4};
//+
Line(2) = {4, 3};
//+
Line(3) = {3, 2};
//+
Line(4) = {2, 1};
//+
Circle(5) = {6, 5, 6};
//+
Physical Line("1") = {1};
//+
Physical Line("2") = {2};
//+
Physical Line("3") = {3};
//+
Physical Line("4") = {4};
//+
Physical Line("5") = {5};
//+
Line Loop(1) = {1, 2, 3, 4};
//+
Line Loop(2) = {5};
//+
Plane Surface(1) = {1, 2};
//+
Physical Surface(6) = {1};
