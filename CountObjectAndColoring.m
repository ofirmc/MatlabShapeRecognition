function [] = CountObjectAndColoring( Image )

[L, num] = bwlabel(Image, 8);
disp(num);
imagesc(L);

end