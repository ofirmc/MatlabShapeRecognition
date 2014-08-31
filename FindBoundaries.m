function [B,L] = FindBoundaries(Image)

%Trace region boundaries in binary image
%'noholes' will accelerate the processing by preventing bwboundaries from searching for inner contours
%L = label matrix
%B = boundaries
[B,L] = bwboundaries(Image, 'noholes');

% Display the label matrix and draw each boundary
RGB1 = label2rgb(L, @jet, [.5 .5 .5]);
imshow(RGB1) ;
 hold on %Retain current graph when adding new graphs
 
for i = 1:length(B)
  boundary = B{i};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2) %Draw 2D line, 'w' = white color
end

end

