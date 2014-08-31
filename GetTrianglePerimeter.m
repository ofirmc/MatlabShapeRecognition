function [ TrianglePerimeter ] = GetTrianglePerimeter( P1, P2, P3 )

SideA = sqrt(power(P2(1, 1) - P1(1, 1), 2) + power(P2(1, 2) - P1(1, 2), 2));
SideB = sqrt(power(P1(1, 1) - P3(1, 1), 2) + power(P1(1, 2) - P3(1, 2), 2));
SideC = sqrt(power(P3(1, 1) - P2(1, 1), 2) + power(P3(1, 2) - P2(1, 2), 2));
TrianglePerimeter = SideA + SideB + SideC;

end