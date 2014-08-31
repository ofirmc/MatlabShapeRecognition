function [I]=ImageToDouble(Image)

Image=im2double(rgb2gray(Image));
% figure('Name','Original Picture Gray','NumberTitle','off'),imshow(Image);
[n,m]=size(Image);
for i=1:n,
     for j=1:m,
        if Image(i,j)<0.6
                Z(i,j)=0;
        else
              Z(i,j)=1;
        end
     end
end
I=1-Z;